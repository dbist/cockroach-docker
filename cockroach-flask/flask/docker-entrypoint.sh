#!/bin/sh

set -e

python init_db.py
python app.py
sleep 5
flask run -h flask -p 8000
