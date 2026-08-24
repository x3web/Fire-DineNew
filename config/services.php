<?php
declare(strict_types=1);

return [
    'mail'=>['host'=>getenv('MAIL_HOST')?:null,'port'=>(int)(getenv('MAIL_PORT')?:587),'encryption'=>getenv('MAIL_ENCRYPTION')?:'tls','from'=>getenv('MAIL_FROM_ADDRESS')?:'info@fireanddine.co.za'],
    'captcha'=>['site_key'=>getenv('CAPTCHA_SITE_KEY')?:null],
    'analytics'=>['ga4'=>getenv('GA4_MEASUREMENT_ID')?:null,'meta_pixel'=>getenv('META_PIXEL_ID')?:null],
];
