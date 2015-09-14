from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route("/")
def hello():
	return "Hello world!"

@app.route('/healthcheck')
def health_check():
		return "healthy"

if __name__ == "__main__":
	app.run(host="0.0.0.0", debug=True)
