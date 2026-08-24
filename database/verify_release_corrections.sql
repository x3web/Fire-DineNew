-- Fire & Dine release-correction verifier (MariaDB 10.11+).
-- Every row must return PASS. Run after the final migration.
SELECT 'exactly three active top-level categories' test,
 IF((SELECT COUNT(*) FROM categories WHERE parent_id IS NULL AND is_active=1)=3
    AND (SELECT COUNT(*) FROM categories WHERE parent_id IS NULL AND is_active=1 AND slug IN ('pizza-ovens','accessories','fireplace'))=3,'PASS','FAIL') result;
SELECT 'protected child topology' test,
 IF((SELECT COUNT(*) FROM categories c JOIN categories p ON p.id=c.parent_id
     WHERE c.is_active=1 AND ((p.slug='pizza-ovens' AND c.slug IN ('domestic','mobile','commercial'))
       OR (p.slug='accessories' AND c.slug IN ('pizza-oven-utensils-accessories','canvas-covers'))))=5,'PASS','FAIL') result;
SELECT 'protected product assignments' test,
 IF((SELECT COUNT(*) FROM products p JOIN categories c ON c.id=p.category_id WHERE p.id IN (75,97) AND c.slug='domestic')=2
    AND (SELECT COUNT(*) FROM products p JOIN categories c ON c.id=p.category_id WHERE p.id IN (95,98) AND c.slug='mobile')=2
    AND (SELECT COUNT(*) FROM products p JOIN categories c ON c.id=p.category_id WHERE p.id IN (93,94,96) AND c.slug='commercial')=3
    AND (SELECT COUNT(*) FROM products p JOIN categories c ON c.id=p.category_id WHERE p.id IN (76,77,78,80,81,82) AND c.slug='pizza-oven-utensils-accessories')=6
    AND (SELECT COUNT(*) FROM products p JOIN categories c ON c.id=p.category_id WHERE p.id=79 AND c.slug='accessories')=1,'PASS','FAIL') result;
SELECT 'hidden archived products' test,
 IF((SELECT COUNT(*) FROM products WHERE id IN (83,106) AND status='archived' AND visibility='hidden')=2,'PASS','FAIL') result;
SELECT 'approved slugs' test,
 IF((SELECT COUNT(*) FROM products WHERE (id=97 AND slug='counter-top-oven') OR (id=94 AND slug='premium-pre-fabricato-range') OR (id=93 AND slug='forno-neapolitan-range'))=3,'PASS','FAIL') result;

SELECT 'Premium DIY exact prices' test,
 IF((SELECT COUNT(*) FROM product_variations WHERE product_id=75 AND enabled=1 AND JSON_UNQUOTE(JSON_EXTRACT(attributes_json,'$.Size'))='Standard' AND regular_price=10300)=1
    AND (SELECT COUNT(*) FROM product_variations WHERE product_id=75 AND enabled=1 AND JSON_UNQUOTE(JSON_EXTRACT(attributes_json,'$.Size'))='Grande' AND regular_price=11800)=1
    AND (SELECT COUNT(*) FROM product_variations WHERE product_id=75 AND enabled=1 AND JSON_UNQUOTE(JSON_EXTRACT(attributes_json,'$.Size'))='Superior' AND regular_price=13600)=1,'PASS','FAIL') result;
SELECT 'Counter Top exact prices' test,
 IF((SELECT COUNT(*) FROM products WHERE id=97 AND regular_price=11600)=1
    AND (SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id=97 AND g.option_code='built_in_thermometer' AND v.value_code='yes' AND v.price_adjustment=1700)=1
    AND (SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id=97 AND g.option_code='stoneskin' AND v.value_code='yes' AND v.price_adjustment=1200)=1,'PASS','FAIL') result;
SELECT 'Premium Mobile exact prices' test,
 IF((SELECT COUNT(*) FROM product_variations WHERE product_id=95 AND enabled=1 AND regular_price IN (22200,21000,16800,29800,28800,23600,33200,32500,27300))=9,'PASS','FAIL') result;
