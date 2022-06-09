#!/bin/bash

docker-compose up -d

docker exec -it roach-0 \
 /cockroach/cockroach init \
 --insecure --host=roach-0

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --insecure --host=roach-0 \
 --execute="CREATE SCHEMA IF NOT EXISTS test;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --insecure --host=roach-0 \
 --execute="CREATE DATABASE IF NOT EXISTS mangodb;"
