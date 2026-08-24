<?php
declare(strict_types=1);

$root=dirname(__DIR__,2);
require $root.'/vendor/autoload.php';
$testEnvironment=$root.'/.env.test';
if(!is_file($testEnvironment))throw new RuntimeException('Missing .env.test. Copy .env.test.example to .env.test and provide dedicated test credentials. The normal .env is never loaded by automated tests.');
foreach(file($testEnvironment,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)?:[] as $line){if(str_starts_with(ltrim($line),'#')||!str_contains($line,'='))continue;[$key,$value]=array_map('trim',explode('=',$line,2));putenv($key.'='.trim($value,"\"'"));}
