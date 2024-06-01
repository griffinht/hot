#!/bin/sh

set -xe

prefix=/home/griffin/.local/share/containers/storage/volumes/status_

mkdir mnt
sshfs root@nerd-vps.wg.hot.griffinht.com:/var/lib/docker/volumes mnt -o uid="$(id -u)" -o gid="$(id -g)"
prefix=mnt/status_

#sleep 100000

cleanup() {
    fusermount --unmount mnt
    rmdir mnt
}
trap cleanup EXIT
#trap cleanup INT

suffix=/_data

echo alertmanager
cp -r alertmanager_config/* "${prefix}alertmanager_config${suffix}"

echo prometheus
cp -r prometheus_config/* "${prefix}prometheus_config${suffix}"
#docker compose kill --signal=SIGHUP prometheus

echo xmpp-alerts
cp -r xmpp-alerts_config/* "${prefix}xmpp-alerts_config${suffix}"

echo caddy
cp -r caddy_config/* "${prefix}caddy_config${suffix}"
cp -r caddy_html/* "${prefix}caddy_html${suffix}"
