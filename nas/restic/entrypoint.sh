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
  # todo
  exit 1
  init
fi
echo 'done'

backup() {
  restic \
    --cleanup-cache \
    --verbose \
    backup "$BACKUP"
  restic \
    --cleanup-cache \
    --verbose \
    backup "$BACKUP2"
  restic forget --prune --keep-daily 3 --keep-weekly 1 --keep-monthly 1
}

while true; do
  echo 'backing up'
  date +%Y-%m-%dT%T
  backup
  sleep 1d
done
