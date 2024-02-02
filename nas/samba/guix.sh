#!/bin/sh

guix shell --container --network \
    --share=/home/griffin/bruh=/bruh \
    samba coreutils -- ./samba.sh "$@"
