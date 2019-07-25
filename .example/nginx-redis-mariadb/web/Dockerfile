FROM nginx:alpine


RUN set -x \
    # Ensure www-data user exists
    # 82 is the standard uid/gid for "www-data" in Alpine
    && sh -c 'addgroup -g 82 -S www-data 2>/dev/null || exit 0'  \
    && sh -c 'adduser -u 82 -S -D -s /sbin/nologin -G www-data -g www-data www-data 2>/dev/null || exit 0' \
    # Add nginx user to www-data
    && apk --no-cache add shadow \
    && usermod -aG www-data nginx

# Copy config
COPY config/*.conf /etc/nginx/

# Add volume to allow persistence
VOLUME ["/var/log"]
