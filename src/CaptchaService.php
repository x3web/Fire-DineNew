<?php
declare(strict_types=1);

namespace FireDine;

use DomainException;

final class CaptchaService
{
    public function siteKey(): ?string
    {
        $value = trim((string)(getenv('CAPTCHA_SITE_KEY') ?: ''));
        return $value === '' ? null : $value;
    }

    public function verify(?string $token, string $remoteAddress): void
    {
        $siteKey = $this->siteKey();
        $secret = trim((string)(getenv('CAPTCHA_SECRET_KEY') ?: ''));
        if (($siteKey === null) !== ($secret === '')) throw new DomainException('CAPTCHA is not configured correctly. Please contact Fire & Dine.');
        if ($siteKey === null) return;
        if (!$token) throw new DomainException('Complete the CAPTCHA check.');
        $payload = http_build_query(['secret'=>$secret,'response'=>$token,'remoteip'=>$remoteAddress]);
        $context = stream_context_create(['http'=>[
            'method'=>'POST','timeout'=>8,'ignore_errors'=>true,
            'header'=>"Content-Type: application/x-www-form-urlencoded\r\nContent-Length: ".strlen($payload)."\r\n",
            'content'=>$payload,
        ]]);
        $raw = @file_get_contents('https://www.google.com/recaptcha/api/siteverify', false, $context);
        $result = is_string($raw) ? json_decode($raw, true) : null;
        if (!is_array($result) || empty($result['success'])) throw new DomainException('CAPTCHA verification failed. Please try again.');
    }
}
