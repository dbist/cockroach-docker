#!/bin/bash

docker-compose build --no-cache
docker-compose up -d

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE DATABASE strapi;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET DATABASE = strapi;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER strapi WITH PASSWORD 'strapi';"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ALL ON DATABASE strapi TO strapi;"

docker-compose exec roach-0 /cockroach/cockroach sql --certs-dir=/certs \
 --host=roach-0 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"
