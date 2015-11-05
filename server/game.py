from flask import Flask, request, jsonify
app = Flask(__name__)

import requests
import logging
import pprint
import Image
import math
from math import sqrt
import random
from random import shuffle
import numpy
from StringIO import StringIO
import pdb
from collections import namedtuple, Counter


#TODO: Read from file
SEARCH_UPC_URL = "http://www.searchupc.com/handlers/upcsearch.ashx"
UPC_REQUEST_TYPE = "3"
UPC_ACCESS_TOKEN = "EDDD50C8-9FC4-48D0-B29A-1E1EF405283A"
WORDNIK_URL = "http://api.wordnik.com:80/v4/words.json/randomWord"
WORDNIK_API_KEY = "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"

# Create debug logger
logger = logging.getLogger('info')
handler = logging.FileHandler('./server/info.log')
logger.addHandler(handler)
logger.setLevel(logging.DEBUG)
# Log flask output to logger
app.logger.addHandler(handler)

@app.route("/")
def hello():
    """Placeholder string for API"""
    return "Hello world!"


@app.route('/healthcheck')
def health_check():
    """AWS Healthcheck"""
    return "healthy"


def get_product_name(upc):
    #TODO: Wrap in try/catch
    params = {'request_type': UPC_REQUEST_TYPE,
              'access_token': UPC_ACCESS_TOKEN,
              'upc': upc}
    barcode_data = requests.get(SEARCH_UPC_URL, params=params)
    barcode_data = barcode_data.json()
    product_name = barcode_data["0"]["productname"]

    MAX_ATTEMPTS = 10
    attempts = 0

    while product_name == " " and attempts < MAX_ATTEMPTS:
        barcode_data = requests.get(SEARCH_UPC_URL, params=params)
        barcode_data = barcode_data.json()
        product_name = barcode_data["0"]["productname"]
        attempts += 1

    return product_name

def get_product_img(upc):
    #TODO: Wrap in try/catch
    params = {'request_type': UPC_REQUEST_TYPE,
              'access_token': UPC_ACCESS_TOKEN,
              'upc': upc}
    barcode_data = requests.get(SEARCH_UPC_URL, params=params)
    barcode_data = barcode_data.json()
    product_img = barcode_data["0"]["imageurl"]

    while product_img == "N/A":
        barcode_data = requests.get(SEARCH_UPC_URL, params=params)
        barcode_data = barcode_data.json()
        product_img = barcode_data["0"]["imageurl"]


    return product_img

###########################################################
# Level 1: Hangman                                        #
###########################################################
@app.route('/v1/generate_random_word', methods=["GET"])
def generate_random_word():
    """
    Generates a random word from searchupc.com

    :return:    random word as string
    """

    # TODO: obfuscate word when passing to client
    # TODO: wrap in try/catch
    params = {'hasDictionaryDef': 'true',
              'includePartOfSpeech': 'noun',
              'excludePartOfSpeech': 'proper-noun',
              'minCorpusCount': 100000,
              'minLength': 5,
              'maxLength': 6,
              'api_key': WORDNIK_API_KEY
              }
    word_data = requests.get(WORDNIK_URL, params=params)
    word_data = word_data.json()
    random_word = word_data["word"]

    response = {}
    response["word"] = random_word

    return jsonify(response)

@app.route('/v1/play_hangman', methods=["GET"])
def play_hangman():
    """
    Checks whether product name first letter is in word

    Request parameters
    upc: product        UPC as string
    target_word:        target word as string
    letters_guessed:    state of current game / all letters guessed as
                        string with underscores (_) representing blanks

    return:             {"guess": letter guessed (or "not in word")
                         "letters_guessed": state of current game}
    """

    upc = request.args.get('upc')
    target_word = request.args.get('target_word').upper()
    target_letters = list(target_word)
    letters_guessed = list(request.args.get('letters_guessed'))

    # Get "current letter" corresponding to first letter of scanned object
    product_name = get_product_name(upc)
    current_letter = product_name[0].upper()

    response = {}

    # If character has already been revealed
    if current_letter in letters_guessed:
        response["guess"] = current_letter
        response["status"] = 0
        response["letters_guessed"] = ''.join(letters_guessed)
    # If guess is correct
    elif current_letter in target_letters:
        new_letters = list(letters_guessed)         # create new list
        for i in range (0, len(target_letters)):  # add new guess to list
            if target_letters[i] == current_letter:
                new_letters[i] = current_letter

        response["guess"] = current_letter
        response["status"] = 1
        response["letters_guessed"] = ''.join(new_letters)
    # If guess is incorrect
    else:
        response["guess"] = current_letter
        response["status"] = 2
        response["letters_guessed"] = ''.join(letters_guessed)
    return jsonify(response)




