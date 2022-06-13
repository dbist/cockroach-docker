#!/bin/sh

set -e

sleep 10
python manage.py runserver 0.0.0.0:8000
