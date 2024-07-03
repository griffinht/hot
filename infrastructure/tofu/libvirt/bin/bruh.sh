#!/bin/sh


# https://gist.github.com/shamil/62935d9b456a6f9877b5

ssh.sh << EOF
set -xe

modprobe nbd
#mkdir -p /mnt/debian

qemu-nbd --connect=/dev/nbd0 /var/lib/libvirt/images/ubuntu
sleep 1
mount /dev/nbd0p1 /mnt/debian
cleanup() {
    echo cleanup
    umount /mnt/debian
    qemu-nbd --disconnect /dev/nbd0
}
trap cleanup EXIT
tail -f /dev/null
EOF
