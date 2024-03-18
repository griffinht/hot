#!/bin/sh

mkdir -p mnt
sshfs -o default_permissions,uid="$(id -u)",gid="$(id -g)" \
    cloudtest.lan.hot.griffinht.com:/var/lib/docker/volumes/ mnt
