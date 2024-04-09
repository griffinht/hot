todo nerd xmpp alerts down - deploy alertmanager with email

# actionable - these can be automated
dynamic ip changed
    update cloudflare config
certbot expiry
    do this for all certbot domains

# semi actionable
status.griffinht.com
    resolveable with ssl?
    response times
    speedtest?

hot-desktop.wg.hot
    routing to host
    ssh login?

wireguard
    dns
    routing to cloudtest and guix
        ssh login?

low disk
    resize vm
    clean up disk
    why am i running out of disk space? todo offload to other thing!
low memory
    allocate more mem/kill memory hog
high cpu
    kill cpu hog

# non actionable
slow network
    debug
slow disk read?
    debug






iperf3

# todo lan monitoring, routeros monitoring, tp-link wap monitoring, cool-desktop monitoring
docker healthcheck monitoring
docker container infinite loops
docker container make sure it is running ok

snmp
    https://help.mikrotik.com/docs/display/ROS/SNMP
        todo add authentication
    https://github.com/akpw/mktxp
    todo dd-wrt
        https://wiki.dd-wrt.com/wiki/index.php/SNMP#Known_OID.C2.B4s_via_SNMP

ntp monitoring make sure the clock is set
    or just enable the correct guix service

healthchecks:
    https://github.com/google/cadvisor/issues/2166

dns https://news.ycombinator.com/item?id=39835488
    https://dmachard.github.io/posts/0043-blackbox-prometheus-dns/
    just deploy your own dns server lol



https://github.com/prometheus/snmp_exporter

containers
    registry
    nginx
        https://technicalramblings.com/blog/visualizing-nginx-geo-data-metrics-with-python-influxdb-and-grafana/
    certbot?
    minio
    databases:
        mariadb
        postgres
        redis

## arp clients
cat /proc/net/arp
https://github.com/prometheus-community/node-exporter-textfile-collector-scripts
    btrfs

## logs
dynamic ip - make sure its correct, alert on changes
todo log export/monitoring/centralized viewing? idk... who cares? like fr whats the advantage of putting your logs in one place
    nginx logs! i want those!
    if something breaks you log in and view the logs
    otherwise who cares...
https://news.ycombinator.com/item?id=35741922
wouldn't it be nice to see all errors? how can you monitor brtfs anyways?
docker healthcheck logs
docker logs in general

https://wiki.mikrotik.com/wiki/Manual:System/Log
tp-link syslog
todo syslog all the things!
linux kernel for every node! btrfs logs!
