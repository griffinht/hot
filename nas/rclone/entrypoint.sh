#!/bin/sh

B2_ACCOUNT="$RCLONE_B2_ACCOUNT"
B2_KEY="$RCLONE_B2_KEY"
SOURCE='/backup'
REMOTE='hot'

rclone config create "$REMOTE" b2 \
  --b2-account "$B2_ACCOUNT"\
  --b2-key "$B2_KEY"

sync() {
  rclone sync --progress "$SOURCE" "$REMOTE":
}

while true; do
  sync
  sleep 15s
done
