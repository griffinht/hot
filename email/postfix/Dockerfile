FROM alpine@sha256:a777c9c66ba177ccfea23f2a216ff6721e78a662cd17019488c417135299cd89

ARG APK_POSTFIX_VERSION=3.6.6-r0
ARG DOMAIN=localhost

RUN apk add --no-cache postfix="$APK_POSTFIX_VERSION"

# config
COPY postfix /etc/postfix
RUN echo "myhostname = $DOMAIN" >> /etc/postfix/main.cf

# https://serverfault.com/questions/885828/is-there-any-way-to-run-postfix-in-foreground
# echo "maillog_file = /dev/stdout" >> /etc/postfix/main.cf ????
ENTRYPOINT ["postfix", "start-fg"]
