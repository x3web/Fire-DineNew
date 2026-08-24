<?php
declare(strict_types=1);

namespace FireDine;

use RuntimeException;

final class MailService
{
    public function send(string $recipient, string $subject, string $html): array
    {
        if (!filter_var($recipient, FILTER_VALIDATE_EMAIL)) return ['sent'=>false,'error'=>'Invalid recipient address.'];
        $subject = trim(str_replace(["\r","\n"], '', $subject));
        $from = getenv('MAIL_FROM_ADDRESS') ?: 'info@fireanddine.co.za';
        $fromName = trim(str_replace(["\r","\n"], '', getenv('MAIL_FROM_NAME') ?: 'Fire & Dine'));
        if (!filter_var($from, FILTER_VALIDATE_EMAIL)) return ['sent'=>false,'error'=>'Invalid sender address.'];
        $transport = strtolower(getenv('MAIL_TRANSPORT') ?: 'smtp');
        try {
            if ($transport === 'log') { error_log('MAIL_LOG recipient='.$recipient.' subject='.$subject); return ['sent'=>true,'error'=>null]; }
            if ($transport === 'smtp') { $this->smtp($recipient,$subject,$html,$from,$fromName); return ['sent'=>true,'error'=>null]; }
            if ($transport !== 'mail') throw new RuntimeException('Unsupported mail transport.');
            $headers=['MIME-Version: 1.0','Content-Type: text/html; charset=UTF-8','From: '.$fromName.' <'.$from.'>','Reply-To: '.$from,'X-Mailer: FireDine'];
            if (!@mail($recipient,$subject,$html,implode("\r\n",$headers))) throw new RuntimeException('The configured mail transport rejected the message.');
            return ['sent'=>true,'error'=>null];
        } catch (\Throwable $e) { error_log('Mail delivery failed: '.$e->getMessage()); return ['sent'=>false,'error'=>'Mail delivery failed.']; }
    }

    private function smtp(string $recipient,string $subject,string $html,string $from,string $fromName): void
    {
        $host=trim((string)getenv('MAIL_HOST'));$port=(int)(getenv('MAIL_PORT')?:587);$encryption=strtolower(trim((string)(getenv('MAIL_ENCRYPTION')?:'tls')));$username=(string)getenv('MAIL_USERNAME');$password=(string)getenv('MAIL_PASSWORD');
        if($host===''||$port<1||$port>65535)throw new RuntimeException('SMTP host or port is not configured.');
        if($encryption==='none'&&(getenv('APP_ENV')?:'production')==='production')throw new RuntimeException('Unencrypted SMTP is disabled in production.');
        $target=($encryption==='ssl'?'ssl://':'tcp://').$host.':'.$port;$errno=0;$error='';$socket=@stream_socket_client($target,$errno,$error,15,STREAM_CLIENT_CONNECT);
        if(!is_resource($socket))throw new RuntimeException('SMTP connection failed.');stream_set_timeout($socket,15);
        try {
            $this->expect($socket,[220]);$this->command($socket,'EHLO '.$this->serverName(),[250]);
            if($encryption==='tls'){$this->command($socket,'STARTTLS',[220]);if(!stream_socket_enable_crypto($socket,true,STREAM_CRYPTO_METHOD_TLS_CLIENT))throw new RuntimeException('SMTP TLS negotiation failed.');$this->command($socket,'EHLO '.$this->serverName(),[250]);}
            if($username!==''||$password!==''){if($username===''||$password==='')throw new RuntimeException('SMTP credentials are incomplete.');$this->command($socket,'AUTH LOGIN',[334]);$this->command($socket,base64_encode($username),[334]);$this->command($socket,base64_encode($password),[235]);}
            $this->command($socket,'MAIL FROM:<'.$from.'>',[250]);$this->command($socket,'RCPT TO:<'.$recipient.'>',[250,251]);$this->command($socket,'DATA',[354]);
            $headers=['Date: '.date(DATE_RFC2822),'From: '.$this->encodeHeader($fromName).' <'.$from.'>','To: <'.$recipient.'>','Subject: '.$this->encodeHeader($subject),'Message-ID: <'.bin2hex(random_bytes(16)).'@'.$this->serverName().'>','MIME-Version: 1.0','Content-Type: text/html; charset=UTF-8','Content-Transfer-Encoding: 8bit'];
            $payload=implode("\n",$headers)."\n\n".preg_replace('/(?m)^\./','..',str_replace(["\r\n","\r"],"\n",$html));fwrite($socket,str_replace("\n","\r\n",$payload)."\r\n.\r\n");$this->expect($socket,[250]);$this->command($socket,'QUIT',[221]);
        } finally { fclose($socket); }
    }

    private function command($socket,string $command,array $codes): string{if(fwrite($socket,$command."\r\n")===false)throw new RuntimeException('SMTP write failed.');return$this->expect($socket,$codes);}
    private function expect($socket,array $codes): string{$response='';do{$line=fgets($socket,4096);if($line===false)throw new RuntimeException('SMTP connection closed unexpectedly.');$response.=$line;}while(isset($line[3])&&$line[3]==='-');$code=(int)substr($line,0,3);if(!in_array($code,$codes,true))throw new RuntimeException('SMTP server rejected the request with code '.$code.'.');return$response;}
    private function encodeHeader(string $value): string{return'=?UTF-8?B?'.base64_encode($value).'?=';}
    private function serverName(): string{$host=parse_url((string)(getenv('APP_URL')?:'https://localhost'),PHP_URL_HOST);return preg_match('/^[a-z0-9.-]+$/i',(string)$host)?(string)$host:'localhost';}
}
