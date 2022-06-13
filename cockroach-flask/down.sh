#!/bin/bash

docker compose down --remove-orphans --volumes
rm -rf flask/__pycache__
