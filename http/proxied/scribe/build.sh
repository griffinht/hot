#!/usr/bin/env sh

DIR="$(mktemp -d)"
cd "$DIR" || exit 1

GIT_REF='f05a12a880cbb1399925d9dc12317f6f5ce8a285'
SHA256='714587d007a7fe4ce26a74062f6de0ccdb56e4f891fedcf334c5bad9fac852da  tar.gz'

if ! (curl "https://git.sr.ht/~edwardloveall/scribe/archive/$GIT_REF.tar.gz" > tar.gz \
    && echo "$SHA256" | sha256sum -c \
    && tar -xz --strip-components=1 < tar.gz \
    && rm tar.gz); then
    echo failed to download and verify source
    exit 1
fi

docker build --tag scribe .
