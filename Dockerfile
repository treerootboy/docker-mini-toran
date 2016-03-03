FROM alpine:latest
MAINTAINER LM <treerootboy@gmail.com>

RUN apk add --update tar wget openssl php-json php-openssl nginx php-fpm php-ctype php-dom \
    && rm -rf /var/cache/apk/* \
    && wget --no-check-certificate https://toranproxy.com/releases/toran-proxy-v1.1.7.tgz \
    && tar xzf toran-proxy-v1.1.7.tgz \
    && rm -f toran-proxy-v1.1.7.tgz

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /toran

ENTRYPOINT php-fpm && nginx -g "daemon off;"

EXPOSE 80
EXPOSE 443

RUN adduser -u8080 -D -H www \
    && chown www:root app/toran app/cache app/logs web/repo app/bootstrap.php.cache \
    && cp app/config/parameters.yml.dist app/config/parameters.yml

VOLUME /toran/app/toran
