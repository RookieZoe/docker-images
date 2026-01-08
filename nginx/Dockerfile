FROM --platform=$TARGETPLATFORM nginx:stable-alpine3.21 AS builder

ARG NGINX_VERSION
ARG NCHAN_VERSION
ARG HEADERS_MORE_VERSION

# Install build dependencies including Rust for ACME module
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre2-dev \
  zlib-dev \
  linux-headers \
  libxslt-dev \
  gd-dev \
  geoip-dev \
  perl-dev \
  libedit-dev \
  bash \
  alpine-sdk \
  findutils \
  curl \
  git \
  cargo \
  rust \
  clang-dev \
  pkgconfig

# Download nginx source
RUN cd /tmp && \
  curl -fSL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx.tar.gz && \
  tar -zxC /tmp -f nginx.tar.gz

# Download nchan module
RUN cd /tmp && \
  curl -fSL https://github.com/slact/nchan/archive/v${NCHAN_VERSION}.tar.gz -o nchan.tar.gz && \
  tar -zxC /tmp -f nchan.tar.gz

# Download headers-more module
RUN cd /tmp && \
  curl -fSL https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz -o headers-more.tar.gz && \
  tar -zxC /tmp -f headers-more.tar.gz

# Clone nginx-acme module
RUN cd /tmp && \
  git clone --depth 1 https://github.com/nginx/nginx-acme.git

# Build nginx with modules
RUN cd /tmp/nginx-${NGINX_VERSION} && \
  export LUAJIT_LIB=/usr/lib && \
  export LUAJIT_INC=/usr/include/luajit-2.1 && \
  ./configure \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --user=nginx \
  --group=nginx \
  --with-compat \
  --with-file-aio \
  --with-threads \
  --with-http_addition_module \
  --with-http_auth_request_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_mp4_module \
  --with-http_random_index_module \
  --with-http_realip_module \
  --with-http_secure_link_module \
  --with-http_slice_module \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-http_v3_module \
  --with-stream \
  --with-stream_realip_module \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --add-dynamic-module=/tmp/nchan-${NCHAN_VERSION} \
  --add-dynamic-module=/tmp/headers-more-nginx-module-${HEADERS_MORE_VERSION} \
  --add-dynamic-module=/tmp/nginx-acme \
  --with-cc-opt='-Os -fomit-frame-pointer -g -Wno-error=format' \
  --with-ld-opt=-Wl,--as-needed,-O1,--sort-common && \
  make -j$(getconf _NPROCESSORS_ONLN) modules && \
  make install

FROM --platform=$TARGETPLATFORM nginx:stable-alpine
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"

ARG NGINX_VERSION
ARG NCHAN_VERSION
ARG HEADERS_MORE_VERSION

ENV NGINX_VERSION=$NGINX_VERSION
ENV NCHAN_VERSION=$NCHAN_VERSION
ENV HEADERS_MORE_VERSION=$HEADERS_MORE_VERSION

# Copy built nginx and modules
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /usr/lib/nginx/modules /usr/lib/nginx/modules

# Create cache and acme directories
RUN mkdir -p /var/cache/nginx/client_temp \
  /var/cache/nginx/proxy_temp \
  /var/cache/nginx/fastcgi_temp \
  /var/cache/nginx/uwsgi_temp \
  /var/cache/nginx/scgi_temp \
  /etc/nginx/acme

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
