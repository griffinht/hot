#!/bin/bash
set -e

./scripts/docker.sh

useradd -m -s /bin/bash docker-user

./scripts/rootless-docker.sh docker-user

echo "net.ipv4.ip_unprivileged_port_start = 0" > /etc/sysctl.d/hot.conf
sudo sysctl --system






# run from diff host!
ssh -T docker-user@192.168.0.5 << 'EOF'
#curl -fsSL https://get.docker.com/rootless | sh
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
printf "export DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/docker.sock\n" >> ~/.bashrc
EOF
docker context create hot-desktop --docker host=ssh://docker-user@192.168.0.5