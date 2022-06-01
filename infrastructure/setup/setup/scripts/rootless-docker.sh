#!/bin/bash
set -e

# usage
# rootless-docker.sh $USER
USER="$1"
if [ -z "$USER" ]; then
  echo specify a user
  exit 1
fi

# https://docs.docker.com/engine/security/rootless/#networking-errors
# fix for docker run -p does not propagate source IP addresses
# decreases throughput according to docs
#todo test might require reload
mkdir -p ~/.config/systemd/user/docker.service.d/
cat << EOF > ~/.config/systemd/user/docker.service.d/override.conf
[Service]
Environment="DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER=slirp4netns"
EOF

# https://docs.docker.com/engine/security/rootless/

# system dependencies
if ! dpkg -l dbus-user-session > /dev/null; then
  echo error: dbus-user-session not installed
  echo this should be installed manually, and might require a restart
  exit 1;
fi

apt-get install -y uidmap

# https://docs.docker.com/engine/security/rootless/#networking-errors
if ! dpkg -l slirp4netns; then
  echo warning: manually installing optional package slirp4netns because it was not already installed
  apt-get install -y slirp4netns
fi

# system setup
# https://unix.stackexchange.com/a/657714/480971
loginctl enable-linger "$USER"

# user install
#systemd-run --uid="$USER" --pipe /bin/bash << 'EOF'
su - "$USER" << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$UID
dockerd-rootless-setuptool.sh install
EOF

# user setup
#systemd-run --uid="$USER" --pipe /bin/bash << 'EOF'
su - "$USER" << 'EOF'
# add environment variables to beginning of .bashrc (before non-interactive check)
# https://superuser.com/a/246841/1252579
source ~/.bashrc
echo $DOCKER_HOST
if [ -n "$DOCKER_HOST" ]; then
  exit 0
fi
temp=$(mktemp)
printf '# setup/rootless-docker.sh\nexport XDG_RUNTIME_DIR=/run/user/$UID\nexport DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock\n' | cat - ~/.bashrc > $temp && mv $temp ~/.bashrc
EOF