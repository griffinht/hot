#!/bin/sh

set -e

cleanup() {
    echo cleaning up "$DOCKER_SOCKET"
    rm "${DOCKER_SOCKET?}"
    exit 0
}
trap cleanup INT
ssh -N -L "${DOCKER_SOCKET?}":/var/run/docker.sock "${SSH_HOST?}"
