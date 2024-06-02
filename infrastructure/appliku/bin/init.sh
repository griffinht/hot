#!/bin/sh

set -e

echo copy paste pubkey https://app.appliku.com/dashboard/team/griffin-wextrsrn/servers/new-custom
read -r pubkey
ssh.sh << EOF
set +xe
echo $pubkey >> .ssh/authorized_keys
echo done! results:
cat .ssh/authorized_keys
echo
EOF

echo IP: "$HOST"
echo 'User: root (default)'
