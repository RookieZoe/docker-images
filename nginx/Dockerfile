FROM nginx:stable-alpine AS builder

ARG nginx_version
ARG nchan_latest_tar
ARG headers_more_latest_tar
ENV NGINX_VERSION=$nginx_version

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
  wget "${nchan_latest_tar}" -O nchan.tar.gz && \
  wget "${headers_more_latest_tar}" -O headers-more-nginx-module.tar.gz

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
  make && make install

FROM nginx:stable-alpine
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
ARG nginx_version
ENV NGINX_VERSION=$nginx_version
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /usr/lib/nginx /usr/lib/nginx
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
