#!/bin/sh

set -xe

target="${1:-mnt}"
mkdir "$target"
# todo make this work for local environments
sshfs -o default_permissions,uid="$(id -u)",gid="$(id -g)" \
    "${SSH_HOST?}:/var/lib/docker/volumes/" "$target"

echo mounted, entering new shell - type exit to unmount
"$SHELL"

fusermount --unmount "$target"
rmdir "$target"
