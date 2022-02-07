#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env

sleep 10

cockroach sql --certs-dir=/certs --url  "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -f dbinit.sql

cockroach sql --certs-dir=/certs --url  "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" --execute="GRANT ALL ON DATABASE PRISMA TO tester;"

# npx prisma db pull # gets executed as root instead of tester

tail -f /dev/null
