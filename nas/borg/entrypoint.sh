#!/bin/sh

REPOSITORY='/borg'
BACKUP='/data'

echo checking "$REPOSITORY"
if [ "$(ls -A $REPOSITORY)" ]; then
  echo "$REPOSITORY" is empty, init new borg repository
  borg init --encryption=none /borg
fi

backup() {
  borg create --stats "$REPOSITORY" "$BACKUP"
}

while true; do
  backup
  sleep 100
done
