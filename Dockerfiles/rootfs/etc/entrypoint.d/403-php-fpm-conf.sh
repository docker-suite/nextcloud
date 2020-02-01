#!/usr/bin/env bash

# shellcheck disable=SC1091
# shellcheck disable=SC2012
# shellcheck disable=SC2086

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Generate default config file only if folder is empty
if [ "$(ls -A ${PHP_INI_DIR}/php-fpm.d/ | wc -m)" == "0" ]; then

    # www.conf
    DEBUG "Generating ${PHP_INI_DIR}/php-fpm.d/nextcloud.conf"
    (set -a && source /etc/environment && templater /etc/entrypoint.d/template/php-fpm/nextcloud.conf.tpl > ${PHP_INI_DIR}/php-fpm.d/nextcloud.conf)

    # daemon.conf
    DEBUG "Generating ${PHP_INI_DIR}/php-fpm.d/daemon.conf"
    {
        echo '[global]';
        echo 'daemonize = no';
    } > ${PHP_INI_DIR}/php-fpm.d/daemon.conf

fi
