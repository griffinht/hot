
QEMU_KERNEL_PARAMS=console=tty50 \
    qemu-system-x86_64 \
    -enable-kvm \
    -drive "file=${1?},format=qcow2" \
    -m 1024 \
    -nographic \
    -nic "user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:2222-:22"
