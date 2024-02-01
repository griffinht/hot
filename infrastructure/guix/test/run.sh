#!/bin/sh

pack() {
    # todo max layers, entrypoint
    guix pack \
        --manifest=manifest.scm \
        --format=docker \
        --image-tag=myimage2 \
        --compression=none
}

set -e

podman load < "$(pack)"
podman run --rm myimage2 bash
ssh -p 2222 podman@localhost podman load < "$(pack)"

export CONTAINER_HOST=ssh://podman@localhost:2222/run/user/1001/podman/podman.sock
export CONTAINER_SSHKEY=../id_ed25519.bin

export DOCKER_HOST=ssh://podman@localhost:2222
