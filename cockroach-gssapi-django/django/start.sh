#!/bin/sh

set -e

echo psql | kinit django@EXAMPLE.COM

env
echo "sleep 10"
sleep 10
python manage.py makemigrations myproject
sleep 10
python manage.py migrate
sleep 10
python manage.py runserver 0.0.0.0:8000
#tail -f /dev/null
