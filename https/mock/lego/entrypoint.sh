#!/usr/bin/env sh

cd /lego
mkdir certificates
cd certificates

if [ ! -f griffinht.com.crt ]; then
    openssl req -new -x509 -nodes -sha256 -nodes -subj "/CN=localhost" -keyout griffinht.com.key > griffinht.com.crt
    #openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes -subj "/CN=localhost"
fi
