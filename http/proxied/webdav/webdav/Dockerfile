FROM alpine as build

COPY . .

RUN ./install.sh

FROM alpine

COPY --from=build /usr/local/bin/webdav /usr/local/bin/webdav

ENTRYPOINT ["webdav"]
