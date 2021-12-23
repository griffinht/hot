#!/bin/bash
set -e

useradd -m -s /bin/bash docker-user
su - docker-user << 'EOF'
mkdir -p ~/.ssh
cat /home/admin/.ssh/authorized_keys > ~/.ssh/authorized_keys
EOF

# run from diff host!
ssh -T docker-user@192.168.0.5 << 'EOF'
#curl -fsSL https://get.docker.com/rootless | sh
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
printf "export DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/docker.sock\n" >> ~/.bashrc
EOF
docker context create hot-desktop --docker host=ssh://docker-user@192.168.0.5