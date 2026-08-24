-- Fire & Dine final release-gate corrections
-- Supported database: MariaDB 10.11+
-- Import after 20260823_fire_dine_release_corrections.sql.
SET NAMES utf8mb4;
SET @fd_previous_sql_mode=@@SQL_MODE;
SET SQL_MODE=CONCAT_WS(',',@@SQL_MODE,'STRICT_TRANS_TABLES');

ALTER TABLE `quote_requests`
  ADD COLUMN IF NOT EXISTS `tax_enabled` tinyint(1) NOT NULL DEFAULT 0 AFTER `customer_notes`,
  ADD COLUMN IF NOT EXISTS `has_confirmed_amount` tinyint(1) NOT NULL DEFAULT 0 AFTER `tax_enabled`,
  MODIFY COLUMN `vat_rate` decimal(6,3) NOT NULL DEFAULT 0.000;

ALTER TABLE `quote_items`
  ADD COLUMN IF NOT EXISTS `pending_price_components_json` longtext DEFAULT NULL AFTER `selected_options_json`,
  ADD COLUMN IF NOT EXISTS `confirmed_line_total` decimal(12,2) DEFAULT NULL AFTER `final_confirmed_price`;

UPDATE `quote_requests`
SET `has_confirmed_amount`=IF(`subtotal`>0 OR `vat_amount`>0 OR `total`>0,1,0),
    `tax_enabled`=IF(`vat_amount`>0 AND `vat_rate`>0,1,0);
UPDATE `quote_items`
SET `confirmed_line_total`=ROUND(`final_confirmed_price`*`quantity`,2)
WHERE `final_confirmed_price` IS NOT NULL;

INSERT INTO `settings` (`setting_key`,`setting_value`,`is_secret`,`updated_at`) VALUES
 ('quote_tax_enabled','0',0,NOW()),
 ('quote_tax_rate','0',0,NOW())
ON DUPLICATE KEY UPDATE `setting_value`=VALUES(`setting_value`),`is_secret`=0,`updated_at`=VALUES(`updated_at`);

CREATE TABLE IF NOT EXISTS `enquiry_status_history` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enquiry_id` bigint(20) UNSIGNED NOT NULL,
  `old_status` varchar(40) DEFAULT NULL,
  `new_status` varchar(40) NOT NULL,
  `summary` varchar(500) NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `enquiry_status_history_enquiry_idx` (`enquiry_id`,`created_at`),
  CONSTRAINT `enquiry_status_history_enquiry_fk` FOREIGN KEY (`enquiry_id`) REFERENCES `enquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `enquiry_status_history_admin_fk` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `enquiry_email_log` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enquiry_id` bigint(20) UNSIGNED NOT NULL,
  `recipient` varchar(190) NOT NULL,
  `status` enum('sent','failed') NOT NULL,
  `error_message` varchar(1000) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `enquiry_email_log_enquiry_idx` (`enquiry_id`,`created_at`),
  CONSTRAINT `enquiry_email_log_enquiry_fk` FOREIGN KEY (`enquiry_id`) REFERENCES `enquiries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `category_slug_redirects`
  ADD COLUMN IF NOT EXISTS `old_parent_slug` varchar(190) DEFAULT NULL AFTER `category_id`,
  ADD COLUMN IF NOT EXISTS `new_parent_slug` varchar(190) DEFAULT NULL AFTER `old_slug`,
  ADD COLUMN IF NOT EXISTS `old_path` varchar(381) DEFAULT NULL AFTER `new_slug`,
  ADD COLUMN IF NOT EXISTS `new_path` varchar(381) DEFAULT NULL AFTER `old_path`;
UPDATE `category_slug_redirects`
SET `old_path`=COALESCE(`old_path`,IF(`old_parent_slug` IS NULL,`old_slug`,CONCAT(`old_parent_slug`,'/',`old_slug`))),
    `new_path`=COALESCE(`new_path`,IF(`new_parent_slug` IS NULL,`new_slug`,CONCAT(`new_parent_slug`,'/',`new_slug`)));
ALTER TABLE `category_slug_redirects`
  DROP INDEX IF EXISTS `category_slug_redirects_old_unique`,
  ADD UNIQUE INDEX IF NOT EXISTS `category_slug_redirects_old_path_unique` (`old_path`);

SET @fd_pizza_ovens_category=(SELECT `id` FROM `categories` WHERE `slug`='pizza-ovens' LIMIT 1);
SET @fd_accessories_category=(SELECT `id` FROM `categories` WHERE `slug`='accessories' LIMIT 1);
UPDATE `categories` SET `name`='Pizza Ovens',`slug`='pizza-ovens',`parent_id`=NULL,`is_active`=1 WHERE `id`=@fd_pizza_ovens_category;
UPDATE `categories` SET `name`='Accessories',`slug`='accessories',`parent_id`=NULL,`is_active`=1 WHERE `id`=@fd_accessories_category;
UPDATE `categories` SET `name`='Fireplace',`slug`='fireplace',`parent_id`=NULL,`is_active`=1 WHERE `slug`='fireplace';
UPDATE `categories` SET `name`='Domestic',`slug`='domestic',`parent_id`=@fd_pizza_ovens_category,`is_active`=1 WHERE `slug`='domestic';
UPDATE `categories` SET `name`='Mobile',`slug`='mobile',`parent_id`=@fd_pizza_ovens_category,`is_active`=1 WHERE `slug`='mobile';
UPDATE `categories` SET `name`='Commercial',`slug`='commercial',`parent_id`=@fd_pizza_ovens_category,`is_active`=1 WHERE `slug`='commercial';
UPDATE `categories` SET `name`='Pizza Oven Utensils & Accessories',`slug`='pizza-oven-utensils-accessories',`parent_id`=@fd_accessories_category,`is_active`=1 WHERE `slug`='pizza-oven-utensils-accessories';
UPDATE `categories` SET `name`='Canvas Covers',`slug`='canvas-covers',`parent_id`=@fd_accessories_category,`is_active`=1 WHERE `slug`='canvas-covers';
UPDATE `categories` SET `is_active`=0 WHERE `parent_id` IS NULL AND `slug` NOT IN ('pizza-ovens','accessories','fireplace');

