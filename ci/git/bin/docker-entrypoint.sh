#!/usr/bin/env sh

if test -n /ssh/ssh_host_id_ed25519_key; then
    ssh-keygen -f /ssh/ssh_host_id_ed25519_key -N '' -t ed25519
else
    echo found existing ssh key, not regenerating
fi

exec /usr/sbin/sshd -D
