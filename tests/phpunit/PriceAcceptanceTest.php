<?php
declare(strict_types=1);

namespace FireDineTests;

final class PriceAcceptanceTest extends DatabaseTestCase
{
    public function testEveryApprovedVariationMapping(): void
    {
        $expected=[
            75=>['Standard'=>10300.0,'Grande'=>11800.0,'Superior'=>13600.0],
            96=>['Standard'=>13800.0,'Grande'=>26000.0,'Superior'=>39500.0],
            94=>['Standard'=>32000.0,'Grande'=>39000.0,'Superior'=>55000.0,'Ultra'=>66000.0],
            93=>['Piccolo'=>37760.0,'Classico'=>54280.0,'Grande'=>71980.0,'Maestro'=>88500.0],
        ];
        foreach($expected as $productId=>$models){
            $stmt=$this->db->prepare("SELECT regular_price,attributes_json FROM product_variations WHERE product_id=? AND enabled=1 ORDER BY position,id");$stmt->execute([$productId]);$actual=[];
            foreach($stmt->fetchAll() as $row){$attributes=json_decode($row['attributes_json'],true,512,JSON_THROW_ON_ERROR);$actual[$attributes['Size']] = (float)$row['regular_price'];}
            self::assertSame($models,$actual,'Incorrect variation map for product '.$productId);
        }
    }

    public function testPremiumMobileNineExactConfigurations(): void
    {
        $expected=['Piccolo|With collapsible-side-table trolley'=>22200.0,'Piccolo|With trolley without side table'=>21000.0,'Piccolo|Without trolley'=>16800.0,'Grande|With collapsible-side-table trolley'=>29800.0,'Grande|With trolley without side table'=>28800.0,'Grande|Without trolley'=>23600.0,'Superior|With collapsible-side-table trolley'=>33200.0,'Superior|With trolley without side table'=>32500.0,'Superior|Without trolley'=>27300.0];
        $stmt=$this->db->query("SELECT regular_price,attributes_json FROM product_variations WHERE product_id=95 AND enabled=1 ORDER BY position,id");$actual=[];
        foreach($stmt->fetchAll() as $row){$a=json_decode($row['attributes_json'],true,512,JSON_THROW_ON_ERROR);$actual[$a['Size'].'|'.$a['Trolley Configuration']]=(float)$row['regular_price'];}
        self::assertSame($expected,$actual);
    }

    public function testSimpleAndAccessoryPrices(): void
    {
        $expected=[76=>650.0,77=>400.0,78=>680.0,79=>850.0,80=>620.0,81=>300.0,82=>680.0,97=>11600.0,98=>18900.0];
        $rows=$this->db->query('SELECT id,regular_price FROM products WHERE id IN (76,77,78,79,80,81,82,97,98) ORDER BY id')->fetchAll();$actual=[];foreach($rows as $row)$actual[(int)$row['id']]=(float)$row['regular_price'];
        self::assertSame($expected,$actual);
    }

    public function testUnknownAmountsAreNeverZero(): void
    {
        self::assertSame(0,(int)$this->db->query("SELECT COUNT(*) FROM product_option_values WHERE pricing_mode='request_quote' AND price_adjustment IS NOT NULL")->fetchColumn());
        self::assertSame(0,(int)$this->db->query("SELECT COUNT(*) FROM products WHERE status='active' AND visibility='visible' AND regular_price=0")->fetchColumn());
    }
}
