#!/bin/bash
set -e

useradd -m -s /bin/bash docker-user
su - docker-user << 'EOF'
mkdir -p ~/.ssh
cat /home/admin/.ssh/authorized_keys > ~/.ssh/authorized_keys
EOF

# rootless docker
apt-get install -y uidmap
# not needed
#apt-get install -y slirp4netns

# make sure environment variables are escaped! https://stackoverflow.com/a/27921346/11975214
# machinectl
#apt-get install -y systemd-container


# run from diff host!
ssh -T docker-user@192.168.0.5 << 'EOF'
#curl -fsSL https://get.docker.com/rootless | sh
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
printf "export DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/docker.sock\n" >> ~/.bashrc
EOF
docker context create hot-desktop --docker host=ssh://docker-user@192.168.0.5

#todo this or that
systemd-run --uid=docker-user --pipe /bin/bash << 'EOF'
## fix XDG_RUNTIME_DIR
# https://unix.stackexchange.com/a/657714/480971 :)
export XDG_RUNTIME_DIR=/run/user/$UID
printf "export XDG_RUNTIME_DIR=/run/user/\$UID\n" >> ~/.bashrc

## rootless docker (needs XDG_RUNTIME_DIR)
# dockerd-rootless-setuptool.sh install ????
curl -fsSL https://get.docker.com/rootless | sh

## fix DOCKER_HOST
#optional?
#export PATH=/home/$(whoami)/bin:$PATH
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
printf "export DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/docker.sock\n" >> ~/.bashrc

## start docker - todo necessary???
#systemctl --user start docker

docker version
docker-compose version

EOF
loginctl enable-linger docker-user

# hot
sysctl -w net.ipv4.ip_unprivileged_port_start=123
echo "net.ipv4.ip_unprivileged_port_start=123" > /etc/sysctl.d/docker.conf