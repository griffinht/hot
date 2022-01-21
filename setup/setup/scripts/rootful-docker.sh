#!/bin/bash
set -e

# usage
# rootful-docker.sh $USER
USER="$1"
if [ -z "$USER" ]; then
  echo specify a user
  exit 1
fi

groupadd -f docker
usermod -aG docker "$USER"

# user setup
su - "$USER" << 'EOF'
# add environment variables to beginning of .bashrc (before non-interactive check)
# https://superuser.com/a/246841/1252579
source ~/.bashrc
echo $DOCKER_HOST
if [ -n "$DOCKER_HOST" ]; then
  exit 0
fi
temp=$(mktemp)
printf '# setup/rootlful-docker.sh\nexport DOCKER_HOST=unix:///var/run/docker.sock\n' | cat - ~/.bashrc > $temp && mv $temp ~/.bashrc
EOF