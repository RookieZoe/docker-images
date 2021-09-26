FROM --platform=$TARGETPLATFORM node:14-alpine3.14 AS builder

ARG RSSHub
ENV NODE_ENV production
ENV TZ Asia/Shanghai

WORKDIR /RSSHub
ADD ${RSSHub} /RSSHub
RUN apk add --no-cache --virtual .build-deps \
  dumb-init \
  git \
  python3 \
  vips-dev \
  fftw-dev \
  build-base

RUN export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true && \
  yarn config delete proxy && \
  yarn install --network-timeout 1000000 --production

RUN mkdir -p /app && \
  mv /RSSHub/api /app/api && \
  mv /RSSHub/lib /app/lib && \
  mv /RSSHub/node_modules /app/node_modules && \
  mv /RSSHub/package.json /app/package.json

FROM --platform=$TARGETPLATFORM node:14-alpine3.14
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
ENV NODE_ENV production
ENV TZ Asia/Shanghai
WORKDIR /app
EXPOSE 1200
ENTRYPOINT ["dumb-init", "--"]
CMD ["yarn", "start"]
COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=builder /app /app
