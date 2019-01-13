#!/bin/sh

php /var/www/html/artisan passport:keys
php /var/www/html/artisan config:clear
php /var/www/html/artisan storage:link

chown -R www-data:www-data /var/www/html

if [ "$DB_HOST" = "mysql" ]; then
    while ! mysqladmin ping -h "$DB_HOST" --silent; do
        sleep 1
    done
fi

php /var/www/html/artisan migrate --force --seed
