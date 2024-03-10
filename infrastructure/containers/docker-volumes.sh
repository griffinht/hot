#!/usr/bin/env sh

#todo use local hostnames
#todo use wireguard
#
#this script is bascially indempotent, run it multiple times and you should be fine
#(won't delete old volumes)

docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=guix.lan.hot.griffinht.com,rw --opt device=:/docker/container_redis container_redis
