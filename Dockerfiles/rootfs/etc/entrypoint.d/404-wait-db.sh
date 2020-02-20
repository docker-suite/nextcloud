#!/usr/bin/env bash

# shellcheck disable=SC2086

#
POSTGRES_HOST=$(env_get "POSTGRES_HOST")
MYSQL_HOST=$(env_get "MYSQL_HOST")
DATABASE_HOST=${MYSQL_HOST:=$POSTGRES_HOST}

# Wait for database connection
if [ -n "$DATABASE_HOST" ]; then

    host=$(echo $DATABASE_HOST | cut -d ":" -f 1)
    port=$(echo $DATABASE_HOST | cut -d ":" -f 2)

    wait-host "${host}:${port}" \
        -t 0 \
        -d 2 \
        -m "Waiting for database connection on host: ${host} and port: ${port}" \
        -s

    if [ $? ]; then
        NOTICE "Database connection established on host: ${host} and port: ${port}"
    else
        WARNING "Error while trying to connect to the database"
    fi

fi
