#!/usr/bin/env sh

DIR="$(mktemp -d)"
cd "$DIR" || exit 1

GIT_REF='3c6c4770d0d57d7e9ce341dfb850de90ffc429c0'
SHA256='126d81bbb6968fcdae525c041d0a5f4b985f2195c0d0cdcab83e31f3700a76c6  tar.gz'

if ! (curl "https://git.sr.ht/~edwardloveall/scribe/archive/$GIT_REF.tar.gz" > tar.gz \
    && echo "$SHA256" | sha256sum -c \
    && tar -xz --strip-components=1 < tar.gz \
    && rm tar.gz); then
    echo failed to download and verify source
    exit 1
fi

docker build --tag scribe .
