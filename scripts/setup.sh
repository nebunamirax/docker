#!/bin/sh

php /var/www/html/artisan passport:keys
php /var/www/html/artisan config:clear

while ! mysqladmin ping -h "$DB_HOST" --silent; do
    sleep 1
done

php /var/www/html/artisan migrate --force --seed

chown -R www-data:www-data /var/www/html
