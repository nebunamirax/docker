#!/bin/sh
set -e

if [ $# -gt 0 ]; then
    exec "$@"
else
    if [ ! -f /var/www/html/.env ]; then
        cp /var/www/html/.env.example /var/www/html/.env
        sed -i "s/APP_ENV=.*/APP_ENV=production/" /var/www/html/.env
        php /var/www/html/artisan key:generate
        php /var/www/html/artisan passport:keys
        php /var/www/html/artisan config:clear
        php /var/www/html/artisan migrate --force --seed
        chown -R www-data:www-data /var/www/html
    fi

    /usr/bin/supervisord -c /etc/supervisord.conf
fi
