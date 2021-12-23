#!/bin/bash
set -e

./scripts/docker.sh

useradd -m -s /bin/bash docker-user

./scripts/rootless-docker.sh docker-user

echo "net.ipv4.ip_unprivileged_port_start = 0" > /etc/sysctl.d/hot.conf
sudo sysctl --system
