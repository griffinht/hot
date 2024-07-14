#!/bin/sh

set +xe

    #doesn't work
    #-net user,hostfwd=tcp:127.0.0.1:2222-:22 \
QEMU_KERNEL_PARAMS=console=ttyS0 \
    ./result/bin/run-nixos-vm \
    -nographic \
    -nic "user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:2222-:22"
