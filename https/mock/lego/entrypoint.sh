#!/usr/bin/env sh

cd certificates
mkdir griffinht.com
cd griffinht.com

openssl req -new -x509 -nodes -sha256 -nodes -subj "/CN=localhost" -keyout griffinht.com.key > fullchain.cer
#openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes -subj "/CN=localhost"
