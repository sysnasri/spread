from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():

    return '<h1 style="color:blue;text-align:center">Hello World Spreadgroup team! My future work place</h1>'


if __name__ == '__main__':
    app.run()
