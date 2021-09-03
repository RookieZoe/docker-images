FROM node:12-alpine AS builder

ENV NODE_ENV production
ENV TZ Asia/Shanghai

RUN apk add --no-cache --virtual .build-deps \
  dumb-init \
  git \
  python \
  vips-dev \
  fftw-dev \
  build-base

RUN cd / && \
  git clone -b selfhost --single-branch https://github.com/RookieZoe/RSSHub.git /RSSHub && \
  cd /RSSHub && \
  export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true && \
  yarn --production

FROM node:12-alpine
LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
WORKDIR /app
COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=builder /RSSHub/lib /app/lib
COPY --from=builder /RSSHub/node_modules /app/node_modules
COPY --from=builder /RSSHub/package.json /app/package.json
EXPOSE 1200
ENTRYPOINT ["dumb-init", "--"]
CMD ["yarn", "start"]
