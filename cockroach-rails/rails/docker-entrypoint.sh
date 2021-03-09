#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "starting up"
sleep 10
ruby ./rails/main.rb
tail -f /dev/null