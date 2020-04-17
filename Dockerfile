FROM php:7.3-fpm-alpine

ENV COMPOSER_VERSION 1.8.0
ENV GALAXY_OF_DRONES_VERSION master

# Install packages
RUN set -ex \
    && apk add --update --no-cache --virtual .run-deps imagemagick libzip mysql-client nginx supervisor

# Install php extensions
RUN set -ex \
    && apk add --update --no-cache --virtual .build-deps $PHPIZE_DEPS libtool imagemagick-dev zlib-dev libzip-dev \
    && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pecl install zip \
    && docker-php-ext-enable zip \
    && docker-php-ext-install bcmath pcntl pdo_mysql \
    && apk del .build-deps

# Install composer
RUN set -ex \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "copy('https://composer.github.io/installer.sig', 'composer-setup.sig');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === trim(file_get_contents('composer-setup.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; exit(1); } echo PHP_EOL;" \
    && php composer-setup.php --version=$COMPOSER_VERSION --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && php -r "unlink('composer-setup.sig');"

# Setup services
RUN set -ex \
    && mkdir -p /run/nginx \
    && touch /run/nginx/nginx.pid \
    && sed -i "s/user .*;/user www-data;/" /etc/nginx/nginx.conf \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && chown -R www-data:www-data /var/www/html

USER www-data

# Install app
RUN set -ex \
    && wget https://github.com/nebunamirax/galaxyofdrones/archive/${GALAXY_OF_DRONES_VERSION}.tar.gz \
    && tar xzf ${GALAXY_OF_DRONES_VERSION}.tar.gz --strip-components=1 \
    && rm -r ${GALAXY_OF_DRONES_VERSION}.tar.gz \
    && composer global require "hirak/prestissimo:^0.3" \
    && composer install -o --no-dev \
    && rm -rf bootstrap/cache/*

USER root

COPY config/supervisord.conf /etc/supervisord.conf
COPY config/nginx-site.conf /etc/nginx/conf.d/default.conf
COPY scripts/dotenv.sh /usr/local/bin/dotenv.sh
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/setup.sh /usr/local/bin/setup.sh

EXPOSE 8000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
