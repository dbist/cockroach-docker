#!/bin/bash

docker-compose build --no-cache
docker-compose up -d

#docker-compose exec roach-0 \
# /cockroach/cockroach sql \
# --certs-dir=/certs --host=roach-0 \
# --execute="CREATE DATABASE IF NOT EXISTS rails_development;"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 \
 --execute="CREATE USER IF NOT EXISTS roach WITH PASSWORD 'roach';"

docker-compose exec roach-0 \
 /cockroach/cockroach sql \
 --certs-dir=/certs --host=roach-0 --execute="GRANT ADMIN TO roach;"

#docker-compose exec roach-0 \
# /cockroach/cockroach sql \
# --certs-dir=/certs --host=roach-0 \
# --execute="GRANT ALL ON DATABASE rails_development TO roach;"

docker-compose exec app \
 bundle exec rake db:setup db:migrate
