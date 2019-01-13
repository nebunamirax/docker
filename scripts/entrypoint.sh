#!/bin/sh
set -e

if [ $# -gt 0 ];then
    exec "$@"
else
    /usr/bin/supervisord -c /etc/supervisord.conf
fi
