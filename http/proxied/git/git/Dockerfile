#FROM nginx:alpine
FROM nginx
#RUN apk add git spawn-fcgi fcgiwrap
RUN apt-get update && apt-get install -y git fcgiwrap cgit

COPY fcgi.sh /docker-entrypoint.d/fcgi.sh
COPY nginx/ /etc/nginx/
COPY cgitrc /etc/cgitrc
COPY cgit.png /usr/share/cgit/cgit.png

COPY htpasswd /passwd/.htpasswd
