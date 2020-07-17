#!/bin/sh

set -e

echo psql | kinit tester@MY.EX

env

sleep 5000

#echo "host all all all trust" >> pg_hba.conf
#pg_ctl reload

#./gss.test
#psql -w "sslmode=require host=cockroach dbname=defaultdb user=root"
