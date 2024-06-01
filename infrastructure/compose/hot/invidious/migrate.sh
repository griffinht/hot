#!/bin/sh

cd invidious && \
    POSTGRES_USER=postgres POSTGRES_DB=postgres PGHOST=localhost guix shell postgresql -- ./docker/init-invidious-db.sh
