-- Fire & Dine phases 5, 6 and 7
-- Idempotent MariaDB migration. Import after 20260823_fire_dine_phases_2_3_4.sql.
SET NAMES utf8mb4;
SET @fd_previous_sql_mode = @@SQL_MODE;
SET SQL_MODE = CONCAT_WS(',', @@SQL_MODE, 'STRICT_TRANS_TABLES');
START TRANSACTION;

ALTER TABLE `products`
  ADD COLUMN IF NOT EXISTS `internal_notes` text DEFAULT NULL AFTER `attributes_json`;

CREATE TABLE IF NOT EXISTS `product_related_products` (
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `related_product_id` bigint(20) UNSIGNED NOT NULL,
  `context_label` varchar(190) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`product_id`,`related_product_id`),
  KEY `product_related_public_idx` (`product_id`,`is_active`,`display_order`),
  CONSTRAINT `product_related_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_related_related_fk` FOREIGN KEY (`related_product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_related_not_self_chk` CHECK (`product_id` <> `related_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Accessories hierarchy. Existing IDs are retained; new IDs are database-generated.
UPDATE `categories` SET `name`='Accessories',`slug`='accessories',`is_active`=1 WHERE `id`=1;
INSERT INTO `categories` (`name`,`slug`,`description`,`is_active`,`parent_id`,`sort_order`)
SELECT 'Pizza Oven Utensils & Accessories','pizza-oven-utensils-accessories','Tools and accessories for Fire & Dine ovens.',1,1,10
WHERE NOT EXISTS (SELECT 1 FROM `categories` WHERE `slug`='pizza-oven-utensils-accessories');
UPDATE `categories` SET `name`='Pizza Oven Utensils & Accessories',`parent_id`=1,`is_active`=1,`sort_order`=10 WHERE `slug`='pizza-oven-utensils-accessories';
INSERT INTO `categories` (`name`,`slug`,`description`,`is_active`,`parent_id`,`sort_order`)
SELECT 'Canvas Covers','canvas-covers','Protective canvas covers for compatible Fire & Dine ovens.',1,1,20
WHERE NOT EXISTS (SELECT 1 FROM `categories` WHERE `slug`='canvas-covers');
UPDATE `categories` SET `name`='Canvas Covers',`parent_id`=1,`is_active`=1,`sort_order`=20 WHERE `slug`='canvas-covers';
SET @fd_utensils_category_id=(SELECT `id` FROM `categories` WHERE `slug`='pizza-oven-utensils-accessories' LIMIT 1);
SET @fd_canvas_category_id=(SELECT `id` FROM `categories` WHERE `slug`='canvas-covers' LIMIT 1);

UPDATE `products` SET
  `category_id`=@fd_utensils_category_id,`regular_price`=650.00,`sale_price`=NULL,`status`='active',`visibility`='visible',`featured`=0,
  `short_description`='The essential tool for every wood-fired oven. It is used to slide pizza into the oven, turn it for an even bake and remove it once cooked. The long handle keeps the user’s hands away from the heat, and the stainless steel head is easy to wipe clean.',
  `description`='The essential tool for every wood-fired oven. It is used to slide pizza into the oven, turn it for an even bake and remove it once cooked. The long handle keeps the user’s hands away from the heat, and the stainless steel head is easy to wipe clean.',
  `specifications`=JSON_OBJECT('Use','Sliding, turning and removing pizza','Head','Stainless steel'),
  `seo_title`='Stainless Steel Paddle | Fire & Dine',`seo_description`='A long-handled stainless steel paddle for sliding, turning and removing pizza from a wood-fired oven.'
WHERE `id`=76;

UPDATE `products` SET
  `category_id`=@fd_utensils_category_id,`regular_price`=400.00,`sale_price`=NULL,`status`='active',`visibility`='visible',`featured`=0,
  `short_description`='Used to move and control the fire inside the oven. The rake allows the user to bank coals to the side, spread them for even heat or move them forward to create a stronger flame. It helps maintain consistent cooking temperatures.',
  `description`='Used to move and control the fire inside the oven. The rake allows the user to bank coals to the side, spread them for even heat or move them forward to create a stronger flame. It helps maintain consistent cooking temperatures.',
  `specifications`=JSON_OBJECT('Use','Moving and controlling the oven fire'),
  `seo_title`='Stainless Steel Coal Rake | Fire & Dine',`seo_description`='A coal rake for banking, spreading and moving coals to control heat in a wood-fired oven.'
WHERE `id`=77;

UPDATE `products` SET
  `category_id`=@fd_utensils_category_id,`regular_price`=680.00,`sale_price`=NULL,`status`='active',`visibility`='visible',`featured`=0,
  `short_description`='Used for quick and clean ash removal between cooking sessions and after the oven has cooled. It is shaped to fit through the oven door and reach the corners of the oven floor.',
  `description`='Used for quick and clean ash removal between cooking sessions and after the oven has cooled. It is shaped to fit through the oven door and reach the corners of the oven floor.',
  `specifications`=JSON_OBJECT('Use','Ash removal after the oven has cooled'),
  `seo_title`='Ash Shovel | Fire & Dine',`seo_description`='An ash shovel shaped to fit through the oven door and reach the corners of the oven floor.'
WHERE `id`=78;

UPDATE `products` SET
  `category_id`=1,`regular_price`=850.00,`sale_price`=NULL,`status`='active',`visibility`='visible',`featured`=0,
  `short_description`='Flat-packs for convenient transport and storage, fits into a vehicle boot and assembles without tools. Made from solid steel in the Fire & Dine workshop in Vanderbijlpark for camping, the beach, rugby outings or patio use.',
  `description`='The Flatpack Braai flat-packs for convenient transport and storage, fits into a vehicle boot and assembles without tools. It is made from solid steel in the Fire & Dine workshop in Vanderbijlpark and is suitable for camping, the beach, rugby outings or patio use.',
  `specifications`=JSON_OBJECT('Assembly','Tool-free','Construction','Solid steel','Made in','Fire & Dine workshop, Vanderbijlpark'),
  `internal_notes`='Awaiting Fire & Dine confirmation: final public name may be Tassie Braai or Flatpack Braai. Keep Flatpack Braai until confirmed.'
WHERE `id`=79;

UPDATE `products` SET
  `category_id`=@fd_utensils_category_id,`regular_price`=620.00,`sale_price`=NULL,`status`='active',`visibility`='visible',`featured`=0,
  `short_description`='The Rib Rack holds ribs upright so heat can circulate around the meat. It allows more racks to fit in the oven and is also suitable for chops and chicken flatties.',
  `description`='The Rib Rack holds ribs upright so heat can circulate around the meat. It allows more racks to fit in the oven and is also suitable for chops and chicken flatties.',
  `specifications`=JSON_OBJECT('Use','Ribs, chops and chicken flatties'),
  `seo_title`='Rib Rack | Fire & Dine',`seo_description`='Hold ribs upright for circulating heat and fit more racks into the oven.'
WHERE `id`=80;

UPDATE `products` SET
  `category_id`=@fd_utensils_category_id,`regular_price`=300.00,`sale_price`=NULL,`status`='active',`visibility`='visible',`featured`=0,
  `short_description`='Keeps the paddle, coal rake and ash shovel organised and within reach next to the oven.',
  `description`='Keeps the paddle, coal rake and ash shovel organised and within reach next to the oven.',
  `specifications`=JSON_OBJECT('Use','Organising a paddle, coal rake and ash shovel')
WHERE `id`=81;

UPDATE `products` SET
  `name`='Accessory Hanger with Shelf',`category_id`=@fd_utensils_category_id,`regular_price`=680.00,`sale_price`=NULL,`status`='active',`visibility`='visible',`featured`=0,
  `short_description`='Provides hooks for keeping oven utensils organised, together with a shelf for items such as firelighters, matches, a thermometer probe or other small cooking accessories.',
  `description`='Provides hooks for keeping oven utensils organised, together with a shelf for items such as firelighters, matches, a thermometer probe or other small cooking accessories.',
  `specifications`=JSON_OBJECT('Storage','Utensil hooks and shelf')
WHERE `id`=82;

UPDATE `products` SET
  `status`='archived',`visibility`='hidden',`featured`=0,
  `internal_notes`='Awaiting Fire & Dine confirmation: second Rib Rack at R580 may be a separate size or a duplicate.'
WHERE `id`=83;

UPDATE `products` SET
  `description`=NULL,`short_description`=NULL,`status`='archived',`visibility`='hidden',`featured`=0,
  `internal_notes`='Not included in the current approved Fire & Dine Product Guide. Keep hidden until approved.'
WHERE `id`=106;

-- Current catalogue identities remain exact even when this migration is run
-- against a database whose Phase 2–4 data was only partially applied.
UPDATE `products` SET `name`='Forno Neapolitan Range',`slug`='forno-neapolitan-range' WHERE `id`=93;
UPDATE `products` SET `name`='Premium Pre-Fabricato Range',`slug`='premium-pre-fabricato-range' WHERE `id`=94;
UPDATE `products` SET `name`='Premium Mobile Range',`slug`='premium-mobile-range' WHERE `id`=95;
UPDATE `products` SET `name`='Steel Oven Range',`slug`='steel-oven-range' WHERE `id`=96;
UPDATE `products` SET `name`='Counter Top Oven',`slug`='counter-top-oven' WHERE `id`=97;
UPDATE `products` SET `name`='Mobile Countertop Oven',`slug`='mobile-countertop-oven' WHERE `id`=98;
UPDATE `product_variations` SET `attributes_json`=REPLACE(`attributes_json`,'Meastro','Maestro') WHERE `product_id`=95;
UPDATE `products` SET `attributes_json`=REPLACE(`attributes_json`,'Meastro','Maestro') WHERE `id`=95;
UPDATE `products` SET `internal_notes`=CONCAT_WS('\n',NULLIF(`internal_notes`,''),'Awaiting Fire & Dine confirmation: Grande DIY front-to-back measurement is 1,050 mm.')
WHERE `id`=75 AND COALESCE(`internal_notes`,'') NOT LIKE '%Grande DIY front-to-back measurement is 1,050 mm%';

-- Canvas Covers: no unambiguously approved product image was present, so the
-- application uses the official Fire & Dine logo fallback without assigning unrelated media.
INSERT INTO `products`
 (`name`,`sku`,`slug`,`description`,`category_id`,`regular_price`,`stock_quantity`,`status`,`featured`,`thumbnail_media_id`,`catalog_id`,`short_description`,`sale_price`,`stock_status`,`brand`,`tags`,`specifications`,`sort_order`,`seo_title`,`seo_description`,`source_system`,`source_id`,`product_type`,`visibility`,`backorders`,`sold_individually`,`attributes_json`,`internal_notes`)
SELECT
 'Canvas Covers','fd-canvas-covers','canvas-covers',
 'Protect your Fire & Dine oven with a durable canvas cover designed for a neat fit, lasting protection and a clean finished appearance. Canvas covers are available in sizes to suit compatible Fire & Dine ovens. Available colour families: canvas beige, autumn brown, olive and dark options. Add a preferred colour to the quote notes.',
 @fd_canvas_category_id,NULL,0,'active',0,NULL,NULL,
 'Protect your Fire & Dine oven with a durable canvas cover designed for a neat fit, lasting protection and a clean finished appearance. Canvas covers are available in sizes to suit compatible Fire & Dine ovens.',
 NULL,'in_stock','Fire & Dine','canvas cover,oven cover',JSON_OBJECT('Available sizes',JSON_ARRAY('Small','Medium','Large'),'Colour families',JSON_ARRAY('Canvas beige','Autumn brown','Olive','Dark options')),20,
 'Canvas Covers | Fire & Dine','Durable canvas covers in Small, Medium and Large for compatible Fire & Dine ovens.',
 'fire-and-dine',NULL,'variable','visible','no',1,JSON_OBJECT('Size',JSON_ARRAY('Small','Medium','Large')),
 'Awaiting Fire & Dine confirmation: final Canvas Cover colour names and availability. Preferred colour may be supplied in quote notes.'
WHERE NOT EXISTS (SELECT 1 FROM `products` WHERE `slug`='canvas-covers');
SET @fd_canvas_product_id=(SELECT `id` FROM `products` WHERE `slug`='canvas-covers' LIMIT 1);
UPDATE `products` SET `name`='Canvas Covers',`category_id`=@fd_canvas_category_id,`product_type`='variable',`status`='active',`visibility`='visible',`stock_status`='in_stock',`featured`=0 WHERE `id`=@fd_canvas_product_id;
UPDATE `product_variations` SET `enabled`=0 WHERE `product_id`=@fd_canvas_product_id AND (`sku` IS NULL OR `sku` NOT IN ('fd-canvas-covers-small','fd-canvas-covers-medium','fd-canvas-covers-large'));
INSERT INTO `product_variations` (`product_id`,`source_system`,`sku`,`regular_price`,`stock_quantity`,`stock_status`,`backorders`,`position`,`attributes_json`,`enabled`)
SELECT @fd_canvas_product_id,'fire-and-dine','fd-canvas-covers-small',2000.00,0,'in_stock','no',1,JSON_OBJECT('Size','Small'),1
WHERE NOT EXISTS (SELECT 1 FROM `product_variations` WHERE `product_id`=@fd_canvas_product_id AND `sku`='fd-canvas-covers-small');
INSERT INTO `product_variations` (`product_id`,`source_system`,`sku`,`regular_price`,`stock_quantity`,`stock_status`,`backorders`,`position`,`attributes_json`,`enabled`)
SELECT @fd_canvas_product_id,'fire-and-dine','fd-canvas-covers-medium',2200.00,0,'in_stock','no',2,JSON_OBJECT('Size','Medium'),1
WHERE NOT EXISTS (SELECT 1 FROM `product_variations` WHERE `product_id`=@fd_canvas_product_id AND `sku`='fd-canvas-covers-medium');
INSERT INTO `product_variations` (`product_id`,`source_system`,`sku`,`regular_price`,`stock_quantity`,`stock_status`,`backorders`,`position`,`attributes_json`,`enabled`)
SELECT @fd_canvas_product_id,'fire-and-dine','fd-canvas-covers-large',2400.00,0,'in_stock','no',3,JSON_OBJECT('Size','Large'),1
WHERE NOT EXISTS (SELECT 1 FROM `product_variations` WHERE `product_id`=@fd_canvas_product_id AND `sku`='fd-canvas-covers-large');
UPDATE `product_variations` SET `source_system`='fire-and-dine',`regular_price`=2000.00,`sale_price`=NULL,`stock_status`='in_stock',`position`=1,`attributes_json`=JSON_OBJECT('Size','Small'),`enabled`=1 WHERE `product_id`=@fd_canvas_product_id AND `sku`='fd-canvas-covers-small';
UPDATE `product_variations` SET `source_system`='fire-and-dine',`regular_price`=2200.00,`sale_price`=NULL,`stock_status`='in_stock',`position`=2,`attributes_json`=JSON_OBJECT('Size','Medium'),`enabled`=1 WHERE `product_id`=@fd_canvas_product_id AND `sku`='fd-canvas-covers-medium';
UPDATE `product_variations` SET `source_system`='fire-and-dine',`regular_price`=2400.00,`sale_price`=NULL,`stock_status`='in_stock',`position`=3,`attributes_json`=JSON_OBJECT('Size','Large'),`enabled`=1 WHERE `product_id`=@fd_canvas_product_id AND `sku`='fd-canvas-covers-large';

-- Deliberate initial related-product mappings. Premium Mobile excludes its
-- included paddle/rack; the release correction adds the optional Rib Rack to
-- Mobile Countertop while continuing to exclude its included paddle.
DELETE FROM `product_related_products` WHERE `product_id` IN (75,93,94,95,96,97,98);
INSERT INTO `product_related_products` (`product_id`,`related_product_id`,`context_label`,`display_order`) VALUES
 (75,76,NULL,10),(75,77,NULL,20),(75,78,NULL,30),(75,80,NULL,40),(75,81,NULL,50),(75,82,NULL,60),(75,@fd_canvas_product_id,NULL,70),
 (93,76,NULL,10),(93,77,NULL,20),(93,78,NULL,30),(93,80,NULL,40),(93,81,NULL,50),(93,82,NULL,60),(93,@fd_canvas_product_id,NULL,70),
 (94,76,NULL,10),(94,77,NULL,20),(94,78,NULL,30),(94,80,NULL,40),(94,81,NULL,50),(94,82,NULL,60),(94,@fd_canvas_product_id,NULL,70),
 (95,77,NULL,10),(95,78,NULL,20),(95,81,NULL,30),(95,82,NULL,40),(95,@fd_canvas_product_id,NULL,50),
 (96,76,NULL,10),(96,77,NULL,20),(96,78,NULL,30),(96,80,NULL,40),(96,81,NULL,50),(96,82,NULL,60),(96,@fd_canvas_product_id,NULL,70),
 (97,76,NULL,10),(97,77,NULL,20),(97,78,NULL,30),(97,80,NULL,40),(97,81,NULL,50),(97,82,NULL,60),(97,@fd_canvas_product_id,NULL,70),
 (98,77,NULL,10),(98,78,NULL,20),(98,81,NULL,30),(98,82,NULL,40),(98,@fd_canvas_product_id,NULL,50)
ON DUPLICATE KEY UPDATE `context_label`=VALUES(`context_label`),`display_order`=VALUES(`display_order`),`is_active`=1;

DELETE r FROM `product_related_products` r JOIN `products` p ON p.id=r.related_product_id
WHERE p.id IN (83,106) OR p.status<>'active' OR p.visibility<>'visible';

INSERT INTO `app_meta` (`meta_key`,`meta_value`,`updated_at`) VALUES
 ('fire_dine_phase_5_6_7','completed',NOW()),
 ('fire_dine_catalogue_cache_version',DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),NOW())
ON DUPLICATE KEY UPDATE `meta_value`=VALUES(`meta_value`),`updated_at`=VALUES(`updated_at`);

COMMIT;
SET SQL_MODE = @fd_previous_sql_mode;
