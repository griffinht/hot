FROM curlimages/curl as minecraft-build

USER root
RUN curl https://api.purpurmc.org/v2/purpur/1.18/latest/download > /server.jar
RUN curl -L https://github.com/itzg/rcon-cli/releases/download/1.5.1/rcon-cli_1.5.1_linux_amd64.tar.gz | tar -xz && cp rcon-cli /usr/local/bin/rcon-cli
RUN chmod +x /usr/local/bin/rcon-cli

FROM eclipse-temurin:17-jre-alpine

COPY --from=minecraft-build /server.jar /server.jar
COPY --from=minecraft-build /usr/local/bin/rcon-cli /usr/local/bin/rcon-cli

RUN adduser --disabled-password minecraft

WORKDIR /minecraft

RUN chown minecraft:minecraft /minecraft

USER minecraft

COPY . .

# configure rcon-cli with password from server.properties
# docker exec -it <container id> rcon-cli
RUN printf "host: localhost\nport: 25575\npassword: $(grep rcon.password < server.properties | cut -c 15-)\n" > $HOME/.rcon-cli.yaml

VOLUME ["/minecraft"]

ENTRYPOINT java -jar /server.jar nogui
