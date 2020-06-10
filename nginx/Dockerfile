FROM nginx:alpine AS builder

# nginx:alpine contains NGINX_VERSION environment variable, like so:

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
  wget "${NCHAN_LATEST_TAR}" -O nchan.tar.gz && \
  wget "${HEADERS_MORE_LATEST_TAR}" -O headers-more-nginx-module.tar.gz

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
  mkdir ./nchan && \
  mkdir ./headers-more-nginx-module && \
  tar -xzC ./nchan -f nchan.tar.gz --strip-components 1 && \
  tar -xzC ./headers-more-nginx-module -f headers-more-nginx-module.tar.gz --strip-components 1 && \
  NCHAN_DIR="$(pwd)/nchan" && \
  HEADERS_MORE_DIR="$(pwd)/headers-more-nginx-module" && \
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
