<?php
declare(strict_types=1);

namespace FireDineTests;

use DomainException;
use FireDine\PricingService;
use FireDine\ProductRepository;

final class PricingServiceTest extends DatabaseTestCase
{
    public function testBrowserPriceFieldsCannotOverrideServerPrice(): void
    {
        $service=new PricingService($this->db,new ProductRepository($this->db));
        $result=$service->price(['product_id'=>76,'quantity'=>1,'unit_price'=>1,'line_total'=>1]);
        self::assertSame(650.0,$result['confirmed_unit_price']);self::assertSame(650.0,$result['confirmed_line_total']);
    }

    public function testOutOfStockProductCannotBePriced(): void
    {
        $this->expectException(DomainException::class);
        (new PricingService($this->db,new ProductRepository($this->db)))->price(['product_id'=>104,'quantity'=>1]);
    }

    public function testQuantityAboveNinetyNineIsRejected(): void
    {
        $this->expectException(DomainException::class);
        (new PricingService($this->db,new ProductRepository($this->db)))->price(['product_id'=>76,'quantity'=>100]);
    }
}
