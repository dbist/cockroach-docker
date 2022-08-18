#!/bin/bash

docker compose up -d

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --insecure --host=roach-0 \
 --execute="CREATE SCHEMA IF NOT EXISTS todo;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --insecure --host=roach-0 \
 --execute="CREATE DATABASE IF NOT EXISTS ferretdb;"
