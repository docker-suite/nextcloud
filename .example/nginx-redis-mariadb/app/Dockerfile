FROM dsuite/nextcloud-fpm:16

# Copy config
COPY config/*.php /usr/src/nextcloud/config/

# Nextcloud tmp directory
RUN \
    mkdir -p /var/www/upload-tmp \
    && chown -R www-data:www-data /var/www/upload-tmp
