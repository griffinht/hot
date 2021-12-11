#!/bin/bash
set -e

while true; do
  ./cloudflare-dynamic.sh griffinht.com;
  sleep 1d
done;
