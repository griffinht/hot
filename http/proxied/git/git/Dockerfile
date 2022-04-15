FROM nginx:alpine
#FROM nginx
RUN apk add git spawn-fcgi fcgiwrap cgit
# RUN apk add python3-pygments python3-markdown
#RUN apt-get update && apt-get install -y git fcgiwrap cgit python3-pygments python3-markdown

COPY fcgi.sh /docker-entrypoint.d/fcgi.sh
COPY nginx /etc/nginx/
COPY cgitrc /etc/cgitrc
COPY cgit.png /usr/share/cgit/cgit.png
