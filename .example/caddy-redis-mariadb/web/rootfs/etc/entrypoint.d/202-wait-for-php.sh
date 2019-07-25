#!/usr/bin/env bash

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Add libraries
source /usr/local/lib/bash-logger.sh
source /usr/local/lib/persist-env.sh


#
PHP_FPM_HOST=$(env_get PHP_FPM_HOST)
PHP_FPM_PORT=$(env_get PHP_FPM_PORT)

#
if [ -n "$PHP_FPM_HOST" ] && [ $PHP_FPM_PORT ]; then

    wait-host "${PHP_FPM_HOST}:${PHP_FPM_PORT}" \
        -t 0 \
        -d 2 \
        -m "Waiting for php-fpm connection on host : $PHP_FPM_HOST:$PHP_FPM_PORT" \
        -s

    if [ $? ]; then
        NOTICE "Connection established on host: ${PHP_FPM_HOST} and port: ${PHP_FPM_PORT}"
    else
        WARNING "Error while trying to connect to $PHP_FPM_HOST:$PHP_FPM_PORT"
    fi

fi
