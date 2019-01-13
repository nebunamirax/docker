#!/bin/sh
set -e

if [ $# -gt 0 ]; then
    exec "$@"
else
    if [ ! -f /var/www/html/.env ]; then
        . /usr/local/bin/envfile.sh
    fi

    if [ ! -f /var/www/html/storage/oauth-private.key ]; then
        . /usr/local/bin/setup.sh
    fi

    /usr/bin/supervisord -c /etc/supervisord.conf
fi
