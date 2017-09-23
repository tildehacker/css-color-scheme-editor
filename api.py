#!/usr/bin/env python

import sys

from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/", methods=['POST'])
def save():
    with open(sys.argv[1]) as f:
        lines = f.readlines()

    for key, value in request.json.items():
        for index, line in enumerate(lines):
            lines[index] = line.replace(key, value)

    with open(sys.argv[2], 'w') as f:
        f.writelines(lines)

    return "Success"

if __name__ == "__main__":
    app.run(host=sys.argv[3], port=sys.argv[4])
