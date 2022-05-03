#!/bin/bash

# todo remove prefix http_
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/http_acme http_acme
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/http_certificates http_certificates
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/http_passwd http_passwd
# todo remove
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/wireguard_wg-access-server-data wireguard_wg-access-server-data
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/vpn vpn
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/downloads downloads
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/qbittorrent qbittorrent
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/minecraft minecraft
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/ data
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/vaultwarden vaultwarden
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/git git
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/wireguard wireguard
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/mail mail
docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.0.5,rw --opt device=:/docker/registry registry
