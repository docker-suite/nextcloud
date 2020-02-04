<?php
$CONFIG = array (
    'apps_paths' => array (
      // Read-only location for apps shipped with Nextcloud.
      0 => array (
        'path'      => getenv('NEXTCLOUD_WWW_DIR').'/apps',
        'url'       => '/apps',
        'writable'  => false,
      ),
      // Writable location for apps installed from AppStore.
      1 => array (
        'path'      => getenv('NEXTCLOUD_WWW_DIR').'/appstore',
        'url'       => '/appstore',
        'writable'  => true,
      ),
    ),
);
