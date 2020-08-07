#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env
echo "waiting a bit"
sleep 10
python manage.py migrate
python manage.py runserver 0.0.0.0:9999
tail -f /dev/null
