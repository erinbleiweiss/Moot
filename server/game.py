from flask import Flask, request, jsonify
app = Flask(__name__)

import requests
from pprintpp import pprint

search_upc_url = "http://www.searchupc.com/handlers/upcsearch.ashx"
UPC_REQUEST_TYPE = "3"
UPC_ACCESS_TOKEN = "EDDD50C8-9FC4-48D0-B29A-1E1EF405283A" #TODO: Read from file


@app.route("/")
def hello():
    """Placeholder string for API"""
    return "Hello world!"


@app.route('/healthcheck')
def health_check():
    """AWS Healthcheck"""
    return "healthy"


@app.route('/v1/get_product_name', methods=["GET"])
def get_product_name():
    """
    Gets product name from scanned UPC barcode from searchupc.com
    :param upc: product UPC as string
    :return: product name as json
    """

    #TODO: Wrap in try/catch
    params = {'request_type': UPC_REQUEST_TYPE,
              'access_token': UPC_ACCESS_TOKEN,
              'upc': request.args.get('upc')}
    barcode_data = requests.get(search_upc_url, params=params)
    barcode_data = barcode_data.json()
    product_name = barcode_data["0"]["productname"]

    pprint(barcode_data)

    response = {}
    response["product_name"] = product_name

    return jsonify(response)



if __name__ == "__main__":
    app.run(debug=True)
