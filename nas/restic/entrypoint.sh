#!/bin/sh
set -e

export B2_ACCOUNT_ID="$RESTIC_B2_ID"
export B2_ACCOUNT_KEY="$RESTIC_B2_KEY"
BACKUP='/data/public'
BUCKET='hot-griffinht-com'
REPOSITORY='hot'
CACHE='/restic/cache'
PASSWORD="$RESTIC_PASSWORD"

check() {
  echo "$PASSWORD" | restic \
    -r b2:"$BUCKET":"$REPOSITORY" \
    snapshots
}

init() {
  echo "$PASSWORD" | restic \
    -r b2:"$BUCKET":"$REPOSITORY" \
    init
}

echo 'checking for existing repository'
if ! check; then
  echo 'repository does not exist, initializing'
  init
fi
echo 'done'

backup() {
  echo "$PASSWORD" | restic \
    -r b2:"$BUCKET":"$REPOSITORY" \
    --cache-dir "$CACHE" \
    --cleanup-cache \
    --verbose \
    backup "$BACKUP"
}

while true; do
  echo 'backing up'
  date +%Y-%m-%dT%T
  backup
  sleep 15s
done