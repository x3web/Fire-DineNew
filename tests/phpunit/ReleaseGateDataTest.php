<?php
declare(strict_types=1);

namespace FireDineTests;

final class ReleaseGateDataTest extends DatabaseTestCase
{
    public function testApprovedCatalogueReleaseCorrections(): void
    {
        self::assertSame(3,(int)$this->db->query('SELECT COUNT(*) FROM categories WHERE parent_id IS NULL AND is_active=1')->fetchColumn());
        self::assertSame(3,(int)$this->db->query("SELECT COUNT(*) FROM categories WHERE parent_id IS NULL AND slug IN ('pizza-ovens','accessories','fireplace') AND is_active=1")->fetchColumn());
        self::assertSame(2,(int)$this->db->query("SELECT COUNT(*) FROM products WHERE id IN (83,106) AND status='archived' AND visibility='hidden'")->fetchColumn());
        self::assertSame(1,(int)$this->db->query("SELECT COUNT(*) FROM products WHERE id=104 AND stock_status='out_of_stock'")->fetchColumn());
        self::assertSame(1,(int)$this->db->query('SELECT COUNT(*) FROM product_related_products WHERE product_id=98 AND related_product_id=80')->fetchColumn());
        self::assertSame(0,(int)$this->db->query("SELECT COUNT(*) FROM products WHERE status='active' AND visibility='visible' AND regular_price=0")->fetchColumn());
        self::assertSame(0,(int)$this->db->query("SELECT COUNT(*) FROM product_option_values WHERE pricing_mode='request_quote' AND price_adjustment IS NOT NULL")->fetchColumn());
    }

    public function testTaxDefaultsAndBrokenGalleryRecord(): void
    {
        $settings=$this->db->query("SELECT setting_key,setting_value FROM settings WHERE setting_key IN ('quote_tax_enabled','quote_tax_rate')")->fetchAll(\PDO::FETCH_KEY_PAIR);
        self::assertSame('0',$settings['quote_tax_enabled']??null);self::assertSame('0',$settings['quote_tax_rate']??null);
        self::assertSame(0,(int)$this->db->query("SELECT COUNT(*) FROM gallery_media WHERE title='Luxurious Sunset Fireplace Retreat' AND enabled=1")->fetchColumn());
    }
}
