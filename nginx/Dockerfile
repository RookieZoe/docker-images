FROM --platform=$TARGETPLATFORM nginx:stable-alpine AS builder

ARG NGINX_VERSION
ARG NCHAN_VERSION
ARG HEADERS_MORE_VERSION
ARG NGINX_SOURCE
ARG NCHAN_SOURCE
ARG HEADERS_MORE_SOURCE

ENV NGINX_VERSION=$NGINX_VERSION
ENV NCHAN_VERSION=$NCHAN_VERSION
ENV HEADERS_MORE_VERSION=$HEADERS_MORE_VERSION

ADD $NGINX_SOURCE /usr/src/nginx
ADD $NCHAN_SOURCE /usr/src/nchan
ADD $HEADERS_MORE_SOURCE /usr/src/headers-more-nginx-module

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

# Reuse same cli arguments as the nginx:stable-alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
  CONFARGS=${CONFARGS/-Os -fomit-frame-pointer -g/-Os} && \
  cd /usr/src/nginx && \
  CFLAGS=${CFLAGS:-} && \
  CFLAGS="$CFLAGS -Wno-error" ./configure \
    --with-compat $CONFARGS \
    --add-dynamic-module=/usr/src/nchan \
    --add-dynamic-module=/usr/src/headers-more-nginx-module && \
  make && make install

FROM --platform=$TARGETPLATFORM nginx:stable-alpine
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
ARG NGINX_VERSION
ARG NCHAN_VERSION
ARG HEADERS_MORE_VERSION
ENV NGINX_VERSION=$NGINX_VERSION
ENV NCHAN_VERSION=$NCHAN_VERSION
ENV HEADERS_MORE_VERSION=$HEADERS_MORE_VERSION
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /usr/lib/nginx /usr/lib/nginx
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
