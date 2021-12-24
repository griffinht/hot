#!/bin/bash
set -e

HOST="$1"
if [ -z "$HOST" ]; then
  echo 'specify an ssh user@host'
  exit 1
fi
SSH_PUB_KEY="$2"
if [ -z "$SSH_PUB_KEY" ]; then
  echo 'specify an ssh public key (file location)'
  exit 1
fi

# create payload
# contains ./setup and the ssh key
tempdir="$(mktemp -d)"
cp -r ./setup/ "$tempdir"/setup/
cat "$SSH_PUB_KEY" > "$tempdir"/setup/authorized_keys

# tar payload
temp=$(mktemp)
(cd "$tempdir"
tar -cf "$temp" ./setup
)
rm -r "$tempdir"

# transfer payload to $HOST
scp "$temp" "$HOST":setup.tar
rm "$temp"

# execute payload on $HOST
ssh "$HOST" /bin/bash << EOF
set -e
tar -xf setup.tar
rm setup.tar
(
cd setup
./setup.sh
)
rm -r ./setup
EOF