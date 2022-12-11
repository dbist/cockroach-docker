#!/bin/bash

docker compose build --no-cache
docker compose up -d

docker compose exec roach-0 \
  /cockroach/cockroach sql \
  --host=lb \
  --insecure \
  --execute="CREATE DATABASE bank;"
