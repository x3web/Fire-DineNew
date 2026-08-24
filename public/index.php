<?php
declare(strict_types=1);

$root = dirname(__DIR__);
$requested = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
$static = realpath(__DIR__ . $requested);
if (PHP_SAPI === 'cli-server' && $static !== false && str_starts_with($static, __DIR__ . DIRECTORY_SEPARATOR) && is_file($static)) return false;
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('Expires: 0');
$autoload = $root . '/vendor/autoload.php';
if (!is_file($autoload)) {
    http_response_code(503);
    header('Content-Type: text/plain; charset=utf-8');
    exit('Application dependencies are not installed. Run composer install.');
}
require $autoload;
try {
    $app = require $root . '/bootstrap/app.php';
    $app->run();
} catch (Throwable $e) {
    error_log($e->__toString());
    http_response_code(503);
    header('Content-Type: text/plain; charset=utf-8');
    exit('Service temporarily unavailable.');
}
