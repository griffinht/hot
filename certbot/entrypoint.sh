#!/bin/bash
set -e

while true; do
  ./certbot.sh griffinht.com;
  sleep 1d
done;
