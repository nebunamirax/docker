#!/bin/sh

cp /var/www/html/.env.example /var/www/html/.env
chown www-data:www-data /var/www/html/.env

sed -i "s/APP_ENV=.*/APP_ENV=production/" /var/www/html/.env
sed -i "s/APP_DEBUG=.*/APP_DEBUG=false/" /var/www/html/.env
sed -i "s/PUSHER_APP_ID=.*/PUSHER_APP_ID=$(openssl rand -hex 10)/" /var/www/html/.env
sed -i "s/PUSHER_APP_KEY=.*/PUSHER_APP_KEY=$(openssl rand -hex 10)/" /var/www/html/.env
sed -i "s/PUSHER_APP_SECRET=.*/PUSHER_APP_SECRET=$(openssl rand -hex 10)/" /var/www/html/.env

php /var/www/html/artisan key:generate
php /var/www/html/artisan config:clear
