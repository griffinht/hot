#!/bin/bash
set -e

USER="docker-user"

./scripts/docker.sh

if id "$USER" > /dev/null; then
  echo warning: user "$USER" already exists
else
  useradd -m -s /bin/bash "$USER"
fi
su - "$USER" << EOF
mkdir -p ~/.ssh/
cat "$(pwd)"/authorized_keys > ~/.ssh/authorized_keys
EOF

# https://docs.docker.com/engine/security/rootless/#networking-errors
# fix for docker run -p does not propagate source IP addresses
# decreases throughput according to docs
#todo test might require reload
mkdir -p ~/.config/systemd/user/docker.service.d/
cat << EOF > ~/.config/systemd/user/docker.service.d/override.conf
[Service]
Environment="DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER=slirp4netns"
EOF

./scripts/rootless-docker.sh "$USER"

echo "net.ipv4.ip_unprivileged_port_start = 0" > /etc/sysctl.d/hot.conf
sysctl --system
