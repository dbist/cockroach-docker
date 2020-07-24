#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env

# uncomment this for a non-kerberos example
# node basic-sample.js

# this is a kerberos example
node kerberos-sample.js

tail -f /dev/null
