<?php
declare(strict_types=1);

if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
$root=dirname(__DIR__,2);
require $root.'/vendor/autoload.php';
$configured=trim((string)(getenv('FIRE_DINE_ENV_FILE')?:''));
$environmentFile=$configured!==''?(str_starts_with($configured,'/')?$configured:$root.'/'.ltrim($configured,'/')):$root.'/.env.test';
if(!is_file($environmentFile)){fwrite(STDERR,"Test environment file not found: {$environmentFile}\n");exit(1);}
foreach(file($environmentFile,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)?:[] as $line){if(str_starts_with(ltrim($line),'#')||!str_contains($line,'='))continue;[$key,$value]=array_map('trim',explode('=',$line,2));if(getenv($key)===false)putenv($key.'='.trim($value,"\"'"));}
$database=(string)getenv('DB_DATABASE');
if(!preg_match('/^[A-Za-z0-9_]+_test$/',$database)){fwrite(STDERR,"Unsafe DB_DATABASE for browser cleanup. The name must match ^[A-Za-z0-9_]+_test$.\n");exit(1);}
$email=strtolower(trim((string)($argv[1]??'')));
if(!filter_var($email,FILTER_VALIDATE_EMAIL)){fwrite(STDERR,"A valid TEST_ADMIN_EMAIL is required for browser cleanup.\n");exit(1);}
$db=\FireDine\Database::connect();
$stmt=$db->prepare('SELECT id,updated_at FROM users WHERE email=? LIMIT 1');$stmt->execute([$email]);$admin=$stmt->fetch();
if(!$admin){fwrite(STDOUT,"No browser-test administrator remained to clean.\n");exit(0);}
$startedAt=(string)$admin['updated_at'];
$db->beginTransaction();
try{
    $downloads=$db->prepare('SELECT brochure_id,COUNT(*) downloads FROM brochure_downloads WHERE downloaded_at>=? GROUP BY brochure_id');$downloads->execute([$startedAt]);$restore=$db->prepare('UPDATE brochures SET download_count=GREATEST(0,download_count-?) WHERE id=?');foreach($downloads->fetchAll() as $row)$restore->execute([(int)$row['downloads'],(int)$row['brochure_id']]);
    foreach(['brochure_downloads'=>'downloaded_at','auth_attempts'=>'attempted_at','tracking_events'=>'occurred_at'] as $table=>$column){$delete=$db->prepare("DELETE FROM `$table` WHERE `$column`>=?");$delete->execute([$startedAt]);}
    $db->prepare('DELETE FROM auth_rate_limits WHERE updated_at>=?')->execute([$startedAt]);
    $db->prepare('DELETE FROM users WHERE id=?')->execute([(int)$admin['id']]);
    $db->commit();
}catch(Throwable $e){if($db->inTransaction())$db->rollBack();fwrite(STDERR,"Browser-test cleanup failed: {$e->getMessage()}\n");exit(1);}
fwrite(STDOUT,"Browser-test records cleaned.\n");
