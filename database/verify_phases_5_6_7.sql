-- Run after both migrations. Every result must be PASS.
SELECT 'accessory hierarchy' AS test,
 IF((SELECT COUNT(*) FROM categories c JOIN categories p ON p.id=c.parent_id WHERE p.slug='accessories' AND c.slug IN ('pizza-oven-utensils-accessories','canvas-covers') AND c.is_active=1)=2,'PASS','FAIL') AS result;

SELECT 'utensil assignments' AS test,
 IF((SELECT COUNT(*) FROM products p JOIN categories c ON c.id=p.category_id WHERE p.id IN (76,77,78,80,81,82) AND c.slug='pizza-oven-utensils-accessories')=6,'PASS','FAIL') AS result;

SELECT 'flatpack direct assignment' AS test,
 IF((SELECT c.slug FROM products p JOIN categories c ON c.id=p.category_id WHERE p.id=79)='accessories','PASS','FAIL') AS result;

SELECT 'hidden products' AS test,
 IF((SELECT COUNT(*) FROM products WHERE id IN (83,106) AND status<>'active' AND visibility='hidden' AND featured=0)=2,'PASS','FAIL') AS result;

SELECT 'canvas variations' AS test,
 IF((SELECT COUNT(*) FROM product_variations v JOIN products p ON p.id=v.product_id WHERE p.slug='canvas-covers' AND v.enabled=1)=3
    AND (SELECT COUNT(*) FROM product_variations v JOIN products p ON p.id=v.product_id WHERE p.slug='canvas-covers' AND v.enabled=1 AND v.regular_price IN (2000,2200,2400))=3,'PASS','FAIL') AS result;

SELECT 'no public zero prices' AS test,
 IF((SELECT COUNT(*) FROM products WHERE status='active' AND visibility='visible' AND regular_price=0)=0
    AND (SELECT COUNT(*) FROM product_variations v JOIN products p ON p.id=v.product_id WHERE p.status='active' AND p.visibility='visible' AND v.enabled=1 AND v.regular_price=0)=0,'PASS','FAIL') AS result;

SELECT 'internal notes present' AS test,
 IF((SELECT COUNT(*) FROM products WHERE id IN (79,83,106) AND internal_notes IS NOT NULL AND internal_notes<>'')=3,'PASS','FAIL') AS result;

SELECT 'related products safe' AS test,
 IF((SELECT COUNT(*) FROM product_related_products WHERE is_active=1 AND related_product_id IN (83,106))=0,'PASS','FAIL') AS result;

SELECT 'phase marker' AS test,
 IF((SELECT meta_value FROM app_meta WHERE meta_key='fire_dine_phase_5_6_7')='completed','PASS','FAIL') AS result;
