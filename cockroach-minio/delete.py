#!/usr/bin/python3

import ndjson, glob, sys
import psycopg2
import psycopg2.errorcodes
import time
import logging
import random

chrg_cd_output = open('chrg_cd.sql', 'w')
chrg_cd = glob.glob('./data/miniobucket/customer/chrg_cd/**/*.ndjson')
count = 0
for i in chrg_cd:
   with open(i, 'r') as f:
      for line in f:
        data = ndjson.loads(line)
        if data[0]["after"] == None:
            print(data[0]["key"][0])
            count+=1

print("Record count: {}".format(count))

# print(data[0]["after"]["chrg_id"])


