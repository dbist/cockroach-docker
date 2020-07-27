#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env

node basic-sample.js

# uncomment this for a kerberos example
# node kerberos-sample.js

tail -f /dev/null
