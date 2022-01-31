#!/bin/bash

# grab the latest cockroach image
docker pull cockroachdb/cockroach:latest-v21.1

docker-compose build --no-cache
docker-compose up -d

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER IF NOT EXISTS roach WITH PASSWORD 'roach';"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 --execute="GRANT ADMIN TO roach;"

# Need to copy client certs for roach generated using PGBouncer CA to /shared directory
docker-compose exec --user root pgbouncer \
 mkdir -p /shared/client/certs
docker-compose exec --user root pgbouncer \
 cp -r /home/postgres/certs /shared/client

# Need to copy server certs for pgbouncer generated using cockroach CA to /shared/node/certs directory
docker-compose exec --user root pgbouncer \
 mkdir -p /shared/node/certs
docker-compose exec --user root pgbouncer \
 cp -r /certs /shared/node
docker-compose exec --user root pgbouncer \
 chown -R postgres:root /shared/node/certs

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 --execute="CREATE DATABASE tpcc;"
