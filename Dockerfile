FROM php:7.3-fpm-alpine

ENV COMPOSER_VERSION 1.8.0

# Install php-imagick
RUN set -ex \
    && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS imagemagick-dev libtool \
    && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick \
    && apk add --no-cache --virtual .imagick-runtime-deps imagemagick \
    && apk del .phpize-deps

# Install composer
RUN set -ex \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "copy('https://composer.github.io/installer.sig', 'composer-setup.sig');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === trim(file_get_contents('composer-setup.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; exit(1); } echo PHP_EOL;" \
    && php composer-setup.php --version=$COMPOSER_VERSION --install-dir=/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && php -r "unlink('composer-setup.sig');"
