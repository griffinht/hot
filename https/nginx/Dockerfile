FROM nginx:alpine

COPY . /etc/nginx

ARG DOMAIN=localhost
RUN envsubst "\$DOMAIN" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
