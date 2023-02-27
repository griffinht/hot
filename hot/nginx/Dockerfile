FROM nginx:alpine

ENV NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template.conf NGINX_ENVSUBST_FILTER=DOMAIN NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx

