#FROM nginx:alpine
FROM nginx
#RUN apk add git spawn-fcgi fcgiwrap
RUN apt-get update && apt-get install -y git fcgiwrap
VOLUME ["/git"]

COPY fcgi.sh /docker-entrypoint.d/fcgi.sh
COPY nginx.conf /etc/nginx/nginx.conf
