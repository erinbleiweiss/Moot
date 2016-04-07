from flask import Flask, request, jsonify, make_response

app = Flask(__name__)

from moot.mootdao import MootDao
from moot.achievements import Achievements
from moot.moot_logger import get_logger

import os
import ConfigParser
import requests
import json
import pprint
from PIL import Image
import math
from math import sqrt
import random
from random import shuffle
from StringIO import StringIO
import pdb
from collections import namedtuple, Counter
from colorama import init, Fore, Back, Style
from colorthief import ColorThief
import colorsys

config = ConfigParser.ConfigParser()
config_path = os.path.join(os.getcwd(), "moot/config.ini")
config.read(config_path)
logger = get_logger(__name__)

SEARCH_UPC_URL = config.get('api', 'search_upc_url')
UPC_REQUEST_TYPE = config.get('api', 'upc_request_type')
UPC_ACCESS_TOKEN = config.get('api', 'upc_access_token')
WORDNIK_URL = config.get('api', 'wordnik_url')
WORDNIK_API_KEY = config.get('api', 'wordnik_api_key')
QR_CODE_URL = config.get('api', 'qr_code_url')

MAX_POINTS_FOR_PRODUCT = 100
SUCCESS = "success"
FAILURE = "failure"


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
def logger_header(endpoint):
    """
    Formats an endpoint name as center-aligned, padded with equal signs
    and logs to standard logger for process readability (see following)

    ==================== /endpoint ====================

    :param endpoint: (String) name of endpoint
    :return: none
    """
    endpoint_string = " {0} ".format(endpoint)
    logger.debug("{0:=^48}".format(endpoint_string))

@app.route('/v1/login', methods=["GET"])
def login():
    logger_header('/login')
    db = MootDao()
    auth = request.authorization
    user_id = auth.username
    password = auth.password
    name = request.args.get('name')

    response = {}

    if (password == config.get('mootapp', 'moot_password') and
            db.login(user_id, name)):
            response["status"] = SUCCESS
    else:
        response["status"] = FAILURE
    return jsonify(response)


@app.route('/v1/get_achievements', methods=["GET"])
def get_achievements():
    logger_header('/get_achievements')
    db = MootDao()
    auth = request.authorization
    user_id = auth.username

    achievements = db.get_achievements(user_id)
    logger.debug(achievements)

    response = {}
    response["achievements"] = achievements
    response["status"] = SUCCESS
    return jsonify(response)


@app.route('/v1/get_unearned_achievements', methods=["GET"])
def get_unearned_achievements():
    logger_header('/get_unearned_achievements')
    db = MootDao()
    auth = request.authorization
    user_id = auth.username

    achievements = db.get_unearned_achievements(user_id)
    logger.debug(achievements)

    response = {}
    response["achievements"] = achievements
    response["status"] = SUCCESS
    return jsonify(response)

def moot_points(str, size):
    sum = 0
    for i in str:
        sum += ord(i)
    return sum % size

@app.route('/v1/award_points', methods=["POST"])
def award_points():
    logger_header('/award_points')
    auth = request.authorization
    user_id = auth.username
    points = request.form["points"]

    db = MootDao()
    response = {}
    try:
        db.award_points(user_id, points)
        response["status"] = SUCCESS
    except Exception:
        response["status"] = FAILURE

    return jsonify(response)



@app.route('/v1/get_points', methods=["GET"])
def get_points():
    logger_header('/get_points')
    auth = request.authorization
    user_id = auth.username

    db = MootDao()
    response = {}
    try:
        points = db.get_points(user_id)
        response["points"] = points
        response["status"] = SUCCESS
    except Exception:
        response["status"] = FAILURE
    return jsonify(response)


@app.route('/v1/get_product_info', methods=["GET"])
def get_product_info():
    auth = request.authorization
    user_id = auth.username

    upc = request.args.get("upc")
    product_name = get_product_name(upc)


    db = MootDao()
    response = {}
    try:
        db.get_product_info()
        response["status"] = SUCCESS
    except Exception:
        response["status"] = FAILURE

    return jsonify(response)


