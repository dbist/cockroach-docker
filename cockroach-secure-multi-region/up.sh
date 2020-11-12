#!/bin/bash

docker-compose build --no-cache
docker-compose up -d

docker exec -it roach-sf-0 \
 /cockroach/cockroach init \
 --certs-dir=/certs --host=roach-sf-0

docker-compose exec roach-sf-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-sf-0 \
 --execute="CREATE USER IF NOT EXISTS roach WITH PASSWORD 'roach';"

docker-compose exec roach-sf-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-sf-0 --execute="GRANT ADMIN TO roach;"
