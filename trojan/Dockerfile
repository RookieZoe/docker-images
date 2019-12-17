FROM alpine:latest AS builder

RUN apk add --no-cache --virtual .build-deps \
  git \
  cmake \
  boost-dev \
  build-base \
  openssl-dev \
  mariadb-connector-c-dev

RUN cd / && \
  git clone --branch=master https://github.com/trojan-gfw/trojan.git && \
  cd trojan/ && \
  cmake . && \
  make -j $(nproc) && \
  strip -s trojan

FROM alpine:latest
COPY --from=builder /trojan/trojan /usr/local/bin/trojan
RUN apk add --no-cache --virtual .trojan-rundeps \
  libstdc++ \
  boost-system \
  mariadb-connector-c \
  boost-program_options

WORKDIR /config
CMD ["trojan", "config.json"]
