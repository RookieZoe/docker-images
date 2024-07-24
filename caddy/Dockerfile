ARG CADDY_VERSION

FROM --platform=$TARGETPLATFORM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
  --with github.com/mholt/caddy-l4 \
  --with github.com/WeidiDeng/caddy-cloudflare-ip \
  --with github.com/fvbommel/caddy-dns-ip-range \
  --with github.com/fvbommel/caddy-combine-ip-ranges

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
