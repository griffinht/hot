#!/usr/bin/env sh

ssh-keygen -f /ssh/ssh_host_id_ed25519_key -N '' -t ed25519

exec /usr/sbin/sshd -D
