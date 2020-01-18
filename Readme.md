# ![](https://github.com/docker-suite/artwork/raw/master/logo/png/logo_32.png) nextcloud
[![Build Status](http://jenkins.hexocube.fr/job/docker-suite/job/nextcloud-fpm/badge/icon?color=green&style=flat-square)](http://jenkins.hexocube.fr/job/docker-suite/job/nextcloud-fpm/)
![Docker Pulls](https://img.shields.io/docker/pulls/dsuite/nextcloud-fpm.svg?style=flat-square)
![Docker Stars](https://img.shields.io/docker/stars/dsuite/nextcloud-fpm.svg?style=flat-square)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/dsuite/nextcloud-fpm/latest.svg?style=flat-square)
![MicroBadger Size (tag)](https://img.shields.io/microbadger/image-size/dsuite/nextcloud-fpm/latest.svg?style=flat-square)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat-square)](https://opensource.org/licenses/MIT)

<img src="https://nextcloud.com/wp-content/themes/next/assets/img/common/nextcloud-square-logo.png" alt="nextcloud" width="200"/>  

This is a docker image for [nextcloud][nextcloud] running on [Alpine php7 container][alpine-php7] with [runit][runit] process supervisor.

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Features
- Based on Alpine Linux with runit process supervisor.
- Bundled with [PHP 7][alpine-php7].
- Automatic installation using environment variables.
- OPCache (opcocde), APCu (local) installed and configured.
- system cron task running.
- MySQL, PostgreSQL and sqlite3 support.
- Redis, FTP, SMB, LDAP, IMAP support.
- Preconfigured with nexcloud recommandations.
- Environment variables provided (see below).

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Nextcloud Environment variables

Name                                | Default value 
------------------------------------|-------------------------------------------------
SQLITE_DATABASE                     | `[empty]`
MYSQL_HOST                          | `[empty]`
MYSQL_DATABASE                      | `[empty]`
MYSQL_USER                          | `[empty]`
MYSQL_PASSWORD                      | `[empty]`
POSTGRES_HOST                       | `[empty]`
POSTGRES_DB                         | `[empty]`
POSTGRES_USER                       | `[empty]`
POSTGRES_PASSWORD                   | `[empty]`
NEXTCLOUD_TABLE_PREFIX              | `nc_`
NEXTCLOUD_ADMIN_USER                | `[empty]`: username of the admin account
NEXTCLOUD_ADMIN_PASSWORD            | `[empty]`: password of the admin account
CORE_MEMORY_LIMIT                   | `512M`

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Php Environment variables

The full list of php7 environment variables is available on [alpine-php7 github repository][alpine-php7].

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Volumes

- **/nextcloud**
    - `/nextcloud/config/`
    - `/nextcloud/appstore/`
    - `/nextcloud/data`
    - `/nextcloud/themes`
- **/var/www**

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Docker-compose

Take a look at this [example][docker-compose]  
You will have a good example on how to run nextcloud with nextcloud-fpm, Redis and caddy web server.

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Configure

In the admin panel, you should switch from `AJAX cron` to `cron` (system cron).

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Tip : how to use occ command

There is a script for that, so you shouldn't bother to log into the container, set the right permissions, and so on.  
Just use `docker exec -it nexcloud occ command`.


[alpine-php7]: https://github.com/docker-suite/alpine-php7/
[docker-compose]: https://github.com/docker-suite/nextcloud-fpm/blob/master/.example/caddy-redis-mariadb/docker-compose.yml
[nextcloud]: https://nextcloud.com/
[runit]: http://smarden.org/runit/
