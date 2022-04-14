#!/bin/sh

apk add curl
curl -L https://github.com/klaussilveira/gitlist/archive/refs/tags/2.0.0.tar.gz | tar -xz --strip-components=1
