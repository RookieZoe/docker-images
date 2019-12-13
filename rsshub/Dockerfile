FROM node:10.17-alpine AS builder

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
  git clone https://github.com/DIYgod/RSSHub.git && \
  cd /RSSHub && \
  export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true && \
  npm install --production

FROM node:10.17-alpine
WORKDIR /app
COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=builder /RSSHub/lib /app/lib
COPY --from=builder /RSSHub/node_modules /app/node_modules
COPY --from=builder /RSSHub/package.json /app/package.json
EXPOSE 1200
ENTRYPOINT ["dumb-init", "--"]
CMD ["npm", "run", "start"]
