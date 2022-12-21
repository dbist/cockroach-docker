#!/bin/bash

docker compose build --no-cache
docker compose up -d

docker compose exec roach-0 \
  /cockroach/cockroach sql \
  --host=roach-0 \
  --insecure \
  --execute="CREATE DATABASE IF NOT EXISTS pgbench;"
