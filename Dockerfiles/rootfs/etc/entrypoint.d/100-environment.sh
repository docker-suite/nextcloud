#!/usr/bin/env bash

# Add libraries
source /usr/local/lib/persist-env.sh

# Nextcloud version
env_set "NEXTCLOUD_MAJOR"   "$(env_get "NEXTCLOUD_MAJOR")"
env_set "NEXTCLOUD_VERSION" "$(env_get "NEXTCLOUD_VERSION")"

# Environment variables used by services
env_set ocpath   /var/www
env_set ocuser   www-data
env_set ocgroup  www-data
env_set rootuser root
env_set datapath /nextcloud/data

[ -n "$(env_get "SQLITE_DATABASE")" ]           && env_set "SQLITE_DATABASE" "$(env_get "SQLITE_DATABASE")"

[ -n "$(env_get "MYSQL_HOST")" ]                && env_set "MYSQL_HOST" "$(env_get "MYSQL_HOST")"
[ -n "$(env_get "MYSQL_DATABASE")" ]            && env_set "MYSQL_DATABASE" "$(env_get "MYSQL_DATABASE")"
[ -n "$(env_get "MYSQL_USER")" ]                && env_set "MYSQL_USER" "$(env_get "MYSQL_USER")"
[ -n "$(env_get "MYSQL_PASSWORD")" ]            && env_set "MYSQL_PASSWORD" "$(env_get "MYSQL_PASSWORD")"

[ -n "$(env_get "POSTGRES_HOST")" ]             && env_set "POSTGRES_HOST" "$(env_get "POSTGRES_HOST")"
[ -n "$(env_get "POSTGRES_DB")" ]               && env_set "POSTGRES_DB" "$(env_get "POSTGRES_DB")"
[ -n "$(env_get "POSTGRES_USER")" ]             && env_set "POSTGRES_USER" "$(env_get "POSTGRES_USER")"
[ -n "$(env_get "POSTGRES_PASSWORD")" ]         && env_set "POSTGRES_PASSWORD" "$(env_get "POSTGRES_PASSWORD")"

[ -n "$(env_get "NEXTCLOUD_TABLE_PREFIX")" ]    && env_set "NEXTCLOUD_TABLE_PREFIX" "$(env_get "NEXTCLOUD_TABLE_PREFIX")"
[ -n "$(env_get "NEXTCLOUD_ADMIN_USER")" ]      && env_set "NEXTCLOUD_ADMIN_USER" "$(env_get "NEXTCLOUD_ADMIN_USER")"
[ -n "$(env_get "NEXTCLOUD_ADMIN_PASSWORD")" ]  && env_set "NEXTCLOUD_ADMIN_PASSWORD" "$(env_get "NEXTCLOUD_ADMIN_PASSWORD")"

[ -n "$(env_get "CORE_MEMORY_LIMIT")" ]         && env_set "CORE_MEMORY_LIMIT" "$(env_get "CORE_MEMORY_LIMIT")"
