FROM craftdock/alpine-php7:7.1

LABEL maintainer="Hexosse <hexosse@gmail.com>" \
      description="Nextcloud image based on alpine with runit process supervisor."

# Nextcloud version
ENV NEXTCLOUD_VERSION 13.0.1


# Ensure nextcloud user exists
RUN set -x \
    && addgroup -S nextcloud \
    && adduser -S -D -G nextcloud nextcloud \
    && adduser nextcloud www-data

RUN \
	# Print executed commands
	set -x \
    # Add codecasts.rocks php repository
    && echo "@php http://php.codecasts.rocks/v3.7/php-7.1" >> /etc/apk/repositories \
    # Update repository indexes
    && apk-update \
    # Add recommanded packages : https://docs.nextcloud.com/server/12/admin_manual/installation/source_installation.html#prerequisites-label
    && apk-install --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        # Required : ctype, dom, GD, iconv, JSON, libxml, mbstring, posix, SimpleXML, XMLReader, XMLWriter ,zip, zlib
        php7-ctype@php \
        php7-dom@php \
        php7-gd@php \
        php7-iconv@php \
        php7-json@php \
        libxml2 \
        php7-mbstring@php \
        php7-posix@php \
        php7-xmlreader@php \
        php7-zip@php \
        php7-zlib@php \
        # Database connectors : pdo_sqlite, pdo_mysql, pdo_pgsql
        php7-pdo_sqlite@php \
        php7-pdo_mysql@php \
        php7-pgsql@php \
        # Recommended packages : curl, fileinfo, bz2, intl, mcrypt, openssl
        php7-curl@php \
        php7-bz2@php \
        php7-intl@php \
        php7-mcrypt@php \
        php7-openssl@php \
        # Required for specific apps : ldap, **smbclient**, ftp, imap
        php7-ldap@php \
        php7-ftp@php \
        php7-imap@php \
        # Recommended for specific apps : exif, gmp
        php7-exif@php \
        php7-gmp@php \
        # For enhanced server performance : apcu, memcached, redis
        php7-apcu@php \
        php7-memcached@php \
        php7-redis@php \
        # For preview generation : imagick, avconv or ffmpeg, OpenOffice or LibreOffice
        imagemagick-libs \
        php7-imagick@php \
        ffmpeg libva \
        libreoffice \
        # For command line processing : pcntl
        php7-pcntl@php \
        # Other tools
        icu-libs \
        boost-filesystem \
    # Add packages used in this image
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        rsync \
    # Download, build and instal libsmbclient-php
    # Add necessary packages to install libsmbclient-php
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        samba \
    # Add temporary packages to compile libsmbclient-php
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --virtual .build-dependencies \
        git \
        autoconf \
        automake \
        file \
        g++ \
        gcc \
        make \
        php7-dev \
        re2c \
        samba-dev \
        zlib-dev \
    # Compile libsmbclient-php
    && git clone https://github.com/eduardok/libsmbclient-php.git /tmp/smbclient \
    && cd /tmp/smbclient \
    && phpize7 \
    && ./configure --with-php-config=/usr/bin/php-config7 \
    && make \
    && make install \
    # Activate libsmbclient-php
    && echo "extension=\"smbclient.so\"" > /etc/php7/conf.d/00_smbclient.ini \
	# Clear apk's cache
	&& rm -rf /etc/service.d/php-fpm \
	&& apk-remove .build-dependencies \
	&& apk-cleanup


# Download, install and verify Nextcloud
RUN curl -fsSL -o nextcloud.tar.bz2 \
        "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" \
    && mkdir /usr/src/ \
	&& tar -xjf nextcloud.tar.bz2 -C /usr/src/ \
	&& rm nextcloud.tar.bz2 \
    #
    && rm -rf /usr/src/nextcloud/updater \
    && mkdir -p /usr/src/nextcloud/assets \
    && mkdir -p /usr/src/nextcloud/config \
    && mkdir -p /usr/src/nextcloud/custom_apps \
    && mkdir -p /usr/src/nextcloud/themes \
    && mkdir -p /usr/src/nextcloud/updater \
    && chmod +x /usr/src/nextcloud/occ


# Copy scripts
COPY /rootfs /

# Add volume to allow persistence
VOLUME ["/nextcloud"]
