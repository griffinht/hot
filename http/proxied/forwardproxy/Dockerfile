FROM alpine

RUN apk add tinyproxy
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

ENTRYPOINT tinyproxy -d