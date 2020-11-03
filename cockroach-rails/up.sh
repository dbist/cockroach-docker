#!/bin/bash

docker-compose build --no-cache
docker-compose up -d

docker-compose exec database \
 /cockroach/cockroach sql \
 --insecure --host=crdb \
 --execute="CREATE DATABASE IF NOT EXISTS rails_development;"

docker-compose exec database \
 /cockroach/cockroach sql \
 --insecure --host=crdb \
 --execute="CREATE USER IF NOT EXISTS roach;"
docker-compose exec app bundle exec rake db:setup db:migrate
