#!/bin/bash
set -e

KEY_FILE="key"

if [[ ! -f "$KEY_FILE" ]]; then
  echo "warning: no wireguard private key found - regenerating"
  touch "$KEY_FILE"
  chmod 000 "$KEY_FILE"
  chmod u+rw "$KEY_FILE"
  wg genkey > "$KEY_FILE"
fi

wg-access-server serve --wireguard-private-key "$(cat $KEY_FILE)"