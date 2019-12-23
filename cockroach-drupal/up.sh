#!/bin/bash

docker-compose up -d

docker-compose exec crdb-1 \
 /cockroach/cockroach sql \
 --insecure \
 --execute="CREATE DATABASE drupal;"

docker-compose exec crdb-1 \
 /cockroach/cockroach sql \
 --insecure \
 --execute="SET DATABASE = drupal;"

docker-compose exec crdb-1 \
 /cockroach/cockroach sql \
 --insecure \
 --execute="CREATE USER drupal;"

docker-compose exec crdb-1 \
 /cockroach/cockroach sql \
 --insecure \
 --execute="GRANT ALL ON DATABASE drupal TO drupal;"

docker-compose exec crdb-1 \
 /cockroach/cockroach sql \
 --insecure \
 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"
