#!/usr/bin/env bash

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu


# Create log folder
mkdir -p /var/log

# give access to www-data
chown www-data:www-data /var/log
