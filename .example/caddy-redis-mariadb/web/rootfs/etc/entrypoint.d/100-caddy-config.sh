#!/bin/sh

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Add libraries
source /usr/local/lib/persist-env.sh

# Default domain
export CADDY_DOMAIN=$(env_get CADDY_DOMAIN "localhost:80")

# Caddyfile
templater /etc/caddy/Caddyfile.tpl > /etc/caddy/Caddyfile