@app.route('/v1/get_product_nameOLD', methods=["GET"])
def get_product_nameOLD():
    """
    Gets product name from scanned UPC barcode from searchupc.com

    Request parameters
    upc:        product UPC as string

    return:     product name as json
    """

    #TODO: Wrap in try/catch
    params = {'request_type': UPC_REQUEST_TYPE,
              'access_token': UPC_ACCESS_TOKEN,
              'upc': request.args.get('upc')}
    barcode_data = requests.get(SEARCH_UPC_URL, params=params)
    barcode_data = barcode_data.json()
    product_name = barcode_data["0"]["productname"]

    logger.debug(pprint.pformat(barcode_data))

    response = {}
    response["product_name"] = product_name

    return jsonify(response)



###########################################################
# Level 2: Maze                                           #
###########################################################
Point = namedtuple('Point', ('coords', 'n', 'ct'))
Cluster = namedtuple('Cluster', ('points', 'center', 'n'))

def get_points(img):
    points = []
    w, h = img.size
    for count, color in img.getcolors(w * h):
        points.append(Point(color, 3, count))
    return points

rtoh = lambda rgb: '#%s' % ''.join(('%02x' % p for p in rgb))


def euclidean(p1, p2):
    return sqrt(sum([
        (p1.coords[i] - p2.coords[i]) ** 2 for i in range(p1.n)
    ]))

def calculate_center(points, n):
    vals = [0.0 for i in range(n)]
    plen = 0
    for p in points:
        plen += p.ct
        for i in range(n):
            vals[i] += (p.coords[i] * p.ct)
    return Point([(v / plen) for v in vals], n, 1)

def kmeans(points, k, min_diff):
    clusters = [Cluster([p], p, p.n) for p in random.sample(points, k)]

    while 1:
        plists = [[] for i in range(k)]

        for p in points:
            smallest_distance = float('Inf')
            for i in range(k):
                distance = euclidean(p, clusters[i].center)
                if distance < smallest_distance:
                    smallest_distance = distance
                    idx = i
            plists[idx].append(p)

        diff = 0
        for i in range(k):
            old = clusters[i]
            center = calculate_center(plists[i], old.n)
            new = Cluster(plists[i], center, old.n)
            clusters[i] = new
            diff = max(diff, euclidean(old.center, new.center))

        if diff < min_diff:
            break

    return clusters

def get_color_name(input_color):
              # Light           # Medium        # Dark
    colors = [[255, 153, 153],  [255, 0, 0],    [113, 0, 0],    # Red
              [255, 111, 168],  [255, 123, 51], [156, 68, 0],   # Orange
              [255, 255, 131],  [255, 255, 0],  [211, 167, 0],  # Yellow
              [166, 196, 113],  [112, 153, 0],  [53, 71, 0],    # Green-Yellow
              [126, 228, 126],  [0, 153, 0],    [0, 60, 0],     # Green
              [130, 222, 231],  [0, 134, 153],  [0, 53, 60],    # Blue-Green
              [131, 184, 255],  [0, 0, 255],    [0, 0, 165],    # Blue
              [166, 131, 199],  [102, 0, 102],  [56, 22, 56],   # Purple
              [244, 131, 225],  [204, 0, 153],  [116, 0, 71],   # Magenta
              [199, 168, 131],  [102, 51, 0],   [36, 13, 0],    # Brown
              [0, 0, 0],                                        # Black
              [255, 255, 255]]                                  # White

    min_distance = 10000000
    color_match = 0

    for i in range (len(colors)):
        distance = math.sqrt( ((colors[i][0] - input_color[0])**2) +
                              ((colors[i][1] - input_color[1])**2) +
                              ((colors[i][2] - input_color[2])**2) )
        if distance < min_distance:
            min_distance = distance
            color_match = i

    if color_match in range (0, 3):
        return "red"
    elif color_match in range (3, 6):
        return "orange"
    elif color_match in range (6, 9):
        return "yellow"
    elif color_match in range (9, 15):
        return "green"
    elif color_match in range (15, 21):
        return "blue"
    elif color_match in range (21, 27):
        return "purple"
    elif color_match in range (27, 30):
        return "brown"
    elif color_match == 30:
        return "black"
    elif color_match == 31:
        return "white"


