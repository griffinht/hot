#!/bin/bash
set -e

HOST="$1"
if [ -z "$HOST" ]; then
  echo specify a host
  exit 1
fi

temp=$(mktemp)
tar -cf "$temp" ./setup
scp "$temp" "$HOST":setup.tar

ssh "$HOST" /bin/bash << EOF
tar -xf setup.tar
rm setup.tar
(
cd setup
./setup.sh
)
rm -r ./setup
EOF