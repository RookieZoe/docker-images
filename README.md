# Docker-images

Some self-build images for self-host.

## 1. nginx

[![status](https://img.shields.io/github/actions/workflow/status/RookieZoe/docker-images/nginx-alpine.yml?label=nginx&logo=github&logoColor=959da5)](https://github.com/RookieZoe/docker-images/actions/workflows/nginx-alpine.yml)
[![rookiezoe/nginx:latest](https://img.shields.io/docker/v/rookiezoe/nginx?color=086dd7&label=rookiezoe%2Fnginx%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/nginx/tags?page=1&ordering=last_updated)

[nginx](https://nginx.org/download) docker image with [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module/releases) and [nchan](https://github.com/slact/nchan/releases) module.

> Usage:
>
> In the beginning of `nginx.conf`, add module.
>
> ```nginx.conf
> load_module modules/ngx_nchan_module.so;
> load_module modules/ngx_http_headers_more_filter_module.so;
> load_module modules/ngx_http_acme_module.so;
> ```
>
> Then, the other config is as same as official [docker-image](https://hub.docker.com/_/nginx)'s config.
> acme module usage reference: [nginx/nginx-acme-example.conf](nginx/nginx-acme-example.conf)

> Caution:
> The official acme module requires a minimum Nginx version of 1.25.1, with a recommended production version of 1.28.0+. The Nginx images built in this repository are effective from version 1.29.2 onwards.

## 2. caddy

[![status](https://img.shields.io/github/actions/workflow/status/RookieZoe/docker-images/caddy-alpine.yml?label=caddy&logo=github&logoColor=959da5)](https://github.com/RookieZoe/docker-images/actions/workflows/caddy-alpine.yml)
[![rookiezoe/caddy:latest](https://img.shields.io/docker/v/rookiezoe/caddy?color=086dd7&label=rookiezoe%2Fcaddy%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/caddy/tags?page=1&ordering=last_updated)

[caddy](https://caddyserver.com/docs/) docker image with [caddy-docker](https://github.com/caddy-docker/caddy-docker) support.

## 3. xray

[![status](https://img.shields.io/github/actions/workflow/status/RookieZoe/docker-images/xray-alpine.yml?label=xray&logo=github&logoColor=959da5)](https://github.com/RookieZoe/docker-images/actions/workflows/xray-alpine.yml)
[![rookiezoe/xray:latest](https://img.shields.io/docker/v/rookiezoe/xray?color=086dd7&label=rookiezoe%2Fxray%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/xray/tags?page=1&ordering=last_updated)

[xray](https://github.com/XTLS/Xray-core) docker image, base on [teddysun](https://github.com/teddysun)'s Dockerfile.
