import requests
import json
import pprint
# from colored import fg, bg, attr

import logging
from logging.config import fileConfig
fileConfig('/home/erin/Thesis/server/logging_config.ini')
logger = logging.getLogger(__name__)

hostname = "http://108.84.181.177:5000"
rest_prefix = "/v1"

upc_host = 'http://www.searchupc.com/handlers/upcsearch.ashx'
upc_access_token = 'EDDD50C8-9FC4-48D0-B29A-1E1EF405283A'
request_type = '3'

cliffbarupc = "722252660091"

h = "071100210453"

def create_user():
    url = "{}{}{}".format(hostname, rest_prefix, "/register")
    payload = {'username': 'ebleiweiss', 'password': 'testpw',
               'email': 'erinbleiweiss@gmail.com'}
    r = requests.post(url, data=payload)

    response = r.json()
    print response

def login(username, password):
    url = "{}{}{}".format(hostname, rest_prefix, "/login")
    r = requests.get(url, auth=(username, password))

    response = r.json()
    print response

def award_points(username, password, points):
    url = "{}{}{}".format(hostname, rest_prefix, "/award_points")
    payload = {'points': points}

    r = requests.post(url, auth=(username, password), data=payload)
    response = r.json()
    print response

def get_points(username, password):
    url = "{}{}{}".format(hostname, rest_prefix, "/get_points")

    r = requests.get(url, auth=(username, password))
    response = r.json()
    print response


def get_achievements(username, password):
    url = "{}{}{}".format(hostname, rest_prefix, "/get_achievements")

    r = requests.get(url, auth=(username, password))
    response = r.json()
    print response


def get_unearned_achievements(username, password):
    url = "{}{}{}".format(hostname, rest_prefix, "/get_unearned_achievements")

    r = requests.get(url, auth=(username, password))
    response = r.json()
    print response

def lookupBarcode(upc):
    payload = {'request_type': request_type, 'access_token': upc_access_token, 'upc': upc}
    # payload = (('request_type', request_type), ('access_token', access_token), ('upc', upc))

    r = requests.get(upc_host, params=payload)
    response = r.json()
    print response


def generate_random_word():
    r = requests.get(hostname + rest_prefix + "/generate_random_word")
    response = r.json()
    print response

def check_letter(upc, target_word, letters_guessed):
    payload = {'upc': upc, 'target_word':target_word, 'letters_guessed': letters_guessed}

    r = requests.get(hostname + rest_prefix + "/play_hangman", params=payload)
    response = r.json()
    print response

def image_colors(upc):
    payload = {'upc': upc}

    r = requests.get(hostname + rest_prefix + "/image_colors", params=payload)
    response = r.json()
    print response


def generate_maze(width, height):
    payload = {'width': width, 'height': height}

    r = requests.get(hostname + rest_prefix + "/generate_maze", params=payload)
    response = r.json()
    print response


def maze_move(dir, maze, row, col):
    payload = {'dir': dir, 'maze': maze, 'row': row, 'col': col}

    r = requests.get(hostname + rest_prefix + "/maze_move", params=payload)
    response = r.json()
    print response

if __name__ == "__main__":

    # generate_random_word()
    # check_letter(h, "catch", "_____")

    # image_colors("722776200100")

    # color = fg('#ff0000')
    # res = attr('reset')
    # print (color + "Hello World !!!" + res)

    # print(x256.from_rgb(220, 40, 150))

    # dir = "west"
    # maze = "12_8_10_10_9_7_5_12_9_5_14_3_5_6_3_12_9_6_9_13_7_6_10_2_3"
    # row = 2
    # col = 1
    #
    #
    #
    # maze_move(dir, maze, row, col)

    # generate_maze(5, 5)

    # generate_random_word()

    # create_user()

    # award_points('ebleiweiss', 'testpw', 150)
    # get_points('ebleiweiss', 'testpw')


    get_achievements('ebleiweiss', 'testpw')
    print('\n\n')
    get_unearned_achievements('ebleiweiss', 'testpw')

