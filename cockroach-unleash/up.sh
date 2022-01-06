#!/bin/bash

docker compose build --no-cache
docker compose up -d

docker exec -it roach-0 \
 /cockroach/cockroach init \
  --insecure \
  --host=roach-0
#  --certs-dir=/certs

# docker compose exec roach-0 \
# /cockroach/cockroach sql \
#  --certs-dir=/certs
#  --host=roach-0 \
#  --execute="CREATE USER IF NOT EXISTS roach WITH PASSWORD 'roach';"

# docker compose exec roach-0 \
# /cockroach/cockroach sql \
#  --host=roach-0 --execute="GRANT ADMIN TO roach;"
#  --certs-dir=/certs 

docker compose exec roach-0 \
 /cockroach/cockroach sql \
  --insecure \
  --host=roach-0 \
  --execute="CREATE DATABASE unleash;"
# --certs-dir=/certs 

docker compose exec roach-0 \
 /cockroach/cockroach sql \
  --insecure \
  --host=roach-0 \
  --execute="SET sql_safe_updates = false;"


# docker cp roach-0:/certs .
