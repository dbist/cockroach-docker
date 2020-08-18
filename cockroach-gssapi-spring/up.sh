#!/bin/bash

# this doesn't work yet, run locally with `django-admin startproject example .`
# docker-compose run web django-admin startproject example .

docker-compose build --no-cache
docker-compose up -d

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER IF NOT EXISTS roach;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE DATABASE roach_data;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ALL ON DATABASE roach_data TO roach;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
  --certs-dir=/certs --host=roach-0 \
  --execute="SET cluster setting server.host_based_authentication.configuration = 'host all all all gss include_realm=0';"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET CLUSTER SETTING cluster.organization = 'Cockroach Labs - Production Testing';" -e "SET CLUSTER SETTING enterprise.license ='${COCKROACH_DEV_LICENSE}';"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET CLUSTER SETTING server.auth_log.sql_connections.enabled = true;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET CLUSTER SETTING server.auth_log.sql_sessions.enabled = true;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"
