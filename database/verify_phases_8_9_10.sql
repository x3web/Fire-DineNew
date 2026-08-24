-- Final Fire & Dine database verification. Every result must be PASS.
SELECT 'confirmation register count' test,IF((SELECT COUNT(*) FROM product_confirmations)=15,'PASS','FAIL') result;
SELECT 'confirmation register open items' test,IF((SELECT COUNT(*) FROM product_confirmations WHERE status='pending')=15,'PASS','FAIL') result;
SELECT 'safe mobile floor wording' test,IF((SELECT COUNT(*) FROM products WHERE id=98 AND (description LIKE '%Firebrick floor%' OR specifications LIKE '%Firebrick floor%'))=0,'PASS','FAIL') result;
SELECT 'safe texture pricing' test,IF((SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id IN (75,97) AND g.option_code='finish_type' AND v.value_code='textured' AND v.pricing_mode='request_quote' AND v.price_adjustment IS NULL)=2,'PASS','FAIL') result;
SELECT 'safe Coastal Kit pricing' test,IF((SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.option_code='coastal_kit' AND v.value_code='yes' AND (v.pricing_mode<>'request_quote' OR v.price_adjustment IS NOT NULL))=0,'PASS','FAIL') result;
SELECT 'active variation counts' test,IF(
 (SELECT COUNT(*) FROM product_variations WHERE product_id=75 AND enabled=1)=3 AND
 (SELECT COUNT(*) FROM product_variations WHERE product_id=95 AND enabled=1)=9 AND
 (SELECT COUNT(*) FROM product_variations WHERE product_id=96 AND enabled=1)=3 AND
 (SELECT COUNT(*) FROM product_variations WHERE product_id=94 AND enabled=1)=4 AND
 (SELECT COUNT(*) FROM product_variations WHERE product_id=93 AND enabled=1)=4 AND
 (SELECT COUNT(*) FROM product_variations v JOIN products p ON p.id=v.product_id WHERE p.slug='canvas-covers' AND v.enabled=1)=3,'PASS','FAIL') result;
