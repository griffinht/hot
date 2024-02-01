#!/bin/sh

set -e

cli="$1"

set -x

$cli info
$cli ps

$cli run --rm docker.io/hello-world

# internet access
$cli run --rm docker.io/curlimages/curl curl icanhazip.com

bruh() {
    port="$1"
    $cli run --rm -p "$port:8080" --detach docker.io/python python3 -m http.server
}

# unpriviledged port
id="$(bruh 8080)"
curl localhost:8080 || fail="$?"
$cli stop --time 1 "$id"
if [ -z "$fail" ]; then
    exit "$fail"
fi

# priviledged port
id="$(bruh 80)"
curl localhost:80 || fail="$?"
$cli stop --time 1 "$id"
if [ -z "$fail" ]; then
    exit "$fail"
fi

# wireguard priviledged
$cli run --rm wireguard

# todo test volumes
# todo test source ips https://github.com/docker/docs/issues/17312
# todo do network performance benchmark
# todo --net=host
# todo cgroups
# todo systemd linger - autostart proxy on system bootup?
# todo ping
