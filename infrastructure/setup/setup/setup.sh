#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo 'cd '"$(pwd)"' && ./hot.sh' | sudo --login
else
  ./hot.sh
fi