SELECT 'Mobile Countertop exact prices' test,
 IF((SELECT COUNT(*) FROM products WHERE id=98 AND regular_price=18900)=1
    AND (SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id=98 AND g.option_code='trolley_configuration' AND v.value_code='without_side_table' AND v.price_adjustment=5600)=1
    AND (SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id=98 AND g.option_code='trolley_configuration' AND v.value_code='with_side_table' AND v.price_adjustment=6000)=1
    AND (SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id=98 AND g.option_code='gas_conversion' AND v.value_code='yes' AND v.price_adjustment=2600)=1,'PASS','FAIL') result;
SELECT 'Steel exact prices' test,
 IF((SELECT COUNT(*) FROM product_variations WHERE product_id=96 AND enabled=1 AND regular_price IN (13800,26000,39500))=3
    AND (SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id=96 AND g.option_code='built_in_thermometer' AND v.value_code='yes' AND v.price_adjustment=1700)=1,'PASS','FAIL') result;
SELECT 'Pre-Fabricato exact prices' test,
 IF((SELECT COUNT(*) FROM product_variations WHERE product_id=94 AND enabled=1 AND regular_price IN (32000,39000,55000,66000))=4
    AND (SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id WHERE g.product_id=94 AND g.option_code='stainless_spigot_door' AND v.value_code='yes' AND v.price_adjustment=1500)=1,'PASS','FAIL') result;
SELECT 'Forno exact prices' test,
 IF((SELECT COUNT(*) FROM product_variations WHERE product_id=93 AND enabled=1 AND regular_price IN (37760,54280,71980,88500))=4,'PASS','FAIL') result;
SELECT 'accessory exact prices' test,
 IF((SELECT COUNT(*) FROM products WHERE (id=76 AND regular_price=650) OR (id=77 AND regular_price=400) OR (id=78 AND regular_price=680)
       OR (id=79 AND regular_price=850) OR (id=80 AND regular_price=620) OR (id=81 AND regular_price=300) OR (id=82 AND regular_price=680))=7,'PASS','FAIL') result;
SELECT 'Canvas exact prices' test,
 IF((SELECT COUNT(*) FROM product_variations v JOIN products p ON p.id=v.product_id
     WHERE p.slug='canvas-covers' AND v.enabled=1 AND v.regular_price IN (2000,2200,2400))=3,'PASS','FAIL') result;

SELECT 'unknown prices stay NULL' test,
 IF((SELECT COUNT(*) FROM product_option_values WHERE pricing_mode='request_quote' AND price_adjustment IS NOT NULL)=0
    AND (SELECT COUNT(*) FROM products WHERE status='active' AND visibility='visible' AND regular_price=0)=0
    AND (SELECT COUNT(*) FROM product_variations WHERE enabled=1 AND regular_price=0)=0,'PASS','FAIL') result;
SELECT 'Steel colours selectable' test,
 IF((SELECT COUNT(*) FROM product_option_values v JOIN product_option_groups g ON g.id=v.option_group_id
     WHERE g.product_id=96 AND g.option_code='steel_colour' AND g.selection_type='single' AND g.is_required=1 AND g.is_active=1
       AND v.value_code IN ('canary_yellow','signal_red','grey_silver','black') AND v.is_active=1 AND v.pricing_mode='included')=4,'PASS','FAIL') result;
SELECT 'Mobile Countertop related products' test,
 IF((SELECT COUNT(*) FROM product_related_products WHERE product_id=98 AND related_product_id=80 AND is_active=1)=1
    AND (SELECT COUNT(*) FROM product_related_products WHERE product_id=98 AND related_product_id=76 AND is_active=1)=0,'PASS','FAIL') result;
SELECT 'FLINT brochure not public' test,
 IF((SELECT COUNT(*) FROM brochures WHERE enabled=1 AND (title LIKE '%Flint%' OR original_filename LIKE '%FLINT%'))=0,'PASS','FAIL') result;
SELECT 'maintenance disabled' test,
 IF(COALESCE((SELECT setting_value FROM settings WHERE setting_key='maintenance_enabled' LIMIT 1),'0')='0','PASS','FAIL') result;
SELECT 'migration marker' test,
 IF((SELECT meta_value FROM app_meta WHERE meta_key='fire_dine_release_corrections')='implemented','PASS','FAIL') result;
