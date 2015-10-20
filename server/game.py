from flask import Flask, request, jsonify
app = Flask(__name__)

import requests
import logging
import pprint

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

    :return: random word as string
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

@app.route('/v1/check_letter', methods=["GET"])
def check_letter():
    """
    Checks whether product name first letter is in word

    Request parameters
    upc: product UPC as string
    target_word: target word as string
    letters_guessed: state of current game / all letters guessed (array)

    return: random word as string
    """

    upc = request.args.get('upc')
    target_word = request.args.get('target_word')
    target_letters = list(target_word)
    letters_guessed = request.args.get('letters_guessed')

    # Get "guess letter" corresponding to current scanned object
    product_name = get_product_name(upc)
    current_letter = product_name[0]

    response = {}

    if current_letter in letters_guessed:
        response["status"] = "success"
        response["guess"] = "duplicate"
        response["letters_guessed"] = letters_guessed
    elif current_letter in target_letters:
        new_letters = list(letters_guessed)
        for i in target_letters:
            if target_letters[i] == current_letter:
                new_letters[i] = current_letter

        response["status"] = "success"
        response["guess"] = current_letter
        response["letters_guessed"] = new_letters
    else:
        response["status"] = "success"
        response["guess"] = "not in word"
        response["letters_guessed"] = letters_guessed

    return jsonify(response)




@app.route('/v1/get_product_nameOLD', methods=["GET"])
def get_product_nameOLD():
    """
    Gets product name from scanned UPC barcode from searchupc.com

    Request parameters
    upc: product UPC as string

    return: product name as json
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



if __name__ == "__main__":
    app.run(debug=True)
