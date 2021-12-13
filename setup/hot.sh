#!/bin/bash
set -e

# hot
apt-get install -y git
useradd -m -s /bin/bash hot
su - hot << EOF
# generate a deploy key for GitHub
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "griffinht@gmail.com"
echo
echo "Title: hot-desktop"
echo "Key: "
cat ~/.ssh/id_ed25519.pub
echo
echo "Add this key to GitHub as a deploy key for this repository"
read -rp "Press enter to continue and clone repository"
#todo
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone git@github.com:stzups/hot.git
EOF

# rootless docker
apt-get install -y uidmap
# not needed
#apt-get install -y slirp4netns
#apt-get install -y dbus-user-session
# todo restart here after dbus-user-session
loginctl enable-linger hot
# make sure environment variables are escaped! https://stackoverflow.com/a/27921346/11975214
systemd-run --uid=hot --pipe /bin/bash << 'EOF'
## fix XDG_RUNTIME_DIR
# https://unix.stackexchange.com/a/657714/480971 :)
export XDG_RUNTIME_DIR=/run/user/$UID
printf "export XDG_RUNTIME_DIR=/run/user/\$UID\n" >> ~/.bashrc

## rootless docker (needs XDG_RUNTIME_DIR)
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
loginctl enable-linger hot

# hot
sysctl -w net.ipv4.ip_unprivileged_port_start=123
