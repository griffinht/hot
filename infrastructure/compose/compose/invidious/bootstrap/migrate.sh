#!/bin/sh

cd invidious && \
    POSTGRES_USER=postgres POSTGRES_DB=postgres PGHOST="${1?specify hostname}" PGPORT=5432 guix shell postgresql -- ./docker/init-invidious-db.sh
