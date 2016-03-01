FROM apline:latest

MAINTAINER LM <treerootboy@gmail.com>

RUN apk add --update php-json php-openssl nginx php-fpm php-ctype php-dom \
    && rm -rf /var/cache/apk/* \
    && adduser -u8080 -D -H www

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /toran

ENTRYPOINT php-fpm && nginx

COPY ./src /toran
