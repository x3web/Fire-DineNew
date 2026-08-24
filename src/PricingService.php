<?php
declare(strict_types=1);

namespace FireDine;

use DomainException;
use PDO;

final class PricingService
{
    public function __construct(private PDO $db, private ProductRepository $products) {}

    public function price(array $input): array
    {
        $productId = filter_var($input['product_id'] ?? null, FILTER_VALIDATE_INT);
        $quantity = filter_var($input['quantity'] ?? 1, FILTER_VALIDATE_INT);
        if (!$productId || !$quantity || $quantity < 1 || $quantity > 99) throw new DomainException('Invalid product or quantity.');
        $product = $this->products->findPublic((int)$productId);
        if (!$product) throw new DomainException('This product is not available.');
        if (($product['stock_status'] ?? 'in_stock') === 'out_of_stock') throw new DomainException('This product is currently out of stock.');

        $variationId = filter_var($input['variation_id'] ?? null, FILTER_VALIDATE_INT) ?: null;
        $base = $product['sale_price'] ?? $product['regular_price'];
        $variationSnapshot = [];
        if ($product['product_type'] === 'variable') {
            if (!$variationId) throw new DomainException('Select a valid product variation.');
            $stmt = $this->db->prepare("SELECT id,sku,regular_price,sale_price,attributes_json,stock_status FROM product_variations WHERE id=? AND product_id=? AND enabled=1 AND stock_status<>'out_of_stock'");
            $stmt->execute([$variationId,$productId]);
            $variation = $stmt->fetch();
            if (!$variation) throw new DomainException('The selected variation is unavailable.');
            $base = $variation['sale_price'] ?? $variation['regular_price'];
            $variationSnapshot = json_decode($variation['attributes_json'] ?: '{}', true) ?: [];
            $selectedSku = $variation['sku'] ?: $product['sku'];
        } elseif ($variationId) {
            throw new DomainException('This product does not accept a variation.');
        } else $selectedSku = $product['sku'];

        $selectedIds = array_values(array_unique(array_map('intval', (array)($input['option_value_ids'] ?? []))));
        $groups = $this->products->options((int)$productId);
        $allowed = [];
        $selectedByGroup = [];
        foreach ($groups as $group) {
            if ($group['type'] === 'display') continue;
            foreach ($group['values'] as $value) $allowed[$value['id']] = [$group,$value];
        }
        foreach ($selectedIds as $id) {
            if (!isset($allowed[$id])) throw new DomainException('An option is not valid for this product.');
            [$group,$value] = $allowed[$id];
            $selectedByGroup[$group['id']][] = $value;
        }
        $selectedCodes = [];
        foreach ($selectedByGroup as $groupId=>$values) {
            $group = current(array_filter($groups,fn($candidate)=>(int)$candidate['id']===(int)$groupId));
            if ($group) $selectedCodes[$group['code']] = array_column($values,'code');
        }
        foreach ($groups as $group) {
            $count = count($selectedByGroup[$group['id']] ?? []);
            $dynamic = $group['metadata']['required_when'] ?? null;
            $dynamicallyRequired = is_array($dynamic) && count(array_intersect((array)($dynamic['values']??[]),$selectedCodes[$dynamic['group']??'']??[]))>0;
            if (($group['required'] || $dynamicallyRequired) && $count === 0) throw new DomainException('Select ' . $group['label'] . '.');
            if ($group['type'] === 'single' && $count > 1) throw new DomainException('Select only one ' . $group['label'] . ' option.');
        }

        $confirmedOptionPrice = 0.0;
        $requiresQuote = $base === null;
        $snapshot = [];
        $pendingComponents = [];
        if ($base === null) $pendingComponents[] = ['type'=>'base_price','label'=>'Product base price'];
        foreach ($selectedByGroup as $values) foreach ($values as $value) {
            $group=$allowed[(int)$value['id']][0];
            $condition=$value['conditions']??[];
            if ($condition && count(array_intersect((array)($condition['values']??[]),$selectedCodes[$condition['group']??'']??[]))===0) throw new DomainException('An option is not available with this configuration.');
            if ($value['pricing_mode'] === 'request_quote') {
                $requiresQuote = true;
                $pendingComponents[]=['type'=>'option','group_code'=>$group['code'],'group_label'=>$group['label'],'code'=>$value['code'],'label'=>$value['label']];
            }
            elseif (in_array($value['pricing_mode'], ['fixed','additive'], true)) $confirmedOptionPrice += (float)($value['price_adjustment'] ?? 0);
            $snapshot[] = ['group_code'=>$group['code'],'group_label'=>$group['label'],'code'=>$value['code'],'label'=>$value['label'],'pricing_mode'=>$value['pricing_mode'],'price_adjustment'=>$value['price_adjustment']];
        }
        $hasConfirmedComponent = $base !== null || $confirmedOptionPrice > 0;
        $confirmedUnit = $hasConfirmedComponent ? (float)($base ?? 0) + $confirmedOptionPrice : null;
        $unit = $requiresQuote ? null : $confirmedUnit;
        return [
            'product_id'=>(int)$productId,'product_name'=>$product['name'],'sku'=>$selectedSku,
            'variation_id'=>$variationId,'variation'=>$variationSnapshot,'selected_options'=>$snapshot,
            'quantity'=>(int)$quantity,'base_price'=>$base === null ? null : (float)$base,
            'confirmed_option_price'=>$confirmedOptionPrice,'confirmed_unit_price'=>$confirmedUnit,
            'confirmed_line_total'=>$confirmedUnit === null ? null : round($confirmedUnit * (int)$quantity, 2),'unit_price'=>$unit,
            'line_total'=>$unit === null ? null : round($unit * (int)$quantity, 2),
            'requires_custom_quote'=>$requiresQuote,'pending_price_components'=>$pendingComponents,
        ];
    }
}
