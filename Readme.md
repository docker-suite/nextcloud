## nextcloud


![](https://s32.postimg.org/69nev7aol/Nextcloud_logo.png)

### Features
- Based on Alpine Linux with runit process supervisor.
- Bundled with [PHP 7][alpine-php7].
- Automatic installation using environment variables.
- OPCache (opcocde), APCu (local) installed and configured.
- system cron task running.
- MySQL, PostgreSQL and sqlite3 support.
- Redis, FTP, SMB, LDAP, IMAP support.
- Preconfigured with nexcloud recommandations.
- Environment variables provided (see below).

### Nextcloud Environment variables

Name                                | Default value 
------------------------------------|-------------------------------------------------
MYSQL_DATABASE                      | (default : none)
MYSQL_USER                          | (default : none)
MYSQL_PASSWORD                      | (default : none)
MYSQL_HOST                          | (default : none)
NEXTCLOUD_ADMIN_USER                | username of the admin account (default : none)
NEXTCLOUD_ADMIN_PASSWORD            | password of the admin account (default : none)

### Php Environment variables

Name                                | Default value 
------------------------------------|-------------------------------------------------
PHP_FPM_PM                          | `ondemand`
PHP_FPM_PM_MAX_CHILDREN             | `9`
PHP_FPM_PM_PROCESS_IDLE_TIMEOUT     | `10s`
PHP_FPM_PM_MAX_REQUEST              | `200`
PHP_FPM_PM_START_SERVER             | `2`
PHP_FPM_PM_MIN_SPARE_SERVERS        | `1`
PHP_FPM_PM_MAX_SPARE_SERVERS        | `3`
PHP_FPM_PM_CLEAR_ENV                | `no`
PHP_FPM_PM_CATCH_WORKERS_OUTPUT     | `yes`
CORE_REALPATH_CACHE_SIZE            | `256K`
CORE_REALPATH_CACHE_TTL             | `600`
CORE_MEMORY_LIMIT                   | `512M`
CORE_UPLOAD_MAX_FILESIZE            | `1G`
CORE_POST_MAX_SIZE                  | `1G`
TIMEZONE                            | `UTC`
OPCACHE_ENABLE                      | `1`
OPCACHE_ENABLE_CLI                  | `0`
OPCACHE_ENABLE_MEMORY_CONSUMPTION   | `128`
OPCACHE_INTERNED_STRINGS_BUFFER     | `8`
OPCACHE_MAX_ACCELERATED_FILES       | `20000`
OPCACHE_MAX_WESTED_PERCENTAGE       | `5`
OPCACHE_USE_CWD                     | `1`
OPCACHE_VALIDATE_TIMESTAMPS         | `1`
OPCACHE_REVALIDATE_FREQ             | `60`
OPCACHE_FILE_UPDATE_PROTECTION      | `2`
OPCACHE_REVALIDATE_PATH             | `0`
OPCACHE_SAVE_COMMENTS               | `1`
OPCACHE_LOAD_COMMENTS               | `1`
OPCACHE_FAST_SHUTDOWN               | `1`


## MariaDb environment variables (When used with [docker-compose file][docker-compose] )

Name                                | Default value                     | Info
------------------------------------|-----------------------------------|-------------------
MYSQL_ROOT_PASSWORD                 | [empty]                           | sets a root password
MYSQL_ALLOW_EMPTY_PASSWORD          | `false`                           | Enable empty password (true or false)
MYSQL_RANDOM_ROOT_PASSWORD          | `false`                           | Generate random root password (true or false)
MYSQL_DATABASE                      | [empty]                           | creates a database as provided by input
MYSQL_USER                          | [empty]                           | creates a user with owner permissions over said database
MYSQL_PASSWORD                      | [empty]                           | changes password of the provided user (not root)
MYSQL_DATA_DIR                      | `/var/lib/mysql/`                 | Change mysql default directory
MYSQL_STARTCMD                      | `/usr/bin/mysqld`                 | Default start command
MYSQL_STARTPARAMS                   | `--skip-host-cache --skip-name-resolve --debug-gdb` | Default start parameters
DEFAULT_CHARACTER_SET               | `utf8`
CHARACTER_SET_SERVER                | `utf8`
COLLATION_SERVER                    | `utf8_general_ci`
TIME_ZONE                           | `+00:00`
KEY_BUFFER_SIZE                     | `16M`
MAX_ALLOWED_PACKET                  | `1M`
TABLE_OPEN_CACHE                    | `64`
SORT_BUFFER_SIZE                    | `512K`
NET_BUFFER_SIZE                     | `8K`
READ_BUFFER_SIZE                    | `256K`
READ_RND_BUFFER_SIZE                | `512K`
MYISAM_SORT_BUFFER_SIZE             | `8M`
BIND_ADRESS                         | `0.0.0.0`
LOG_BIN                             | `mysql-bin`
BINLOG_FORMAT                       | `mixed`
SERVER_ID                           | `1`
INNODB_DATA_FILE_PATH               | `ibdata1:10M:autoextend`
INNODB_BUFFER_POOL_SIZE             | `16M`
INNODB_LOG_FILE_SIZE                | `5M`
INNODB_LOG_BUFFER_SIZE              | `8M`
INNODB_EMPTY_FREE_LIST_ALGORITHM    | `legacy`
INNODB_FLUSH_LOG_AT_TRX_COMMIT      | `1`
INNODB_LOCK_WAIT_TIMEOUT            | `50`
INNODB_USE_NATIVE_AIO               | `1`
INNODB_LARGE_PREFIX                 | `OFF`
INNODB_FILE_FORMAT                  | `Antelope`
INNODB_FILE_PER_TABLE               | `ON`
MAX_ALLOWED_PACKET                  | `16M`
KEY_BUFFER_SIZE                     | `20M`
SORT_BUFFER_SIZE                    | `20M`
READ_BUFFER                         | `2M`
WRITE_BUFFER                        | `2M`
RETENTION_DAYS                      | `14`

### Port
- **80** 
- **443**

### Volumes (When used with docker-compose file)
- **/nextcloud/data** : Nextcloud data.
- **/var/www** : Nextcloud files.

### Docker-compose
Take a look at the  [docker-compose file][docker-compose]  
You will have a good example on how to run nextcloud with MariaDb, Redis and caddy web server.


### Configure
In the admin panel, you should switch from `AJAX cron` to `cron` (system cron).

### Tip : how to use occ command
There is a script for that, so you shouldn't bother to log into the container, set the right permissions, and so on. Just use `docker exec -it nexcloud occ command`.


[alpine-php7]: https://hub.docker.com/r/craftdock/alpine-php7/
[docker-compose]: https://github.com/CraftDock/nextcloud-fpm/blob/master/.example/mariadb-redis-caddy/docker-compose.yml
