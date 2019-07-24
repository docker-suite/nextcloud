#!/usr/bin/env bash

# Add libraries
source /usr/local/lib/bash-logger.sh
source /usr/local/lib/persist-env.sh

# version_greater A B returns whether A > B
 version_greater() {
    [ "$(printf '%s\n' "$@" | sort -g | head -n 1)" != "$1" ];
}

# return true if specified directory is empty
directory_empty() {
    [ `ls -A "$1"/ | wc -m` == "0" ]
}

run_as() {
    su-exec ${ocuser} /bin/sh -c "$1"
}

NOTICE "Checking nextcloud version..."

# Get the installed version and the image version
installed_version="0.0.0~unknown"
if [ -f ${ocpath}/version.php ]; then
    installed_version=$(php -r 'require "/var/www/version.php"; echo "$OC_VersionString";')
fi
image_version=$(php -r 'require "/usr/src/nextcloud/version.php"; echo "$OC_VersionString";')

# Can't start Nextcloud if installed_version is greater than image_version
if version_greater "$installed_version" "$image_version"; then
    WARNING ''
    WARNING "Can't start Nextcloud because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
    WARNING ''
    runit service nexcloud stop
    exit 1
fi

DEBUG "##################################################################"
DEBUG "installed_version: $installed_version"
DEBUG "image_version: $image_version"
DEBUG "##################################################################"

# Start installing nextcloud
# This will always happen if you don't mount /var/www
if version_greater "$image_version" "$installed_version"; then
    #
    if [ "$installed_version" != "0.0.0~unknown" ]; then
        NOTICE "Updating nextcloud files to $image_version..."
    else
        NOTICE "Installing nextcloud $image_version..."
    fi

    # use rsync to copy the files from /usr/src/nextcloud to ocpath (/var/www)
    rsync_options="-rlDog --chown ${ocuser}:${ocgroup}"
    rsync $rsync_options --delete --exclude /config/ --exclude /custom_apps/ --exclude /themes/ /usr/src/nextcloud/ ${ocpath}/
    # Update if empty
    for dir in config custom_apps themes; do
        if [ ! -d ${ocpath}/"$dir" ] || directory_empty ${ocpath}/"$dir"; then
            rsync $rsync_options --include /"$dir"/ --exclude '/*' /usr/src/nextcloud/ ${ocpath}/
        fi
    done
fi

# Make sure data folders exist
mkdir -p ${datapath}
# Define nextcloud path from datapath
nextcloudpath=$(realpath ${datapath}/../)
# Move files into volumes (keep original files)
mvlink  ${ocpath}/config            ${nextcloudpath}/config
mvlink  ${ocpath}/custom_apps       ${nextcloudpath}/custom_apps
mvlink  ${ocpath}/themes            ${nextcloudpath}/themes
# Create log file if necessary
[ ! -e /var/log/nextcloud.log ]     && touch /var/log/nextcloud.log
mvlink /var/log/nextcloud.log       ${nextcloudpath}/log/nextcloud.log

# Adjust file permissions
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640

# Adjust files owner
find ${ocpath}/             \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/apps/        \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/assets/      \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/config/      \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/custom_apps/ \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/themes/      \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/updater/     \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
# Adjust files owner
find ${datapath}/           \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}

# chmod/chown .htaccess
if [ -f ${ocpath}/.htaccess ]; then
    chmod 0644 ${ocpath}/.htaccess
    chown ${rootuser}:${ocgroup} ${ocpath}/.htaccess
fi
if [ -f ${datapath}/.htaccess ]; then
    chmod 0644 ${datapath}/.htaccess
    chown ${rootuser}:${ocgroup} ${datapath}/.htaccess
fi


# Get installed version from config
# This is necessary if you don't mount /var/www
if [ -f /var/www/config/config.php ]; then
    installed_version=$(php -r 'require "/var/www/config/config.php"; echo array_key_exists("version",$CONFIG) ? $CONFIG["version"] : "0.0.0~unknown";')
fi

# Can't start Nextcloud if installed_version is greater than image_version
if version_greater "$installed_version" "$image_version"; then
    WARNING ''
    WARNING "Can't start Nextcloud because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
    WARNING ''
    runit service nexcloud stop
    exit 1
fi

DEBUG "##################################################################"
DEBUG "installed_version: $installed_version"
DEBUG "image_version: $image_version"
DEBUG "##################################################################"

# Launch the update process if nextcloud is already installed
if [ "$installed_version" != "0.0.0~unknown" ]; then
    NOTICE "Upgrading nextcloud to $image_version..."
    # Adjust file permissions
    find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
    find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
    # Launch the upgrade process
    /usr/local/bin/occ upgrade
fi
