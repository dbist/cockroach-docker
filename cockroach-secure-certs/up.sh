#!/bin/bash

if [ "$*" == "" ]; then
    echo "No arguments provided"
    echo "Argument 1: databasename"
    exit 1
fi

DATABASE=$1
USER=$2

docker-compose build --no-cache
docker-compose up -d

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE DATABASE $DATABASE;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET DATABASE = $DATABASE;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER max WITH PASSWORD 'roach';"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ALL ON DATABASE $DATABASE TO max;"

docker-compose exec roach-0 /cockroach/cockroach sql --certs-dir=/certs --host=roach-0 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"
