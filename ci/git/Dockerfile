FROM project42/syslog-alpine:latest

RUN apk add openssh-server git

COPY etc /etc/
COPY bin /usr/local/bin/

RUN adduser -s /usr/bin/git-shell -D git && mkdir /ssh/ && passwd -d git

ENTRYPOINT ["/init"]
