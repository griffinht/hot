FROM nginx:alpine

# todo i could use NGINX_ENTRYPOINT_LOCAL_RESOLVERS but who cares
ENV NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template.conf \
    NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx

