#!/bin/bash
set -e

cat << EOF >> /etc/modules
nfs
nfsd
EOF