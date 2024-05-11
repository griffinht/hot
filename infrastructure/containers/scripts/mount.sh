#!/bin/sh

set -xe

target=mnt
mkdir "$target"
sshfs -o default_permissions,uid="$(id -u)",gid="$(id -g)" \
    "${SSH_HOST?}:/var/lib/docker/volumes/" "$target"

"$SHELL"

fusermount --unmount "$target"
rmdir "$target"
