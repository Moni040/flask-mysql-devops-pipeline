#!/bin/bash
apt update -y
apt install -y docker.io docker-compose-plugin rsync
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu