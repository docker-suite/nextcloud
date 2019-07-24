<?php
$CONFIG = array (
  'filelocking.enabled' => 'true',
  'memcache.local' => '\\OC\\Memcache\\Redis',
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => array(
    'host' => 'redis',
    'port' => 6379,
    'timeout' => 0,
    'dbindex' => 0,
  ),
);
