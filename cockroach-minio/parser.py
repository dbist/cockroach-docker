#!/usr/bin/python3

import json, glob

files = glob.glob("./data/miniobucket/dogs/2019-12-18/*.ndjson")
# {"after": {"id": 1, "name": "Sam"}, "key": [1], "updated": "1576705237076659400.0000000000"}

try:
    for i in files:
        print(i)
        f = open(i, "r")
        jsonstr = f.read()
        y = json.loads(jsonstr)
        print(y["after"])
except json.decoder.JSONDecodeError:
    pass

#f = open("./data/miniobucket/file", "r")
#jsonstr = f.read()
#y = json.loads(jsonstr)
#print(y["after"])