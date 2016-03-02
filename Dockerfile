FROM alpine:latest

MAINTAINER LM <treerootboy@gmail.com>

RUN apk add --update php-json php-openssl nginx php-fpm php-ctype php-dom php-phar git sudo \
    && rm -rf /var/cache/apk/* \
    && adduser -u8080 -D -H www \
    && php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php \
    && php composer-setup.php --install-dir=/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer --version

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /toran

ENTRYPOINT php-fpm && nginx -g "daemon off;"

EXPOSE 80
EXPOSE 443

COPY ./src /toran
RUN mkdir -p app/toran app/cache app/logs web/repo vendor \
    && touch app/bootstrap.php.cache \
    && chown www:root app/toran app/cache app/logs web/repo app/bootstrap.php.cache vendor \
    && cp app/config/parameters.yml.dist app/config/parameters.yml \
    && sed -i 's/example.org/composer.8891.com.tw/g' app/config/parameters.yml \
    && sudo -u www composer install --prefer-dist
    
VOLUME /toran/app/toran
