FROM dsuite/caddy:latest

# Define plugins needed by caddy
ENV PLUGINS=""

# Add plugins to caddy
RUN bash -c '/usr/local/bin/caddy-install.sh'

# Copy scripts
COPY rootfs /

# Add volume to allow persistence
VOLUME ["/var/log"]