#!/bin/sh

set -e

echo psql | kinit sqlalchemy@EXAMPLE.COM

env

sleep 10

tail -f /dev/null
