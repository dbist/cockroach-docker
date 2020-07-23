#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env

sleep 5000

#psql -w "sslmode=require host=cockroach dbname=defaultdb user=root"
