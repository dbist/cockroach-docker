#!/bin/bash

docker compose build --no-cache
docker compose up -d

docker compose exec roach-0 \
 /cockroach/cockroach init \
 --certs-dir=/certs --host=roach-0

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE DATABASE flask_db;"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET DATABASE = flask_db;"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER roach WITH PASSWORD 'roach';"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ALL ON DATABASE flask_db TO roach WITH GRANT OPTION;"

docker compose exec roach-0 /cockroach/cockroach sql --certs-dir=/certs --host=roach-0 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"
