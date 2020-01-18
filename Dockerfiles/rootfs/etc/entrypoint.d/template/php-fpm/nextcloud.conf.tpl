
; Start a new pool named 'nextcloud'.
[nextcloud]

; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
user = nextcloud
group = www-data

; The address on which to accept FastCGI requests.
; Valid syntaxes are:
;   'ip.add.re.ss:port'    - to listen on a TCP socket to a specific IPv4 address on
;                            a specific port;
;   '[ip:6:addr:ess]:port' - to listen on a TCP socket to a specific IPv6 address on
;                            a specific port;
;   'port'                 - to listen on a TCP socket to all addresses
;                            (IPv6 and IPv4-mapped) on a specific port;
;   '/path/to/unix/socket' - to listen on a unix socket.
; Note: This value is mandatory.
listen = 9000

; Set permissions for unix socket, if one is used. In Linux, read/write
; permissions must be set in order to allow connections from a web server. Many
; BSD-derived systems allow connections regardless of permissions.
; Default Values: user and group are set as the running user
;                 mode is set to 0666
listen.owner = nextcloud
listen.group = www-data
;listen.mode = 0660

; Choose how the process manager will control the number of child processes.
; Possible Values:
;   static  - a fixed number (pm.max_children) of child processes;
;   dynamic - the number of child processes are set dynamically based on the
;             following directives. With this process management, there will be
;             always at least 1 children.
;             pm.max_children      - the maximum number of children that can
;                                    be alive at the same time.
;             pm.start_servers     - the number of children created on startup.
;             pm.min_spare_servers - the minimum number of children in 'idle'
;                                    state (waiting to process). If the number
;                                    of 'idle' processes is less than this
;                                    number then some children will be created.
;             pm.max_spare_servers - the maximum number of children in 'idle'
;                                    state (waiting to process). If the number
;                                    of 'idle' processes is greater than this
;                                    number then some children will be killed.
;  ondemand - no children are created at startup. Children will be forked when
;             new requests will connect. The following parameter are used:
;             pm.max_children           - the maximum number of children that
;                                         can be alive at the same time.
;             pm.process_idle_timeout   - The number of seconds after which
;                                         an idle process will be killed.
; Note: This value is mandatory.
pm = {{PHP_FPM_PM}}

; The number of child processes to be created when pm is set to 'static' and the
; maximum number of child processes when pm is set to 'dynamic' or 'ondemand'.
; This value sets the limit on the number of simultaneous requests that will be
; served. Equivalent to the ApacheMaxClients directive with mpm_prefork.
; Equivalent to the PHP_FCGI_CHILDREN environment variable in the original PHP
; CGI. The below defaults are based on a server without much resources. Don't
; forget to tweak pm.* to fit your needs.
; Note: Used when pm is set to 'static', 'dynamic' or 'ondemand'
; Note: This value is mandatory.
pm.max_children = {{PHP_FPM_PM_MAX_CHILDREN}}

; The number of child processes created on startup.
; Note: Used only when pm is set to 'dynamic'
; Default Value: min_spare_servers + (max_spare_servers - min_spare_servers) / 2
pm.start_servers = {{PHP_FPM_PM_START_SERVER}}

; The desired minimum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.min_spare_servers = {{PHP_FPM_PM_MIN_SPARE_SERVERS}}

; The desired maximum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.max_spare_servers = {{PHP_FPM_PM_MAX_SPARE_SERVERS}}

; The number of seconds after which an idle process will be killed.
; Note: Used only when pm is set to 'ondemand'
; Default Value: 10s
pm.process_idle_timeout = {{PHP_FPM_PM_PROCESS_IDLE_TIMEOUT}}

; The number of requests each child process should execute before respawning.
; This can be useful to work around memory leaks in 3rd party libraries. For
; endless request processing specify '0'. Equivalent to PHP_FCGI_MAX_REQUESTS.
; Default Value: 0
pm.max_requests = {{PHP_FPM_PM_MAX_REQUEST}}

; The access log file
; Default: not set
access.log = /var/log/nextcloud/access.log

; Redirect worker stdout and stderr into main error log. If not set, stdout and
; stderr will be redirected to /dev/null according to FastCGI specs.
; Note: on highloaded environement, this can cause some delay in the page
; process time (several ms).
; Default Value: no
catch_workers_output = {{PHP_FPM_PM_CATCH_WORKERS_OUTPUT}}

; Clear environment in FPM workers
; Prevents arbitrary environment variables from reaching FPM worker processes
; by clearing the environment in workers before env vars specified in this
; pool configuration are added.
; Setting to "no" will make all environment variables available to PHP code
; via getenv(), $_ENV and $_SERVER.
; Default Value: yes
clear_env = {{PHP_FPM_PM_CLEAR_ENV}}

; Pass environment variables like LD_LIBRARY_PATH. All $VARIABLEs are taken from
; the current environment.
; Default Value: clean env
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp

; Additional php.ini defines, specific to this pool of workers. These settings
; overwrite the values previously defined in the php.ini. The directives are the
; same as the PHP SAPI:
;   php_value/php_flag             - you can set classic ini defines which can
;                                    be overwritten from PHP call 'ini_set'.
;   php_admin_value/php_admin_flag - these directives won't be overwritten by
;                                     PHP call 'ini_set'
; For php_*flag, valid values are on, off, 1, 0, true, false, yes or no.
;
; Defining 'extension' will load the corresponding shared extension from
; extension_dir. Defining 'disable_functions' or 'disable_classes' will not
; overwrite previously defined php.ini values, but will append the new value
; instead.
;
; Note: path INI options can be relative and will be expanded with the prefix
; (pool, global or /usr/lib/php7.x)

; Allow HTTP file uploads.
php_admin_flag[file_uploads] = true

; Maximal size of a file that can be uploaded via web interface.
;php_admin_value[memory_limit] = 512M
;php_admin_value[post_max_size] = 1G
;php_admin_value[upload_max_filesize] = 1G

; Where to store temporary files.
php_admin_value[session.save_path] = /tmp/nextcloud
php_admin_value[sys_temp_dir] = /tmp/nextcloud
php_admin_value[upload_tmp_dir] = /tmp/nextcloud

; Log errors to specified file.
php_admin_flag[log_errors] = on
php_admin_value[error_log] = /var/log/nextcloud/error.log

; OPcache error_log file name. Empty string assumes "stderr"
php_admin_value[opcache.error_log] = /var/log/nextcloud/error.log

; Output buffering is a mechanism for controlling how much output data
; (excluding headers and cookies) PHP should keep internally before pushing that
; data to the client. If your application's output exceeds this setting, PHP
; will send that data in chunks of roughly the size you specify.
; This must be disabled for ownCloud.
php_admin_flag[output_buffering] = false

; Overload(replace) single byte functions by mbstring functions.
; This must be disabled for nextcloud.
php_admin_flag[mbstring.func_overload] = false

; Disable certain functions for security reasons.
; http://php.net/disable-functions
php_admin_value[disable_functions] = exec,passthru,shell_exec,system,proc_open,curl_multi_exec,show_source

; Set recommended settings for OpCache.
; https://docs.nextcloud.com/server/13/admin_manual/configuration_server/server_tuning.html#enable-php-opcache
php_admin_flag[opcache.enable] = true
php_admin_flag[opcache.enable_cli] = true
php_admin_flag[opcache.save_comments] = true
php_admin_value[opcache.interned_strings_buffer] = 8
php_admin_value[opcache.max_accelerated_files] = 10000
php_admin_value[opcache.memory_consumption] = 128
php_admin_value[opcache.revalidate_freq] = 1
