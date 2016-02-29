from flask import Flask, request, jsonify, make_response
from flask_mail import Mail, Message
from flask_wtf import Form
from wtforms import StringField, PasswordField, validators, ValidationError

app = Flask(__name__)
mail = Mail(app)

from werkzeug.datastructures import MultiDict

from mootdao import MootDao

import requests
import logging
import pprint
import Image
import math
from math import sqrt
import random
from random import shuffle
from StringIO import StringIO
import pdb
from collections import namedtuple, Counter
from colorama import init, Fore, Back, Style

import logging
from logging.config import fileConfig

#TODO: Read from file
SEARCH_UPC_URL = "http://www.searchupc.com/handlers/upcsearch.ashx"
UPC_REQUEST_TYPE = "3"
UPC_ACCESS_TOKEN = "EDDD50C8-9FC4-48D0-B29A-1E1EF405283A"
WORDNIK_URL = "http://api.wordnik.com:80/v4/words.json/randomWord"
WORDNIK_API_KEY = "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
QR_CODE_URL = "http://api.qrserver.com/v1/create-qr-code/"


fileConfig('logging_config.ini')
logger = logging.getLogger(__name__)

class RegistrationForm(Form):
    username = StringField('Username', [
        validators.DataRequired(message="Username cannot be blank"),
        validators.Length(4, 20,
                          message="Username must be between "
                                  "4 and 20 characters"),
        validators.regexp('^[A-Za-z][A-Za-z0-9_.]*$',
                          message="Usernames may contain only letters, "
                                  "numbers, periods or underscores")
    ])
    password = PasswordField('Password', [
        validators.DataRequired(message="Password cannot be blank"),
        validators.Length(4, 20,
                          message="Password must be between "
                                  "4 and 20 characters"),
    ])
    confirmPassword = PasswordField('Confirm password', [
        validators.equal_to('password',
                            message="Passwords must match")
    ])
    email = StringField('Email address', [
        validators.DataRequired(message="Email cannot be blank."),
        validators.Email(message="Email address is not valid")
    ])

    def getValue(self, param):
        return getattr(self, param)._value()


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
# Global Utilities                                        #
###########################################################
@app.route('/v1/register', methods=["POST"])
def register():
    logger.debug('register()')
    try:
        data = MultiDict(mapping=request.form)
        form = RegistrationForm(data, csrf_enabled=False)

        if form.validate():
            username = form.getValue("username")
            password = form.getValue("password")
            email = form.getValue("email")

            db = MootDao()
            db.create_user(username, password, email)

            response = {}
            response["status"] = "success"
            response["message"] = "created user"

            logger.debug('it worked?')
            return jsonify(response)
        else:
            for fieldName, errorMessages in form.errors.iteritems():
                for err in errorMessages:
                    logger.debug("{}: {}".format(fieldName, err))

            logger.debug('validation failure')
            response = {}
            response["status"] = "failure"
            return jsonify(response)

    except Exception as e:
        logger.debug('Exception: {}'.format(e))
        response = {}
        response["status"] = "failure"
        return jsonify(response)



@app.route('/v1/login', methods=["GET"])
def login():
    db = MootDao()
    auth = request.authorization

    username = auth.username
    password = auth.password
    #
    response = {}
    if db.login(username, password):
        response["status"] = "success"
    else:
        response["status"] = "failure"

    logger.debug("Attempting to login user '{}' with password '{}' - {}".format(
        username, password, response["status"]))

    return jsonify(response)


@app.route('/v1/forgot_password', methods=["GET"])
def forgot_password():
    msg = Message()
    msg.recipients = ["erin.bleiweiss@utexas.edu"]
    msg.body = "Moot test email"
    msg.subject = "Moot Password Reset"
    # msg.sender = ("Moot", "moot@erinbleiweiss.com")
    mail.send(msg)
    return "Message sent"

def moot_points(str, size):
    sum = 0
    for i in str:
        sum += ord(i)
    return sum % size


def increment_score(username, points):
    db = MootDao()

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
    logger.debug(product_name)

    current_letter = product_name[0].upper()
    logger.debug(current_letter)

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


def find_colors(img, n=4):
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

    print(Fore.RED + 'some red text')
    print(Style.RESET_ALL)

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

    grid = Maze(width, height)
    starting_row = random.randint(0, height-1)
    starting_col = random.randint(0, width-1)
    carve_passages(starting_row, starting_col, grid)
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
    """
    Uses recursive backtracking to carve passages from a maze grid
    Completes when all tiles in grid have been visited

    row:        Current row in grid
    col:        Current col in grid
    grid:       Grid as Maze object
    """

    directions = ['north', 'east', 'south', 'west']
    random.shuffle(directions)

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
            grid.maze[row][col].visited = 1
            grid.maze[row_new][col_new].visited = 1
            carve_passages(row_new, col_new, grid)


@app.route('/v1/maze_move', methods=["GET"])
def move():
    """
    Checks whether a move in a maze is valid, and returns
    new position

    Request parameters
    dir:                direction indicated (north, east, south, or west)'
    maze:               Maze with tile presets as underscore_delineated_string
                        ex: 12_8_10_10_9_7_5_12_9_5...
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

    response = {}

    current_tile = Tile(int(maze[row][col]))
    logger.info(("Started at: {}").format(current_tile))

    dx = {'north': 0, 'east': 1, 'south': 0, 'west': -1}
    dy = {'north': -1, 'east': 0, 'south': 1, 'west': 0}

    # If wall exists
    if getattr(current_tile, dir):
        response["success"] = "false"
        logger.info(("Hit a wall moving {}").format(dir))
        return jsonify (response)

    response["success"] = "true"
    response["row"] = row + dy[dir]
    response["col"] = col + dx[dir]
    new_tile = Tile(int(maze[row + dy[dir]][col + dx[dir]]))
    logger.info(("Moved {} to: {}").format(dir, new_tile))

    return jsonify(response)


###########################################################
# Level 3: Jigsaw                                         #
###########################################################
@app.route('/v1/get_qr_code', methods=["GET"])
def get_qr_code():
    """
    Returns a qr code image from api.qrserver.com

    Request parameters
    width:                  desired qr code width
    height:                 desired qr code height

    return:                 A QR code image as .png
    """

    base_url = QR_CODE_URL
    width = request.args.get('width')
    height = request.args.get('height')
    # target_url = 'http://www.google.com'
    # TODO: Obtain endpoint URL (and route?) dynamically
    target_url = "http://52.26.94.97:5000/v1/check_qr_code"

    request_url = ("{}?size={}x{}&data={}").format(base_url,
                                                   width,
                                                   height,
                                                   target_url)

    logger.debug(request_url)

    r = requests.get(request_url)
    response = make_response(r.content)
    response.content_type = "image/png"
    return response


@app.route('/v1/check_qr_code', methods=["GET"])
def check_qr_code():
    """
    Returns true for a unique identifier

    return:                 true
    """

    response = {}
    # Totally unique, definitely obfuscated identification string
    response["correcthorsebatterystaple"] = "true"

    return jsonify(response)



if __name__ == "__main__":
    app.run(debug=True)






