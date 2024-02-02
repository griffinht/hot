#!/usr/bin/env bash

pack() {
    # todo max layers, entrypoint
    guix pack \
        --manifest=manifest.scm \
        --format=docker \
        --image-tag=myimage2 \
        --compression=none
}

set -e

#podman load < "$(pack)"
#podman run --rm myimage2 bash
#ssh -p 2222 podman@localhost podman load < "$(pack)"


port=2375
user=root
export CONTAINER_SSHKEY=../id_ed25519.bin

tunnel() {
    ssh \
        -i "$CONTAINER_SSHKEY" \
        -o "StrictHostKeyChecking=no" \
        -o "UserKnownHostsFile=/dev/null" \
        -p 2222 \
        -L "$port:localhost:$port" \
        -N \
        "$user@localhost" \
        &
    pid="$!"
    cleanup() {
        kill "$pid"
    }
    trap cleanup INT
    trap cleanup EXIT
}

tunnel

#export CONTAINER_HOST=ssh://podman@localhost:2222/run/user/1001/podman/podman.sock
export DOCKER_HOST=tcp://localhost:$port

guix shell \
    --container \
    --expose="/home/$USER/.ssh/config=bruh" \
    --preserve=DOCKER_HOST \
    podman docker-cli openssh \
    -- ./test2.sh
