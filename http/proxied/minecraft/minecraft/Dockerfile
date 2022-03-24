FROM alpine as build

COPY build.sh build.sh
RUN ./build.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

FROM eclipse-temurin:17-jre-alpine

COPY --from=build /usr/local/bin/ /usr/local/bin/

WORKDIR /minecraft

RUN adduser --disabled-password minecraft \
    && chown minecraft:minecraft .

USER minecraft

VOLUME ["/minecraft"]

COPY --chown=minecraft:minecraft minecraft .
COPY rcon-cli.yml /home/minecraft/.rcon-cli.yaml

ENTRYPOINT entrypoint.sh
