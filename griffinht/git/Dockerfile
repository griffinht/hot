FROM nginx:alpine

RUN apk --no-cache add spawn-fcgi fcgiwrap cgit py3-pip \
    && pip install pygments markdown

COPY fcgi.sh /docker-entrypoint.d/fcgi.sh
COPY nginx /etc/nginx/
COPY cgitrc /etc/cgitrc
COPY cgit/ /usr/share/webapps/cgit/
