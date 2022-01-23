#!/bin/sh

REPOSITORY='/borg'
BACKUP='/data/public'

echo checking "$REPOSITORY"
if [ ! "$(ls -A $REPOSITORY)" ]; then
  echo "$REPOSITORY" is empty, init new borg repository
  borg init --encryption=none /borg
fi

backup() {
  borg create \
    --stats \
    --verbose \
    --show-rc \
    --compression lz4 \
    "$REPOSITORY"'::{now}' \
    "$BACKUP"
}

while true; do
  backup
  sleep 15s
done
