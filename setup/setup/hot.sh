#!/bin/bash
set -e

USER="docker-user"

./scripts/docker.sh

if id "$USER" > /dev/null; then
  echo warning: user "$USER" already exists
else
  useradd -m -s /bin/bash "$USER"
fi

./scripts/rootless-docker.sh "$USER"

echo "net.ipv4.ip_unprivileged_port_start = 0" > /etc/sysctl.d/hot.conf
sysctl --system
