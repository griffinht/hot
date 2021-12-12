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
apt-get install -y dbus-user-session slirp4netns
# todo restart here
loginctl enable-linger hot
# make sure environment variables are escaped! https://stackoverflow.com/a/27921346/11975214
systemd-run --uid=docker-user --pipe /bin/bash << 'EOF'
# https://unix.stackexchange.com/a/657714/480971 :)
export XDG_RUNTIME_DIR=/run/user/$UID
curl -fsSL https://get.docker.com/rootless | sh
#optional?
#export PATH=/home/$(whoami)/bin:$PATH
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
systemctl --user start docker
printf "export XDG_RUNTIME_DIR=/run/user/\$UID\nexport DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/docker.sock\n" >> ~/.bashrc

docker version
docker-compose version

EOF

sysctl -w net.ipv4.ip_unprivileged_port_start=123
