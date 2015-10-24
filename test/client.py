import requests
import json
import pprint

hostname = "http://52.26.94.97:5000"
rest_prefix = "/v1"

upc_host = 'http://www.searchupc.com/handlers/upcsearch.ashx'
upc_access_token = 'EDDD50C8-9FC4-48D0-B29A-1E1EF405283A'
request_type = '3'

cliffbarupc = "722252660091"

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

def image_colors(url):
    payload = {'url': url}

    r = requests.get(hostname + rest_prefix + "/image_colors", params=payload)
    response = r.json()
    print response

if __name__ == "__main__":

    # generate_random_word()
    # check_letter(cliffbarupc, "catch", "_____")

    image_colors("http://ecx.images-amazon.com/images/I/51k%2BSIgoMjL._SL160_.jpg")