SELECT 'simple products stay simple' test,IF((SELECT COUNT(*) FROM products WHERE id IN (97,98) AND product_type='simple')=2,'PASS','FAIL') result;
SELECT 'no duplicate active variations' test,IF((SELECT COUNT(*) FROM (SELECT product_id,attributes_json,COUNT(*) n FROM product_variations WHERE enabled=1 GROUP BY product_id,attributes_json HAVING n>1) d)=0,'PASS','FAIL') result;
SELECT 'no public zero products' test,IF((SELECT COUNT(*) FROM products WHERE status='active' AND visibility='visible' AND regular_price=0)=0,'PASS','FAIL') result;
SELECT 'no public zero variations' test,IF((SELECT COUNT(*) FROM product_variations v JOIN products p ON p.id=v.product_id WHERE p.status='active' AND p.visibility='visible' AND v.enabled=1 AND v.regular_price=0)=0,'PASS','FAIL') result;
SELECT 'no negative prices' test,IF((SELECT COUNT(*) FROM products WHERE regular_price<0 OR sale_price<0)=0 AND (SELECT COUNT(*) FROM product_variations WHERE regular_price<0 OR sale_price<0)=0 AND (SELECT COUNT(*) FROM product_option_values WHERE price_adjustment<0)=0,'PASS','FAIL') result;
SELECT 'hidden products remain hidden' test,IF((SELECT COUNT(*) FROM products WHERE id IN (83,106) AND status<>'active' AND visibility='hidden')=2,'PASS','FAIL') result;
SELECT 'three main categories' test,IF((SELECT COUNT(*) FROM categories WHERE parent_id IS NULL AND is_active=1 AND slug IN ('pizza-ovens','accessories','fireplace'))=3,'PASS','FAIL') result;
SELECT 'five child categories' test,IF((SELECT COUNT(*) FROM categories c JOIN categories p ON p.id=c.parent_id WHERE c.is_active=1 AND ((p.slug='pizza-ovens' AND c.slug IN ('domestic','mobile','commercial')) OR (p.slug='accessories' AND c.slug IN ('pizza-oven-utensils-accessories','canvas-covers'))))=5,'PASS','FAIL') result;
SELECT 'no orphan products' test,IF((SELECT COUNT(*) FROM products p LEFT JOIN categories c ON c.id=p.category_id WHERE p.category_id IS NOT NULL AND c.id IS NULL)=0,'PASS','FAIL') result;
SELECT 'no orphan variations' test,IF((SELECT COUNT(*) FROM product_variations v LEFT JOIN products p ON p.id=v.product_id WHERE p.id IS NULL)=0,'PASS','FAIL') result;
SELECT 'no orphan options' test,IF((SELECT COUNT(*) FROM product_option_groups g LEFT JOIN products p ON p.id=g.product_id WHERE p.id IS NULL)=0 AND (SELECT COUNT(*) FROM product_option_values v LEFT JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.id IS NULL)=0,'PASS','FAIL') result;
SELECT 'no orphan product media' test,IF((SELECT COUNT(*) FROM product_media pm LEFT JOIN products p ON p.id=pm.product_id LEFT JOIN media_assets m ON m.id=pm.media_id WHERE p.id IS NULL OR m.id IS NULL)=0,'PASS','FAIL') result;
SELECT 'no duplicate slugs' test,IF((SELECT COUNT(*) FROM (SELECT slug,COUNT(*) n FROM products GROUP BY slug HAVING n>1) d)=0,'PASS','FAIL') result;
SELECT 'no duplicate product SKUs' test,IF((SELECT COUNT(*) FROM (SELECT sku,COUNT(*) n FROM products GROUP BY sku HAVING n>1) d)=0,'PASS','FAIL') result;
SELECT 'no duplicate variation SKUs' test,IF((SELECT COUNT(*) FROM (SELECT sku,COUNT(*) n FROM product_variations WHERE sku IS NOT NULL AND sku<>'' GROUP BY sku HAVING n>1) d)=0,'PASS','FAIL') result;
SELECT 'valid product JSON' test,IF((SELECT COUNT(*) FROM products WHERE specifications IS NOT NULL AND NOT JSON_VALID(specifications))=0 AND (SELECT COUNT(*) FROM products WHERE attributes_json IS NOT NULL AND NOT JSON_VALID(attributes_json))=0,'PASS','FAIL') result;
SELECT 'valid variation JSON' test,IF((SELECT COUNT(*) FROM product_variations WHERE NOT JSON_VALID(attributes_json))=0,'PASS','FAIL') result;
SELECT 'valid option JSON' test,IF((SELECT COUNT(*) FROM product_option_groups WHERE metadata_json IS NOT NULL AND NOT JSON_VALID(metadata_json))=0 AND (SELECT COUNT(*) FROM product_option_values WHERE conditions_json IS NOT NULL AND NOT JSON_VALID(conditions_json))=0,'PASS','FAIL') result;
SELECT 'no self-parent categories' test,IF((SELECT COUNT(*) FROM categories WHERE parent_id=id)=0,'PASS','FAIL') result;
SELECT 'no two-level category cycles' test,IF((SELECT COUNT(*) FROM categories a JOIN categories b ON b.id=a.parent_id WHERE b.parent_id=a.id)=0,'PASS','FAIL') result;
SELECT 'quote-only values have NULL price' test,IF((SELECT COUNT(*) FROM product_option_values WHERE pricing_mode='request_quote' AND price_adjustment IS NOT NULL)=0,'PASS','FAIL') result;
SELECT 'final migration marker' test,IF((SELECT meta_value FROM app_meta WHERE meta_key='fire_dine_phase_8_9_10')='implemented','PASS','FAIL') result;
