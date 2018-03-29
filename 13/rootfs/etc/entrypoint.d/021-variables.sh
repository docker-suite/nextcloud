#!/bin/sh

# Redirect STDERR to STDOUT
exec 2>&1

# Make environnement variables accessibles
[ -r /etc/envvars ] && . /etc/envvars

# Variables
export ocpath=/var/www
export ocuser=www-data
export ocgroup=www-data
export rootuser=root
export datapath=/nextcloud/data

# Save original environment variables to /etc/envvars
export > /etc/envvars
