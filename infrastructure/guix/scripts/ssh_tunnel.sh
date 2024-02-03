#!/bin/sh

# todo pass in any number of host:vm ports

./scripts/ssh.sh \
    -L 8080:localhost:80 \
    -L 4445:localhost:445 \
    -N \
    root@localhost
