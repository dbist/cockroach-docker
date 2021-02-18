#!/bin/bash

docker-compose down --remove-orphans --volumes
rm -rf roach-0 roach-1 roach-2
