#!/bin/bash

docker-compose build --no-cache
docker-compose up -d

docker-compose exec roach-0 \
 /cockroach/cockroach workload init movr \
 'postgresql://root@roach-0:26257?sslcert=/certs/client.root.crt&sslkey=/certs/client.root.key&sslmode=verify-full&sslrootcert=/certs/ca.crt'

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="SET DATABASE = movr;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER maxroach WITH PASSWORD 'maxroach';"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ALL ON TABLE movr.* TO maxroach;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="GRANT ALL ON DATABASE movr TO maxroach;"

docker exec --user root -it jupyterlab \
 bash -c 'chown -R jovyan /certs/client.maxroach.*'

docker-compose exec roach-0 \
 /cockroach/cockroach sql --certs-dir=/certs \
 --host=roach-0 \
 --execute="SET CLUSTER SETTING server.remote_debugging.mode = \"any\";"
