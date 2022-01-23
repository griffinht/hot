#!/bin/sh

export B2_ACCOUNT_ID="$RESTIC_B2_ID"
export B2_ACCOUNT_KEY="$RESTIC_B2_KEY"
BACKUP='/data/public'
BUCKET='hot-griffinht-com'
REPOSITORY='hot'
PASSWORD='password'

echo "$PASSWORD" | restic -r b2:"$BUCKET":"$REPOSITORY" init

backup() {
  echo "$PASSWORD" | restic -r b2:"$BUCKET":"$REPOSITORY" \
    --verbose \
    backup \
    "$BACKUP"
}

sleep 10000
while true; do
  backup
  sleep 15s
done