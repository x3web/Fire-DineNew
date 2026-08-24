<?php
declare(strict_types=1);

return [
    'environment'=>getenv('APP_ENV')?:'production',
    'debug'=>filter_var(getenv('APP_DEBUG')?:'false',FILTER_VALIDATE_BOOL),
    'url'=>rtrim(getenv('APP_URL')?:'https://www.fireanddine.co.za','/'),
    'session_secure'=>filter_var(getenv('SESSION_SECURE')?:'true',FILTER_VALIDATE_BOOL),
    'session_lifetime'=>(int)(getenv('SESSION_LIFETIME')?:7200),
];
