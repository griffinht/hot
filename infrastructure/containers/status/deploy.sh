#!/bin/sh

set -xe

prefix=/home/griffin/.local/share/containers/storage/volumes/status_
suffix=/_data

echo alertmanager
cp alertmanager.yml "${prefix}alertmanager_config${suffix}"

echo prometheus
cp prometheus.yml "${prefix}prometheus_config${suffix}"
docker compose kill --signal=SIGHUP prometheus

echo xmpp-alerts
cp xmpp-alerts.yml "${prefix}prometheus_config${suffix}"

echo caddy
cp Caddyfile "${prefix}caddy_config${suffix}"
cp -r html "${prefix}caddy_html${suffix}"
