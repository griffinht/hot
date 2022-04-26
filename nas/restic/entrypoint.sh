#!/bin/sh
set -e

export B2_ACCOUNT_ID="$RESTIC_B2_ID"
export B2_ACCOUNT_KEY="$RESTIC_B2_KEY"

export RESTIC_PASSWORD="$RESTIC_PASSWORD"

BUCKET='hot-griffinht-com'
REPOSITORY='hot'
export RESTIC_REPOSITORY='b2:'"$BUCKET"':'"$REPOSITORY"

BACKUP='/data/public/docker'
BACKUP2='/data/public/backup'
CACHE='/restic/cache'

check() {
  restic snapshots
}

init() {
  restic init
}

echo 'checking for existing repository'
if ! check; then
  echo 'repository does not exist, initializing'
  init
fi
echo 'done'

backup() {
  restic \
    --cache-dir "$CACHE" \
    --cleanup-cache \
    --verbose \
    backup "$BACKUP"
  restic \
    --cache-dir "$CACHE" \
    --cleanup-cache \
    --verbose \
    backup "$BACKUP2"
}

while true; do
  echo 'backing up'
  date +%Y-%m-%dT%T
  backup
  sleep 1d
done
