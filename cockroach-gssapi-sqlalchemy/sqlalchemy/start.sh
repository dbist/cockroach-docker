#!/bin/sh

set -e

echo psql | kinit sqlalchemy@EXAMPLE.COM

env

sleep 10

python ./sqlalchemy/sqlalchemy-basic-sample.py

tail -f /dev/null
