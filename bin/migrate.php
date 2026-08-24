<?php
declare(strict_types=1);

if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
$root=dirname(__DIR__);
$environmentFile=(string)(getenv('FIRE_DINE_ENV_FILE')?:$root.'/.env');
if(!is_file($environmentFile)){fwrite(STDERR,"Environment file not found: $environmentFile\n");exit(1);}
foreach(file($environmentFile,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)?:[] as $line){if(str_starts_with(ltrim($line),'#')||!str_contains($line,'='))continue;[$key,$value]=array_map('trim',explode('=',$line,2));if(getenv($key)===false)putenv($key.'='.trim($value,"\"'"));}
$binary=null;foreach(['mariadb','mysql'] as $candidate){$path=trim((string)shell_exec('command -v '.escapeshellarg($candidate).' 2>/dev/null'));if($path!==''){$binary=$path;break;}}
if(!$binary){fwrite(STDERR,"MariaDB client not found. Install the MariaDB 10.11 client and retry.\n");exit(1);}
$host=getenv('DB_HOST')?:'127.0.0.1';$port=getenv('DB_PORT')?:'3306';$name=getenv('DB_DATABASE')?:'fireanddine';$user=getenv('DB_USERNAME')?:'fireanddine';$password=getenv('DB_PASSWORD')?:'';
try{$pdo=new PDO("mysql:host=$host;port=$port;dbname=$name;charset=utf8mb4",$user,$password,[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC]);}catch(Throwable $e){fwrite(STDERR,"Database connection failed.\n");exit(1);}
$pdo->exec("CREATE TABLE IF NOT EXISTS schema_migrations (migration varchar(255) NOT NULL,checksum char(64) NOT NULL,applied_at timestamp NOT NULL DEFAULT current_timestamp(),PRIMARY KEY(migration)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
$lock=$pdo->query("SELECT GET_LOCK('fire_dine_schema_migrations',30)")->fetchColumn();if((int)$lock!==1){fwrite(STDERR,"Could not acquire the migration lock. Another deployment may be running.\n");exit(1);}
try{
    $files=glob($root.'/database/migrations/*.sql')?:[];sort($files,SORT_STRING);$lookup=$pdo->prepare("SELECT checksum FROM schema_migrations WHERE migration=?");$record=$pdo->prepare("INSERT INTO schema_migrations(migration,checksum) VALUES(?,?)");
    foreach($files as $file){$migration=basename($file);$checksum=hash_file('sha256',$file);$lookup->execute([$migration]);$applied=$lookup->fetchColumn();if($applied!==false){if(!hash_equals((string)$applied,$checksum))throw new RuntimeException("Checksum mismatch for already-applied migration: $migration");fwrite(STDOUT,"Skipping $migration (already applied).\n");continue;}
        fwrite(STDOUT,"Applying $migration…\n");$command=[$binary,'--host='.$host,'--port='.$port,'--user='.$user,'--default-character-set=utf8mb4','--binary-mode=1','--show-warnings',$name];$environment=$_ENV;$environment['MYSQL_PWD']=$password;$process=proc_open($command,[0=>['file',$file,'r'],1=>STDOUT,2=>STDERR],$pipes,$root,$environment);if(!is_resource($process)||proc_close($process)!==0)throw new RuntimeException("Migration failed: $migration");$record->execute([$migration,$checksum]);
    }
    fwrite(STDOUT,"All pending migrations applied successfully.\n");
}catch(Throwable $e){fwrite(STDERR,$e->getMessage()."\n");$pdo->query("SELECT RELEASE_LOCK('fire_dine_schema_migrations')");exit(1);}
$pdo->query("SELECT RELEASE_LOCK('fire_dine_schema_migrations')");
