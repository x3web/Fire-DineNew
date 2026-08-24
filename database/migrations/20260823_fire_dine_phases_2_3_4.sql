-- Fire & Dine: Phases 2, 3 and 4 database migration
-- Target: MariaDB 10.11+
-- Safe to run repeatedly. Existing product/media/source IDs and historical quote rows are preserved.

SET NAMES utf8mb4;
SET @fd_previous_sql_mode = @@SQL_MODE;
SET SQL_MODE = CONCAT_WS(',', @@SQL_MODE, 'STRICT_TRANS_TABLES');

CREATE TABLE IF NOT EXISTS `product_option_groups` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `option_code` varchar(100) NOT NULL,
  `public_label` varchar(190) NOT NULL,
  `selection_type` enum('single','multiple','display') NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `metadata_json` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_option_groups_product_code_unique` (`product_id`,`option_code`),
  KEY `product_option_groups_public_idx` (`product_id`,`is_active`,`display_order`),
  CONSTRAINT `product_option_groups_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_option_groups_metadata_json_chk` CHECK (`metadata_json` IS NULL OR json_valid(`metadata_json`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `product_option_values` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `option_group_id` bigint(20) UNSIGNED NOT NULL,
  `value_code` varchar(100) NOT NULL,
  `public_label` varchar(190) NOT NULL,
  `price_adjustment` decimal(12,2) DEFAULT NULL,
  `pricing_mode` enum('included','fixed','additive','request_quote') NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `conditions_json` longtext DEFAULT NULL,
  `metadata_json` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_option_values_group_code_unique` (`option_group_id`,`value_code`),
  KEY `product_option_values_public_idx` (`option_group_id`,`is_active`,`display_order`),
  CONSTRAINT `product_option_values_group_fk` FOREIGN KEY (`option_group_id`) REFERENCES `product_option_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_option_values_conditions_json_chk` CHECK (`conditions_json` IS NULL OR json_valid(`conditions_json`)),
  CONSTRAINT `product_option_values_metadata_json_chk` CHECK (`metadata_json` IS NULL OR json_valid(`metadata_json`)),
  CONSTRAINT `product_option_values_quote_price_chk` CHECK (`pricing_mode` <> 'request_quote' OR `price_adjustment` IS NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `product_slug_redirects` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `old_slug` varchar(190) NOT NULL,
  `new_slug` varchar(190) NOT NULL,
  `redirect_code` smallint(5) UNSIGNED NOT NULL DEFAULT 301,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_slug_redirects_old_slug_unique` (`old_slug`),
  KEY `product_slug_redirects_product_idx` (`product_id`,`is_active`),
  CONSTRAINT `product_slug_redirects_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_slug_redirects_code_chk` CHECK (`redirect_code` IN (301,308))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `quote_items`
  ADD COLUMN IF NOT EXISTS `selected_options_json` longtext DEFAULT NULL AFTER `variation_snapshot`,
  ADD COLUMN IF NOT EXISTS `requires_custom_quote` tinyint(1) NOT NULL DEFAULT 0 AFTER `selected_options_json`,
  ADD COLUMN IF NOT EXISTS `base_price` decimal(12,2) DEFAULT NULL AFTER `requires_custom_quote`,
  ADD COLUMN IF NOT EXISTS `confirmed_option_price` decimal(12,2) NOT NULL DEFAULT 0.00 AFTER `base_price`,
  ADD COLUMN IF NOT EXISTS `final_confirmed_price` decimal(12,2) DEFAULT NULL AFTER `confirmed_option_price`;

DROP PROCEDURE IF EXISTS `fd_migrate_phases_2_3_4`;
DELIMITER $$
CREATE PROCEDURE `fd_migrate_phases_2_3_4`()
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    DROP TEMPORARY TABLE IF EXISTS `tmp_fd_option_groups`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_fd_option_values`;
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

  IF NOT EXISTS (SELECT 1 FROM `categories` WHERE `slug`='pizza-ovens' AND `name`='Pizza Ovens' AND `parent_id` IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Phase 2 aborted: top-level Pizza Ovens category not found';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM `categories` WHERE `slug`='accessories' AND `name`='Accessories' AND `parent_id` IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Phase 2 aborted: top-level Accessories category not found';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM `categories` WHERE `slug`='fireplace' AND `name`='Fireplace' AND `parent_id` IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Phase 2 aborted: top-level Fireplace category not found';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM `products` WHERE `id`=75 AND `sku`='wc-370' AND `name`='Premium DIY Range') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 75 identity mismatch'; END IF;
  IF NOT EXISTS (SELECT 1 FROM `products` WHERE `id`=93 AND `sku`='wc-1233' AND `name` IN ('Neapolitan Commercial Range','Forno Neapolitan Range')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 93 identity mismatch'; END IF;
  IF NOT EXISTS (SELECT 1 FROM `products` WHERE `id`=94 AND `sku`='wc-1250' AND `name` IN ('Fabricato Commercial Range','Premium Pre-Fabricato Range')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 94 identity mismatch'; END IF;
  IF NOT EXISTS (SELECT 1 FROM `products` WHERE `id`=95 AND `sku`='wc-1267' AND `name`='Premium Mobile Range') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 95 identity mismatch'; END IF;
  IF NOT EXISTS (SELECT 1 FROM `products` WHERE `id`=96 AND `sku`='wc-1280' AND `name`='Steel Oven Range') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 96 identity mismatch'; END IF;
  IF NOT EXISTS (SELECT 1 FROM `products` WHERE `id`=97 AND `sku`='wc-1293' AND `name` IN ('Countertop Oven','Counter Top Oven')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 97 identity mismatch'; END IF;
  IF NOT EXISTS (SELECT 1 FROM `products` WHERE `id`=98 AND `sku`='wc-1486' AND `name`='Mobile Countertop Oven') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 98 identity mismatch'; END IF;

  IF EXISTS (SELECT 1 FROM `products` WHERE `slug`='counter-top-oven' AND `id`<>97) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Slug counter-top-oven belongs to another product'; END IF;
  IF EXISTS (SELECT 1 FROM `products` WHERE `slug`='premium-pre-fabricato-range' AND `id`<>94) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Slug premium-pre-fabricato-range belongs to another product'; END IF;
  IF EXISTS (SELECT 1 FROM `products` WHERE `slug`='forno-neapolitan-range' AND `id`<>93) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Slug forno-neapolitan-range belongs to another product'; END IF;

  INSERT INTO `categories` (`name`,`slug`,`description`,`is_active`,`catalog_id`,`parent_id`,`image_media_id`,`sort_order`)
  SELECT 'Domestic','domestic',NULL,1,p.`catalog_id`,p.`id`,NULL,10 FROM `categories` p WHERE p.`slug`='pizza-ovens'
  ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`is_active`=1,`catalog_id`=VALUES(`catalog_id`),`parent_id`=VALUES(`parent_id`),`sort_order`=10;
  INSERT INTO `categories` (`name`,`slug`,`description`,`is_active`,`catalog_id`,`parent_id`,`image_media_id`,`sort_order`)
  SELECT 'Mobile','mobile',NULL,1,p.`catalog_id`,p.`id`,NULL,20 FROM `categories` p WHERE p.`slug`='pizza-ovens'
  ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`is_active`=1,`catalog_id`=VALUES(`catalog_id`),`parent_id`=VALUES(`parent_id`),`sort_order`=20;
  INSERT INTO `categories` (`name`,`slug`,`description`,`is_active`,`catalog_id`,`parent_id`,`image_media_id`,`sort_order`)
  SELECT 'Commercial','commercial',NULL,1,p.`catalog_id`,p.`id`,NULL,30 FROM `categories` p WHERE p.`slug`='pizza-ovens'
  ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`is_active`=1,`catalog_id`=VALUES(`catalog_id`),`parent_id`=VALUES(`parent_id`),`sort_order`=30;
  INSERT INTO `categories` (`name`,`slug`,`description`,`is_active`,`catalog_id`,`parent_id`,`image_media_id`,`sort_order`)
  SELECT 'Pizza Oven Utensils & Accessories','pizza-oven-utensils-accessories',NULL,1,p.`catalog_id`,p.`id`,NULL,10 FROM `categories` p WHERE p.`slug`='accessories'
  ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`is_active`=1,`catalog_id`=VALUES(`catalog_id`),`parent_id`=VALUES(`parent_id`),`sort_order`=10;
  INSERT INTO `categories` (`name`,`slug`,`description`,`is_active`,`catalog_id`,`parent_id`,`image_media_id`,`sort_order`)
  SELECT 'Canvas Covers','canvas-covers',NULL,1,p.`catalog_id`,p.`id`,NULL,20 FROM `categories` p WHERE p.`slug`='accessories'
  ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`is_active`=1,`catalog_id`=VALUES(`catalog_id`),`parent_id`=VALUES(`parent_id`),`sort_order`=20;

  UPDATE `products` SET `category_id`=(SELECT `id` FROM `categories` WHERE `slug`='domestic') WHERE `id` IN (75,97);
  UPDATE `products` SET `category_id`=(SELECT `id` FROM `categories` WHERE `slug`='mobile') WHERE `id` IN (95,98);
  UPDATE `products` SET `category_id`=(SELECT `id` FROM `categories` WHERE `slug`='commercial') WHERE `id` IN (93,94,96);
  UPDATE `products` SET `category_id`=(SELECT `id` FROM `categories` WHERE `slug`='pizza-oven-utensils-accessories') WHERE `id` IN (76,77,78,80,81,82);
  UPDATE `products` SET `category_id`=(SELECT `id` FROM `categories` WHERE `slug`='accessories') WHERE `id`=79;

  INSERT INTO `product_slug_redirects` (`product_id`,`old_slug`,`new_slug`,`redirect_code`,`is_active`) VALUES
    (97,'countertop-oven','counter-top-oven',301,1),
    (94,'fabricato-commercial-range','premium-pre-fabricato-range',301,1),
    (93,'neapolitan-commercial-range','forno-neapolitan-range',301,1)
  ON DUPLICATE KEY UPDATE `product_id`=VALUES(`product_id`),`new_slug`=VALUES(`new_slug`),`redirect_code`=301,`is_active`=1;

  UPDATE `products` SET
    `name`='Premium DIY Range', `slug`='premium-diy-range', `regular_price`=NULL, `sale_price`=NULL,
    `stock_status`='in_stock', `product_type`='variable', `attributes_json`=JSON_OBJECT('Size',JSON_ARRAY('Standard','Grande','Superior')),
    `short_description`='Three-model DIY pizza oven range with included finish choices and optional extras.',
    `description`='<h3>Premium DIY Range</h3><p>Available in Standard, Grande and Superior models.</p><h3>Standard inclusions</h3><ul><li>Floor insulation</li><li>Mild steel door with thermometer in the door</li><li>430 stainless steel flue and pipe</li><li>Smooth coating in a colour of the customer''s choice</li><li>Brick-face front in a colour of the customer''s choice when used with a plain smooth finish</li></ul><h3>Optional extras</h3><ul><li>Separate built-in thermometer</li><li>Textured finish</li><li>Coastal kit</li><li>Mosaic</li><li>Oven trolley</li><li>Canvas cover</li></ul>',
    `specifications`=JSON_OBJECT(
      'layout','model_table',
      'columns',JSON_ARRAY(JSON_OBJECT('key','model','label','Model'),JSON_OBJECT('key','front_to_back','label','Front to back'),JSON_OBJECT('key','side_to_side','label','Side to side'),JSON_OBJECT('key','price','label','Price')),
      'models',JSON_ARRAY(
        JSON_OBJECT('model','Standard','front_to_back','950 mm','side_to_side','820 mm','price',10300),
        JSON_OBJECT('model','Grande','front_to_back','1,050 mm','side_to_side','920 mm','price',11800),
        JSON_OBJECT('model','Superior','front_to_back','1,200 mm','side_to_side','1,020 mm','price',13600)
      ),
      'standard_inclusions',JSON_ARRAY('Floor insulation','Mild steel door with thermometer in the door','430 stainless steel flue and pipe','Smooth coating in a colour of the customer''s choice','Brick-face front in a colour of the customer''s choice when used with a plain smooth finish'),
      'finish_rules',JSON_OBJECT('smooth','Included','brick_face','Included with plain smooth finish','textured','Request Quote'),
      'confirmation_notes',JSON_ARRAY('Grande front-to-back measurement of 1,050 mm requires confirmation.','Final textured-colour list requires confirmation.','Oven trolley details and price require confirmation.','Canvas-cover size mapping requires confirmation.')
    )
  WHERE `id`=75;

  UPDATE `products` SET
    `name`='Counter Top Oven', `slug`='counter-top-oven', `regular_price`=11600.00, `sale_price`=NULL,
    `stock_status`='in_stock', `product_type`='simple', `attributes_json`=JSON_OBJECT(),
    `short_description`='Compact Counter Top Oven for up to two pizzas, with product-specific finish and optional-extra choices.',
    `description`='<h3>Counter Top Oven</h3><p>A compact oven with capacity for up to two pizzas at a time.</p><h3>Standard inclusions</h3><ul><li>Oven door</li><li>Flue pipe</li><li>Applicable included DIY finish rules</li></ul><h3>Optional extras</h3><ul><li>Built-in thermometer</li><li>StoneSkin</li><li>Coastal kit</li><li>Mosaic</li><li>Textured finish</li></ul>',
    `specifications`=JSON_OBJECT(
      'layout','key_value',
      'fields',JSON_ARRAY(JSON_OBJECT('label','Depth, front to back','value','640 mm'),JSON_OBJECT('label','Width, side to side','value','920 mm'),JSON_OBJECT('label','Capacity','value','Up to two pizzas at a time')),
      'standard_inclusions',JSON_ARRAY('Oven door','Flue pipe','Applicable included DIY finish rules'),
      'finish_rules',JSON_OBJECT('smooth','Included','brick_face','Included with plain smooth finish','textured','Request Quote'),
      'confirmation_notes',JSON_ARRAY('Final textured-colour list requires confirmation.')
    )
  WHERE `id`=97;

  UPDATE `products` SET
    `name`='Premium Mobile Range', `slug`='premium-mobile-range', `regular_price`=NULL, `sale_price`=NULL,
    `stock_status`='in_stock', `product_type`='variable',
    `attributes_json`=JSON_OBJECT('Size',JSON_ARRAY('Piccolo','Grande','Superior'),'Trolley Configuration',JSON_ARRAY('With collapsible-side-table trolley','With trolley without side table','Without trolley')),
    `short_description`='Mobile pizza oven range with nine exact size-and-trolley configurations.',
    `description`='<h3>Premium Mobile Range</h3><p>Choose one oven size and one trolley configuration.</p><h3>Standard inclusions</h3><ul><li>Built into a steel transport frame</li><li>Trolley with collapsible side table in the listed standard price</li><li>Built-in thermometer</li><li>Stainless steel door</li><li>Stainless steel spigot</li><li>304 stainless steel brushed flue pipe</li><li>Storm cowl</li><li>Paddle</li><li>Rack</li></ul><h3>Optional extras</h3><ul><li>Additional flue pipes</li><li>Mosaic</li><li>Canvas cover</li></ul>',
    `specifications`=JSON_OBJECT(
      'layout','variation_matrix',
      'columns',JSON_ARRAY(JSON_OBJECT('key','model','label','Model'),JSON_OBJECT('key','trolley','label','Trolley configuration'),JSON_OBJECT('key','price','label','Price')),
      'defaults',JSON_OBJECT('Trolley Configuration','With collapsible-side-table trolley'),
      'standard_inclusions',JSON_ARRAY('Built into a steel transport frame','Trolley with collapsible side table in the listed standard price','Built-in thermometer','Stainless steel door','Stainless steel spigot','304 stainless steel brushed flue pipe','Storm cowl','Paddle','Rack'),
      'confirmation_notes',JSON_ARRAY('Piccolo, Grande and Superior model names require final confirmation.','Canvas-cover mapping requires confirmation.')
    )
  WHERE `id`=95;

  UPDATE `products` SET
    `name`='Mobile Countertop Oven', `slug`='mobile-countertop-oven', `regular_price`=18900.00, `sale_price`=NULL,
    `stock_status`='in_stock', `product_type`='simple', `attributes_json`=JSON_OBJECT(),
    `short_description`='Mobile Countertop Oven requiring no installation, with trolley and gas-conversion choices.',
    `description`='<h3>Mobile Countertop Oven</h3><p>A one-piece mobile oven that requires no installation and has capacity for up to two pizzas at a time.</p><h3>Standard inclusions</h3><ul><li>One-piece floor and dome</li><li>Mobile unit requiring no installation</li><li>Stainless steel flue pipe</li><li>Storm cowl</li><li>Built-in thermometer</li><li>Textured finish</li><li>Paddle</li><li>Firebrick floor</li></ul><h3>Optional extras</h3><ul><li>Trolley configuration</li><li>Gas conversion</li><li>Additional flue pipes</li><li>Mosaic</li><li>Canvas cover</li></ul>',
    `specifications`=JSON_OBJECT(
      'layout','key_value',
      'fields',JSON_ARRAY(JSON_OBJECT('label','Dimensions','value','640 × 920 mm'),JSON_OBJECT('label','Capacity','value','Up to two pizzas at a time')),
      'standard_inclusions',JSON_ARRAY('One-piece floor and dome','Mobile unit requiring no installation','Stainless steel flue pipe','Storm cowl','Built-in thermometer','Textured finish','Paddle','Firebrick floor'),
      'confirmation_notes',JSON_ARRAY('Final wording for the firebrick floor requires confirmation.','Canvas-cover mapping requires confirmation.')
    )
  WHERE `id`=98;

  UPDATE `products` SET
    `name`='Steel Oven Range', `slug`='steel-oven-range', `regular_price`=NULL, `sale_price`=NULL,
    `stock_status`='in_stock', `product_type`='variable', `attributes_json`=JSON_OBJECT('Size',JSON_ARRAY('Standard','Grande','Superior')),
    `short_description`='Three-model steel pizza oven range with model-specific dimensions, included colour choices and optional extras.',
    `description`='<h3>Steel Oven Range</h3><p>Available in Standard, Grande and Superior models.</p><h3>Included colour</h3><p>Included steel colour — final colour confirmed during quotation.</p><h3>Optional extras</h3><ul><li>Built-in thermometer</li><li>Coastal kit</li></ul>',
    `specifications`=JSON_OBJECT(
      'layout','model_table',
      'columns',JSON_ARRAY(JSON_OBJECT('key','model','label','Model'),JSON_OBJECT('key','inner','label','Inner size'),JSON_OBJECT('key','outer','label','Outer size'),JSON_OBJECT('key','door','label','Door size'),JSON_OBJECT('key','chimney','label','Chimney diameter'),JSON_OBJECT('key','price','label','Price')),
      'models',JSON_ARRAY(
        JSON_OBJECT('model','Standard','legacy_label','Small','inner','500 × 890 mm','outer','600 × 1,020 mm','door','240 × 435 mm','chimney','130 mm','price',13800),
        JSON_OBJECT('model','Grande','legacy_label','Medium','inner','810 × 890 mm','outer','970 × 1,020 mm','door','270 × 600 mm','chimney','150 mm','price',26000),
        JSON_OBJECT('model','Superior','legacy_label','Large','inner','1,100 × 1,094 mm','outer','1,180 × 1,260 mm','door','260 × 860 mm','chimney','170 mm','price',39500)
      ),
      'included_choice','Included steel colour — final colour confirmed during quotation.',
      'provisional_colours',JSON_ARRAY('Canary Yellow','Signal Red','Grey/Silver','Black'),
      'confirmation_notes',JSON_ARRAY('Final Steel Range colour list requires confirmation.')
    )
  WHERE `id`=96;

  UPDATE `products` SET
    `name`='Premium Pre-Fabricato Range', `slug`='premium-pre-fabricato-range', `regular_price`=NULL, `sale_price`=NULL,
    `stock_status`='in_stock', `product_type`='variable', `attributes_json`=JSON_OBJECT('Size',JSON_ARRAY('Standard','Grande','Superior','Ultra')),
    `short_description`='Pre-Fabricato oven range for restaurants, guesthouses and homes passionate about authentic wood-fired cooking.',
    `description`='<h3>Premium Pre-Fabricato Range</h3><p>Designed for restaurants, guesthouses and homes with a passion for authentic wood-fired cooking.</p><h3>Standard inclusions</h3><ul><li>Textured finish</li><li>Smooth coating as an included alternative</li><li>One-piece floor and dome</li><li>Storm cowl</li><li>Brushed flue pipe</li></ul><h3>Optional extras</h3><ul><li>Built-in thermometer</li><li>Coastal kit</li><li>Stainless steel spigot and door</li><li>Mosaic</li><li>Canvas cover</li></ul>',
    `specifications`=JSON_OBJECT(
      'layout','model_table',
      'columns',JSON_ARRAY(JSON_OBJECT('key','model','label','Model'),JSON_OBJECT('key','outside','label','Outside dimensions'),JSON_OBJECT('key','inside_diameter','label','Inside diameter'),JSON_OBJECT('key','weight','label','Weight'),JSON_OBJECT('key','capacity','label','Capacity'),JSON_OBJECT('key','price','label','Price')),
      'models',JSON_ARRAY(
        JSON_OBJECT('model','Standard','outside','1,250 × 1,150 mm','inside_diameter','800 mm','weight','360 kg','capacity','3 pizzas','price',32000),
        JSON_OBJECT('model','Grande','outside','1,350 × 1,250 mm','inside_diameter','900 mm','weight','580 kg','capacity','4 pizzas','price',39000),
        JSON_OBJECT('model','Superior','outside','1,500 × 1,500 mm','inside_diameter','1,140 mm','weight','780 kg','capacity','5 pizzas','price',55000),
        JSON_OBJECT('model','Ultra','outside','1,800 × 1,800 mm','inside_diameter','1,300 mm','weight','1,200 kg','capacity','6 pizzas','price',66000)
      ),
      'positioning',JSON_ARRAY('Restaurants','Guesthouses','Homes with a passion for authentic wood-fired cooking'),
      'standard_inclusions',JSON_ARRAY('Textured finish','Smooth coating as an included alternative','One-piece floor and dome','Storm cowl','Brushed flue pipe'),
      'confirmation_notes',JSON_ARRAY('Final flue-pipe material requires confirmation.','Built-in thermometer price for this range requires confirmation.','Ultra canvas-cover size and price mapping requires confirmation.')
    )
  WHERE `id`=94;

  UPDATE `products` SET
    `name`='Forno Neapolitan Range', `slug`='forno-neapolitan-range', `regular_price`=NULL, `sale_price`=NULL,
    `stock_status`='in_stock', `product_type`='variable', `attributes_json`=JSON_OBJECT('Size',JSON_ARRAY('Piccolo','Classico','Grande','Maestro')),
    `short_description`='Four-model Forno Neapolitan range with coastal-ready construction, included thermometers and logo tiling.',
    `description`='<h3>Forno Neapolitan Range</h3><h3>Standard construction</h3><ul><li>Heavy-duty steel frame</li><li>Walls and dome cast 80 mm thick</li><li>Dense 1600-grade material</li><li>100 mm ceramic blanket dome insulation</li><li>Lightweight external insulation</li><li>Coastal-ready construction</li><li>Built-in thermometer</li><li>Door-mounted thermometer</li><li>1.2-metre flue pipe</li><li>Storm cowl</li></ul><h3>Logo tiling</h3><ul><li>Customer logo tiled onto the front of the oven</li><li>Tiled area extends 300 mm to the left and 300 mm to the right of the door</li><li>Logo tiling in up to two colours is included</li><li>More than two colours requires a custom quote</li></ul>',
    `specifications`=JSON_OBJECT(
      'layout','model_table',
      'columns',JSON_ARRAY(JSON_OBJECT('key','model','label','Model'),JSON_OBJECT('key','inside_diameter','label','Inside diameter'),JSON_OBJECT('key','outside_diameter','label','Outside diameter'),JSON_OBJECT('key','capacity','label','Capacity'),JSON_OBJECT('key','price','label','Price')),
      'models',JSON_ARRAY(
        JSON_OBJECT('model','Piccolo','legacy_label','Small','inside_diameter','800 mm','outside_diameter','1,000 mm','capacity','2–3 medium pizzas','price',37760),
        JSON_OBJECT('model','Classico','legacy_label','Medium','inside_diameter','950 mm','outside_diameter','1,240 mm','capacity','4 pizzas','price',54280),
        JSON_OBJECT('model','Grande','legacy_label','Large','inside_diameter','1,280 mm','outside_diameter','1,600 mm','capacity','6–7 pizzas','price',71980),
        JSON_OBJECT('model','Maestro','legacy_label','Extra Large','inside_diameter','1,500 mm','outside_diameter','1,900 mm','capacity','8–10 pizzas','price',88500)
      ),
      'standard_construction',JSON_ARRAY('Heavy-duty steel frame','Walls and dome cast 80 mm thick','Dense 1600-grade material','100 mm ceramic blanket dome insulation','Lightweight external insulation','Coastal-ready construction','Built-in thermometer','Door-mounted thermometer','1.2-metre flue pipe','Storm cowl'),
      'logo_tiling',JSON_OBJECT('front_left','300 mm','front_right','300 mm','up_to_two_colours','Included','three_or_more_colours','Request Quote'),
      'confirmation_notes',JSON_ARRAY()
    )
  WHERE `id`=93;

  UPDATE `product_variations` SET `enabled`=0 WHERE `product_id` IN (75,93,94,95,96,97,98);

  INSERT INTO `product_variations` (`product_id`,`source_system`,`source_id`,`sku`,`regular_price`,`sale_price`,`stock_quantity`,`stock_status`,`backorders`,`position`,`attributes_json`,`enabled`) VALUES
    (75,'x3web_phase_2_4',75001,NULL,10300,NULL,NULL,'in_stock','no',1,JSON_OBJECT('Size','Standard'),1),
    (75,'x3web_phase_2_4',75002,NULL,11800,NULL,NULL,'in_stock','no',2,JSON_OBJECT('Size','Grande'),1),
    (75,'x3web_phase_2_4',75003,NULL,13600,NULL,NULL,'in_stock','no',3,JSON_OBJECT('Size','Superior'),1),
    (95,'x3web_phase_2_4',95001,NULL,22200,NULL,NULL,'in_stock','no',1,JSON_OBJECT('Size','Piccolo','Trolley Configuration','With collapsible-side-table trolley'),1),
    (95,'x3web_phase_2_4',95002,NULL,21000,NULL,NULL,'in_stock','no',2,JSON_OBJECT('Size','Piccolo','Trolley Configuration','With trolley without side table'),1),
    (95,'x3web_phase_2_4',95003,NULL,16800,NULL,NULL,'in_stock','no',3,JSON_OBJECT('Size','Piccolo','Trolley Configuration','Without trolley'),1),
    (95,'x3web_phase_2_4',95004,NULL,29800,NULL,NULL,'in_stock','no',4,JSON_OBJECT('Size','Grande','Trolley Configuration','With collapsible-side-table trolley'),1),
    (95,'x3web_phase_2_4',95005,NULL,28800,NULL,NULL,'in_stock','no',5,JSON_OBJECT('Size','Grande','Trolley Configuration','With trolley without side table'),1),
    (95,'x3web_phase_2_4',95006,NULL,23600,NULL,NULL,'in_stock','no',6,JSON_OBJECT('Size','Grande','Trolley Configuration','Without trolley'),1),
    (95,'x3web_phase_2_4',95007,NULL,33200,NULL,NULL,'in_stock','no',7,JSON_OBJECT('Size','Superior','Trolley Configuration','With collapsible-side-table trolley'),1),
    (95,'x3web_phase_2_4',95008,NULL,32500,NULL,NULL,'in_stock','no',8,JSON_OBJECT('Size','Superior','Trolley Configuration','With trolley without side table'),1),
    (95,'x3web_phase_2_4',95009,NULL,27300,NULL,NULL,'in_stock','no',9,JSON_OBJECT('Size','Superior','Trolley Configuration','Without trolley'),1),
    (96,'x3web_phase_2_4',96001,NULL,13800,NULL,NULL,'in_stock','no',1,JSON_OBJECT('Size','Standard'),1),
    (96,'x3web_phase_2_4',96002,NULL,26000,NULL,NULL,'in_stock','no',2,JSON_OBJECT('Size','Grande'),1),
    (96,'x3web_phase_2_4',96003,NULL,39500,NULL,NULL,'in_stock','no',3,JSON_OBJECT('Size','Superior'),1),
    (94,'x3web_phase_2_4',94001,NULL,32000,NULL,NULL,'in_stock','no',1,JSON_OBJECT('Size','Standard'),1),
    (94,'x3web_phase_2_4',94002,NULL,39000,NULL,NULL,'in_stock','no',2,JSON_OBJECT('Size','Grande'),1),
    (94,'x3web_phase_2_4',94003,NULL,55000,NULL,NULL,'in_stock','no',3,JSON_OBJECT('Size','Superior'),1),
    (94,'x3web_phase_2_4',94004,NULL,66000,NULL,NULL,'in_stock','no',4,JSON_OBJECT('Size','Ultra'),1),
    (93,'x3web_phase_2_4',93001,NULL,37760,NULL,NULL,'in_stock','no',1,JSON_OBJECT('Size','Piccolo'),1),
    (93,'x3web_phase_2_4',93002,NULL,54280,NULL,NULL,'in_stock','no',2,JSON_OBJECT('Size','Classico'),1),
    (93,'x3web_phase_2_4',93003,NULL,71980,NULL,NULL,'in_stock','no',3,JSON_OBJECT('Size','Grande'),1),
    (93,'x3web_phase_2_4',93004,NULL,88500,NULL,NULL,'in_stock','no',4,JSON_OBJECT('Size','Maestro'),1)
  ON DUPLICATE KEY UPDATE
    `product_id`=VALUES(`product_id`),`regular_price`=VALUES(`regular_price`),`sale_price`=NULL,`stock_status`='in_stock',`backorders`='no',
    `position`=VALUES(`position`),`attributes_json`=VALUES(`attributes_json`),`enabled`=1;

  UPDATE `product_option_values` v JOIN `product_option_groups` g ON g.`id`=v.`option_group_id` SET v.`is_active`=0 WHERE g.`product_id` IN (75,93,94,95,96,97,98);
  UPDATE `product_option_groups` SET `is_active`=0 WHERE `product_id` IN (75,93,94,95,96,97,98);

  CREATE TEMPORARY TABLE `tmp_fd_option_groups` (
    `product_id` bigint(20) UNSIGNED NOT NULL, `option_code` varchar(100) NOT NULL, `public_label` varchar(190) NOT NULL,
    `selection_type` varchar(20) NOT NULL, `is_required` tinyint(1) NOT NULL, `display_order` int(11) NOT NULL, `metadata_json` longtext DEFAULT NULL,
    PRIMARY KEY (`product_id`,`option_code`)
  ) ENGINE=InnoDB;
  INSERT INTO `tmp_fd_option_groups` VALUES
    (75,'built_in_thermometer','Built-in Thermometer','single',0,10,JSON_OBJECT('note','Separate from the thermometer already fitted in the door')),
    (75,'finish_type','Finish Type','single',1,20,NULL),(75,'smooth_colour','Smooth Colour','single',0,30,JSON_OBJECT('required_when',JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')))),
    (75,'coastal_kit','Coastal Kit','single',0,40,NULL),(75,'mosaic','Mosaic','single',0,50,NULL),(75,'oven_trolley','Oven Trolley','single',0,60,JSON_OBJECT('confirmation_required',TRUE)),(75,'canvas_cover','Canvas Cover','display',0,70,JSON_OBJECT('cover_size_mapping','To confirm in later Canvas Cover phase')),
    (97,'built_in_thermometer','Built-in Thermometer','single',0,10,NULL),(97,'stoneskin','StoneSkin','single',0,20,NULL),(97,'finish_type','Finish Type','single',1,30,NULL),(97,'smooth_colour','Smooth Colour','single',0,40,JSON_OBJECT('required_when',JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')))),(97,'coastal_kit','Coastal Kit','single',0,50,NULL),(97,'mosaic','Mosaic','single',0,60,NULL),
    (95,'additional_flue_pipes','Additional Flue Pipes','single',0,10,NULL),(95,'mosaic','Mosaic','single',0,20,NULL),(95,'canvas_cover','Canvas Cover','display',0,30,NULL),
    (98,'trolley_configuration','Trolley Configuration','single',1,10,NULL),(98,'gas_conversion','Gas Conversion','single',1,20,NULL),(98,'additional_flue_pipes','Additional Flue Pipes','single',0,30,NULL),(98,'mosaic','Mosaic','single',0,40,NULL),(98,'canvas_cover','Canvas Cover','display',0,50,NULL),
    (96,'built_in_thermometer','Built-in Thermometer','single',0,10,NULL),(96,'coastal_kit','Coastal Kit','single',0,20,NULL),(96,'steel_colour_info','Included Steel Colour','display',0,30,JSON_OBJECT('provisional_colours',JSON_ARRAY('Canary Yellow','Signal Red','Grey/Silver','Black'),'confirmation_required',TRUE)),
    (94,'finish_type','Finish Type','single',1,10,NULL),(94,'built_in_thermometer','Built-in Thermometer','single',0,20,NULL),(94,'coastal_kit','Coastal Kit','single',0,30,NULL),(94,'stainless_spigot_door','Stainless Steel Spigot and Door','single',0,40,NULL),(94,'mosaic','Mosaic','single',0,50,NULL),(94,'canvas_cover','Canvas Cover','display',0,60,NULL),
    (93,'logo_tiling','Logo Tiling','single',1,10,NULL),(93,'mosaic_finish','Mosaic Finish','single',0,20,NULL);

  INSERT INTO `product_option_groups` (`product_id`,`option_code`,`public_label`,`selection_type`,`is_required`,`is_active`,`display_order`,`metadata_json`)
  SELECT `product_id`,`option_code`,`public_label`,`selection_type`,`is_required`,1,`display_order`,`metadata_json` FROM `tmp_fd_option_groups`
  ON DUPLICATE KEY UPDATE `public_label`=VALUES(`public_label`),`selection_type`=VALUES(`selection_type`),`is_required`=VALUES(`is_required`),`is_active`=1,`display_order`=VALUES(`display_order`),`metadata_json`=VALUES(`metadata_json`);

  CREATE TEMPORARY TABLE `tmp_fd_option_values` (
    `product_id` bigint(20) UNSIGNED NOT NULL, `option_code` varchar(100) NOT NULL, `value_code` varchar(100) NOT NULL, `public_label` varchar(190) NOT NULL,
    `price_adjustment` decimal(12,2) DEFAULT NULL, `pricing_mode` varchar(20) NOT NULL, `is_default` tinyint(1) NOT NULL, `display_order` int(11) NOT NULL,
    `conditions_json` longtext DEFAULT NULL, `metadata_json` longtext DEFAULT NULL,
    PRIMARY KEY (`product_id`,`option_code`,`value_code`)
  ) ENGINE=InnoDB;

  INSERT INTO `tmp_fd_option_values` VALUES
    (75,'built_in_thermometer','no','No',0,'included',1,10,NULL,NULL),(75,'built_in_thermometer','yes','Yes',1700,'additive',0,20,NULL,NULL),
    (75,'finish_type','smooth','Smooth coating',0,'included',0,10,NULL,NULL),(75,'finish_type','brick_face','Brick-face front on plain smooth finish',0,'included',0,20,NULL,NULL),(75,'finish_type','textured','Textured finish',NULL,'request_quote',0,30,NULL,NULL),
    (75,'coastal_kit','no','No',0,'included',1,10,NULL,NULL),(75,'coastal_kit','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(75,'mosaic','no','No',0,'included',1,10,NULL,NULL),(75,'mosaic','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(75,'oven_trolley','no','No',0,'included',1,10,NULL,NULL),(75,'oven_trolley','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(75,'canvas_cover','available','Available — Request Quote',NULL,'request_quote',1,10,NULL,NULL),
    (97,'built_in_thermometer','no','No',0,'included',1,10,NULL,NULL),(97,'built_in_thermometer','yes','Yes',1700,'additive',0,20,NULL,NULL),(97,'stoneskin','no','No',0,'included',1,10,NULL,NULL),(97,'stoneskin','yes','Yes',1200,'additive',0,20,NULL,NULL),
    (97,'finish_type','smooth','Smooth coating',0,'included',0,10,NULL,NULL),(97,'finish_type','brick_face','Brick-face front on plain smooth finish',0,'included',0,20,NULL,NULL),(97,'finish_type','textured','Textured finish',NULL,'request_quote',0,30,NULL,NULL),(97,'coastal_kit','no','No',0,'included',1,10,NULL,NULL),(97,'coastal_kit','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(97,'mosaic','no','No',0,'included',1,10,NULL,NULL),(97,'mosaic','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),
    (95,'additional_flue_pipes','no','No',0,'included',1,10,NULL,NULL),(95,'additional_flue_pipes','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(95,'mosaic','no','No',0,'included',1,10,NULL,NULL),(95,'mosaic','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(95,'canvas_cover','available','Available — Request Quote',NULL,'request_quote',1,10,NULL,NULL),
    (98,'trolley_configuration','no_trolley','No trolley',0,'included',1,10,NULL,NULL),(98,'trolley_configuration','without_side_table','Trolley without side table',5600,'additive',0,20,NULL,NULL),(98,'trolley_configuration','with_side_table','Trolley with side table',6000,'additive',0,30,NULL,NULL),(98,'gas_conversion','no','No',0,'included',1,10,NULL,NULL),(98,'gas_conversion','yes','Yes',2600,'additive',0,20,NULL,NULL),(98,'additional_flue_pipes','no','No',0,'included',1,10,NULL,NULL),(98,'additional_flue_pipes','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(98,'mosaic','no','No',0,'included',1,10,NULL,NULL),(98,'mosaic','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(98,'canvas_cover','available','Available — Request Quote',NULL,'request_quote',1,10,NULL,NULL),
    (96,'built_in_thermometer','no','No',0,'included',1,10,NULL,NULL),(96,'built_in_thermometer','yes','Yes',1700,'additive',0,20,NULL,NULL),(96,'coastal_kit','no','No',0,'included',1,10,NULL,NULL),(96,'coastal_kit','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(96,'steel_colour_info','quotation_confirmation','Included steel colour — final colour confirmed during quotation.',0,'included',1,10,NULL,JSON_OBJECT('provisional',TRUE)),
    (94,'finish_type','textured','Textured finish',0,'included',1,10,NULL,NULL),(94,'finish_type','smooth','Smooth coating',0,'included',0,20,NULL,NULL),(94,'built_in_thermometer','no','No',0,'included',1,10,NULL,NULL),(94,'built_in_thermometer','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(94,'coastal_kit','no','No',0,'included',1,10,NULL,NULL),(94,'coastal_kit','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(94,'stainless_spigot_door','no','No',0,'included',1,10,NULL,NULL),(94,'stainless_spigot_door','yes','Yes',1500,'additive',0,20,NULL,NULL),(94,'mosaic','no','No',0,'included',1,10,NULL,NULL),(94,'mosaic','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL),(94,'canvas_cover','available','Available — Request Quote',NULL,'request_quote',1,10,NULL,NULL),
    (93,'logo_tiling','no_logo','No logo',0,'included',1,10,NULL,NULL),(93,'logo_tiling','up_to_two_colours','Logo up to two colours',0,'included',0,20,NULL,NULL),(93,'logo_tiling','three_or_more_colours','Logo with three or more colours',NULL,'request_quote',0,30,NULL,NULL),(93,'mosaic_finish','no','No',0,'included',1,10,NULL,NULL),(93,'mosaic_finish','yes','Yes — Request Quote',NULL,'request_quote',0,20,NULL,NULL);

  INSERT INTO `tmp_fd_option_values` (`product_id`,`option_code`,`value_code`,`public_label`,`price_adjustment`,`pricing_mode`,`is_default`,`display_order`,`conditions_json`,`metadata_json`) VALUES
    (75,'smooth_colour','brown','Brown',0,'included',0,10,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','burgundy','Burgundy',0,'included',0,20,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','red','Red',0,'included',0,30,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','terracotta','Terracotta',0,'included',0,40,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','heritage_green','Heritage Green',0,'included',0,50,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','green','Green',0,'included',0,60,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','grey','Grey',0,'included',0,70,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','charcoal','Charcoal',0,'included',0,80,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','anthracite','Anthracite',0,'included',0,90,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','black','Black',0,'included',0,100,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','white','White',0,'included',0,110,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(75,'smooth_colour','african_sand','African Sand',0,'included',0,120,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),
    (97,'smooth_colour','brown','Brown',0,'included',0,10,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','burgundy','Burgundy',0,'included',0,20,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','red','Red',0,'included',0,30,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','terracotta','Terracotta',0,'included',0,40,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','heritage_green','Heritage Green',0,'included',0,50,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','green','Green',0,'included',0,60,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','grey','Grey',0,'included',0,70,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','charcoal','Charcoal',0,'included',0,80,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','anthracite','Anthracite',0,'included',0,90,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','black','Black',0,'included',0,100,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','white','White',0,'included',0,110,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL),(97,'smooth_colour','african_sand','African Sand',0,'included',0,120,JSON_OBJECT('group','finish_type','values',JSON_ARRAY('smooth','brick_face')),NULL);

  INSERT INTO `product_option_values` (`option_group_id`,`value_code`,`public_label`,`price_adjustment`,`pricing_mode`,`is_default`,`is_active`,`display_order`,`conditions_json`,`metadata_json`)
  SELECT g.`id`,v.`value_code`,v.`public_label`,v.`price_adjustment`,v.`pricing_mode`,v.`is_default`,1,v.`display_order`,v.`conditions_json`,v.`metadata_json`
  FROM `tmp_fd_option_values` v JOIN `product_option_groups` g ON g.`product_id`=v.`product_id` AND g.`option_code`=v.`option_code`
  ON DUPLICATE KEY UPDATE `public_label`=VALUES(`public_label`),`price_adjustment`=VALUES(`price_adjustment`),`pricing_mode`=VALUES(`pricing_mode`),`is_default`=VALUES(`is_default`),`is_active`=1,`display_order`=VALUES(`display_order`),`conditions_json`=VALUES(`conditions_json`),`metadata_json`=VALUES(`metadata_json`);

  DROP TEMPORARY TABLE `tmp_fd_option_values`;
  DROP TEMPORARY TABLE `tmp_fd_option_groups`;

  IF (SELECT COUNT(*) FROM `categories` c JOIN `categories` p ON p.`id`=c.`parent_id` WHERE p.`slug`='pizza-ovens' AND c.`slug` IN ('domestic','mobile','commercial') AND c.`is_active`=1) <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Category validation failed'; END IF;
  IF (SELECT COUNT(*) FROM `categories` c JOIN `categories` p ON p.`id`=c.`parent_id` WHERE p.`slug`='accessories' AND c.`slug` IN ('pizza-oven-utensils-accessories','canvas-covers') AND c.`is_active`=1) <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Accessories hierarchy validation failed'; END IF;
  IF EXISTS (SELECT 1 FROM `products` WHERE `id` IN (75,93,94,95,96,97,98) AND (`specifications` IS NULL OR NOT JSON_VALID(`specifications`) OR `attributes_json` IS NULL OR NOT JSON_VALID(`attributes_json`))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Structured product JSON validation failed'; END IF;
  IF EXISTS (SELECT 1 FROM `product_option_values` WHERE `pricing_mode`='request_quote' AND `price_adjustment` IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Request Quote option contains a numeric price'; END IF;
  IF EXISTS (SELECT `product_id`,`attributes_json`,COUNT(*) FROM `product_variations` WHERE `enabled`=1 GROUP BY `product_id`,`attributes_json` HAVING COUNT(*)>1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Duplicate active variation validation failed'; END IF;
  IF (SELECT COUNT(*) FROM `product_variations` WHERE `product_id`=75 AND `enabled`=1)<>3 OR (SELECT MIN(`regular_price`) FROM `product_variations` WHERE `product_id`=75 AND `enabled`=1)<>10300 OR (SELECT MAX(`regular_price`) FROM `product_variations` WHERE `product_id`=75 AND `enabled`=1)<>13600 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Premium DIY variation validation failed'; END IF;
  IF (SELECT COUNT(*) FROM `product_variations` WHERE `product_id`=95 AND `enabled`=1)<>9 OR (SELECT MIN(`regular_price`) FROM `product_variations` WHERE `product_id`=95 AND `enabled`=1)<>16800 OR (SELECT MAX(`regular_price`) FROM `product_variations` WHERE `product_id`=95 AND `enabled`=1)<>33200 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Premium Mobile variation validation failed'; END IF;
  IF (SELECT COUNT(*) FROM `product_variations` WHERE `product_id`=96 AND `enabled`=1)<>3 OR (SELECT MIN(`regular_price`) FROM `product_variations` WHERE `product_id`=96 AND `enabled`=1)<>13800 OR (SELECT MAX(`regular_price`) FROM `product_variations` WHERE `product_id`=96 AND `enabled`=1)<>39500 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Steel variation validation failed'; END IF;
  IF (SELECT COUNT(*) FROM `product_variations` WHERE `product_id`=94 AND `enabled`=1)<>4 OR (SELECT MIN(`regular_price`) FROM `product_variations` WHERE `product_id`=94 AND `enabled`=1)<>32000 OR (SELECT MAX(`regular_price`) FROM `product_variations` WHERE `product_id`=94 AND `enabled`=1)<>66000 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Pre-Fabricato variation validation failed'; END IF;
  IF (SELECT COUNT(*) FROM `product_variations` WHERE `product_id`=93 AND `enabled`=1)<>4 OR (SELECT MIN(`regular_price`) FROM `product_variations` WHERE `product_id`=93 AND `enabled`=1)<>37760 OR (SELECT MAX(`regular_price`) FROM `product_variations` WHERE `product_id`=93 AND `enabled`=1)<>88500 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Forno variation validation failed'; END IF;
  IF EXISTS (SELECT 1 FROM `products` WHERE `id` IN (75,93,94,95,96) AND `regular_price`=0) OR EXISTS (SELECT 1 FROM `products` WHERE `id` IN (97,98) AND (`regular_price` IS NULL OR `regular_price`<=0)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Affected-product zero-price validation failed'; END IF;
  IF (SELECT `category_id` FROM `products` WHERE `id`=79)<>(SELECT `id` FROM `categories` WHERE `slug`='accessories') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Flatpack Braai category validation failed'; END IF;

  COMMIT;
END$$
DELIMITER ;

CALL `fd_migrate_phases_2_3_4`();
DROP PROCEDURE `fd_migrate_phases_2_3_4`;

DROP TRIGGER IF EXISTS `categories_protect_oven_children_insert`;
DROP TRIGGER IF EXISTS `categories_protect_oven_children_update`;
DELIMITER $$
CREATE TRIGGER `categories_protect_oven_children_insert` BEFORE INSERT ON `categories` FOR EACH ROW
BEGIN
  DECLARE pizza_ovens_id bigint(20) UNSIGNED;
  IF NEW.`slug` IN ('domestic','mobile','commercial') THEN
    SELECT `id` INTO pizza_ovens_id FROM `categories` WHERE `slug`='pizza-ovens' LIMIT 1;
    IF NEW.`parent_id` IS NULL OR NEW.`parent_id`<>pizza_ovens_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Domestic, Mobile and Commercial must remain children of Pizza Ovens'; END IF;
  END IF;
END$$
CREATE TRIGGER `categories_protect_oven_children_update` BEFORE UPDATE ON `categories` FOR EACH ROW
BEGIN
  DECLARE pizza_ovens_id bigint(20) UNSIGNED;
  IF NEW.`slug` IN ('domestic','mobile','commercial') THEN
    SELECT `id` INTO pizza_ovens_id FROM `categories` WHERE `slug`='pizza-ovens' LIMIT 1;
    IF NEW.`parent_id` IS NULL OR NEW.`parent_id`<>pizza_ovens_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Domestic, Mobile and Commercial must remain children of Pizza Ovens'; END IF;
  END IF;
END$$
DELIMITER ;

SET SQL_MODE = @fd_previous_sql_mode;