def get_product_info_internal(user_id, upc):
    logger_header('/get_product_info_internal')

    # Get data from searchupc API
    params = {'request_type': UPC_REQUEST_TYPE,
              'access_token': UPC_ACCESS_TOKEN,
              'upc': upc}
    barcode_data = requests.get(SEARCH_UPC_URL, params=params)
    barcode_data = barcode_data.json()
    product_name = barcode_data["0"]["productname"]
    product_img_url = barcode_data["0"]["imageurl"]

    # Download product image
    img_response = requests.get(product_img_url)

    # Get dominant color as RGB value
    color_thief = ColorThief(StringIO(img_response.content))
    dominant_color = color_thief.get_color(quality=1)
    dominant_color = tuple([color / 255.0 for color in dominant_color])
    red, green, blue = dominant_color[0], \
                       dominant_color[1], \
                       dominant_color[2]

    # Convert RGB color to HSV color, then increase saturation
    # value to 100%
    hsv_color = colorsys.rgb_to_hsv(red, green, blue)
    hue = hsv_color[0]
    saturation = hsv_color[1]
    value = hsv_color[2]
    new_rgb_color = colorsys.hsv_to_rgb(hue, 1.0, value)
    new_rgb_color = tuple([color * 255 for color in new_rgb_color])

    # Get color name of closest match
    color_name = get_color_name(new_rgb_color)

    logger.debug(new_rgb_color)
    logger.debug(color_name)

    product_info = {
        "product_name": product_name,
        "color": color_name,
        "product_img": product_img_url
    }

    db = MootDao()
    try:
        db.save_product(user_id, upc, product_name, color_name, "")
    except Exception as e:
        logger.critical("Problem saving product info to database: {}".format(e))

    return product_info

@app.route('/v1/save_product', methods=["POST"])
def save_product():
    logger_header('/save_product')
    auth = request.authorization
    user_id = auth.username

    upc = request.form["upc"]

    response = {}
    try:
        product_info = get_product_info_internal(user_id, upc)
        response["status"] = SUCCESS
    except Exception as e:
        logger.critical("Problem saving product '{0}': {1}".format(upc, e))
        response["status"] = FAILURE
    return jsonify(response)


@app.route('/v1/get_high_scores', methods=["GET"])
def get_high_scores():
    logger_header('/get_high_scores')
    num_scores = request.args.get('num_scores')

    db = MootDao()
    response = {}
    try:
        scores = db.get_high_scores(num_scores)
        response["scores"] = scores
        response["status"] = SUCCESS
    except Exception as e:
        response["status"] = FAILURE
        logger.critical("Problem getting high scores: {0}".format(e))
    return jsonify(response)


###########################################################
# Level 1: Hangman                                        #
###########################################################
@app.route('/v1/generate_random_word', methods=["GET"])
def generate_random_word():
    """
    Generates a random word from searchupc.com

    :difficulty: A number from 1-3 indicating the current level stage.
    Words should get progressively harder.  Level 1 should always use
    the word "scan"

    :return:    random word as string
    """
    logger_header("/generate_random_word")
    logger.debug("auth: {}".format(request.authorization))
    auth = request.authorization
    user_id = auth.username
    difficulty = int(request.args.get('difficulty'))

    response = {}

    if difficulty == 1:
        response["word"] = "scan"
        response["status"] = "success"
        return jsonify(response)
    elif difficulty == 2:
        minLength = 4
        maxLength = 4
        minCorpusCount= 100000
    elif difficulty == 3:
        minLength = 5
        maxLength = 5
        minCorpusCount= 100000


    if difficulty > 1:
        # TODO: obfuscate word when passing to client
        # TODO: wrap in try/catch
        params = {'hasDictionaryDef': 'true',
                  'includePartOfSpeech': 'noun',
                  'excludePartOfSpeech': 'proper-noun',
                  'minCorpusCount': minCorpusCount,
                  'minLength': minLength,
                  'maxLength': maxLength,
                  'api_key': WORDNIK_API_KEY
                  }

        try:
            # TODO: make sure word does not contain special characters, and does
            # not start with a capital letter (is not a proper noun)
            word_data = requests.get(WORDNIK_URL, params=params)
            word_data = word_data.json()
            random_word = word_data["word"]
            logger.info("Game data for user '{}': Hangman Word = '{}'".format(
                user_id, random_word))
            response["word"] = random_word
            response["status"] = SUCCESS
        except Exception as e:
            response["word"] = ""
            response["status"] = FAILURE
            response["message"] =  "Problem retrieving word from Wordnik API"

    return jsonify(response)

