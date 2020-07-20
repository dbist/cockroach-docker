#!/bin/sh

set -e

echo psql | kinit tester@MY.EX

env

sleep 5000

#psql -w "sslmode=require host=cockroach dbname=defaultdb user=root"
