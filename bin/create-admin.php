<?php
declare(strict_types=1);

if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
$root=dirname(__DIR__);require $root.'/vendor/autoload.php';
$configuredEnvironment=trim((string)(getenv('FIRE_DINE_ENV_FILE')?:''));
$environmentFile=$configuredEnvironment!==''?(str_starts_with($configuredEnvironment,'/')?$configuredEnvironment:$root.'/'.ltrim($configuredEnvironment,'/')):$root.'/.env';
if(!is_file($environmentFile)){fwrite(STDERR,"Environment file not found: {$environmentFile}\n");exit(1);}
foreach(file($environmentFile,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)?:[] as $line){if(str_starts_with(ltrim($line),'#')||!str_contains($line,'='))continue;[$key,$value]=array_map('trim',explode('=',$line,2));if(getenv($key)===false)putenv($key.'='.trim($value,"\"'"));}
$email=strtolower(trim((string)($argv[1]??'')));$first=trim((string)($argv[2]??'Admin'));$last=trim((string)($argv[3]??'User'));
if(!filter_var($email,FILTER_VALIDATE_EMAIL)){fwrite(STDERR,"Usage: php bin/create-admin.php email@example.com FirstName LastName\nPassword is read from standard input.\n");exit(1);}

function readAdminPassword(): string
{
    $sttyState=null;
    $isTty=function_exists('stream_isatty')&&stream_isatty(STDIN);
    if($isTty&&is_callable('shell_exec')){
        $state=@shell_exec('stty -g 2>/dev/null');
        if(is_string($state)&&trim($state)!==''){$sttyState=trim($state);@shell_exec('stty -echo 2>/dev/null');}
    }
    try{
        fwrite(STDOUT,'Enter a password of at least 12 characters: ');
        $line=fgets(STDIN);
        if($line===false)throw new RuntimeException('No password was provided on standard input.');
        return rtrim($line,"\r\n");
    }finally{
        if($sttyState!==null&&is_callable('shell_exec'))@shell_exec('stty '.escapeshellarg($sttyState).' 2>/dev/null');
        fwrite(STDOUT,PHP_EOL);
    }
}

try{$password=readAdminPassword();}catch(Throwable $e){fwrite(STDERR,$e->getMessage()."\n");exit(1);}
if(strlen($password)<12){fwrite(STDERR,"Password must be at least 12 characters.\n");exit(1);}
$algorithm=defined('PASSWORD_ARGON2ID')?PASSWORD_ARGON2ID:PASSWORD_DEFAULT;$hash=password_hash($password,$algorithm);if($hash===false){fwrite(STDERR,"Password hashing failed.\n");exit(1);}
$db=\FireDine\Database::connect();$stmt=$db->prepare("INSERT INTO users(first_name,last_name,email,password_hash,role,status,must_change_password,session_version,password_changed_at) VALUES(?,?,?,?,'super_admin','active',0,1,NOW()) ON DUPLICATE KEY UPDATE first_name=VALUES(first_name),last_name=VALUES(last_name),password_hash=VALUES(password_hash),role='super_admin',status='active',password_changed_at=NOW(),session_version=session_version+1");$stmt->execute([$first,$last,$email,$hash]);fwrite(STDOUT,"Administrator created or updated.\n");
