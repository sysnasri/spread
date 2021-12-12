from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():

    return '<h1 style="color:blue;text-align:center">Hello Spreadgroup team! My future work teammate:)</h1>'


if __name__ == '__main__':
    app.run()
