{{CADDY_DOMAIN}} {

	root   /var/www

	#log /var/log/nextcloud_access.log {                          # Change path syntax for your OS or your preferred location!
	#	rotate_size 1          # Rotate after 1 MB
	#	rotate_age  7          # Keep log files for 7 days
	#	rotate_keep 2          # Keep at most 2 log files
	#}

	#errors /var/log/nextcloud_errors.log {                        # Change path syntax for your OS or your preferred location!
	#	rotate_size 1          # Set max size 1 MB
	#	rotate_age  7          # Keep log files for 7 days
	#	rotate_keep 2          # Keep at most 2 log files
	#}

	#log    /var/log/nextcloud_access.log
	#errors /var/log/nextcloud_errors.log

    log     stdout
    errors  stdout

	gzip

	fastcgi / {{PHP_FPM_HOST}}:{{PHP_FPM_PORT}} php {
		env PATH /bin
	}

	# checks for images
	rewrite {
		ext .svg .gif .png .html .ttf .woff .ico .jpg .jpeg
		r ^/index.php/(.+)$
		to /{1} /index.php?{1}
	}

	rewrite {
		r ^/index.php/.*$
		to /index.php?{query}
	}

	# client support (e.g. os x calendar / contacts)
	redir /.well-known/carddav /remote.php/carddav 301
	redir /.well-known/caldav /remote.php/caldav 301

	# remove trailing / as it causes errors with php-fpm
	rewrite {
		r ^/remote.php/(webdav|caldav|carddav|dav)(\/?)$
		to /remote.php/{1}
	}

	rewrite {
		r ^/remote.php/(webdav|caldav|carddav|dav)/(.+?)(\/?)$
		to /remote.php/{1}/{2}
	}

	rewrite {
		r ^/public.php/(.+?)(\/?)$
		to /public.php/(.+?)(\/?)$
	}

	# .htaccess / data / config / ... shouldn't be accessible from outside
	status 403 {
		/.htacces
		/data
		/config
		/db_structure
		/.xml
		/README
	}

	header / Strict-Transport-Security "max-age=31536000;"
}
