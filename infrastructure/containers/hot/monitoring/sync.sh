#!/bin/sh

scp -r prometheus_config/* cloudtest.lan.hot.griffinht.com:/var/lib/docker/volumes/monitoring_prometheus_config/_data
scp -r alertmanager_config/* cloudtest.lan.hot.griffinht.com:/var/lib/docker/volumes/monitoring_alertmanager_config/_data
#scp mktxp.conf cloudtest.lan.hot.griffinht.com:/var/lib/docker/volumes/monitoring_mktxp_config/_data
