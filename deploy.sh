#!/bin/bash
set -e

cd /home/ubuntu/flask-mysql-ci-cd

docker compose down
docker compose pull || true
docker compose build
docker compose up -d

docker compose ps
