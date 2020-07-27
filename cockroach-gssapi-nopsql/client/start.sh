#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env

tail -f /dev/null