@app.route('/v1/play_hangman', methods=["GET"])
def play_hangman():
    """
    Checks whether product name first letter is in word

    Returns one of the following game_states:
        0: Letter is in word, and is a correct guess
        1: Letter is in word, but has already been guessed
        2: Letter is not in word

    Request parameters
    upc: product        UPC as string
    target_word:        target word as string
    letters_guessed:    state of current game / all letters guessed as
                        string with underscores (_) representing blanks

    return:             {"guess": letter guessed"
                         "game_state": 0, 1, or 2 (see above)
                         "letters_guessed": state of current game}
    """
    logger_header("/play_hangman")
    auth = request.authorization
    user_id = auth.username

    upc = request.args.get('upc')
    target_word = request.args.get('target_word').upper()
    target_letters = list(target_word)
    letters_guessed = list(request.args.get('letters_guessed'))

    # Get "current letter" corresponding to first letter of scanned object
    product_info = get_product_info_internal(user_id, upc)
    product_name = product_info["product_name"]

    points_earned = moot_points(product_name, MAX_POINTS_FOR_PRODUCT)
    db = MootDao()
    response = {}
    try:
        db.award_points(user_id, points_earned)
    except Exception as e:
        logger.critical("Awarding points to user '{0}' failed with exception "
                        "{1}".format(user_id, e))

    logger.debug(product_name)

    current_letter = product_name[0].upper()
    logger.debug(current_letter)

    response = {}


    db = MootDao()
    try:
        db.save_product(user_id, upc, product_name, "", "")
    except Exception as e:
        logger.critical(e)
        response["status"] = FAILURE
        return jsonify(response)


    logger.debug(points_earned)

    # If character has already been revealed
    if current_letter in letters_guessed:
        response["guess"] = current_letter
        response["status"] = SUCCESS
        response["product_name"] = product_name
        response["color"] = product_info["color"]
        response["product_img"] = product_info["product_img"]
        response["points_earned"] = points_earned
        response["game_state"] = 1
        response["letters_guessed"] = ''.join(letters_guessed)
    # If guess is correct
    elif current_letter in target_letters:
        new_letters = list(letters_guessed)         # create new list
        for i in range (0, len(target_letters)):  # add new guess to list
            if target_letters[i] == current_letter:
                new_letters[i] = current_letter

        response["guess"] = current_letter
        response["status"] = SUCCESS
        response["product_name"] = product_name
        response["color"] = product_info["color"]
        response["product_img"] = product_info["product_img"]
        response["points_earned"] = points_earned
        response["game_state"] = 0
        response["letters_guessed"] = ''.join(new_letters)
    # If guess is incorrect
    else:
        response["guess"] = current_letter
        response["status"] = SUCCESS
        response["product_name"] = product_name
        response["color"] = product_info["color"]
        response["product_img"] = product_info["product_img"]
        response["points_earned"] = points_earned
        response["game_state"] = 2
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
    logger_header('/get_product_nameOLD')
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
def get_color_name(input_color):
    #           # Light           # Medium        # Dark
    # colors = [[255, 153, 153],  [255, 0, 0],    [113, 0, 0],    # Red
    #           [255, 111, 168],  [255, 123, 51], [156, 68, 0],   # Orange
    #           [255, 255, 131],  [255, 255, 0],  [211, 167, 0],  # Yellow
    #           [166, 196, 113],  [112, 153, 0],  [53, 71, 0],    # Green-Yellow
    #           [126, 228, 126],  [0, 153, 0],    [0, 60, 0],     # Green
    #           [130, 222, 231],  [0, 134, 153],  [0, 53, 60],    # Blue-Green
    #           [131, 184, 255],  [0, 0, 255],    [0, 0, 165],    # Blue
    #           [166, 131, 199],  [102, 0, 102],  [56, 22, 56],   # Purple
    #           [244, 131, 225],  [204, 0, 153],  [116, 0, 71],   # Magenta
    #           [199, 168, 131],  [102, 51, 0],   [36, 13, 0],    # Brown
    #           [0, 0, 0],                                        # Black
    #           [255, 255, 255]]                                  # White


              # Light           # Medium        # Dark
    colors = [[255, 153, 153],  [255, 0, 0],    [113, 0, 0],    # Red
              [255, 111, 168],  [255, 123, 51], [156, 68, 0],   # Orange
              [255, 255, 131],  [255, 255, 0],  [211, 167, 0],  # Yellow
              [166, 196, 113],  [112, 153, 0],  [53, 71, 0],    # Green-Yellow
              [126, 228, 126],  [0, 153, 0],    [0, 60, 0],     # Green
              [130, 222, 231],  [0, 134, 153],  [0, 53, 60],    # Blue-Green
              [131, 184, 255],  [0, 0, 255],    [0, 0, 165],    # Blue
              [166, 131, 199],  [102, 0, 102],  [56, 22, 56],   # Purple
              [244, 131, 225],  [204, 0, 153],  [116, 0, 71]]   # Magenta

    # colors = [
    #     [179, 48, 49],              # Red
    #     [236, 125, 0],              # Orange
    #     [251, 201, 71],             # Yellow
    #     [202, 209, 0],              # Green-Yellow
    #     [141, 163, 0],              # Green
    #     [23, 136, 132],             # Teal
    #     [17, 116, 187],             # Blue
    #     [157, 86, 154]              # Purple
    # ]

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
    elif color_match in range (9, 12):
        return "greenyellow"
    elif color_match in range (12, 15):
        return "green"
    elif color_match in range (15, 18):
        return "blue"
    elif color_match in range (18, 21):
        return "teal"
    elif color_match in range (21, 27):
        return "purple"


