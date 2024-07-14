#!/bin/sh

set -e

#scp -r prometheus_config/* "$SSH_HOST":/var/lib/docker/volumes/monitoring2_prometheus_config/_data
docker compose cp prometheus_config/* prometheus:/config
#scp -r alertmanager_config/* cloudtest.lan.hot.griffinht.com:/var/lib/docker/volumes/monitoring_alertmanager_config/_data
#scp mktxp.conf cloudtest.lan.hot.griffinht.com:/var/lib/docker/volumes/monitoring_mktxp_config/_data
#todo kill --signal=SIGHUP prometheus
#logs prometheus grep for error? or maybe alert monitoring? the sync job should fail if there is a config error... 


reload() {
    container="$1"
    docker compose kill --signal=SIGHUP "$container"
    result="$(docker compose logs --tail 1 "$container")"
    
    if ! echo "$result" | grep 'Completed loading of configuration file'; then
        echo reload failed
        echo "$result"
        return 1
    fi
}

# todo concurrency
reload prometheus
#reload alertmanager
