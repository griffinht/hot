#!/bin/sh

set -e

cleanup() {
    echo cleaning up "$DOCKER_SOCKET"
    rm "${DOCKER_SOCKET?}"
}
trap cleanup INT EXIT
interrupt() {
    exit 0
}
trap interrupt INT
ssh -N -L "${DOCKER_SOCKET?}":/var/run/docker.sock "${SSH_HOST?}"
