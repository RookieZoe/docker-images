# Docker-images

Some self-build images for self-host.

## 1. nginx

[![nginx](http://dockeri.co/image/rookiezoe/nginx)](https://hub.docker.com/r/rookiezoe/nginx)

[![status](https://github.com/RookieZoe/docker-images/workflows/nginx-alpine/badge.svg)](https://github.com/RookieZoe/docker-images/actions?query=workflow%3Anginx-alpine)

[nginx](http://nginx.org/download) docker image with [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module/releases) and [nchan](https://github.com/slact/nchan/releases) module.

### Usage

1. In the beginning of `nginx.conf`, add module.

```nginx.conf
load_module modules/ngx_nchan_module.so;
load_module modules/ngx_http_headers_more_filter_module.so;
```

2. Then, the other config is as same as official [docker-image](https://hub.docker.com/_/nginx)'s config.

## 2. rsshub

[![rsshub](http://dockeri.co/image/rookiezoe/rsshub)](https://hub.docker.com/r/rookiezoe/rsshub)

[![status](https://github.com/RookieZoe/docker-images/workflows/rsshub-alpine/badge.svg)](https://github.com/RookieZoe/docker-images/actions?query=workflow%3Arsshub-alpine)

[rsshub](https://github.com/DIYgod/RSSHub) docker image.

### Usage

Deploy configuration: as same as offical config: [Configuration](https://docs.rsshub.app/en/install/#configuration-3)

## 3. xray

[![xray](http://dockeri.co/image/rookiezoe/xray)](https://hub.docker.com/r/rookiezoe/xray)

[![status](https://github.com/RookieZoe/docker-images/workflows/xray-alpine/badge.svg)](https://github.com/RookieZoe/docker-images/actions?query=workflow%3Axray-alpine)

[xray](https://github.com/XTLS/Xray-core) docker image.