UPDATE `products` SET `status`='archived',`visibility`='hidden',`featured`=0 WHERE `id` IN (83,106);
UPDATE `products` SET `stock_status`='out_of_stock' WHERE `id`=104;
INSERT INTO `product_related_products` (`product_id`,`related_product_id`,`context_label`,`display_order`,`is_active`)
VALUES (98,80,'Optional Rib Rack',30,1)
ON DUPLICATE KEY UPDATE `context_label`=VALUES(`context_label`),`display_order`=VALUES(`display_order`),`is_active`=1;

UPDATE `gallery_media`
SET `enabled`=0
WHERE `title`='Luxurious Sunset Fireplace Retreat';
UPDATE `gallery_media`
SET `enabled`=0
WHERE `id` IN (65,75) OR `title` IN ('Flint 1','Flint 1 Pizza oven');

DELIMITER $$
DROP PROCEDURE IF EXISTS `fd_verify_release_gate_fixes`$$
CREATE PROCEDURE `fd_verify_release_gate_fixes`()
BEGIN
  IF (SELECT COUNT(*) FROM `categories` WHERE `parent_id` IS NULL AND `is_active`=1)<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Exactly three active top-level categories are required'; END IF;
  IF (SELECT COUNT(*) FROM `categories` WHERE `parent_id` IS NULL AND `is_active`=1 AND (`name`,`slug`) IN (('Pizza Ovens','pizza-ovens'),('Accessories','accessories'),('Fireplace','fireplace')))<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Protected top-level category validation failed'; END IF;
  IF (SELECT COUNT(*) FROM `categories` c JOIN `categories` p ON p.`id`=c.`parent_id` WHERE c.`is_active`=1 AND ((c.`name`='Domestic' AND c.`slug`='domestic' AND p.`slug`='pizza-ovens') OR (c.`name`='Mobile' AND c.`slug`='mobile' AND p.`slug`='pizza-ovens') OR (c.`name`='Commercial' AND c.`slug`='commercial' AND p.`slug`='pizza-ovens') OR (c.`name`='Pizza Oven Utensils & Accessories' AND c.`slug`='pizza-oven-utensils-accessories' AND p.`slug`='accessories') OR (c.`name`='Canvas Covers' AND c.`slug`='canvas-covers' AND p.`slug`='accessories')))<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Protected subcategory validation failed'; END IF;
  IF EXISTS (SELECT 1 FROM `products` WHERE `id` IN (83,106) AND (`status`<>'archived' OR `visibility`<>'hidden')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Archived product visibility validation failed'; END IF;
  IF EXISTS (SELECT 1 FROM `products` WHERE `id`=104 AND `stock_status`<>'out_of_stock') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 104 stock validation failed'; END IF;
  IF NOT EXISTS (SELECT 1 FROM `product_related_products` WHERE `product_id`=98 AND `related_product_id`=80 AND `is_active`=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product 98 Rib Rack relationship validation failed'; END IF;
  IF EXISTS (SELECT 1 FROM `products` WHERE `status`='active' AND `visibility`='visible' AND `regular_price`=0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Visible zero-price product validation failed'; END IF;
  IF EXISTS (SELECT 1 FROM `product_option_values` WHERE `pricing_mode`='request_quote' AND `price_adjustment` IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Pending price component contains a numeric amount'; END IF;
END$$
CALL `fd_verify_release_gate_fixes`()$$
DROP PROCEDURE `fd_verify_release_gate_fixes`$$
DELIMITER ;

INSERT INTO `app_meta` (`meta_key`,`meta_value`,`updated_at`) VALUES
 ('fire_dine_release_gate_fixes','implemented',NOW()),
 ('fire_dine_application_version','unreleased-verification-required',NOW()),
 ('fire_dine_database_migration_version','20260823_release_gate_fixes',NOW()),
 ('fire_dine_catalogue_cache_version',DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),NOW())
ON DUPLICATE KEY UPDATE `meta_value`=VALUES(`meta_value`),`updated_at`=VALUES(`updated_at`);

SET SQL_MODE=@fd_previous_sql_mode;

-- Ensure this deployment has the requested administrator login.
INSERT INTO `users`
  (`first_name`,`last_name`,`email`,`password_hash`,`role`,`status`,`must_change_password`,`session_version`,`password_changed_at`)
VALUES
  ('Fire & Dine','Administrator','info@fireanddine.co.za','$2y$12$XI6zEi7itoMi24oLMmce0O3AsXrsDkYWYxskfRWEvyf3HXV04I/AK','super_admin','active',0,1,NOW())
ON DUPLICATE KEY UPDATE
  `first_name`=VALUES(`first_name`),`last_name`=VALUES(`last_name`),
  `password_hash`=VALUES(`password_hash`),`role`='super_admin',`status`='active',
  `must_change_password`=0,`failed_login_attempts`=0,`locked_until`=NULL,
  `password_changed_at`=NOW(),`session_version`=`session_version`+1;
