FROM alpine@sha256:a777c9c66ba177ccfea23f2a216ff6721e78a662cd17019488c417135299cd89 as build


ARG BRANCH=v1.9

# install.sh
WORKDIR /usr/src/
RUN apk add --no-cache curl git make go
COPY install.sh .
RUN ./install.sh

FROM alpine@sha256:a777c9c66ba177ccfea23f2a216ff6721e78a662cd17019488c417135299cd89

COPY --from=build /usr/local/bin/ /usr/local/bin/

COPY chasquid /etc/chasquid

ENTRYPOINT ["chasquid"]
