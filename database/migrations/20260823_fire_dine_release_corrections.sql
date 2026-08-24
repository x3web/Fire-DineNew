-- Fire & Dine release correction migration
-- Supported database: MariaDB 10.11+
-- Import after 20260823_fire_dine_phases_8_9_10.sql.
SET NAMES utf8mb4;
SET @fd_previous_sql_mode=@@SQL_MODE;
SET SQL_MODE=CONCAT_WS(',',@@SQL_MODE,'STRICT_TRANS_TABLES');
START TRANSACTION;

ALTER TABLE `quote_requests`
  ADD COLUMN IF NOT EXISTS `interest` varchar(190) DEFAULT NULL AFTER `company`,
  ADD COLUMN IF NOT EXISTS `pricing_status` enum('confirmed','price_pending') NOT NULL DEFAULT 'confirmed' AFTER `total`,
  ADD COLUMN IF NOT EXISTS `idempotency_key` varchar(128) DEFAULT NULL AFTER `pricing_status`;
ALTER TABLE `quote_requests` ADD UNIQUE INDEX IF NOT EXISTS `quote_requests_idempotency_unique` (`idempotency_key`);

CREATE TABLE IF NOT EXISTS `category_slug_redirects` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `old_slug` varchar(190) NOT NULL,
  `new_slug` varchar(190) NOT NULL,
  `redirect_code` smallint(5) UNSIGNED NOT NULL DEFAULT 301,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_slug_redirects_old_unique` (`old_slug`),
  KEY `category_slug_redirects_category_idx` (`category_id`,`is_active`),
  CONSTRAINT `category_slug_redirects_category_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `category_slug_redirects_code_chk` CHECK (`redirect_code` IN (301,308))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Re-assert the protected two-level catalogue topology. Any historical extra
-- root remains available to administrators for audit, but is not active.
UPDATE `categories` SET `parent_id`=NULL,`is_active`=1
WHERE `slug` IN ('pizza-ovens','accessories','fireplace');
UPDATE `categories` SET `is_active`=0
WHERE `parent_id` IS NULL AND `slug` NOT IN ('pizza-ovens','accessories','fireplace');
UPDATE `categories` SET `parent_id`=(SELECT `id` FROM (SELECT `id` FROM `categories` WHERE `slug`='pizza-ovens' LIMIT 1) p),`is_active`=1
WHERE `slug` IN ('domestic','mobile','commercial');
UPDATE `categories` SET `parent_id`=(SELECT `id` FROM (SELECT `id` FROM `categories` WHERE `slug`='accessories' LIMIT 1) p),`is_active`=1
WHERE `slug` IN ('pizza-oven-utensils-accessories','canvas-covers');

-- Customer-facing catalogue copy must describe the products, not the data work.
UPDATE `products` SET `short_description`='Three-model DIY pizza oven range with included finish choices and optional extras.' WHERE `id`=75;
UPDATE `products` SET `short_description`='Three-model steel pizza oven range with model-specific dimensions, included colour choices and optional extras.' WHERE `id`=96;

-- Steel colours are a required included selection, not display-only metadata.
UPDATE `product_option_groups` SET `is_active`=0 WHERE `product_id`=96 AND `option_code`='steel_colour_info';
INSERT INTO `product_option_groups` (`product_id`,`option_code`,`public_label`,`selection_type`,`is_required`,`is_active`,`display_order`,`metadata_json`)
VALUES (96,'steel_colour','Steel Colour','single',1,1,30,JSON_OBJECT('public_note','Current availability is confirmed during quotation.'))
ON DUPLICATE KEY UPDATE `public_label`=VALUES(`public_label`),`selection_type`='single',`is_required`=1,`is_active`=1,`display_order`=30,`metadata_json`=VALUES(`metadata_json`),`id`=LAST_INSERT_ID(`id`);
SET @fd_steel_colour_group=LAST_INSERT_ID();
INSERT INTO `product_option_values` (`option_group_id`,`value_code`,`public_label`,`price_adjustment`,`pricing_mode`,`is_default`,`is_active`,`display_order`,`conditions_json`,`metadata_json`) VALUES
 (@fd_steel_colour_group,'canary_yellow','Canary Yellow — availability confirmed during quotation',0,'included',0,1,10,NULL,NULL),
 (@fd_steel_colour_group,'signal_red','Signal Red — availability confirmed during quotation',0,'included',0,1,20,NULL,NULL),
 (@fd_steel_colour_group,'grey_silver','Grey/Silver — availability confirmed during quotation',0,'included',0,1,30,NULL,NULL),
 (@fd_steel_colour_group,'black','Black — availability confirmed during quotation',0,'included',0,1,40,NULL,NULL)
ON DUPLICATE KEY UPDATE `public_label`=VALUES(`public_label`),`price_adjustment`=0,`pricing_mode`='included',`is_active`=1,`display_order`=VALUES(`display_order`);

-- Mobile Countertop includes the paddle, not the Rib Rack. The Rib Rack is a
-- related purchasable accessory and the included paddle is not cross-sold.
DELETE FROM `product_related_products` WHERE `product_id`=98 AND `related_product_id`=76;
INSERT INTO `product_related_products` (`product_id`,`related_product_id`,`context_label`,`display_order`,`is_active`)
VALUES (98,80,'Optional Rib Rack',30,1)
ON DUPLICATE KEY UPDATE `context_label`=VALUES(`context_label`),`display_order`=VALUES(`display_order`),`is_active`=1;

-- Archived FLINT content is retained internally but not promoted publicly.
UPDATE `brochures` SET `enabled`=0,`display_shop`=0,`display_home`=0,`display_about`=0,`display_services`=0,`display_footer`=0
WHERE `title` LIKE '%Flint%' OR `original_filename` LIKE '%FLINT%';
UPDATE `gallery_media` SET `enabled`=0 WHERE `title` LIKE '%Flint%';

-- A clean production installation must start with maintenance mode disabled.
UPDATE `settings` SET `setting_value`='0' WHERE `setting_key`='maintenance_enabled';

INSERT INTO `app_meta` (`meta_key`,`meta_value`,`updated_at`) VALUES
 ('fire_dine_release_corrections','implemented',NOW()),
 ('fire_dine_application_version','unreleased-verification-required',NOW()),
 ('fire_dine_database_migration_version','20260823_release_corrections',NOW()),
 ('fire_dine_catalogue_cache_version',DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),NOW())
ON DUPLICATE KEY UPDATE `meta_value`=VALUES(`meta_value`),`updated_at`=VALUES(`updated_at`);

COMMIT;
SET SQL_MODE=@fd_previous_sql_mode;
