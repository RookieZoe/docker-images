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
> ```
>
> Then, the other config is as same as official [docker-image](https://hub.docker.com/_/nginx)'s config.

## 2. rsshub

[![status](https://img.shields.io/github/actions/workflow/status/RookieZoe/docker-images/rsshub-alpine.yml?label=rsshub&logo=github&logoColor=959da5)](https://github.com/RookieZoe/docker-images/actions/workflows/rsshub-alpine.yml)
[![rookiezoe/rsshub:latest](https://img.shields.io/docker/v/rookiezoe/rsshub?color=086dd7&label=rookiezoe%2Frsshub%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/rsshub/tags?page=1&ordering=last_updated)

[rsshub](https://github.com/DIYgod/RSSHub) docker image.

> Usage:
>
> Deploy configuration: as same as offical config: [Configuration](https://docs.rsshub.app/en/install/#configuration-3)

## 3. xray

[![status](https://img.shields.io/github/actions/workflow/status/RookieZoe/docker-images/xray-alpine.yml?label=xray&logo=github&logoColor=959da5)](https://github.com/RookieZoe/docker-images/actions/workflows/xray-alpine.yml)
[![rookiezoe/xray:latest](https://img.shields.io/docker/v/rookiezoe/xray?color=086dd7&label=rookiezoe%2Fxray%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/xray/tags?page=1&ordering=last_updated)

[xray](https://github.com/XTLS/Xray-core) docker image, base on [teddysun](https://github.com/teddysun)'s Dockerfile.

## 4. epub2audiobook

[![status](https://img.shields.io/github/actions/workflow/status/RookieZoe/docker-images/epub2audiobook.yml?label=epub2audiobook&logo=github&logoColor=959da5)](https://github.com/RookieZoe/docker-images/actions/workflows/epub2audiobook.yml)
[![rookiezoe/epub2audiobook:latest](https://img.shields.io/docker/v/rookiezoe/epub2audiobook?color=086dd7&label=rookiezoe%2Fepub2audiobook%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/epub2audiobook/tags?page=1&ordering=last_updated)

Thanks to [p0n1/epub_to_audiobook](https://github.com/p0n1/epub_to_audiobook)

> Usage:
>
> run as a buddy server with your audiobookshelf, such as:
> run `docker-compose up -d` with the following [docker-compose.example.yml](epub2audiobook/docker-compose.example.yml)
> then you can keep it running in the background.
> when you need to convert a epub file, just run:
> docker exec epub2audiobook python epub2audiobook.py /books/bookauthor/bookname/bookname.epub /books/bookauthor/bookname/ --voice_name zh-CN-XiaoxiaoNeural --language zh-CN
