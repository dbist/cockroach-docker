#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --user "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
   CREATE DATABASE dvdrental;
   GRANT ALL PRIVILEGES ON DATABASE dvdrental TO postgres;
EOSQL
