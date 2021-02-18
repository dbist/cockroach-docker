#!/bin/bash
set -e

# restore schema
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname $POSTGRES_DB -e -f docker-entrypoint-initdb.d/dvdrental/restore.sql

# restore the data
# pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" docker-entrypoint-initdb.d/dvdrental/dvdrental.tar
