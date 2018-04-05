#!/bin/sh

# set -e : Exit the script if any statement returns a non-true return value.
set -e

# Default domain
export CADDY_DOMAIN="${CADDY_DOMAIN:=localhost:80}"

# Caddyfile
templater /etc/caddy/Caddyfile.tpl > /etc/caddy/Caddyfile
