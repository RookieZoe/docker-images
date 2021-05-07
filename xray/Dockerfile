# Dockerfile for xray based alpine with nginx
# Copyright (C) 2019 - 2020 Teddysun <i@teddysun.com>
# Reference URL:
# https://github.com/XTLS/Xray-core
# https://github.com/Loyalsoldier/v2ray-rules-dat/

FROM alpine:latest AS builder

ARG XRAY_VERSION

COPY download.sh /download.sh
RUN set -ex \
  && apk add --no-cache unzip \
  && mkdir -p /var/log/xray /usr/local/share/xray \
  && chmod +x /download.sh \
  && /download.sh $XRAY_VERSION \
  && wget -O /geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat > /dev/null 2>&1 \
  && wget -O /geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat > /dev/null 2>&1

FROM alpine:latest
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
WORKDIR /root

COPY config.json /etc/xray/config.json
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY 10-envsubst-on-templates.sh /docker-entrypoint.d/10-envsubst-on-templates.sh
COPY --from=builder /geoip.dat /usr/local/share/xray/geoip.dat
COPY --from=builder /geosite.dat /usr/local/share/xray/geosite.dat
COPY --from=builder /xray /usr/bin/xray

RUN set -ex \
  && apk add --no-cache tzdata ca-certificates \
  && apk add --no-cache --virtual .gettext gettext \
  && mv /usr/bin/envsubst /tmp/ \
  && runDeps="$( \
    scanelf --needed --nobanner /tmp/envsubst \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u \
  )" \
  && apk add --no-cache $runDeps \
  && apk del .gettext \
  && mv /tmp/envsubst /usr/local/bin/ \
  && mkdir -p /var/log/xray /usr/local/share/xray \
  && chmod +x /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.d/* \
  && chmod +x /usr/bin/xray

ENTRYPOINT ["/docker-entrypoint.sh"]

ENV TZ=Asia/Shanghai
VOLUME /etc/xray

CMD ["xray", "-config", "/etc/xray/config.json"]