@app.route('/v1/image_colors', methods=["GET"])
def image_colors():
    logger_header("/image_colors")
    auth = request.authorization
    user_id = auth.username
    upc = request.args.get('upc')

    product_info = get_product_info_internal(user_id, upc)
    color_name = product_info["color"]

    product_name = product_info["product_name"]
    points_earned = moot_points(product_name, MAX_POINTS_FOR_PRODUCT)
    db = MootDao()
    try:
        db.award_points(user_id, points_earned)
    except Exception as e:
        logger.critical("Awarding points to user '{0}' failed with exception "
                        "{1}".format(user_id, e))

    response = {}
    response["product_name"] = product_name
    response["product_img"] = product_info["product_img"]
    response["points_earned"] = points_earned
    response["color"] = color_name
    response["status"] = SUCCESS
    return jsonify(response)



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

        binary = ("{}{}{}{}").format(self.north,
                                     self.west,
                                     self.south,
                                     self.east)
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

    logger_header('/generate_maze')
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
    response['status'] = SUCCESS
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
def maze_move():
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
    logger_header('/maze_move')

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

    diagonals = {"northeast": ("north", "east"),
                 "southeast": ("south", "east"),
                 "southwest": ("south", "west"),
                 "northwest": ("north", "west")}

    logger.debug("Direction: {0}".format(dir))

    # For diagonal movements, the user is advancing two tiles.  Thus, two
    # combinations of moves should be tested before a move can be considered a
    # failure. First, check movement of dir1 and dir2 as first and second
    # directions in tuple.  If a success is not returned, check movement of
    # dir2 and then dir1
    if dir in diagonals:
        # Direction is a diagonal movement
        dir1 = diagonals[dir][0]
        dir2 = diagonals[dir][1]
        if getattr(current_tile, dir1):
            # First direction is invalid as first move for current tile
            logger.debug("Hit wall moving {0}".format(dir1))
        else:
             # First direction valid as first move for current tile
            logger.debug("Moved {0}".format(dir1))
            intermediate_tile = Tile(int(maze[row + dy[dir1]][col + dx[dir1]]))
            if getattr(intermediate_tile, dir2):
                # First direction valid as first move, but second direction
                # invalid for second move
                logger.debug("Moved {0}, then hit wall moving {1}".format(
                    dir1, dir2))
                logger.info(("Hit a wall moving {}").format(dir))
            else:
                # Diagonal movement is valid
                logger.debug("Moved {0}, then moved {1}".format(dir1, dir2))
                response["status"] = SUCCESS
                response["row"] = row + dy[dir1] + dy[dir2]
                response["col"] = col + dx[dir1] + dx[dir2]
                new_tile = Tile(int(maze[row + dy[dir1] + dy[dir2]]
                                    [col + dx[dir1] + dx[dir2]]))
                logger.info(("Moved {} to: {}").format(dir, new_tile))
                return jsonify(response)


        if getattr(current_tile, dir2):
            # Second direction is invalid as first move for current tile
            logger.debug("Hit wall moving {0}".format(dir2))
        else:
             # Second direction valid as first move for current tile
            logger.debug("Moved {0}".format(dir2))
            intermediate_tile = Tile(int(maze[row + dy[dir2]][col + dx[dir2]]))
            if getattr(intermediate_tile, dir1):
                # Second direction valid as first move, but first direction
                # invalid for second move
                logger.debug("Moved {0}, then hit wall moving {1}".format(
                    dir2, dir1))
                logger.info(("Hit a wall moving {}").format(dir))
            else:
                # Diagonal movement is valid
                logger.debug("Moved {0}, then moved {1}".format(dir2, dir1))
                response["status"] = SUCCESS
                response["row"] = row + dy[dir1] + dy[dir2]
                response["col"] = col + dx[dir1] + dx[dir2]
                new_tile = Tile(int(maze[row + dy[dir1] + dy[dir2]]
                                    [col + dx[dir1] + dx[dir2]]))
                logger.info(("Moved {} to: {}").format(dir, new_tile))
                return jsonify(response)


    else:
        # Movement is not a diagonal movement
        if getattr(current_tile, dir):
            # Wall exists for 1-tile movement
            logger.info(("Hit a wall moving {}").format(dir))
        else:
            # 1-tile movement is valid
            response["status"] = SUCCESS
            response["row"] = row + dy[dir]
            response["col"] = col + dx[dir]
            new_tile = Tile(int(maze[row + dy[dir]][col + dx[dir]]))
            logger.info(("Moved {} to: {}").format(dir, new_tile))
            return jsonify(response)

    response["status"] = FAILURE
    logger.info(("Hit a wall moving {}").format(dir))
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
    logger_header('/get_qr_code')
    base_url = QR_CODE_URL
    width = request.args.get('width')
    height = request.args.get('height')
    # target_url = 'http://www.google.com'
    # TODO: Obtain endpoint URL (and route?) dynamically
    # TODO: Make qr code unique for user_id
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
    logger_header('/check_qr_code')
    response = {}
    # Totally unique, definitely obfuscated identification string
    response["status"] = SUCCESS
    response["correcthorsebatterystaple"] = SUCCESS

    return jsonify(response)



###########################################################
# Achievements                                            #
###########################################################
@app.route('/v1/check_for_achievements', methods=["GET"])
def check_for_achievements():
    logger_header("/check_for_achievements")
    auth = request.authorization
    user_id = auth.username

    ach = Achievements(user_id)

    response = {}
    try:
        response["achievements"] = ach.check_all_achievements()
        response["status"] = SUCCESS
    except Exception as e:
        response["status"] = FAILURE
        logger.debug("Problem checking user achievements {}".format(e))
    return jsonify(response)



def check_for_achievements_internal(user_id):
    ach = Achievements(user_id)
    try:
        return ach.check_all_achievements()
    except Exception:
        return []


if __name__ == "__main__":
    app.run(debug=True)






