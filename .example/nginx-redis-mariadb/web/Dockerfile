FROM nginx:alpine

# Ensure www-data user exists
# 82 is the standard uid/gid for "www-data" in Alpine
RUN set -x && addgroup -g 82 -S www-data && adduser -u 82 -S -D -G www-data www-data

# Copy scripts
COPY ./nginx.conf /etc/nginx/nginx.conf
