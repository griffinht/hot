FROM nginx:alpine

ENV NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template.conf \
    NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/

COPY . /etc/nginx
