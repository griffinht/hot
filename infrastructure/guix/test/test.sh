#!/bin/sh

set -e

# localhost does not work for podman because of ssh known hosts issue
host=127.0.0.1
port=2222
user=podman
uri="ssh://$user@$host:$port"
# docker uses this implicitly, podman needs to be explicitly informed
identity=~/.ssh/id_ed25519

podmana() {
    # todo configure container policy
    known_hosts="$(mktemp)"
    ssh-keyscan -p 2222 127.0.0.1 > "$known_hosts"
    CONTAINER_HOST="$host" \
        CONTAINER_SSHKEY="$HOME/.ssh/id_ed25519" \
        guix shell --container \
        --preserve=CONTAINER_HOST \
        "--share=$known_hosts=$HOME/.ssh/known_hosts" \
        "--expose=$HOME/.ssh/id_ed25519" \
        --network \
        podman openssh
        #podman openssh -- ./test.sh podman-remote
        #podman openssh -- ssh -p 2222 docker@127.0.0.1
}

run_test() {
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
}

run_docker() {
    run_test docker
}

run_podman() {
    run_test podman
}

run_docker
run_podman
