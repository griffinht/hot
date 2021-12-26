FROM nginx

RUN apt-get update && apt-get install -y git fcgiwrap

VOLUME ["/git"]

COPY fcgi.sh /docker-entrypoint.d/fcgi.sh
RUN chmod u+x /docker-entrypoint.d/fcgi.sh
COPY nginx.conf /etc/nginx/nginx.conf
