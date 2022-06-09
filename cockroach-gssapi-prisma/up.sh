#!/bin/bash

docker pull cockroachdb/cockroach:latest-v21.2

docker compose build --no-cache
docker compose up -d

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER tester;"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ALL ON DATABASE defaultdb TO tester;"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER roach WITH PASSWORD 'roach';"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ADMIN TO roach;"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
  --certs-dir=/certs --host=roach-0 \
  --execute="SET cluster setting server.host_based_authentication.configuration = 'host all all all gss include_realm=0';"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET CLUSTER SETTING cluster.organization = 'Cockroach Labs - Production Testing';" -e "SET CLUSTER SETTING enterprise.license ='${COCKROACH_DEV_LICENSE}';"

docker compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"



docker cp client:/certs .
