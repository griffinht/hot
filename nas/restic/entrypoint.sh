#!/bin/sh
set -e

time() {
  date +%Y-%m-%dT%T
}
echo SCRIPT STARTED
time

BACKUP='/data/public/docker'
BACKUP2='/data/public/backup'

check() {
  echo CHECK
  restic snapshots
}

init() {
  echo INIT
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
  echo BACKUP
  time
  restic \
    --cleanup-cache \
    --verbose \
    backup "$BACKUP"
  time
  restic \
    --cleanup-cache \
    --verbose \
    backup "$BACKUP2"
  time
  restic forget --prune --keep-daily 3 --keep-weekly 1 --keep-monthly 1
  time
}

echo START BACKUP LOOP
while true; do
  echo BACKUP LOOP
  time
  backup
  echo SLEEP
  time
  sleep 1d
  echo DONE SLEEPING
  time
done
