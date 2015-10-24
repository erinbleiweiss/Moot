from flask import Flask, request, jsonify
app = Flask(__name__)

import requests
import logging
import pprint
import Image
import math
from math import sqrt
import random
import numpy
from StringIO import StringIO
import pdb
from collections import namedtuple


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

    return product_name

def get_product_img(upc):
    #TODO: Wrap in try/catch
    params = {'request_type': UPC_REQUEST_TYPE,
              'access_token': UPC_ACCESS_TOKEN,
              'upc': upc}
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
              'maxLength': 8,
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

    return:             random word as string
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
        response["guess"] = "duplicate"
        response["letters_guessed"] = ''.join(letters_guessed)
    # If guess is correct
    elif current_letter in target_letters:
        new_letters = list(letters_guessed)         # create new list
        for i in range (0, len(target_letters)-1):  # add new guess to list
            if target_letters[i] == current_letter:
                new_letters[i] = current_letter

        response["guess"] = current_letter
        response["letters_guessed"] = ''.join(new_letters)
    # If guess is incorrect
    else:
        response["guess"] = "not in word"
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


def find_colors(img, n=3):
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

    logger.debug([get_color_name(c) for c in colors])

    result = {}
    for color in find_colors(img):
        color_name = get_color_name(color)
        if color_name not in neutral_colors:
            result["dominant_color"] = color_name
            return jsonify(result)

    result["dominant_color"] = "none"
    return jsonify(result)


if __name__ == "__main__":
    app.run(debug=True)
