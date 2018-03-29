#!/bin/sh

# Redirect STDERR to STDOUT
exec 2>&1

# Make environnement variables accessibles
[ -r /etc/envvars ] && . /etc/envvars

# version_greater A B returns whether A > B
function version_greater() {
    [ "$(printf '%s\n' "$@" | sort -g | head -n 1)" != "$1" ];
}

# return true if specified directory is empty
function directory_empty() {
    [ `ls -A "$1"/ | wc -m` == "0" ]
}

function run_as() {
    su-exec ${ocuser} /bin/sh -c "$1"
}

echo "Checking nextcloud version..."

# Get the installed version and the image version
installed_version="0.0.0~unknown"
if [ -f ${ocpath}/version.php ]; then 
    installed_version=$(php -r 'require "/var/www/version.php"; echo "$OC_VersionString";')
fi
image_version=$(php -r 'require "/usr/src/nextcloud/version.php"; echo "$OC_VersionString";')

# Can't start Nextcloud if installed_version is greater than image_version
if version_greater "$installed_version" "$image_version"; then
    echo "Can't start Nextcloud because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
    runit service nexcloud stop
    exit 1
fi

# Start installing nextcloud
if version_greater "$image_version" "$installed_version"; then
    echo "Upgrading nextcloud to $image_version..."
    # use rsync to copy the files from /usr/src/nextcloud to ocpath
    rsync_options="-rlDog --chown ${ocuser}:${ocgroup}"
    rsync $rsync_options --delete --exclude /config/ --exclude /custom_apps/ --exclude /themes/ /usr/src/nextcloud/ ${ocpath}/
    # Update if empty
    for dir in config custom_apps themes; do
        if [ ! -d ${ocpath}/"$dir" ] || directory_empty ${ocpath}/"$dir"; then
            rsync $rsync_options --include /"$dir"/ --exclude '/*' /usr/src/nextcloud/ ${ocpath}/
        fi
    done

    # Launch the update process if nextcloud is already installed
    if [ "$installed_version" != "0.0.0~unknown" ]; then
        # Adjust file permissions
        find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
        find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
        # Launch the upgrade process
        occ upgrade --no-app-disable
    fi
fi

# Make sure folders exist
mkdir -p ${datapath}

# Adjust file permissions
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640

# chown Directories
find ${ocpath}/             \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/apps/        \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/assets/      \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/config/      \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/custom_apps/ \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/themes/      \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
find ${ocpath}/updater/     \( \! -user ${ocuser} -o \! -group ${ocgroup} \) -print0 | xargs -0 -r chown ${ocuser}:${ocgroup}
# chown Directories
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

# Put files into volumes on first start
mvlink  ${ocpath}/config            ${datapath}/../config
mvlink  ${ocpath}/custom_apps       ${datapath}/../custom_apps
mvlink  ${ocpath}/themes            ${datapath}/../themes
mvlink /var/log/nextcloud.log       ${datapath}/../log/nextcloud.log
