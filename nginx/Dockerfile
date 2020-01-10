FROM nginx:alpine AS builder

# nginx:alpine contains NGINX_VERSION environment variable, like so:
ENV NCHAN_VERSION 1.2.6
ENV HEADERS_MORE_VERSION 0.33

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
  wget "https://github.com/slact/nchan/archive/v${NCHAN_VERSION}.tar.gz" -O nchan.tar.gz && \
  wget "https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz" -O headers-more-nginx-module.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
  CONFARGS=${CONFARGS/-Os -fomit-frame-pointer/-Os} && \
  mkdir /usr/src && \
  tar -zxC /usr/src -f nginx.tar.gz && \
  tar -xzvf "nchan.tar.gz" && \
  tar -xzvf "headers-more-nginx-module.tar.gz" && \
  NCHAN_DIR="$(pwd)/nchan-${NCHAN_VERSION}" && \
  HEADERS_MORE_DIR="$(pwd)/headers-more-nginx-module-${HEADERS_MORE_VERSION}" && \
  cd /usr/src/nginx-$NGINX_VERSION && \
  ./configure --with-compat $CONFARGS --add-dynamic-module=$NCHAN_DIR --add-dynamic-module=$HEADERS_MORE_DIR && \
  make modules && \
  mv ./objs/*.so /

FROM nginx:alpine
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
COPY --from=builder /ngx_nchan_module.so /usr/local/nginx/modules/ngx_nchan_module.so
COPY --from=builder /ngx_http_headers_more_filter_module.so /usr/local/nginx/modules/ngx_http_headers_more_filter_module.so

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
