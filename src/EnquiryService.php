<?php
declare(strict_types=1);

namespace FireDine;

use DomainException;
use PDO;

final class EnquiryService
{
    public function __construct(private PDO $db,private MailService $mail) {}

    public function submit(array $input): array
    {
        if(trim((string)($input['website']??''))!=='')throw new DomainException('The request could not be accepted.');
        foreach(['first_name','last_name','email','phone','message'] as $field)if(trim((string)($input[$field]??''))==='')throw new DomainException('Please complete all required contact fields.');
        if(!filter_var($input['email'],FILTER_VALIDATE_EMAIL))throw new DomainException('Enter a valid email address.');
        $limits=['first_name'=>100,'last_name'=>100,'email'=>190,'phone'=>50,'application'=>50,'product'=>190,'location'=>255,'measurements'=>500,'message'=>5000,'preferred_contact'=>30];
        foreach($limits as $field=>$limit)if(strlen((string)($input[$field]??''))>$limit)throw new DomainException('One or more enquiry fields are too long.');
        $values=['first_name'=>trim((string)$input['first_name']),'last_name'=>trim((string)$input['last_name']),'email'=>strtolower(trim((string)$input['email'])),'phone'=>trim((string)$input['phone']),'application'=>trim((string)($input['application']??'General enquiry'))?:'General enquiry','product'=>trim((string)($input['product']??'Not specified'))?:'Not specified','location'=>trim((string)($input['location']??'Not specified'))?:'Not specified','measurements'=>trim((string)($input['measurements']??'')),'message'=>trim((string)$input['message']),'preferred_contact'=>trim((string)($input['preferred_contact']??'Email'))?:'Email','ip_hash'=>hash('sha256',($_SERVER['REMOTE_ADDR']??'').'|'.(getenv('APP_KEY')?:'local'))];
        $this->db->beginTransaction();
        try{
            $stmt=$this->db->prepare("INSERT INTO enquiries(first_name,last_name,email,phone,application,product,location,measurements,message,preferred_contact,status,ip_hash) VALUES(:first_name,:last_name,:email,:phone,:application,:product,:location,NULLIF(:measurements,''),:message,:preferred_contact,'new',:ip_hash)");
            $stmt->execute($values);$enquiryId=(int)$this->db->lastInsertId();
            $this->db->prepare("INSERT INTO enquiry_status_history(enquiry_id,old_status,new_status,summary,admin_id) VALUES(?,NULL,'new','Customer submitted enquiry',NULL)")->execute([$enquiryId]);
            $this->db->commit();
        }catch(\Throwable $e){if($this->db->inTransaction())$this->db->rollBack();throw$e;}
        $body='<h2>Fire &amp; Dine enquiry #'.$enquiryId.'</h2><p><strong>Date:</strong> '.$this->escape(date('Y-m-d H:i:s')).'<br><strong>Status:</strong> New</p><p><strong>Name:</strong> '.$this->escape($values['first_name'].' '.$values['last_name']).'<br><strong>Email:</strong> '.$this->escape($values['email']).'<br><strong>Phone:</strong> '.$this->escape($values['phone']).'<br><strong>Location:</strong> '.$this->escape($values['location']).'<br><strong>Application:</strong> '.$this->escape($values['application']).'<br><strong>Selected product:</strong> '.$this->escape($values['product']).'<br><strong>Measurements:</strong> '.$this->escape($values['measurements']?:'Not supplied').'<br><strong>Preferred contact:</strong> '.$this->escape($values['preferred_contact']).'</p><p><strong>Message:</strong><br>'.nl2br($this->escape($values['message'])).'</p>';
        $recipient=getenv('QUOTE_NOTIFICATION_EMAIL')?:'info@fireanddine.co.za';
        try{$result=$this->mail->send($recipient,'New Fire & Dine enquiry #'.$enquiryId,$body);}catch(\Throwable $e){$result=['sent'=>false,'error'=>'Mail transport exception.'];error_log($e->__toString());}
        try{$this->db->prepare("INSERT INTO enquiry_email_log(enquiry_id,recipient,status,error_message) VALUES(?,?,?,?)")->execute([$enquiryId,$recipient,$result['sent']?'sent':'failed',$result['error']??null]);}catch(\Throwable $e){error_log('Enquiry #'.$enquiryId.' email result could not be logged: '.$e->getMessage());}
        if(!$result['sent'])error_log('Enquiry #'.$enquiryId.' email failed after the enquiry was saved.');
        return['message'=>'Thank you. Your enquiry has been received.','enquiry_id'=>$enquiryId,'email_sent'=>(bool)$result['sent']];
    }

    private function escape(string $value): string{return htmlspecialchars($value,ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');}
}
