#!/bin/bash

docker compose build --no-cache
docker compose up -d

docker exec -it roach-0 \
 /cockroach/cockroach init \
 --certs-dir=/certs --host=roach-0

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER IF NOT EXISTS roach WITH PASSWORD 'roach';"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 --execute="GRANT ADMIN TO roach;"

# docker cp roach-0:/certs .
