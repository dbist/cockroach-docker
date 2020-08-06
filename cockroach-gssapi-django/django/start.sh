#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env

# Exit with error unless we find the expected error message.
python manage.py inspectdb 2>&1 | grep 'use of GSS authentication requires an enterprise license'
