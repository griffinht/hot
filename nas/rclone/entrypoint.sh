#!/bin/sh

B2_ACCOUNT="$RCLONE_B2_ACCOUNT"
B2_KEY="$RCLONE_B2_KEY"
SOURCE='/backup'
CACHE='/rclone/cache'
REMOTE='hot'

echo creating config
rclone config create "$REMOTE" b2 \
  --b2-account "$B2_ACCOUNT"\
  --b2-key "$B2_KEY"

sync() {
  rclone sync \
    --progress \
    --cache-dir "$CACHE" \
    "$SOURCE" "$REMOTE":
}

while true; do
  echo 'syncing'
  sync
  echo 'done'
  sleep '15s'
done
