<?php
declare(strict_types=1);

namespace FireDine;

use DomainException;
use PDO;
use RuntimeException;

final class QuoteService
{
    public function __construct(private PDO $db, private PricingService $pricing, private MailService $mail) {}

    public function submit(array $input): array
    {
        foreach (['full_name','email','phone','address_line','suburb','city','province','postal_code'] as $field) {
            if (trim((string)($input[$field] ?? '')) === '') throw new DomainException('Please complete all required contact and delivery fields.');
        }
        if (!filter_var($input['email'], FILTER_VALIDATE_EMAIL)) throw new DomainException('Enter a valid email address.');
        if (trim((string)($input['website'] ?? '')) !== '') throw new DomainException('The request could not be accepted.');
        $idempotencyKey = trim((string)($input['idempotency_key'] ?? ''));
        if (!preg_match('/^[A-Za-z0-9_-]{16,128}$/', $idempotencyKey)) throw new DomainException('Refresh the quote form and submit again.');
        $existing = $this->findByIdempotencyKey($idempotencyKey);
        if ($existing) return $this->publicResult($existing, true);

        $rawItems = $input['items'] ?? [];
        if (!is_array($rawItems) || !$rawItems) throw new DomainException('Your quote basket is empty.');
        if (count($rawItems) > 50) throw new DomainException('A quote may contain at most 50 product lines.');
        $limits = ['full_name'=>190,'email'=>190,'phone'=>60,'company'=>190,'interest'=>190,'address_line'=>255,'suburb'=>120,'city'=>120,'province'=>120,'postal_code'=>30,'country'=>120,'customer_notes'=>5000];
        foreach ($limits as $field=>$limit) if (strlen((string)($input[$field] ?? '')) > $limit) throw new DomainException('One or more quote fields are too long.');

        $items = array_map(fn($item) => $this->pricing->price((array)$item), $rawItems);
        $confirmedLines = array_values(array_filter(array_column($items, 'confirmed_line_total'), fn($value) => $value !== null));
        $hasConfirmedAmount = $confirmedLines !== [];
        $confirmedSubtotal = round(array_sum(array_map('floatval', $confirmedLines)), 2);
        $hasCustom = in_array(true, array_column($items, 'requires_custom_quote'), true);
        $tax = $this->taxConfiguration();
        $taxEnabled = $tax['enabled'] && $hasConfirmedAmount;
        $taxRate = $taxEnabled ? $tax['rate'] : 0.0;
        $taxAmount = $taxEnabled ? round($confirmedSubtotal * $taxRate / 100, 2) : 0.0;
        $confirmedTotal = round($confirmedSubtotal + $taxAmount, 2);

        $this->db->beginTransaction();
        try {
            $year = (int)date('Y');
            $this->db->prepare("INSERT INTO quote_sequences(quote_year,last_number) VALUES(:year,1) ON DUPLICATE KEY UPDATE last_number=LAST_INSERT_ID(last_number+1)")->execute(['year'=>$year]);
            $number = (int)$this->db->lastInsertId();
            if ($number === 0) $number = 1;
            $quoteNumber = sprintf('FDQ-%d-%05d', $year, $number);
            $stmt = $this->db->prepare("INSERT INTO quote_requests
                (quote_number,status,full_name,email,phone,company,interest,address_line,suburb,city,province,postal_code,country,customer_notes,tax_enabled,has_confirmed_amount,vat_rate,subtotal,vat_amount,total,pricing_status,idempotency_key,submitted_ip_hash,submitted_at)
                VALUES (:quote_number,'new_enquiry',:full_name,:email,:phone,NULLIF(:company,''),NULLIF(:interest,''),:address_line,:suburb,:city,:province,:postal_code,:country,NULLIF(:customer_notes,''),:tax_enabled,:has_confirmed_amount,:vat_rate,:subtotal,:vat_amount,:total,:pricing_status,:idempotency_key,:submitted_ip_hash,NOW())");
            $stmt->execute([
                'quote_number'=>$quoteNumber,'full_name'=>trim((string)$input['full_name']),'email'=>strtolower(trim((string)$input['email'])),'phone'=>trim((string)$input['phone']),
                'company'=>trim((string)($input['company'] ?? '')),'interest'=>trim((string)($input['interest'] ?? '')),'address_line'=>trim((string)$input['address_line']),
                'suburb'=>trim((string)$input['suburb']),'city'=>trim((string)$input['city']),'province'=>trim((string)$input['province']),'postal_code'=>trim((string)$input['postal_code']),
                'country'=>trim((string)($input['country'] ?? 'South Africa')),'customer_notes'=>trim((string)($input['customer_notes'] ?? '')),
                'tax_enabled'=>$taxEnabled?1:0,'has_confirmed_amount'=>$hasConfirmedAmount?1:0,'vat_rate'=>$taxRate,'subtotal'=>$confirmedSubtotal,'vat_amount'=>$taxAmount,
                'total'=>$confirmedTotal,'pricing_status'=>$hasCustom?'price_pending':'confirmed','idempotency_key'=>$idempotencyKey,
                'submitted_ip_hash'=>hash('sha256',($_SERVER['REMOTE_ADDR'] ?? '').'|'.(getenv('APP_KEY') ?: 'local')),
            ]);
            $quoteId = (int)$this->db->lastInsertId();
            $itemStmt = $this->db->prepare("INSERT INTO quote_items
                (quote_id,product_id,variation_id,product_name,sku,variation_snapshot,selected_options_json,pending_price_components_json,requires_custom_quote,base_price,confirmed_option_price,final_confirmed_price,confirmed_line_total,quantity,unit_price,line_total,sort_order)
                VALUES (:quote_id,:product_id,:variation_id,:product_name,:sku,:variation_snapshot,:selected_options_json,:pending_price_components_json,:requires_custom_quote,:base_price,:confirmed_option_price,:final_confirmed_price,:confirmed_line_total,:quantity,:unit_price,:line_total,:sort_order)");
            foreach ($items as $index=>$item) {
                $itemStmt->execute([
                    'quote_id'=>$quoteId,'product_id'=>$item['product_id'],'variation_id'=>$item['variation_id'],'product_name'=>$item['product_name'],'sku'=>$item['sku'],
                    'variation_snapshot'=>json_encode($item['variation'],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),'selected_options_json'=>json_encode($item['selected_options'],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),
                    'pending_price_components_json'=>json_encode($item['pending_price_components'],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),'requires_custom_quote'=>$item['requires_custom_quote']?1:0,
                    'base_price'=>$item['base_price'],'confirmed_option_price'=>$item['confirmed_option_price'],'final_confirmed_price'=>$item['confirmed_unit_price'],
                    'confirmed_line_total'=>$item['confirmed_line_total'],'quantity'=>$item['quantity'],'unit_price'=>$item['unit_price'],'line_total'=>$item['line_total'],'sort_order'=>$index,
                ]);
            }
            $history = $this->db->prepare("INSERT INTO quote_history(quote_id,status,event_type,summary,ip_hash) VALUES(:quote_id,'new_enquiry','submitted','Customer submitted quote request',:ip_hash)");
            $history->execute(['quote_id'=>$quoteId,'ip_hash'=>hash('sha256',($_SERVER['REMOTE_ADDR'] ?? '').'|'.(getenv('APP_KEY') ?: 'local'))]);
            $this->db->commit();
        } catch (\Throwable $e) {
            if ($this->db->inTransaction()) $this->db->rollBack();
            if ((string)$e->getCode() === '23000') {
                $existing = $this->findByIdempotencyKey($idempotencyKey);
                if ($existing) return $this->publicResult($existing, true);
            }
            throw $e;
        }

        try { $this->sendNotifications($quoteId); }
        catch (\Throwable $e) { error_log('Quote '.$quoteNumber.' notification logging failed after commit: '.$e->getMessage()); }
        return $this->publicResult([
            'quote_id'=>$quoteId,'quote_number'=>$quoteNumber,'subtotal'=>$confirmedSubtotal,'vat_amount'=>$taxAmount,'total'=>$confirmedTotal,
            'pricing_status'=>$hasCustom?'price_pending':'confirmed','has_confirmed_amount'=>$hasConfirmedAmount?1:0,'tax_enabled'=>$taxEnabled?1:0,'vat_rate'=>$taxRate,
        ], false);
    }

    private function taxConfiguration(): array
    {
        $stmt=$this->db->query("SELECT setting_key,setting_value FROM settings WHERE setting_key IN ('quote_tax_enabled','quote_tax_rate')");
        $settings=[];foreach($stmt->fetchAll() as $row)$settings[$row['setting_key']]=$row['setting_value'];
        $enabled=filter_var($settings['quote_tax_enabled']??'0',FILTER_VALIDATE_BOOLEAN);
        $rate=is_numeric($settings['quote_tax_rate']??null)?(float)$settings['quote_tax_rate']:0.0;
        if($enabled&&($rate<0||$rate>100))throw new RuntimeException('The configured quote tax rate is invalid.');
        return['enabled'=>$enabled,'rate'=>$enabled?$rate:0.0];
    }

    private function findByIdempotencyKey(string $key): ?array
    {
        $stmt = $this->db->prepare("SELECT id quote_id,quote_number,subtotal,vat_amount,total,pricing_status,has_confirmed_amount,tax_enabled,vat_rate FROM quote_requests WHERE idempotency_key=:key LIMIT 1");
        $stmt->execute(['key'=>$key]);
        return $stmt->fetch() ?: null;
    }

    private function publicResult(array $row, bool $duplicate): array
    {
        $hasConfirmed=!empty($row['has_confirmed_amount']);
        return [
            'quote_id'=>(int)$row['quote_id'],'quote_number'=>$row['quote_number'],
            'confirmed_subtotal'=>$hasConfirmed?(float)$row['subtotal']:null,
            'tax_enabled'=>!empty($row['tax_enabled']),'tax_rate'=>!empty($row['tax_enabled'])?(float)$row['vat_rate']:0.0,
            'tax_amount'=>$hasConfirmed?(float)$row['vat_amount']:null,'confirmed_total'=>$hasConfirmed?(float)$row['total']:null,
            'pricing_status'=>$row['pricing_status'],'has_quote_only'=>$row['pricing_status']==='price_pending','has_confirmed_amount'=>$hasConfirmed,'duplicate'=>$duplicate,
        ];
    }

    private function sendNotifications(int $quoteId): void
    {
        $messages=$this->notificationMessages($quoteId);
        $log = $this->db->prepare("INSERT INTO quote_email_log(quote_id,email_type,recipient,status,error_message) VALUES(:quote_id,:email_type,:recipient,:status,:error_message)");
        foreach ($messages as $message) {
            try { $result = $this->mail->send($message['to'],$message['subject'],$message['body']); }
            catch (\Throwable $e) { $result=['sent'=>false,'error'=>'Mail transport exception.']; error_log($e->__toString()); }
            try { $log->execute(['quote_id'=>$quoteId,'email_type'=>$message['type'],'recipient'=>$message['to'],'status'=>$result['sent']?'sent':'failed','error_message'=>$result['error']??null]); }
            catch (\Throwable $e) { error_log('Quote #'.$quoteId.' email result could not be logged: '.$e->getMessage()); }
        }
    }

    public function notificationMessages(int $quoteId): array
    {
        $stmt=$this->db->prepare('SELECT * FROM quote_requests WHERE id=?');$stmt->execute([$quoteId]);$quote=$stmt->fetch();
        if(!$quote)throw new RuntimeException('The saved quote could not be loaded for notification.');
        $itemsStmt=$this->db->prepare('SELECT * FROM quote_items WHERE quote_id=? ORDER BY sort_order,id');$itemsStmt->execute([$quoteId]);$items=$itemsStmt->fetchAll();
        $historyStmt=$this->db->prepare('SELECT status,summary,created_at FROM quote_history WHERE quote_id=? ORDER BY created_at,id');$historyStmt->execute([$quoteId]);$history=$historyStmt->fetchAll();
        $summary=$this->quoteHtml($quote,$items,$history);
        $adminUrl=$this->adminQuoteUrl((int)$quote['id']);
        return [
            ['type'=>'business_notification','to'=>getenv('QUOTE_NOTIFICATION_EMAIL') ?: 'info@fireanddine.co.za','subject'=>'New Fire & Dine quote '.$quote['quote_number'],'body'=>'<p>A new quote request has been saved.</p><p><a href="'.$this->escape($adminUrl).'">Open this quote in the Fire &amp; Dine admin system</a></p>'.$summary],
            ['type'=>'customer_acknowledgement','to'=>(string)$quote['email'],'subject'=>'Fire & Dine quote request '.$quote['quote_number'],'body'=>'<p>Hello '.$this->escape((string)$quote['full_name']).',</p><p>Thank you. We have received your quote request.</p>'.$summary],
        ];
    }

    private function adminQuoteUrl(int $quoteId): string
    {
        $configured=trim((string)(getenv('APP_URL')?:''));
        $parts=$configured!==''?parse_url($configured):false;
        $valid=filter_var($configured,FILTER_VALIDATE_URL)!==false&&is_array($parts)&&in_array(strtolower((string)($parts['scheme']??'')),['http','https'],true)&&!empty($parts['host'])&&!isset($parts['user'])&&!isset($parts['pass'])&&!isset($parts['query'])&&!isset($parts['fragment']);
        $base=rtrim($valid?$configured:'https://www.fireanddine.co.za','/');
        return $base.'/admin/quote?id='.rawurlencode((string)$quoteId);
    }

    private function quoteHtml(array $quote,array $items,array $history): string
    {
        $rows='';
        foreach($items as $item){
            $configuration=[];
            foreach((array)(json_decode($item['variation_snapshot']?:'{}',true)?:[]) as $label=>$value)$configuration[]=ucwords(str_replace('_',' ',(string)$label)).': '.$value;
            foreach((array)(json_decode($item['selected_options_json']?:'[]',true)?:[]) as $option)if(is_array($option))$configuration[]=($option['group_label']??'Option').': '.($option['label']??$option['code']??'');
            $pending=[];foreach((array)(json_decode($item['pending_price_components_json']?:'[]',true)?:[]) as $component)if(is_array($component))$pending[]=$component['label']??'Price component';
            $amount=$item['confirmed_line_total']===null?'Price pending':$this->money((float)$item['confirmed_line_total']);
            if($pending)$amount='Price pending'.($item['confirmed_line_total']!==null?' · confirmed components '.$amount:'').' ('.$this->escape(implode(', ',$pending)).')';
            $rows.='<tr><td>'.$this->escape((string)$item['product_name']).'<br><small>'.$this->escape((string)($item['sku']??'')).($configuration?'<br>'.$this->escape(implode(' · ',$configuration)):'').'</small></td><td>'.(int)$item['quantity'].'</td><td>'.$amount.'</td></tr>';
        }
        $historyHtml='';foreach($history as $entry)$historyHtml.='<li>'.$this->escape((string)$entry['status']).' — '.$this->escape((string)$entry['summary']).' ('.$this->escape((string)$entry['created_at']).')</li>';
        $confirmed=!empty($quote['has_confirmed_amount'])?'<p><strong>Confirmed subtotal:</strong> '.$this->money((float)$quote['subtotal']).'<br>'.(!empty($quote['tax_enabled'])?'<strong>Configured tax ('.number_format((float)$quote['vat_rate'],3,'.','').'&#37;):</strong> '.$this->money((float)$quote['vat_amount']).'<br>':'<strong>Tax:</strong> Disabled; Product Guide prices used as supplied.<br>').'<strong>Confirmed total:</strong> '.$this->money((float)$quote['total']).'</p>':'<p><strong>Confirmed amount:</strong> Price pending.</p>';
        $address=implode(', ',array_filter([$quote['address_line'],$quote['suburb'],$quote['city'],$quote['province'],$quote['postal_code'],$quote['country']]));
        return '<h2>Quote '.$this->escape((string)$quote['quote_number']).'</h2><p><strong>Date:</strong> '.$this->escape((string)$quote['submitted_at']).'<br><strong>Status:</strong> '.$this->escape((string)$quote['status']).'</p><h3>Customer</h3><p><strong>Name:</strong> '.$this->escape((string)$quote['full_name']).'<br><strong>Company:</strong> '.$this->escape((string)($quote['company']?:'Not supplied')).'<br><strong>Email:</strong> '.$this->escape((string)$quote['email']).'<br><strong>Phone:</strong> '.$this->escape((string)$quote['phone']).'<br><strong>Address:</strong> '.$this->escape($address).'</p><p><strong>Customer notes and selected colours:</strong><br>'.nl2br($this->escape((string)($quote['customer_notes']?:'None supplied'))).'</p><h3>Products and configuration</h3><table border="1" cellpadding="6" cellspacing="0"><thead><tr><th>Product, variation and options</th><th>Quantity</th><th>Amount</th></tr></thead><tbody>'.$rows.'</tbody></table>'.$confirmed.'<p>Delivery and installation are quoted separately.</p><h3>Status history</h3><ol>'.$historyHtml.'</ol>';
    }

    private function escape(string $value): string{return htmlspecialchars($value,ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');}
    private function money(float $value): string{return'R'.number_format($value,2,'.',' ');}
}
