#!/bin/sh
set -e

BACKUP='/data/public/docker'
BACKUP2='/data/public/backup'

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
  restic forget --keep-daily 7 --keep-weekly 2 --keep-monthly 1 --prune
}

while true; do
  echo 'backing up'
  date +%Y-%m-%dT%T
  backup
  sleep 1d
done
