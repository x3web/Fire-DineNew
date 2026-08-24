<?php
declare(strict_types=1);

namespace FireDineTests;

use DomainException;
use FireDine\Application;
use FireDine\CaptchaService;
use FireDine\EnquiryService;
use FireDine\MailService;
use FireDine\PricingService;
use FireDine\ProductRepository;
use FireDine\QuoteService;
use PHPUnit\Framework\Attributes\PreserveGlobalState;
use PHPUnit\Framework\Attributes\RunInSeparateProcess;

final class QuoteTransactionTest extends DatabaseTestCase
{
    private ?int $quoteId=null;
    private ?int $sequenceBefore=null;
    private string|false $mailTransportBefore=false;
    private string|false $appUrlBefore=false;
    private string|false $notificationEmailBefore=false;
    private array $taxSettingsBefore=[];

    protected function setUp(): void
    {
        parent::setUp();$year=(int)date('Y');$stmt=$this->db->prepare('SELECT last_number FROM quote_sequences WHERE quote_year=?');$stmt->execute([$year]);$value=$stmt->fetchColumn();$this->sequenceBefore=$value===false?null:(int)$value;$this->mailTransportBefore=getenv('MAIL_TRANSPORT');$this->appUrlBefore=getenv('APP_URL');$this->notificationEmailBefore=getenv('QUOTE_NOTIFICATION_EMAIL');
        $settings=$this->db->query("SELECT setting_key,setting_value FROM settings WHERE setting_key IN ('quote_tax_enabled','quote_tax_rate')")->fetchAll();foreach($settings as $setting)$this->taxSettingsBefore[$setting['setting_key']]=$setting['setting_value'];
    }

    protected function tearDown(): void
    {
        if($this->quoteId){foreach(['quote_email_log','quote_history','quote_items'] as $table)$this->db->prepare("DELETE FROM `$table` WHERE quote_id=?")->execute([$this->quoteId]);$this->db->prepare('DELETE FROM quote_requests WHERE id=?')->execute([$this->quoteId]);}
        $year=(int)date('Y');if($this->sequenceBefore===null)$this->db->prepare('DELETE FROM quote_sequences WHERE quote_year=?')->execute([$year]);else$this->db->prepare('UPDATE quote_sequences SET last_number=? WHERE quote_year=?')->execute([$this->sequenceBefore,$year]);
        foreach(['quote_tax_enabled','quote_tax_rate'] as $key){if(array_key_exists($key,$this->taxSettingsBefore))$this->db->prepare('UPDATE settings SET setting_value=? WHERE setting_key=?')->execute([$this->taxSettingsBefore[$key],$key]);else$this->db->prepare('DELETE FROM settings WHERE setting_key=?')->execute([$key]);}
        $this->mailTransportBefore===false?putenv('MAIL_TRANSPORT'):putenv('MAIL_TRANSPORT='.$this->mailTransportBefore);
        $this->appUrlBefore===false?putenv('APP_URL'):putenv('APP_URL='.$this->appUrlBefore);
        $this->notificationEmailBefore===false?putenv('QUOTE_NOTIFICATION_EMAIL'):putenv('QUOTE_NOTIFICATION_EMAIL='.$this->notificationEmailBefore);
    }

    #[RunInSeparateProcess]
    #[PreserveGlobalState(false)]
    public function testRealQuotePersistsLinesServerPricesVariationSkuAndEmailLog(): void
    {
        putenv('MAIL_TRANSPORT=log');putenv('QUOTE_NOTIFICATION_EMAIL=info@fireanddine.co.za');putenv('APP_URL=https://test.fireanddine.example/base/');$this->configureTax(false,15.0);
        $repo=new ProductRepository($this->db);$pricing=new PricingService($this->db,$repo);$service=new QuoteService($this->db,$pricing,new MailService());
        $canvas=$repo->findBySlug('canvas-covers');self::assertNotNull($canvas);$variation=$canvas['variations'][0];
        $product=$repo->findBySlug('counter-top-oven');self::assertNotNull($product);$selected=[];foreach($product['options'] as $group){if($group['code']==='built_in_thermometer'){foreach($group['values'] as $value)if($value['code']==='yes')$selected[]=$value['id'];continue;}if($group['required']){$default=current(array_filter($group['values'],fn($value)=>$value['default']))?:($group['values'][0]??null);if($default)$selected[]=$default['id'];}}
        $before=(int)$this->db->query('SELECT COUNT(*) FROM quote_requests')->fetchColumn();$input=array_replace($this->customer(),['customer_notes'=>'Canvas Cover colour: Olive','idempotency_key'=>bin2hex(random_bytes(24)),'items'=>[['product_id'=>$canvas['id'],'variation_id'=>$variation['id'],'quantity'=>2,'unit_price'=>1,'line_total'=>1],['product_id'=>$product['id'],'quantity'=>1,'option_value_ids'=>$selected,'line_total'=>1]]]);
        $result=$service->submit($input);$this->quoteId=(int)$result['quote_id'];self::assertSame($before+1,(int)$this->db->query('SELECT COUNT(*) FROM quote_requests')->fetchColumn());self::assertMatchesRegularExpression('/^FDQ-\d{4}-\d{5}$/',$result['quote_number']);
        self::assertFalse($result['tax_enabled']);self::assertSame(0.0,$result['tax_rate']);self::assertSame(0.0,$result['tax_amount']);self::assertSame($result['confirmed_subtotal'],$result['confirmed_total']);
        $stmt=$this->db->prepare('SELECT * FROM quote_items WHERE quote_id=? ORDER BY sort_order');$stmt->execute([$this->quoteId]);$items=$stmt->fetchAll();self::assertCount(2,$items);self::assertSame($variation['sku'],$items[0]['sku']);self::assertSame(4000.0,(float)$items[0]['line_total']);self::assertNotSame(1.0,(float)$items[1]['line_total']);self::assertNotSame([],json_decode($items[0]['variation_snapshot'],true));self::assertNotSame([],json_decode($items[1]['selected_options_json'],true));
        $stmt=$this->db->prepare('SELECT COUNT(*) FROM quote_email_log WHERE quote_id=? AND status=\'sent\'');$stmt->execute([$this->quoteId]);self::assertSame(2,(int)$stmt->fetchColumn());
        $messages=$service->notificationMessages($this->quoteId);$business=current(array_filter($messages,fn($message)=>$message['type']==='business_notification'));$customer=current(array_filter($messages,fn($message)=>$message['type']==='customer_acknowledgement'));$adminUrl='https://test.fireanddine.example/base/admin/quote?id='.$this->quoteId;self::assertIsArray($business);self::assertIsArray($customer);self::assertStringContainsString($adminUrl,$business['body']);self::assertStringNotContainsString('/admin/quote',$customer['body']);
        $application=new Application($this->db,$repo,$pricing,$service,new EnquiryService($this->db,new MailService()),new CaptchaService(),dirname(__DIR__,2));$method=new \ReflectionMethod($application,'adminQuote');ob_start();try{$method->invoke($application,$this->quoteId);$html=(string)ob_get_contents();}finally{ob_end_clean();}self::assertStringContainsString('Canvas Cover colour: Olive',$html);$savedOptions=json_decode($items[1]['selected_options_json'],true);self::assertNotEmpty($savedOptions);self::assertStringContainsString((string)$savedOptions[0]['label'],$html);
        $duplicate=$service->submit($input);self::assertTrue($duplicate['duplicate']);self::assertSame($this->quoteId,$duplicate['quote_id']);
    }

