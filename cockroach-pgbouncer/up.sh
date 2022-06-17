#!/bin/bash

docker compose build --no-cache
docker compose up -d

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --insecure --host=roach-0 \
 --execute="CREATE USER IF NOT EXISTS roach;"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --insecure --host=roach-0 --execute="GRANT ADMIN TO roach;"
