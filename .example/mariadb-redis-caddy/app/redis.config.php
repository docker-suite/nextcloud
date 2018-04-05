<?php
$CONFIG = array (
  'memcache.local' => '\\OC\\Memcache\\Redis',
  'filelocking.enabled' => 'true',
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => array(
    'host' => 'redis',
    'port' => 6379,
    'timeout' => 0,
    'dbindex' => 0,
  ),
);
