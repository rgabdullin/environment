#!/bin/bash
set -e

docker compose build
docker compose push

docker stack deploy -c docker-compose.yaml env
docker stack deploy -c dask-cluster.yaml env