def find_colors(img, n=7):
    img.thumbnail((200, 200))
    w, h = img.size

    points = get_points(img)
    clusters = kmeans(points, n, 1)

    rgb_values = [c.center.coords for c in clusters]
    return rgb_values


@app.route('/v1/image_colors', methods=["GET"])
def image_colors():
    upc = request.args.get('upc')
    url = get_product_img(upc)
    response = requests.get(url)
    img = Image.open(StringIO(response.content))

    neutral_colors = ["black", "white", "brown"]

    colors = find_colors(img)
    for color in colors:
        logger.debug([int(i) for i in color])
    logger.debug([get_color_name(c) for c in colors])

    result = {}
    dominant_colors = []
    for color in colors:
        color_name = get_color_name(color)
        if color_name not in neutral_colors:
            dominant_colors.append(color_name)

    if len(dominant_colors) > 0:
        count = Counter(dominant_colors)
        result["dominant_color"] = count.most_common()[0][0]
        return jsonify(result)

    result["dominant_color"] = "none"
    return jsonify(result)


class Tile (object):
    def __init__(self, preset):
        # Initialize a tile with preset walls

        # Convert preset integer to 4 digit binary
        binary = list("{0:04b}".format(preset))

        # Positions 0, 1, 2, 3 in array correspond to N, W, S, E directions
        # Value of 0 = no wall, 1 = wall

        # 0  = ____     4  = _W__     8  = N___     12 = NW__
        # 1  = ___E     5  = _W_E     9  = N__E     13 = NW_E
        # 2  = __S_     6  = _WS_     10 = N_S_     14 = NWS_
        # 3  = __SE     7  = _WSE     11 = N_SE     15 = NWSE

        # Convert 0/1 values to True/False
        walls = [(i=="1") for i in binary]

        self.north = walls[0]
        self.west = walls[1]
        self.south = walls[2]
        self.east = walls[3]
        self.visited = 0

    def get_preset(self):
        # Print tile as preset number (from above)
        self.north = 1 if self.north else 0
        self.west = 1 if self.west else 0
        self.south = 1 if self.south else 0
        self.east = 1 if self.east else 0

        binary = ("{}{}{}{}").format(self.north, self.west, self.south, self.east)
        return str(int(binary, 2))

    def __repr__(self):
        return self.get_preset()


class Maze (object):
    def __init__(self, width, height, tiles=None):
        self.width = width
        self.height = height
        self.maze = []

        if tiles is None:
            # Initialize maze as grid (2D list) of tiles with all walls filled
            for row in range (0, self.width):
                current_row = []
                for col in range (0, self.height):
                    current_tile = Tile(15)
                    current_row.append(current_tile)
                self.maze.append(current_row)
        else:
            # 1D to square 2D list
            self.maze = [tiles[i:i+self.width] for i in range(0, len(tiles), self.width)]


    def __str__(self):
        return str(self.maze)


