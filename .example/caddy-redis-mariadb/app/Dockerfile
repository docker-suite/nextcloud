FROM dsuite/nextcloud-fpm:16

# Copy scripts
COPY config/*.php /usr/src/nextcloud/config/

# Nextcloud tmp directory
RUN \
    mkdir -p /var/www/upload-tmp \
    && chown -R www-data:www-data /var/www/upload-tmp
