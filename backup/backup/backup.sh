#!/bin/bash

function backup {
  date
  echo "backing up $(pwd)"

  #todo
  date
  echo 'done'
}

while true; do
  backup
  sleep 1d
done