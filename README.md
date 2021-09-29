# Docker-images

Some self-build images for self-host.

## 1. nginx

[![status](https://img.shields.io/github/workflow/status/RookieZoe/docker-images/nginx-alpine?color=34d058&label=nginx&logo=github&logoColor=fff)](https://github.com/RookieZoe/docker-images/actions/workflows/nginx-alpine.yml)
[![rookiezoe/nginx:latest](https://img.shields.io/docker/v/rookiezoe/nginx?label=rookiezoe%2Fnginx%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/nginx/tags?page=1&ordering=last_updated)

[nginx](https://nginx.org/download) docker image with [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module/releases) and [nchan](https://github.com/slact/nchan/releases) module.

> Usage:
>
> In the beginning of `nginx.conf`, add module.
>
> ```nginx.conf
> load_module modules/ngx_nchan_module.so;
> load_module modules/ngx_http_headers_more_filter_module.so;
> ```
>
> Then, the other config is as same as official [docker-image](https://hub.docker.com/_/nginx)'s config.

## 2. rsshub

[![status](https://img.shields.io/github/workflow/status/RookieZoe/docker-images/rsshub-alpine?color=34d058&label=rsshub&logo=github&logoColor=fff)](https://github.com/RookieZoe/docker-images/actions/workflows/rsshub-alpine.yml)
[![rookiezoe/rsshub:latest](https://img.shields.io/docker/v/rookiezoe/rsshub?label=rookiezoe%2Frsshub%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/rsshub/tags?page=1&ordering=last_updated)

[rsshub](https://github.com/DIYgod/RSSHub) docker image.

> Usage:
>
> Deploy configuration: as same as offical config: [Configuration](https://docs.rsshub.app/en/install/#configuration-3)

## 3. xray

[![status](https://img.shields.io/github/workflow/status/RookieZoe/docker-images/xray-alpine?color=34d058&label=xray&logo=github&logoColor=fff)](https://github.com/RookieZoe/docker-images/actions/workflows/xray-alpine.yml)
[![rookiezoe/xray:latest](https://img.shields.io/docker/v/rookiezoe/xray?label=rookiezoe%2Fxray%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/xray/tags?page=1&ordering=last_updated)

[xray](https://github.com/XTLS/Xray-core) docker image, base on [teddysun](https://github.com/teddysun)'s Dockerfile.
