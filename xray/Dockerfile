FROM alpine:latest AS builder

ARG xray_version
ENV XRAY_VERSION=$xray_version
COPY download-xray.sh /download-xray.sh
RUN set -ex \
  && apk add --no-cache unzip \
  && mkdir -p /var/log/xray /usr/local/share/xray \
  && chmod +x /download-xray.sh \
  && /download-xray.sh $xray_version \
  && wget -O /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat >/dev/null 2>&1 \
  && wget -O /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat >/dev/null 2>&1

FROM alpine:latest
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
ARG xray_version
ENV XRAY_VERSION=$xray_version
WORKDIR /root

COPY config.json /etc/xray/config.json
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY 10-envsubst-on-templates.sh /docker-entrypoint.d/10-envsubst-on-templates.sh
COPY --from=builder /xray /usr/bin/xray
COPY --from=builder /var/log/xray /var/log/xray
COPY --from=builder /usr/local/share/xray /usr/local/share/xray

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
  && chmod +x /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.d/* \
  && chmod +x /usr/bin/xray

ENTRYPOINT ["/docker-entrypoint.sh"]

ENV TZ=Asia/Shanghai
VOLUME /etc/xray

CMD ["xray", "-config", "/etc/xray/config.json"]
