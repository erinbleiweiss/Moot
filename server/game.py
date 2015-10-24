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

def find_nearest_color(input_color):
    colors = [(209, 0, 0),
              (255, 102, 34),
              (255, 218, 33),
              (51, 221, 0),
              (17, 51, 204),
              (51, 0, 68),
              (0, 0, 0),
              (255, 255, 255)]

    min_distance = 10000000
    min_index = 0

    for i in range (len(colors)):
        distance = math.sqrt( ((colors[i][0] - input_color[0])**2) +
                              ((colors[i][1] - input_color[1])**2) +
                              ((colors[i][2] - input_color[2])**2) )
        if distance < min_distance:
            min_distance = distance
            min_index = i

    if min_index == 0:
        return "Red"
    elif min_index == 1:
        return "Orange"
    elif min_index == 2:
        return "Yellow"
    elif min_index == 3:
        return "Green"
    elif min_index == 4:
        return "Blue"
    elif min_index == 5:
        return "Purple"
    elif min_index == 6:
        return "Black"
    elif min_index == 7:
        return "White"


def find_colors(img, n=3):
    img.thumbnail((200, 200))
    w, h = img.size

    points = get_points(img)
    clusters = kmeans(points, n, 1)

    rgb_values = [c.center.coords for c in clusters]
    return rgb_values


@app.route('/v1/image_colors', methods=["GET"])
def image_colors():
    url = request.args.get('url')
    response = requests.get(url)
    img = Image.open(StringIO(response.content))


    print find_colors(img, 3)

    # print result

    fakeResult = {}
    fakeResult["ran"] = "yes"
    return jsonify(fakeResult)


if __name__ == "__main__":
    app.run(debug=True)