    public function testConfiguredTaxRateIsAppliedOnlyWhenEnabled(): void
    {
        putenv('MAIL_TRANSPORT=log');$this->configureTax(true,12.5);$repo=new ProductRepository($this->db);$service=new QuoteService($this->db,new PricingService($this->db,$repo),new MailService());$product=$repo->findPublic(76);self::assertNotNull($product);
        $result=$service->submit($this->customer()+['idempotency_key'=>bin2hex(random_bytes(24)),'items'=>[['product_id'=>76,'quantity'=>2]]]);$this->quoteId=(int)$result['quote_id'];self::assertTrue($result['tax_enabled']);self::assertSame(12.5,$result['tax_rate']);$expectedTax=round((float)$result['confirmed_subtotal']*0.125,2);self::assertSame($expectedTax,$result['tax_amount']);self::assertSame(round((float)$result['confirmed_subtotal']+$expectedTax,2),$result['confirmed_total']);
    }

    public function testInvalidLineCreatesNoQuoteOrItems(): void
    {
        putenv('MAIL_TRANSPORT=log');$repo=new ProductRepository($this->db);$service=new QuoteService($this->db,new PricingService($this->db,$repo),new MailService());$quotes=(int)$this->db->query('SELECT COUNT(*) FROM quote_requests')->fetchColumn();$items=(int)$this->db->query('SELECT COUNT(*) FROM quote_items')->fetchColumn();
        try{$service->submit($this->customer()+['idempotency_key'=>bin2hex(random_bytes(24)),'items'=>[['product_id'=>999999,'quantity'=>1]]]);self::fail('Invalid product was accepted.');}catch(DomainException){self::assertSame($quotes,(int)$this->db->query('SELECT COUNT(*) FROM quote_requests')->fetchColumn());self::assertSame($items,(int)$this->db->query('SELECT COUNT(*) FROM quote_items')->fetchColumn());}
    }

    public function testMailFailureDoesNotDeleteCommittedQuoteOrReference(): void
    {
        putenv('MAIL_TRANSPORT=forced-failure');$repo=new ProductRepository($this->db);$service=new QuoteService($this->db,new PricingService($this->db,$repo),new MailService());$product=$repo->findPublic(76);self::assertNotNull($product);
        $result=$service->submit($this->customer()+['idempotency_key'=>bin2hex(random_bytes(24)),'items'=>[['product_id'=>76,'quantity'=>1]]]);$this->quoteId=(int)$result['quote_id'];self::assertNotSame('',$result['quote_number']);$stmt=$this->db->prepare('SELECT COUNT(*) FROM quote_requests WHERE id=?');$stmt->execute([$this->quoteId]);self::assertSame(1,(int)$stmt->fetchColumn());$stmt=$this->db->prepare("SELECT COUNT(*) FROM quote_email_log WHERE quote_id=? AND status='failed'");$stmt->execute([$this->quoteId]);self::assertSame(2,(int)$stmt->fetchColumn());
    }

    private function customer(): array{return['full_name'=>'Automated Test','email'=>'test@example.invalid','phone'=>'0830000000','company'=>'','interest'=>'Canvas Covers','address_line'=>'1 Test Road','suburb'=>'Test','city'=>'Vanderbijlpark','province'=>'Gauteng','postal_code'=>'1911','country'=>'South Africa','customer_notes'=>'','website'=>''];}
    private function configureTax(bool $enabled,float $rate): void{$stmt=$this->db->prepare("INSERT INTO settings(setting_key,setting_value,is_secret) VALUES(?,?,0) ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value),is_secret=0");$stmt->execute(['quote_tax_enabled',$enabled?'1':'0']);$stmt->execute(['quote_tax_rate',(string)$rate]);}
}
