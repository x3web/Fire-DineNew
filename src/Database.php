<?php
declare(strict_types=1);

namespace FireDine;

use PDO;
use RuntimeException;

final class Database
{
    public static function connect(): PDO
    {
        $host = getenv('DB_HOST') ?: '127.0.0.1';
        $port = getenv('DB_PORT') ?: '3306';
        $name = getenv('DB_DATABASE') ?: 'fireanddine';
        $user = getenv('DB_USERNAME') ?: 'fireanddine';
        $pass = getenv('DB_PASSWORD') ?: '';
        try {
            return new PDO(
                "mysql:host={$host};port={$port};dbname={$name};charset=utf8mb4",
                $user,
                $pass,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ]
            );
        } catch (\Throwable $e) {
            throw new RuntimeException('Database connection failed. Check the configured MariaDB service and .env values.', 0, $e);
        }
    }
}
