#!/bin/bash

docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/http_acme http_acme
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/http_certificates http_certificates
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/http_passwd http_passwd
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/wireguard_wg-access-server-data wireguard_wg-access-server-data
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/ data
