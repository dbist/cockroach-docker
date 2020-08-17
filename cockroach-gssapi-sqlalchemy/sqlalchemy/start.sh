#!/bin/sh

set -e

echo psql | kinit sqlalchemy@EXAMPLE.COM

env

tail -f /dev/null
