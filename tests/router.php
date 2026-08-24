<?php
declare(strict_types=1);

$path=parse_url($_SERVER['REQUEST_URI']??'/',PHP_URL_PATH)?:'/';
$public=dirname(__DIR__).'/public';
if($path!=='/'&&is_file($public.$path))return false;
require $public.'/index.php';
