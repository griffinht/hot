#!/bin/sh

# todo pass in any number of host:vm ports

./scripts/ssh.sh \
    -L 8080:localhost:80 \
    root@localhost
