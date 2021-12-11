from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():

    return "Hello World Spreadgroup team! My future work place"


if __name__ == '__main__':
    app.run()
