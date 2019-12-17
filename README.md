# Containers

Some self-build images for self-host.

## nginx

![status](https://github.com/RookieZoe/container/workflows/nginx-alpine/badge.svg)

[nginx](http://nginx.org/download) docker image with [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module/releases) and [nchan](https://github.com/slact/nchan/releases) module.

## rsshub

![status](https://github.com/RookieZoe/container/workflows/rsshub-alpine/badge.svg)

[rsshub](https://github.com/DIYgod/RSSHub) docker image.

Deploy configuration: as same as offical config: [Configuration](https://docs.rsshub.app/en/install/#configuration-3)

## trojan

![status](https://github.com/RookieZoe/container/workflows/trojan-alpine/badge.svg)

[trojan](https://github.com/trojan-gfw/trojan) docker image.

Docker run:

```bash
docker run -dt --name trojan -v $HOST_CONFIG_DIR:/config -p 443:443 rookiezoe/trojan
```

Deploy configuration: as same as offical config: [Configuration](https://trojan-gfw.github.io/trojan/config)
