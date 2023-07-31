#!/usr/bin/env sh

DIR="$(mktemp -d)"
cd "$DIR" || exit 1

#todo broken

GIT_REF='7dc577eff0af4fd75d70b8e27d29af0333caf944'
SHA256='64e3c10656c218fe37ca13f634c6669bac9c2472c14ce39ce13b0148e0d0309e  tar.gz'

if ! (curl "https://git.sr.ht/~edwardloveall/scribe/archive/$GIT_REF.tar.gz" > tar.gz \
    && echo "$SHA256" | sha256sum -c \
    && tar -xz --strip-components=1 < tar.gz \
    && rm tar.gz); then
    echo failed to download and verify source, 
    echo "$SHA256" given, actual:
    sha256sum tar.gz
    exit 1
fi

docker build --tag scribe .
