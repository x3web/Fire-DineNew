<?php
declare(strict_types=1);

use FireDine\Application;
use FireDine\CaptchaService;
use FireDine\Database;
use FireDine\EnquiryService;
use FireDine\MailService;
use FireDine\PricingService;
use FireDine\ProductRepository;
use FireDine\QuoteService;

$root = dirname(__DIR__);
$configuredEnvironment=(string)(getenv('FIRE_DINE_ENV_FILE')?:'');
$envFile=$configuredEnvironment!==''?(str_starts_with($configuredEnvironment,'/')?$configuredEnvironment:$root.'/'.ltrim($configuredEnvironment,'/')):$root.'/.env';
if (is_file($envFile)) {
    foreach (file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) ?: [] as $line) {
        if (str_starts_with(ltrim($line), '#') || !str_contains($line, '=')) continue;
        [$key, $value] = array_map('trim', explode('=', $line, 2));
        if (getenv($key) === false) putenv($key . '=' . trim($value, "\"'"));
    }
}

$production=(getenv('APP_ENV')?:'production')==='production';
if($production&&(strlen((string)(getenv('APP_KEY')?:''))<32||str_contains((string)getenv('APP_KEY'),'replace-')))throw new RuntimeException('APP_KEY must be set to a unique random value of at least 32 characters.');
ini_set('display_errors',$production?'0':(filter_var(getenv('APP_DEBUG')?:'false',FILTER_VALIDATE_BOOL)?'1':'0'));
ini_set('log_errors','1');
ini_set('error_log',$root.'/storage/logs/application.log');
ini_set('session.use_strict_mode','1');
ini_set('session.use_only_cookies','1');
ini_set('session.gc_maxlifetime',(string)(int)(getenv('SESSION_LIFETIME')?:7200));

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_name('fire_dine_session');
    session_set_cookie_params([
        'httponly' => true,
        'secure' => filter_var(getenv('SESSION_SECURE') ?: 'true', FILTER_VALIDATE_BOOL),
        'samesite' => 'Lax',
        'path' => '/',
    ]);
    session_start();
}

$now=time();
$idleLimit=max(300,(int)(getenv('SESSION_IDLE_LIFETIME')?:1800));
$absoluteLimit=max($idleLimit,(int)(getenv('SESSION_ABSOLUTE_LIFETIME')?:28800));
if((isset($_SESSION['last_activity'])&&$now-(int)$_SESSION['last_activity']>$idleLimit)||(isset($_SESSION['session_started'])&&$now-(int)$_SESSION['session_started']>$absoluteLimit)){
    $_SESSION=[];session_regenerate_id(true);
}
$_SESSION['session_started']??=$now;
$_SESSION['last_activity']=$now;

$db = Database::connect();

// Apply the requested deployment administrator once. The marker prevents the
// account password or active sessions being reset on later requests.
$adminSeedMarker='fire_dine_deployment_admin_seed_20260824';
$adminSeed=$db->prepare("SELECT meta_value FROM app_meta WHERE meta_key=? LIMIT 1");
$adminSeed->execute([$adminSeedMarker]);
if($adminSeed->fetchColumn()===false){
    $db->beginTransaction();
    try{
        $db->prepare("INSERT INTO users(first_name,last_name,email,password_hash,role,status,must_change_password,session_version,password_changed_at) VALUES(?,?,?,?, 'super_admin','active',0,1,NOW()) ON DUPLICATE KEY UPDATE first_name=VALUES(first_name),last_name=VALUES(last_name),password_hash=VALUES(password_hash),role='super_admin',status='active',must_change_password=0,failed_login_attempts=0,locked_until=NULL,password_changed_at=NOW(),session_version=session_version+1")
            ->execute(['Fire & Dine','Administrator','info@fireanddine.co.za','$2y$12$XI6zEi7itoMi24oLMmce0O3AsXrsDkYWYxskfRWEvyf3HXV04I/AK']);
        $db->prepare("INSERT INTO app_meta(meta_key,meta_value,updated_at) VALUES(?,'applied',NOW()) ON DUPLICATE KEY UPDATE meta_value='applied',updated_at=NOW()")
            ->execute([$adminSeedMarker]);
        $db->commit();
    }catch(Throwable $e){if($db->inTransaction())$db->rollBack();throw $e;}
}
$products = new ProductRepository($db);
$pricing = new PricingService($db, $products);
$mail = new MailService();
$enquiries = new EnquiryService($db, $mail);
$captcha = new CaptchaService();
$quotes = new QuoteService($db, $pricing, $mail);
return new Application($db, $products, $pricing, $quotes, $enquiries, $captcha, $root);
