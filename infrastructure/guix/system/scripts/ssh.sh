#!/bin/sh

# default behavior with no args
if [ $# -eq 0 ]; then
    set -- "root@localhost"
fi

# todo add -o no rememeber
ssh \
    -i id_ed25519.bin \
    -p 2222 \
    "$@"
