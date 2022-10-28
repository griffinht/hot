FROM project42/syslog-alpine:latest

RUN apk add openssh-server git

COPY etc /etc/
COPY bin /usr/local/bin/

RUN adduser -s /bin/sh -D git && mkdir /ssh/ && passwd -d git

ENTRYPOINT ["/init"]
