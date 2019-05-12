<?php
$CONFIG = array (
    'apps_paths' => array (
      // Read-only location for apps shipped with Nextcloud and installed by apk.
      0 => array (
        'path'      => OC::$SERVERROOT.'/apps',
        'url'       => '/apps',
        'writable'  => false,
      ),
      // Writable location for apps installed from AppStore.
      1 => array (
        'path'      => OC::$SERVERROOT.'/custom_apps',
        'url'       => '/custom_apps',
        'writable'  => true,
      ),
    ),
);
