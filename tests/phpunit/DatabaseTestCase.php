<?php
declare(strict_types=1);

namespace FireDineTests;

use PDO;
use PHPUnit\Framework\TestCase;

abstract class DatabaseTestCase extends TestCase
{
    protected PDO $db;

    protected function setUp(): void
    {
        foreach(['TEST_DB_HOST','TEST_DB_PORT','TEST_DB_DATABASE','TEST_DB_USERNAME','TEST_DB_PASSWORD'] as $key)if(getenv($key)===false)throw new \RuntimeException('Missing required test credential: '.$key.'. Configure it explicitly in .env.test.');
        $name=(string)getenv('TEST_DB_DATABASE');
        if(!preg_match('/^[A-Za-z0-9_]+_test$/',$name))throw new \RuntimeException('Unsafe TEST_DB_DATABASE. The name must match ^[A-Za-z0-9_]+_test$.');
        $host=(string)getenv('TEST_DB_HOST');$port=(string)getenv('TEST_DB_PORT');$user=(string)getenv('TEST_DB_USERNAME');$password=(string)getenv('TEST_DB_PASSWORD');
        $this->db=new PDO("mysql:host=$host;port=$port;dbname=$name;charset=utf8mb4",$user,$password,[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false]);
    }
}