@app.route('/v1/generate_maze', methods=["GET"])
def generate_maze():
    """
    Generates a random maze given a specified grid, using a recursive
    backtracking algorithm

    Uses helper function carve_passages for recursion

    Request parameters
    width:          Desired width of maze
    height:         Desired height of maze

    return:         Maze with tile presets as underscore_delineated_string
                    ex: 12_8_10_10_9_7_5_12_9_5...
    """

    width = int(request.args.get('width'))
    height = int(request.args.get('height'))

    row = 0          # Starting x coordinate
    col = 0          # Starting y coordinate

    grid = Maze(width, height)
    carve_passages(row, col, grid)
    logger.debug(grid)

    flat_grid = []
    for row in grid.maze:
        for col in row:
            flat_grid.append(col.get_preset())

    maze_string = ''
    for i in flat_grid:
        maze_string += str(i)
        maze_string += '_'
    maze_string = maze_string[:-1]

    logger.debug(maze_string)

    response = {}
    response['maze'] = maze_string

    return jsonify(response)


def carve_passages(row, col, grid):

    directions = ['north', 'east', 'south', 'west']
    shuffle(directions)
    dx = {'north': 0, 'east': 1, 'south': 0, 'west': -1}
    dy = {'north': -1, 'east': 0, 'south': 1, 'west': 0}
    opposite = {'north': 'south', 'east': 'west', 'south': 'north', 'west': 'east'}

    width = len(grid.maze[0])
    height = len(grid.maze)

    for dir in directions:
        row_new = row + dy[dir]
        col_new = col + dx[dir]


        row_valid = (0 <= row_new < height)
        col_valid = (0  <= col_new < width)

        if row_valid and col_valid and grid.maze[row_new][col_new].visited == 0:
            setattr(grid.maze[row][col], dir, 0)
            setattr(grid.maze[row_new][col_new], opposite[dir], 0)
            grid.maze[row_new][col_new].visited = 1
            carve_passages(row_new, col_new, grid)


@app.route('/v1/maze_move', methods=["GET"])
def move():
    """
    Checks whether a move in a maze is valid, and returns
    new position

    Request parameters
    dir:                direction indicated (north, east, south, or west)
    row:                row (y) of location in 2D maze grid
    col:                column (x) of location in 2D maze grid
    return:             {"success": true or false
                         "row":     new position (y)
                         "col":     new position (x)
                        }
    """

    dir = request.args.get('dir')
    maze = request.args.get('maze')
    row = int(request.args.get('row'))
    col = int(request.args.get('col'))

    logger.debug(maze)

    maze = maze.split('_')
    size = int(len(maze) ** .5)

    # 1D to square 2D list
    maze = [maze[i:i+size] for i in range(0, len(maze), size)]
    print(maze)

    response = {}

    current_tile = Tile(int(maze[row][col]))
    logger.info(("Started at: {}").format(current_tile))

    logger.critical(getattr(current_tile, dir))


    if dir == "north":
        if current_tile.north:
            response["success"] = "false"
            logger.info("Hit a wall moving north")
            return jsonify(response)

        response["success"] = "true"
        response["row"] = row - 1
        response["col"] = col
        new_tile = Tile(int(maze[row-1][col]))
        logger.info(("Moved north to: {}").format(new_tile))

        return jsonify(response)

    if dir == "east":
        if current_tile.east:
            logger.debug(current_tile.east)
            response["success"] = "false"
            logger.info("Hit a wall moving west")
            return jsonify(response)

        response["success"] = "true"
        response["row"] = row
        response["col"] = col + 1
        new_tile = Tile(int(maze[row][col+1]))
        logger.info(("Moved east to: {}").format(new_tile))

        return jsonify(response)

    if dir == "south":
        if current_tile.south:
            response["success"] = "false"
            logger.info("Hit a wall moving south")
            return jsonify(response)

        response["success"] = "true"
        response["row"] = row + 1
        response["col"] = col
        new_tile = Tile(int(maze[row+1][col]))
        logger.info(("Moved south to: {}").format(new_tile))

        return jsonify(response)

    if dir == "west":
        if current_tile.west:
            response["success"] = "false"
            logger.info("Hit a wall moving east")
            return jsonify(response)

        response["success"] = "true"
        response["row"] = row
        response["col"] = col - 1
        new_tile = Tile(int(maze[row][col-1]))
        logger.info(("Moved west to: {}").format(new_tile))

        return jsonify(response)

if __name__ == "__main__":
    app.run(debug=True)






