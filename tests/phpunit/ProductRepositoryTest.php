<?php
declare(strict_types=1);

namespace FireDineTests;

use FireDine\NotFoundException;
use FireDine\ProductRepository;

final class ProductRepositoryTest extends DatabaseTestCase
{
    public function testPublicSearchFiltersAndBounds(): void
    {
        $repo=new ProductRepository($this->db);$result=$repo->search(['category'=>'pizza-ovens','subcategory'=>'domestic','featured'=>'0','q'=>'oven','page'=>1,'per_page'=>500]);self::assertLessThanOrEqual(48,$result['pagination']['per_page']);
        foreach($result['products'] as $product){self::assertSame('Domestic',$product['category_name']);self::assertArrayNotHasKey('internal_notes',$product);self::assertArrayNotHasKey('source_system',$product);}
    }

    public function testInvalidParentChildCombinationIsRejected(): void
    {
        $this->expectException(NotFoundException::class);(new ProductRepository($this->db))->search(['category'=>'accessories','subcategory'=>'domestic']);
    }

    public function testOutOfStockVariationIsReportedUnavailable(): void
    {
        $repo=new ProductRepository($this->db);foreach($repo->list(['per_page'=>48]) as $summary){$product=$repo->findBySlug($summary['slug']);foreach($product['variations'] as $variation)if($variation['stock_status']==='out_of_stock')self::assertFalse($variation['available']);}
        self::addToAssertionCount(1);
    }

    public function testOnlyAllowedVisibleStateIsPublic(): void
    {
        $repo=new ProductRepository($this->db);self::assertNotNull($repo->findPublic(75));self::assertNull($repo->findPublic(83));self::assertNull($repo->findPublic(106));
    }

    public function testPublicProductPayloadRecursivelyRemovesInternalFields(): void
    {
        $product=(new ProductRepository($this->db))->findBySlug('premium-diy-range');
        self::assertNotNull($product);$this->assertNoInternalKeys($product);
    }

    private function assertNoInternalKeys(array $value): void
    {
        foreach($value as $key=>$item){if(is_string($key))self::assertDoesNotMatchRegularExpression('/legacy_label|confirmation|provisional|internal|migration|administrative|admin_|source_system|source_id|import_/i',$key);if(is_array($item))$this->assertNoInternalKeys($item);}
    }
}
