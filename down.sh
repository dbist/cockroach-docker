#!/bin/bash

docker compose -f $1 down --remove-orphans --volumes
