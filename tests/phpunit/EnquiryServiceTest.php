<?php
declare(strict_types=1);

namespace FireDineTests;

use FireDine\Application;
use FireDine\CaptchaService;
use FireDine\EnquiryService;
use FireDine\MailService;
use FireDine\PricingService;
use FireDine\ProductRepository;
use FireDine\QuoteService;
use PHPUnit\Framework\Attributes\PreserveGlobalState;
use PHPUnit\Framework\Attributes\RunInSeparateProcess;

final class EnquiryServiceTest extends DatabaseTestCase
{
    private ?int $enquiryId=null;
    private ?int $adminId=null;
    private string|false $mailTransportBefore=false;

    protected function setUp(): void
    {
        parent::setUp();$this->mailTransportBefore=getenv('MAIL_TRANSPORT');$email='enquiry-admin-'.bin2hex(random_bytes(8)).'@example.invalid';$hash=password_hash(bin2hex(random_bytes(16)),PASSWORD_DEFAULT);$stmt=$this->db->prepare("INSERT INTO users(first_name,last_name,email,password_hash,role,status,must_change_password,session_version,password_changed_at) VALUES('Enquiry','Test Administrator',?,?,'super_admin','active',0,1,NOW())");$stmt->execute([$email,$hash]);$this->adminId=(int)$this->db->lastInsertId();
    }
    protected function tearDown(): void
    {
        if($this->enquiryId){foreach(['enquiry_email_log','enquiry_status_history'] as $table)$this->db->prepare("DELETE FROM `$table` WHERE enquiry_id=?")->execute([$this->enquiryId]);$this->db->prepare('DELETE FROM enquiries WHERE id=?')->execute([$this->enquiryId]);}
        if($this->adminId)$this->db->prepare('DELETE FROM users WHERE id=?')->execute([$this->adminId]);
        $_POST=[];$_GET=[];$_SESSION=[];
        $this->mailTransportBefore===false?putenv('MAIL_TRANSPORT'):putenv('MAIL_TRANSPORT='.$this->mailTransportBefore);
    }

    #[RunInSeparateProcess]
    #[PreserveGlobalState(false)]
    public function testMailFailureLeavesCompleteEnquiryAndFailureLog(): void
    {
        putenv('MAIL_TRANSPORT=forced-failure');$service=new EnquiryService($this->db,new MailService());
        $result=$service->submit(['first_name'=>'Automated','last_name'=>'Enquiry','email'=>'enquiry@example.invalid','phone'=>'0830000000','location'=>'Vanderbijlpark','product'=>'Canvas Covers','application'=>'Outdoor <built-in>','measurements'=>'900 × 700 & site check','preferred_contact'=>'Email','message'=>'Automated persistence test','website'=>'']);
        $this->enquiryId=(int)$result['enquiry_id'];self::assertFalse($result['email_sent']);
        $stmt=$this->db->prepare('SELECT first_name,last_name,email,phone,location,product,application,measurements,preferred_contact,message,status,created_at FROM enquiries WHERE id=?');$stmt->execute([$this->enquiryId]);$row=$stmt->fetch();self::assertSame('Automated',$row['first_name']);self::assertSame('Canvas Covers',$row['product']);self::assertSame('Outdoor <built-in>',$row['application']);self::assertSame('900 × 700 & site check',$row['measurements']);self::assertSame('Email',$row['preferred_contact']);self::assertSame('new',$row['status']);self::assertNotEmpty($row['created_at']);
        $stmt=$this->db->prepare("SELECT COUNT(*) FROM enquiry_email_log WHERE enquiry_id=? AND status='failed'");$stmt->execute([$this->enquiryId]);self::assertSame(1,(int)$stmt->fetchColumn());
        $stmt=$this->db->prepare('SELECT COUNT(*) FROM enquiry_status_history WHERE enquiry_id=?');$stmt->execute([$this->enquiryId]);self::assertSame(1,(int)$stmt->fetchColumn());
        $application=$this->application();$detail=new \ReflectionMethod($application,'adminEnquiry');ob_start();try{$detail->invoke($application,$this->enquiryId);$html=(string)ob_get_contents();}finally{ob_end_clean();}self::assertStringContainsString('Outdoor &lt;built-in&gt;',$html);self::assertStringContainsString('900 × 700 &amp; site check',$html);self::assertStringContainsString('<strong>Preferred contact:</strong> Email',$html);self::assertStringContainsString('<h2>Notification delivery</h2>',$html);self::assertStringContainsString('<strong>failed</strong>',$html);self::assertStringContainsString('Mail delivery failed.',$html);

        $_SESSION['csrf']=bin2hex(random_bytes(32));$_POST=['csrf'=>$_SESSION['csrf'],'id'=>(string)$this->enquiryId,'status'=>'in_progress','summary'=>'Follow-up assigned'];$save=new \ReflectionMethod($application,'saveEnquiryStatus');$save->invoke($application,$this->adminId);$stmt=$this->db->prepare('SELECT status FROM enquiries WHERE id=?');$stmt->execute([$this->enquiryId]);self::assertSame('in_progress',$stmt->fetchColumn());$stmt=$this->db->prepare("SELECT COUNT(*) FROM enquiry_status_history WHERE enquiry_id=? AND old_status='new' AND new_status='in_progress' AND summary='Follow-up assigned' AND admin_id=?");$stmt->execute([$this->enquiryId,$this->adminId]);self::assertSame(1,(int)$stmt->fetchColumn());
    }

    private function application(): Application
    {
        $repo=new ProductRepository($this->db);$pricing=new PricingService($this->db,$repo);$mail=new MailService();return new Application($this->db,$repo,$pricing,new QuoteService($this->db,$pricing,$mail),new EnquiryService($this->db,$mail),new CaptchaService(),dirname(__DIR__,2));
    }
}
