#!/bin/sh

set -e

sleep 10
python init_db.py
python app.py
sleep 10
flask run -h flask -p 8000
