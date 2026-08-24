SELECT 'protected root categories' check_name,
 IF((SELECT COUNT(*) FROM categories WHERE parent_id IS NULL AND is_active=1)=3
    AND (SELECT COUNT(*) FROM categories WHERE parent_id IS NULL AND is_active=1 AND slug IN ('pizza-ovens','accessories','fireplace'))=3,'PASS','FAIL') result;
SELECT 'protected subcategory parents' check_name,
 IF((SELECT COUNT(*) FROM categories c JOIN categories p ON p.id=c.parent_id WHERE c.is_active=1 AND ((c.slug IN ('domestic','mobile','commercial') AND p.slug='pizza-ovens') OR (c.slug IN ('pizza-oven-utensils-accessories','canvas-covers') AND p.slug='accessories')))=5,'PASS','FAIL') result;
SELECT 'archived products 83 and 106' check_name,
 IF((SELECT COUNT(*) FROM products WHERE id IN (83,106) AND status='archived' AND visibility='hidden')=2,'PASS','FAIL') result;
SELECT 'product 104 out of stock' check_name,
 IF((SELECT COUNT(*) FROM products WHERE id=104 AND stock_status='out_of_stock')=1,'PASS','FAIL') result;
SELECT 'product 98 Rib Rack relationship' check_name,
 IF((SELECT COUNT(*) FROM product_related_products WHERE product_id=98 AND related_product_id=80 AND is_active=1)=1,'PASS','FAIL') result;
SELECT 'unknown prices are not zero' check_name,
 IF((SELECT COUNT(*) FROM products WHERE status='active' AND visibility='visible' AND regular_price=0)=0
    AND (SELECT COUNT(*) FROM product_option_values WHERE pricing_mode='request_quote' AND price_adjustment IS NOT NULL)=0,'PASS','FAIL') result;
SELECT 'quote tax disabled by default' check_name,
 IF((SELECT setting_value FROM settings WHERE setting_key='quote_tax_enabled')='0'
    AND (SELECT setting_value FROM settings WHERE setting_key='quote_tax_rate')='0','PASS','FAIL') result;
SELECT 'broken gallery record disabled' check_name,
 IF((SELECT COUNT(*) FROM gallery_media WHERE title='Luxurious Sunset Fireplace Retreat' AND enabled=1)=0,'PASS','FAIL') result;
SELECT 'enquiry administration tables' check_name,
 IF((SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name IN ('enquiry_status_history','enquiry_email_log'))=2,'PASS','FAIL') result;
SELECT 'release gate marker' check_name,
 IF((SELECT meta_value FROM app_meta WHERE meta_key='fire_dine_release_gate_fixes')='implemented','PASS','FAIL') result;
