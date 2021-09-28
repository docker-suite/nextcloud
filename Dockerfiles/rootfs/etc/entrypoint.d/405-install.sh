#!/usr/bin/env bash

# return true if specified directory is empty
directory_empty() {
    [ `ls -A "$1"/ | wc -m` == "0" ]
}

run_as() {
    su-exec "$NEXTCLOUD_USER" /bin/sh -c "$1"
}

NOTICE "Checking nextcloud version..."

# Get the installed version and the image version
installed_version="0.0.0+unknown"
if [ -f "${NEXTCLOUD_WWW_DIR}/version.php" ]; then
    installed_version=$(php -r "require '${NEXTCLOUD_WWW_DIR}/version.php'; echo \$OC_VersionString;")
    installed_version=$(echo "$installed_version" | sed -e 's/\./\+/3')
fi
image_version=$(php -r "require '${NEXTCLOUD_INSTALL_DIR}/version.php'; echo \$OC_VersionString;")

DEBUG "##################################################################"
DEBUG "Checking nextcloud version..."
DEBUG "installed version: $installed_version"
DEBUG "image version: $image_version"
DEBUG "##################################################################"

# Can't start Nextcloud if installed_version is greater than image_version
if [[ $(semver compare  "$installed_version" "$image_version") -eq 1 ]]; then
    WARNING ''
    WARNING "Can't start Nextcloud because the installed version ($installed_version) is higher than the image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
    WARNING ''
    runit service nexcloud stop
    exit 1
fi

# Start installing nextcloud
# This will always happen if you don't mount /var/www
if [[ $(semver compare  "$image_version" "$installed_version") -eq 1 ]]; then
    #
    if [[ "$installed_version" != "0.0.0+unknown" ]]; then
        NOTICE "Updating nextcloud files to $image_version..."
    else
        NOTICE "Installing nextcloud $image_version..."
    fi

    # use rsync to copy the files from /usr/src/nextcloud to /var/www
    rsync_options="--archive --chown ${NEXTCLOUD_USER}:${NEXTCLOUD_GROUP}"
    DEBUG "Syncing ${NEXTCLOUD_INSTALL_DIR}/ to ${NEXTCLOUD_WWW_DIR}/"
    rsync $rsync_options --delete --exclude "/config/" --exclude "/apps/" --exclude "/appstore/" --exclude "/themes/" "${NEXTCLOUD_INSTALL_DIR}/" "${NEXTCLOUD_WWW_DIR}/"

    # Update config, apps and themes folder if they are empty
    for dir in config apps themes; do
        DEBUG "Syncing ${NEXTCLOUD_INSTALL_DIR}/$dir to ${NEXTCLOUD_WWW_DIR}/$dir"
        if [[ ! -d "${NEXTCLOUD_WWW_DIR}/${dir}" ]] || directory_empty "${NEXTCLOUD_WWW_DIR}/$dir"; then
            rsync $rsync_options --include /$dir/ --exclude '/*' "${NEXTCLOUD_INSTALL_DIR}/" "${NEXTCLOUD_WWW_DIR}/"
        fi
    done

    # Update apps folder if it exists
    if [[ -d "${NEXTCLOUD_WWW_DIR}/apps" ]]; then
        DEBUG "Syncing ${NEXTCLOUD_INSTALL_DIR}/apps to ${NEXTCLOUD_WWW_DIR}/apps"
        source=${NEXTCLOUD_INSTALL_DIR}/apps
        destination=${NEXTCLOUD_WWW_DIR}/apps

        shopt -s nullglob
        {
            for dir in "$destination/"*/; do
                dirname=$(basename "$dir")
                if [ -d "$source/$dirname" ]; then
                printf '+ /%s/***\n' "$dirname"
                fi
            done
            printf -- '- *\n'
        } > "/tmp/filter.rules"

        rsync $rsync_options --delete --filter="merge /tmp/filter.rules" "$source"/ "$destination"
    fi
fi

# Move files into volumes (keep original files)
mvlink "${NEXTCLOUD_WWW_DIR}/config" "$NEXTCLOUD_CONFIG_DIR"

# Get installed version from config
# This is necessary if you don't mount /var/www
if [[ -f "${NEXTCLOUD_WWW_DIR}/config/config.php" ]]; then
    installed_version=$(php -r "require '${NEXTCLOUD_WWW_DIR}/config/config.php'; echo array_key_exists(\"version\",\$CONFIG) ? \$CONFIG[\"version\"] : \"0.0.0\";")
    installed_version=$(echo "$installed_version" | sed -e 's/\./\+/3')
fi

# Can't start Nextcloud if installed_version is greater than image_version
if [[ $(semver compare  "$installed_version" "$image_version") -eq 1 ]]; then
    WARNING ''
    WARNING "Can't start Nextcloud because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
    WARNING ''
    exit 1
fi

DEBUG "##################################################################"
DEBUG "Current nextcloud version..."
DEBUG "installed version: $installed_version"
DEBUG "image version: $image_version"
DEBUG "##################################################################"

# Launch the update process if nextcloud is already installed
if [[ $(semver compare  "$image_version" "$installed_version") -eq 1 ]]; then
    NOTICE "Upgrading nextcloud to $image_version..."
    # Adjust file permissions
    find "${NEXTCLOUD_WWW_DIR}"/ -type d -print0 | xargs -0 chmod 0750
    find "${NEXTCLOUD_WWW_DIR}"/ -type f -print0 | xargs -0 chmod 0640
    # Launch the upgrade process
    /usr/local/bin/occ upgrade || true
fi

DEBUG "##################################################################"
DEBUG "Nextcloud installation done."
DEBUG "##################################################################"
