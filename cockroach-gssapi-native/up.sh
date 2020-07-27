#!/bin/bash

docker-compose build --no-cache
docker-compose up -d

docker-compose exec cockroach \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=cockroach \
 --execute="CREATE USER tester;"

docker-compose exec cockroach \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=cockroach \
 --execute="GRANT ALL ON DATABASE defaultdb TO tester;"

docker-compose exec cockroach \
 /cockroach/cockroach sql \
  --certs-dir=/certs --host=cockroach \
  --execute="SET cluster setting server.host_based_authentication.configuration = 'host all all all gss include_realm=0';"

docker-compose exec cockroach \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=cockroach \
 --execute="SET CLUSTER SETTING cluster.organization = 'Cockroach Labs - Production Testing';" -e "SET CLUSTER SETTING enterprise.license ='${COCKROACH_DEV_LICENSE}';"

docker-compose exec cockroach \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=cockroach \
 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"
