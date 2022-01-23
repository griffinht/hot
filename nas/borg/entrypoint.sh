#!/bin/sh
set -e

REPOSITORY='/backup'
ARCHIVE='{now}'
BACKUP='/data/public'
export BORG_BASE_DIR='/borg'

echo checking "$REPOSITORY"
if [ ! "$(ls -A $REPOSITORY)" ]; then
  echo "$REPOSITORY" is empty, init new borg repository
  borg init --encryption=none "$REPOSITORY"
fi

backup() {
  borg create \
    --stats \
    --verbose \
    --show-rc \
    --compression lz4 \
    "$REPOSITORY"::"$ARCHIVE" \
    "$BACKUP"
}

while true; do
  backup
  sleep 15s
done
