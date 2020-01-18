#!/usr/bin/env bash

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Generate default config file only if folder is empty
if [ "$(ls -A ${PHP_INI_DIR}/php-fpm.d/ | wc -m)" == "0" ]; then

    # Define default variables to be used in www.conf
    export PHP_FPM_PM=${PHP_FPM_PM:='ondemand'}
    export PHP_FPM_PM_CATCH_WORKERS_OUTPUT=${PHP_FPM_PM_CATCH_WORKERS_OUTPUT:='yes'}
    export PHP_FPM_PM_CLEAR_ENV=${PHP_FPM_PM_CLEAR_ENV:='no'}
    export PHP_FPM_PM_MAX_CHILDREN=${PHP_FPM_PM_MAX_CHILDREN:='9'}
    export PHP_FPM_PM_MAX_REQUEST=${PHP_FPM_PM_MAX_REQUEST:='200'}
    export PHP_FPM_PM_MAX_SPARE_SERVERS=${PHP_FPM_PM_MAX_SPARE_SERVERS:='3'}
    export PHP_FPM_PM_MIN_SPARE_SERVERS=${PHP_FPM_PM_MIN_SPARE_SERVERS:='1'}
    export PHP_FPM_PM_PROCESS_IDLE_TIMEOUT=${PHP_FPM_PM_PROCESS_IDLE_TIMEOUT:='10s'}
    export PHP_FPM_PM_START_SERVER=${PHP_FPM_PM_START_SERVER:='2'}

    # www.conf
    DEBUG "Generating ${PHP_INI_DIR}/php-fpm.d/nextcloud.conf"
    (export > /tmp/env && set -a && source /tmp/env && templater /etc/entrypoint.d/template/php-fpm/nextcloud.conf.tpl > ${PHP_INI_DIR}/php-fpm.d/nextcloud.conf)

    # daemon.conf
    DEBUG "Generating ${PHP_INI_DIR}/php-fpm.d/daemon.conf"
    {
        echo '[global]';
        echo 'daemonize = no';
    } > ${PHP_INI_DIR}/php-fpm.d/daemon.conf

fi
