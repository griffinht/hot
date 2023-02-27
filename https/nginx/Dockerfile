FROM nginx:alpine

COPY . /etc/nginx

ARG DOMAIN=localhost
RUN envsubst "\$DOMAIN" < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf
