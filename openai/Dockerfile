FROM alpine

RUN apk add nginx-mod-http-lua

RUN echo 'include /workdir/nginx.conf;' > /etc/nginx/nginx.conf
