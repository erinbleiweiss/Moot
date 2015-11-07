import requests
import json
import pprint

hostname = "http://52.26.94.97:5000"
rest_prefix = "/v1"

upc_host = 'http://www.searchupc.com/handlers/upcsearch.ashx'
upc_access_token = 'EDDD50C8-9FC4-48D0-B29A-1E1EF405283A'
request_type = '3'

cliffbarupc = "722252660091"

h = "071100210453"

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


    dir = "west"
    maze = "12_8_10_10_9_7_5_12_9_5_14_3_5_6_3_12_9_6_9_13_7_6_10_2_3"
    row = 2
    col = 1



    maze_move(dir, maze, row, col)

    generate_maze(5, 5)
