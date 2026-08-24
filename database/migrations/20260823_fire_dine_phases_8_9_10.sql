-- Fire & Dine phases 8, 9 and 10
-- Run after 20260823_fire_dine_phases_5_6_7.sql.
SET NAMES utf8mb4;
SET @fd_previous_sql_mode = @@SQL_MODE;
SET SQL_MODE = CONCAT_WS(',', @@SQL_MODE, 'STRICT_TRANS_TABLES');
START TRANSACTION;
SET @fd_canvas_product_id=(SELECT `id` FROM `products` WHERE `slug`='canvas-covers' LIMIT 1);

CREATE TABLE IF NOT EXISTS `product_confirmations` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `confirmation_key` varchar(120) NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `internal_title` varchar(190) NOT NULL,
  `issue_description` text NOT NULL,
  `provisional_value` text DEFAULT NULL,
  `public_handling` text NOT NULL,
  `status` enum('pending','confirmed','rejected','replaced') NOT NULL DEFAULT 'pending',
  `confirmed_value` text DEFAULT NULL,
  `confirmed_by` varchar(190) DEFAULT NULL,
  `confirmation_date` date DEFAULT NULL,
  `internal_notes` text DEFAULT NULL,
  `blocks_purchasing` tinyint(1) NOT NULL DEFAULT 0,
  `requires_price_update` tinyint(1) NOT NULL DEFAULT 0,
  `requires_content_update` tinyint(1) NOT NULL DEFAULT 0,
  `requires_image` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_confirmations_key_unique` (`confirmation_key`),
  KEY `product_confirmations_product_status_idx` (`product_id`,`status`),
  CONSTRAINT `product_confirmations_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `product_confirmations_resolution_chk` CHECK (`status`='pending' OR (`confirmed_by` IS NOT NULL AND `confirmation_date` IS NOT NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `product_confirmation_history` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `confirmation_id` bigint(20) UNSIGNED NOT NULL,
  `old_status` varchar(30) DEFAULT NULL,
  `new_status` varchar(30) NOT NULL,
  `old_confirmed_value` text DEFAULT NULL,
  `new_confirmed_value` text DEFAULT NULL,
  `changed_by_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `change_note` text DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `confirmation_history_confirmation_idx` (`confirmation_id`,`changed_at`),
  CONSTRAINT `confirmation_history_confirmation_fk` FOREIGN KEY (`confirmation_id`) REFERENCES `product_confirmations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `confirmation_history_user_fk` FOREIGN KEY (`changed_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `product_confirmations`
 (`confirmation_key`,`product_id`,`internal_title`,`issue_description`,`provisional_value`,`public_handling`,`status`,`internal_notes`,`blocks_purchasing`,`requires_price_update`,`requires_content_update`,`requires_image`) VALUES
 ('premium_diy_grande_dimension',75,'Premium DIY Grande dimension','Grande front-to-back is interpreted from the guide wording and requires confirmation.','1,050 mm','Continue using 1,050 mm and state: Please confirm final base dimensions with Fire & Dine before construction.','pending','Do not publish the source voice-note explanation.',0,0,1,0),
 ('premium_mobile_model_names',95,'Premium Mobile model names','Current guide uses Piccolo, Grande and Superior; earlier material used Piccolo, Vivace and Maestro.','Piccolo, Grande and Superior','Display only Piccolo, Grande and Superior.','pending','Do not show both naming systems.',0,0,1,0),
 ('mobile_countertop_floor_wording',98,'Mobile Countertop floor wording','Firebrick floor was interpreted from a voice note.','Firebrick floor','Use Heat-retaining oven floor until material wording is confirmed.','pending','No material certification claim.',0,0,1,0),
 ('steel_oven_colours',96,'Steel Oven colours','The master guide shows four colours while older material mentions additional colours.','Canary Yellow; Signal Red; Grey/Silver; Black','Display the four guide colours and state that current availability is confirmed during quotation.','pending','Do not publish blue or olive green or add surcharges.',0,0,1,0),
 ('textured_finish_colours',NULL,'Textured finish colours','One source says four colours while the swatch sheet shows seven.','Midnight Black; Pebble Beige; Soft Beige; Charcoal Grey; Speckled Gold; Granite Grey; Sandstone','Display: Textured finish available — current colours confirmed during quotation.','pending','Seven swatch names are internal provisional values, not guaranteed public variations.',0,0,1,0),
 ('textured_finish_pricing',NULL,'Textured finish pricing','Handwritten values may indicate R1,100, R1,200 or R1,500 depending on size; mapping is unconfirmed.','R1,100 / R1,200 / R1,500, mapping unknown','Request Quote with no automatic amount.','pending','Never store or display R0 and never calculate a provisional total.',0,1,1,0),
 ('coastal_kit_price',NULL,'Coastal Kit price','Sources conflict on whether Coastal Kit is free or a paid extra.','Conflicting; old R1,955 must not be used','Request Quote wherever optional; omit as an extra where coastal-ready is standard.','pending','Do not describe as free and do not automatically add R1,955.',0,1,1,0),
 ('prefabricato_flue_material',94,'Premium Pre-Fabricato flue material','The guide confirms a brushed flue pipe but not the final metal type.','Brushed flue pipe','Use Brushed flue pipe only.','pending','Do not claim mild steel or stainless steel.',0,0,1,0),
 ('premium_mobile_trolley_anomaly',95,'Premium Mobile trolley pricing anomaly','Guide trolley component values do not follow a logical size progression.','Medium no side table R5,200; Large no side table R5,200; Medium collapsible R6,200; Large collapsible R5,900','Keep the exact complete oven-and-trolley prices supplied by the guide.','pending','Do not recalculate or silently correct the anomaly.',0,1,0,0),
 ('x_small_crate',NULL,'X-Small crate','Crate fee is recorded but product assignment and dimensions are unknown.','R850','Delivery and crating quoted separately; do not assign automatically.','pending','Do not assign to Counter Top Oven without confirmation.',0,1,1,0),
 ('rib_rack_duplicate',83,'Rib Rack duplication','Product 80 is R620 and product 83 is R580; duplicate versus second size is unresolved.','Product 80 R620; product 83 R580','Keep product 80 active and product 83 archived/hidden.','pending','Do not state that two public sizes exist.',0,1,1,0),
 ('flatpack_name_specs',79,'Flatpack Braai name and specifications','Final name may be Tassie Braai or Flatpack Braai; dimensions, weight and included grid are unknown.','Flatpack Braai','Continue Flatpack Braai without dimensions, weight, grid or custom stainless claim.','pending','Keep directly under Accessories.',0,0,1,0),
 ('image_smooth_colours',NULL,'Approved smooth-colour photographs','No clearly named approved smooth-colour product/swatches were found in the supplied package.',NULL,'Use only supplied approved media; otherwise use the official fallback.','pending','Add approved image and map it without replacing unrelated media.',0,0,0,1),
 ('image_textured_swatches',NULL,'Approved textured-swatch photographs','No clearly named approved textured-swatch image set was found in the supplied package.',NULL,'Use only supplied approved media; do not generate or substitute.','pending','Add approved swatches after colour confirmation.',0,0,0,1),
 ('image_canvas_covers',@fd_canvas_product_id,'Approved Canvas Covers photograph','No clearly identified Canvas Cover photograph was found in the supplied package.',NULL,'Use the official Fire & Dine logo fallback.','pending','Replace fallback only with an approved Canvas Cover image.',0,0,0,1)
ON DUPLICATE KEY UPDATE
 `product_id`=VALUES(`product_id`),`internal_title`=VALUES(`internal_title`),`issue_description`=VALUES(`issue_description`),
 `provisional_value`=VALUES(`provisional_value`),`public_handling`=VALUES(`public_handling`),`internal_notes`=VALUES(`internal_notes`),
 `blocks_purchasing`=VALUES(`blocks_purchasing`),`requires_price_update`=VALUES(`requires_price_update`),
 `requires_content_update`=VALUES(`requires_content_update`),`requires_image`=VALUES(`requires_image`);

-- Safe public handling for unresolved guide content.
UPDATE `products` SET
 `description`=REPLACE(`description`,'Firebrick floor','Heat-retaining oven floor'),
 `specifications`=REPLACE(`specifications`,'Firebrick floor','Heat-retaining oven floor')
WHERE `id`=98;
UPDATE `products` SET
 `description`='<h3>Steel Oven Range</h3><p>Available in Standard, Grande and Superior models.</p><h3>Included colours</h3><p>Canary Yellow, Signal Red, Grey/Silver and Black. Current colour availability is confirmed during quotation.</p><h3>Optional extras</h3><ul><li>Built-in thermometer</li><li>Coastal Kit — Request Quote</li></ul>',
 `specifications`=JSON_SET(COALESCE(`specifications`,JSON_OBJECT()),'$.included_choice','Canary Yellow, Signal Red, Grey/Silver and Black. Current colour availability is confirmed during quotation.','$.available_colours',JSON_ARRAY('Canary Yellow','Signal Red','Grey/Silver','Black'))
WHERE `id`=96;
UPDATE `products` SET
 `description`=CONCAT(REPLACE(COALESCE(`description`,''),'<h3>Optional extras</h3>','<p>Please confirm final base dimensions with Fire & Dine before construction.</p><h3>Optional extras</h3>'))
WHERE `id`=75 AND `description` NOT LIKE '%Please confirm final base dimensions%';
UPDATE `product_option_values` v JOIN `product_option_groups` g ON g.id=v.option_group_id
SET v.public_label='Textured finish — current colours confirmed during quotation',v.price_adjustment=NULL,v.pricing_mode='request_quote'
WHERE g.option_code='finish_type' AND v.value_code='textured' AND g.product_id IN (75,97);
UPDATE `product_option_values` v JOIN `product_option_groups` g ON g.id=v.option_group_id
SET v.public_label='Yes — Request Quote',v.price_adjustment=NULL,v.pricing_mode='request_quote'
WHERE g.option_code='coastal_kit' AND v.value_code='yes';

-- Final read-path indexes. No data is removed.
ALTER TABLE `products` ADD INDEX IF NOT EXISTS `products_public_category_idx` (`status`,`visibility`,`category_id`,`featured`,`sort_order`);
ALTER TABLE `categories` ADD INDEX IF NOT EXISTS `categories_parent_public_idx` (`parent_id`,`is_active`,`sort_order`);
ALTER TABLE `product_variations` ADD INDEX IF NOT EXISTS `product_variations_public_idx` (`product_id`,`enabled`,`stock_status`,`position`);
ALTER TABLE `product_media` ADD INDEX IF NOT EXISTS `product_media_product_order_idx` (`product_id`,`sort_order`,`is_primary`);

INSERT INTO `app_meta` (`meta_key`,`meta_value`,`updated_at`) VALUES
 ('fire_dine_phase_8_9_10','implemented',NOW()),
 ('fire_dine_application_version','unreleased-verification-required',NOW()),
 ('fire_dine_database_migration_version','20260823_phases_8_9_10',NOW()),
 ('fire_dine_product_guide_reference_date','2026-08-22',NOW()),
 ('fire_dine_catalogue_cache_version',DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),NOW())
ON DUPLICATE KEY UPDATE `meta_value`=VALUES(`meta_value`),`updated_at`=VALUES(`updated_at`);

COMMIT;
SET SQL_MODE = @fd_previous_sql_mode;
