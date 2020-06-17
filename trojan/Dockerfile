FROM alpine:latest AS builder

ARG TROJAN_LATEST_TAR
ENV trojan_latest_tar=$TROJAN_LATEST_TAR

RUN apk add --no-cache --virtual .build-deps \
  git \
  cmake \
  boost-dev \
  build-base \
  openssl-dev \
  mariadb-connector-c-dev

RUN wget "${trojan_latest_tar}" -O /trojan.tar.gz && \
  mkdir /trojan && \
  tar -xzC /trojan -f trojan.tar.gz --strip-components 1 && \
  cd /trojan/ && \
  cmake . && \
  make -j $(nproc) && \
  strip -s trojan

FROM alpine:latest
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
COPY --from=builder /trojan/trojan /usr/local/bin/trojan
RUN apk add --no-cache --virtual .trojan-rundeps \
  libstdc++ \
  boost-system \
  mariadb-connector-c \
  boost-program_options

WORKDIR /config
CMD ["trojan", "config.json"]
