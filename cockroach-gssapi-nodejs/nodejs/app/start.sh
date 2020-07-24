#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env

node basic-sample.js

tail -f /dev/null
