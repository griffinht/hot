FROM debian as build

RUN apt-get update && apt-get install -y curl patch make gcc libpcre3-dev zlib1g-dev libssl-dev

WORKDIR /usr/src

RUN curl https://nginx.org/download/nginx-1.21.6.tar.gz \
      | tar -xz && \
    mv nginx-1.21.6/ nginx/ && \
    cd nginx/ && \
    curl -L https://github.com/chobits/ngx_http_proxy_connect_module/archive/refs/heads/master.tar.gz \
      | tar -xz && \
    mv ngx_http_proxy_connect_module-master /usr/ngx_http_proxy_connect_module && \
    patch -p1 < /usr/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch && \
    ./configure \
      --add-dynamic-module=/usr/ngx_http_proxy_connect_module \
      \
      --prefix=/etc/nginx \
      --sbin-path=/usr/sbin/nginx \
      --modules-path=/usr/lib/nginx/modules \
      --conf-path=/etc/nginx/nginx.conf \
      --error-log-path=/var/log/nginx/error.log \
      --http-log-path=/var/log/nginx/access.log \
      --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -ffile-prefix-map=/data/builder/debuild/nginx-1.21.5/debian/debuild-base/nginx-1.21.5=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
    && make

RUN cd nginx && make install

#FROM debian
#RUN apt-get update && apt-get install -y make

#COPY --from=build /usr/src /usr/src
#COPY --from=build /usr/ngx_http_proxy_connect_module /usr/ngx_http_proxy_connect_module
#WORKDIR /usr/src

#RUN cd nginx && \
#    make install && \
#    rm -r ../nginx && \
#    rm -r /usr/ngx_http_proxy_connect_module && \
#    apt-get remove -y make && \
#    ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx

WORKDIR /etc/nginx
CMD ["nginx", "-g", "daemon off;"]
#CMD sleep 10000
COPY --from=stzups/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=stzups/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=stzups/stzups.net:latest /stzups.net/ /stzups.net/
COPY --from=stzups/realgmoney.com:latest /realgmoney.com/ /realgmoney.com/
COPY hot/ /hot/

COPY ./nginx/ /etc/nginx