FROM alpine:3.18.4
LABEL maintainer "SkyDev Cyber Defense"

ENV NGINX_VERSION 1.24.0

##
# dependent packages for docker build
##

WORKDIR /tmp

RUN apk update && \
    apk add       \
      alpine-sdk  \
      openssl-dev \
      pcre-dev    \
      zlib-dev

RUN curl -LSs http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O                                             && \
    tar xf nginx-${NGINX_VERSION}.tar.gz                                                                             && \
    cd     nginx-${NGINX_VERSION}                                                                                    && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module                                               && \
    patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch                             && \
    ./configure                                                                                                         \
      --add-module=./ngx_http_proxy_connect_module                                                                      \
      --sbin-path=/usr/sbin/nginx                                                                                       \
      --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' && \
    make -j $(nproc)                                                                                                 && \
    make install                                                                                                     && \
    rm -rf /tmp/*

##
# application deployment
##

WORKDIR /

COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 5678

STOPSIGNAL SIGTERM

CMD [ "nginx", "-g", "daemon off;" ]
