FROM dsuite/nextcloud-fpm:16

# Copy scripts
COPY config/*.php /usr/src/nextcloud/config/

# Nextcloud tmp directory
RUN \
    mkdir -p /var/www/nextcloud/data/upload-tmp \
    && chown -R www-data:www-data /var/www/nextcloud/data/upload-tmp
