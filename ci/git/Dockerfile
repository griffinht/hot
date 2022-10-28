FROM alpine

RUN apk add openssh-server git

RUN adduser -s /bin/sh -D git && mkdir /ssh/ && passwd -d git

COPY bin /usr/local/bin/
COPY ssh /etc/ssh/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
