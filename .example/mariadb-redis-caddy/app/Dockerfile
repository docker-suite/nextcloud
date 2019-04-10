FROM craftdock/nextcloud-fpm

# Copy scripts
COPY ./redis.config.php /usr/src/nextcloud/config/redis.config.php

# Nextcloud tmp directory
RUN \
    mkdir -p /var/www/nextcloud/data/upload-tmp \
    && chown -R www-data:www-data /var/www/nextcloud/data/upload-tmp
