FROM curlimages/curl as minecraft-build

USER root
RUN curl https://api.purpurmc.org/v2/purpur/1.18/latest/download > /server.jar

FROM eclipse-temurin:17-jre-alpine

COPY --from=minecraft-build /server.jar /server.jar

RUN adduser --no-create-home --disabled-password minecraft

WORKDIR /minecraft

RUN chown minecraft:minecraft /minecraft

USER minecraft

RUN echo "eula=true" > eula.txt

VOLUME ["/minecraft"]

ENTRYPOINT java -jar /server.jar nogui
