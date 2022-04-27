FROM alpine@sha256:a777c9c66ba177ccfea23f2a216ff6721e78a662cd17019488c417135299cd89

ARG APK_DOVECOT_VERSION=2.3.17.1-r0

RUN apk add --no-cache dovecot="$APK_DOVECOT_VERSION"

# config
COPY dovecot /etc/dovecot

# todo https://doc.dovecot.org/configuration_manual/mail_location/#index-files

VOLUME ["/mail"]

ENTRYPOINT ["dovecot", "-F"]
