FROM curlimages/curl as minecraft-build

USER root
RUN curl https://api.purpurmc.org/v2/purpur/1.18/latest/download > /server.jar

FROM eclipse-temurin:17-jre-alpine

COPY --from=minecraft-build /server.jar /server.jar

VOLUME ["/minecraft"]

WORKDIR /minecraft

ENTRYPOINT java -jar /server.jar nogui
