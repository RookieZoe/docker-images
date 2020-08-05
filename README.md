# Docker-images

Some self-build images for self-host.

## nginx

[![nginx](http://dockeri.co/image/rookiezoe/nginx)](https://hub.docker.com/r/rookiezoe/nginx)

[![status](https://github.com/RookieZoe/container/workflows/nginx-alpine/badge.svg)](https://github.com/RookieZoe/docker-images/actions?query=workflow%3Anginx-alpine)

[nginx](http://nginx.org/download) docker image with [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module/releases) and [nchan](https://github.com/slact/nchan/releases) module.

To use:

```nginx.conf
load_module modules/ngx_nchan_module.so;
load_module modules/ngx_http_headers_more_filter_module.so;
```

## rsshub

[![rsshub](http://dockeri.co/image/rookiezoe/rsshub)](https://hub.docker.com/r/rookiezoe/rsshub)

[![status](https://github.com/RookieZoe/container/workflows/rsshub-alpine/badge.svg)](https://github.com/RookieZoe/docker-images/actions?query=workflow%3Arsshub-alpine)

[rsshub](https://github.com/DIYgod/RSSHub) docker image.

Deploy configuration: as same as offical config: [Configuration](https://docs.rsshub.app/en/install/#configuration-3)
