#!/usr/bin/env bash

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Log folder
access_log="access.log"
error_log="error.log"
nextcloud_log="nextcloud.log"

# Create log folder if necessary
if [[ ! -d "${NEXTCLOUD_LOG_DIR}" ]]; then
    DEBUG "Creating log folder: $NEXTCLOUD_LOG_DIR"
    mkdir -p "$NEXTCLOUD_LOG_DIR"
fi

# Create nextcloud access log file
if [[ ! -f "${NEXTCLOUD_LOG_DIR}/${access_log}" ]]; then
    DEBUG "Creating nextcloud access log file: ${NEXTCLOUD_LOG_DIR}/${access_log}"
    touch "${NEXTCLOUD_LOG_DIR}/${access_log}"
fi

# Create nextcloud error log file
if [[ ! -f "${NEXTCLOUD_LOG_DIR}/${error_log}" ]]; then
    DEBUG "Creating nextcloud error log file: ${NEXTCLOUD_LOG_DIR}/${error_log}"
    touch "${NEXTCLOUD_LOG_DIR}/${error_log}"
fi

# Create nextcloud log file
if [[ ! -f "${NEXTCLOUD_LOG_DIR}/${nextcloud_log}" ]]; then
    DEBUG "Creating nextcloud log file: ${NEXTCLOUD_LOG_DIR}/${nextcloud_log}"
    touch "${NEXTCLOUD_LOG_DIR}/${nextcloud_log}"
fi

# Update permissions
if [[ -n "$(getent passwd $NEXTCLOUD_USER)" ]] && [[ -n "$(getent group $NEXTCLOUD_GROUP)" ]] ; then
    chown -R $NEXTCLOUD_USER:$NEXTCLOUD_GROUP "$NEXTCLOUD_LOG_DIR"
    chmod 0775 "${NEXTCLOUD_LOG_DIR}"
fi
