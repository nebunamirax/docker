#!/bin/sh

cp /var/www/html/.env.example /var/www/html/.env

sed -i "s/APP_ENV=.*/APP_ENV=production/" /var/www/html/.env
sed -i "s/APP_DEBUG=.*/APP_DEBUG=false/" /var/www/html/.env

php /var/www/html/artisan key:generate
php /var/www/html/artisan config:clear
