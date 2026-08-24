-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 22, 2026 at 11:21 AM
-- Server version: 10.11.14-MariaDB-0ubuntu0.24.04.1
-- PHP Version: 8.4.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fireanddine`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

-- Privacy sanitisation: data rows for `admins` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `admin_profiles`
--

CREATE TABLE `admin_profiles` (
  `id` varchar(100) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `phone` varchar(80) DEFAULT NULL,
  `image_key` varchar(500) DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_sessions`
--

CREATE TABLE `admin_sessions` (
  `id` varchar(100) NOT NULL,
  `admin_id` varchar(100) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `last_seen_at` datetime NOT NULL DEFAULT current_timestamp(),
  `ip_address` varchar(100) DEFAULT NULL,
  `user_agent` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_sessions`
--

-- Privacy sanitisation: data rows for `admin_sessions` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(40) NOT NULL DEFAULT 'administrator',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_users`
--

-- Privacy sanitisation: data rows for `admin_users` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `analytics_audit_log`
--

CREATE TABLE `analytics_audit_log` (
  `id` varchar(100) NOT NULL,
  `actor_email` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `target_type` varchar(100) DEFAULT NULL,
  `target_id` varchar(100) DEFAULT NULL,
  `trace_id` varchar(100) NOT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_blocked_events`
--

CREATE TABLE `analytics_blocked_events` (
  `id` varchar(100) NOT NULL,
  `reason` varchar(500) NOT NULL,
  `event_type` varchar(100) DEFAULT NULL,
  `network_hash` varchar(255) DEFAULT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_consents`
--

CREATE TABLE `analytics_consents` (
  `id` varchar(100) NOT NULL,
  `anonymous_id` varchar(100) NOT NULL,
  `policy_version` varchar(100) NOT NULL,
  `analytics_allowed` tinyint(1) NOT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_conversions`
--

CREATE TABLE `analytics_conversions` (
  `id` varchar(100) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `entity_type` varchar(100) DEFAULT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_daily_summaries`
--

CREATE TABLE `analytics_daily_summaries` (
  `summary_date` date NOT NULL,
  `metric_key` varchar(255) NOT NULL,
  `metric_value` bigint(20) NOT NULL DEFAULT 0,
  `dimension_key` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_errors`
--

CREATE TABLE `analytics_errors` (
  `id` varchar(100) NOT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `error_code` varchar(255) DEFAULT NULL,
  `page_path` varchar(1000) DEFAULT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_events`
--

CREATE TABLE `analytics_events` (
  `id` varchar(100) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `page_path` varchar(1000) DEFAULT NULL,
  `element_id` varchar(255) DEFAULT NULL,
  `element_type` varchar(100) DEFAULT NULL,
  `element_label` varchar(255) DEFAULT NULL,
  `x_percent` double DEFAULT NULL,
  `y_percent` double DEFAULT NULL,
  `device_category` varchar(50) DEFAULT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_form_events`
--

CREATE TABLE `analytics_form_events` (
  `id` varchar(100) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `form_id` varchar(255) NOT NULL,
  `field_id` varchar(255) DEFAULT NULL,
  `event_type` varchar(100) NOT NULL,
  `validation_status` varchar(100) DEFAULT NULL,
  `time_spent_ms` int(11) DEFAULT NULL,
  `device_category` varchar(50) DEFAULT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_pageviews`
--

CREATE TABLE `analytics_pageviews` (
  `id` varchar(100) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `page_path` varchar(1000) NOT NULL,
  `page_title` varchar(500) DEFAULT NULL,
  `referrer_host` varchar(500) DEFAULT NULL,
  `occurred_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_sessions`
--

CREATE TABLE `analytics_sessions` (
  `id` varchar(100) NOT NULL,
  `visitor_id` varchar(100) NOT NULL,
  `started_at` datetime NOT NULL,
  `last_seen_at` datetime NOT NULL,
  `ended_at` datetime DEFAULT NULL,
  `duration_seconds` int(11) NOT NULL DEFAULT 0,
  `page_count` int(11) NOT NULL DEFAULT 0,
  `entry_path` varchar(1000) DEFAULT NULL,
  `exit_path` varchar(1000) DEFAULT NULL,
  `device_category` varchar(50) DEFAULT NULL,
  `browser_family` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `region` varchar(150) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  `traffic_source` varchar(255) DEFAULT NULL,
  `is_returning` tinyint(1) NOT NULL DEFAULT 0,
  `is_suspicious` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analytics_settings`
--

CREATE TABLE `analytics_settings` (
  `key` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `app_meta`
--

CREATE TABLE `app_meta` (
  `meta_key` varchar(100) NOT NULL,
  `meta_value` varchar(255) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `app_meta`
--

INSERT INTO `app_meta` (`meta_key`, `meta_value`, `updated_at`) VALUES
('schema_version', '14', '2026-08-11 11:15:02');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` varchar(100) NOT NULL,
  `admin_id` varchar(100) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `entity_type` varchar(100) DEFAULT NULL,
  `entity_id` varchar(100) DEFAULT NULL,
  `ip_address` varchar(100) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `safe_summary` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

-- Privacy sanitisation: data rows for `audit_logs` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `auth_attempts`
--

CREATE TABLE `auth_attempts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `identity_hash` char(64) NOT NULL,
  `attempted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `success` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_attempts`
--

-- Privacy sanitisation: data rows for `auth_attempts` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `auth_rate_limits`
--

CREATE TABLE `auth_rate_limits` (
  `rate_key` char(64) NOT NULL,
  `attempts` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `window_started_at` datetime NOT NULL,
  `blocked_until` datetime DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `brochures`
--

CREATE TABLE `brochures` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(190) NOT NULL DEFAULT 'Download Our Brochure',
  `description` varchar(1000) DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `original_filename` varchar(255) DEFAULT NULL,
  `stored_filename` varchar(255) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_size` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `cover_path` varchar(500) DEFAULT NULL,
  `cover_alt` varchar(255) DEFAULT NULL,
  `button_text` varchar(120) NOT NULL DEFAULT 'Download Brochure',
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  `display_shop` tinyint(1) NOT NULL DEFAULT 1,
  `display_home` tinyint(1) NOT NULL DEFAULT 0,
  `display_about` tinyint(1) NOT NULL DEFAULT 0,
  `display_services` tinyint(1) NOT NULL DEFAULT 0,
  `display_footer` tinyint(1) NOT NULL DEFAULT 0,
  `download_count` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brochures`
--

INSERT INTO `brochures` (`id`, `title`, `description`, `file_path`, `original_filename`, `stored_filename`, `mime_type`, `file_size`, `cover_path`, `cover_alt`, `button_text`, `enabled`, `display_shop`, `display_home`, `display_about`, `display_services`, `display_footer`, `download_count`, `created_at`, `updated_at`, `updated_by`) VALUES
(4, 'Fire & Dine - Flint1', NULL, '/uploads/brochures/72acd21262506fcc15181aced26733537d3c79c6.pdf', 'FLINT1_Brochure (1).pdf', '72acd21262506fcc15181aced26733537d3c79c6.pdf', 'application/pdf', 4264888, '/uploads/brochures/bfb4eef1adcaccecdb75a92c5b74bb79bcc1dd5a.png', 'Fire & Dine - Pizza Oven', 'Download Brochure', 1, 1, 0, 1, 0, 0, 1, '2026-08-12 12:48:43', '2026-08-20 14:20:54', 1),
(5, 'FIre and Dine- Pizza Ovens', NULL, '/uploads/brochures/d2bd464db35fe359802d654988a27a068a019477.pdf', 'Fire & Dine - Pizza Oven.pdf', 'd2bd464db35fe359802d654988a27a068a019477.pdf', 'application/pdf', 69330165, '/uploads/brochures/5a09629378099d16c02e6f187c4fb0bea07b8820.jpeg', 'FIre and Dine- Pizza Ovens', 'Download Brochure', 1, 1, 0, 1, 0, 0, 2, '2026-08-14 10:25:01', '2026-08-20 14:20:47', 1);

-- --------------------------------------------------------

--
-- Table structure for table `brochure_downloads`
--

CREATE TABLE `brochure_downloads` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `brochure_id` bigint(20) UNSIGNED NOT NULL,
  `ip_hash` char(64) DEFAULT NULL,
  `user_agent_hash` char(64) DEFAULT NULL,
  `downloaded_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brochure_downloads`
--

-- Privacy sanitisation: data rows for `brochure_downloads` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `catalogs`
--

CREATE TABLE `catalogs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(190) NOT NULL,
  `slug` varchar(190) NOT NULL,
  `description` text DEFAULT NULL,
  `image_media_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(190) NOT NULL,
  `slug` varchar(190) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `catalog_id` bigint(20) UNSIGNED DEFAULT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `image_media_id` bigint(20) UNSIGNED DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `is_active`, `created_at`, `updated_at`, `catalog_id`, `parent_id`, `image_media_id`, `sort_order`) VALUES
(1, 'Accessories', 'accessories', NULL, 1, '2026-08-11 10:04:55', '2026-08-11 10:04:55', NULL, NULL, 1, 0),
(3, 'Pizza Ovens', 'pizza-ovens', NULL, 1, '2026-08-11 10:07:07', '2026-08-11 10:07:07', NULL, NULL, NULL, 0),
(4, 'Fireplace', 'fireplace', NULL, 1, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `categories_legacy_20260811`
--

-- Clean-install omission: legacy/raw staging statement removed.


--
-- Dumping data for table `categories_legacy_20260811`
--

-- Privacy sanitisation: data rows for `categories_legacy_20260811` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` varchar(100) NOT NULL,
  `code` varchar(100) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `discount_type` varchar(50) NOT NULL,
  `discount_value` decimal(12,2) NOT NULL DEFAULT 0.00,
  `minimum_spend` decimal(12,2) DEFAULT NULL,
  `maximum_spend` decimal(12,2) DEFAULT NULL,
  `max_uses` int(11) DEFAULT NULL,
  `max_uses_per_customer` int(11) DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coupon_redemptions`
--

CREATE TABLE `coupon_redemptions` (
  `id` varchar(100) NOT NULL,
  `coupon_id` varchar(100) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `customer_email` varchar(255) NOT NULL,
  `discount_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `full_name` varchar(190) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `total_spend` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `enquiries`
--

CREATE TABLE `enquiries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `application` varchar(50) NOT NULL,
  `product` varchar(190) NOT NULL,
  `location` varchar(255) NOT NULL,
  `measurements` varchar(500) DEFAULT NULL,
  `message` text NOT NULL,
  `preferred_contact` varchar(30) NOT NULL DEFAULT 'Email',
  `attachment_path` varchar(255) DEFAULT NULL,
  `attachment_name` varchar(255) DEFAULT NULL,
  `status` enum('new','in_progress','closed') NOT NULL DEFAULT 'new',
  `ip_hash` char(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `attribution_json` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gallery_media`
--

CREATE TABLE `gallery_media` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `media_type` varchar(20) NOT NULL,
  `source_type` varchar(20) NOT NULL DEFAULT 'upload',
  `title` varchar(190) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `stored_filename` varchar(255) DEFAULT NULL,
  `original_filename` varchar(255) DEFAULT NULL,
  `external_url` varchar(1000) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `thumbnail_path` varchar(500) DEFAULT NULL,
  `thumbnail_filename` varchar(255) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_size` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `managed_upload` tinyint(1) NOT NULL DEFAULT 1,
  `legacy_key` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `gallery_media`
--

INSERT INTO `gallery_media` (`id`, `media_type`, `source_type`, `title`, `description`, `alt_text`, `file_path`, `stored_filename`, `original_filename`, `external_url`, `external_id`, `thumbnail_path`, `thumbnail_filename`, `mime_type`, `file_size`, `display_order`, `enabled`, `managed_upload`, `legacy_key`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'image', 'upload', 'Residential pizza oven installation', NULL, 'Residential mosaic pizza oven installed outdoors on a masonry base', '/assets/images/optimized/installation-residential-real-1200.webp', NULL, NULL, NULL, NULL, NULL, NULL, 'image/webp', 0, 10, 1, 0, 'legacy-1', '2026-08-09 17:08:22', '2026-08-09 17:08:22', NULL, NULL),
(2, 'image', 'upload', 'Commercial oven installation', NULL, 'Twin wood-fired pizza ovens installed for a commercial setting', '/assets/images/optimized/installation-commercial-real-1200.webp', NULL, NULL, NULL, NULL, NULL, NULL, 'image/webp', 0, 20, 1, 0, 'legacy-2', '2026-08-09 17:08:22', '2026-08-09 17:08:22', NULL, NULL),
(3, 'image', 'upload', 'Outdoor fire and dining area', NULL, 'Blue outdoor pizza oven with stainless flue in an open-air setting', '/assets/images/optimized/gallery-outdoor-blue-1200.webp', NULL, NULL, NULL, NULL, NULL, NULL, 'image/webp', 0, 30, 1, 0, 'legacy-3', '2026-08-09 17:08:22', '2026-08-09 17:08:22', NULL, NULL),
(4, 'image', 'upload', 'Wood-fired pizza oven in use', NULL, 'Pizza cooking in a glowing wood-fired oven', '/assets/images/optimized/gallery-pizza-action-1200.webp', NULL, NULL, NULL, NULL, NULL, NULL, 'image/webp', 0, 40, 1, 0, 'legacy-4', '2026-08-09 17:08:22', '2026-08-09 17:08:22', NULL, NULL),
(5, 'image', 'upload', 'Freestanding pizza oven', NULL, 'Fire & Dine Neapolitan pizza oven', '/assets/images/optimized/product-01-1200.webp', NULL, NULL, NULL, NULL, NULL, NULL, 'image/webp', 0, 50, 1, 0, 'legacy-5', '2026-08-09 17:08:22', '2026-08-09 17:08:22', NULL, NULL),
(7, 'image', 'upload', 'Mosaic pizza oven', NULL, 'Fire & Dine mosaic pizza oven', '/assets/images/optimized/product-03-1200.webp', NULL, NULL, NULL, NULL, NULL, NULL, 'image/webp', 0, 70, 1, 0, 'legacy-7', '2026-08-09 17:08:22', '2026-08-09 17:08:22', NULL, NULL),
(9, 'image', 'upload', 'Fire cooking accessories', NULL, 'Fire cooking tools arranged beside a wood-fired oven', '/assets/images/optimized/category-accessories-1200.webp', NULL, NULL, NULL, NULL, NULL, NULL, 'image/webp', 0, 90, 1, 0, 'legacy-9', '2026-08-09 17:08:22', '2026-08-09 17:08:22', NULL, NULL),
(65, 'image', 'upload', 'Flint 1', NULL, NULL, '/uploads/gallery/images/572cef3a0f3148dd9440451e106333cdfd7f2af9.jpg', '572cef3a0f3148dd9440451e106333cdfd7f2af9.jpg', 'WhatsApp Image 2026-08-11 at 14.46.27.jpeg', NULL, NULL, NULL, NULL, 'image/jpeg', 177955, 1, 1, 1, NULL, '2026-08-11 13:09:10', '2026-08-11 13:09:10', 1, 1),
(75, 'video', 'upload', 'Flint 1 Pizza oven', NULL, NULL, '/uploads/gallery/videos/4208d688048b08e125fae0b71b75bbd1aa80d86d.mp4', '4208d688048b08e125fae0b71b75bbd1aa80d86d.mp4', 'FLINT 1.mp4', NULL, NULL, '/uploads/gallery/images/a8f0d3959a67300c42cab8569c0f3857eaf78d86.png', 'a8f0d3959a67300c42cab8569c0f3857eaf78d86.png', 'video/mp4', 11969946, 1, 1, 1, NULL, '2026-08-11 13:14:26', '2026-08-19 14:05:13', 1, 1),
(114, 'video', 'youtube', 'Want by ons is dit nie net kos nie dis n leefstyl.', NULL, NULL, NULL, NULL, NULL, 'https://www.youtube.com/watch?v=9bjQZ9XgzeU', '9bjQZ9XgzeU', '/uploads/gallery/images/f909754fc46e532d38bdf2471c5156e86a87ff8e.png', 'f909754fc46e532d38bdf2471c5156e86a87ff8e.png', NULL, 0, 2, 1, 1, NULL, '2026-08-11 14:22:56', '2026-08-19 14:01:25', 1, 1),
(132, 'image', 'upload', 'Luxurious Sunset Fireplace Retreat', NULL, 'Luxurious Sunset Fireplace Retreat', '/uploads/gallery/images/098dc1d12e04ea2bfce159937e6fc167cb3d47e7.png', '098dc1d12e04ea2bfce159937e6fc167cb3d47e7.png', 'ChatGPT Image Aug 12, 2026, 12_53_35 PM.png', NULL, NULL, NULL, NULL, 'image/png', 2187328, 100, 1, 0, 'fire-dine-gallery-evening-pizza-oven', '2026-08-12 10:58:36', '2026-08-12 10:59:56', NULL, 1),
(218, 'image', 'upload', 'Spar Pizza oven', NULL, NULL, '/uploads/gallery/images/26f05859435e63efcc7c74f8cb211bd3e85369f5.webp', '26f05859435e63efcc7c74f8cb211bd3e85369f5.webp', 'tmpun9a6tgd.webp', NULL, NULL, NULL, NULL, 'image/webp', 103184, 7, 1, 1, NULL, '2026-08-19 14:10:33', '2026-08-19 14:10:33', 1, 1),
(219, 'image', 'upload', 'Mobile pizza oven', NULL, NULL, '/uploads/gallery/images/70805fa63bd59a4fc96b051c764e46760ef90f3e.webp', '70805fa63bd59a4fc96b051c764e46760ef90f3e.webp', 'tmp28l_wo8j.webp', NULL, NULL, NULL, NULL, 'image/webp', 75928, 8, 1, 1, NULL, '2026-08-19 14:12:16', '2026-08-19 14:13:39', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `google_reviews`
--

CREATE TABLE `google_reviews` (
  `id` varchar(100) NOT NULL,
  `google_review_id` varchar(255) NOT NULL,
  `reviewer_name` varchar(255) DEFAULT NULL,
  `reviewer_image_url` varchar(1000) DEFAULT NULL,
  `rating` int(11) NOT NULL,
  `review_text` text DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `synced_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_settings`
--

CREATE TABLE `maintenance_settings` (
  `id` varchar(100) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  `is_published` tinyint(1) NOT NULL DEFAULT 0,
  `title` varchar(255) DEFAULT NULL,
  `heading` varchar(500) DEFAULT NULL,
  `subheading` varchar(500) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `logo_key` varchar(500) DEFAULT NULL,
  `background_image_key` varchar(500) DEFAULT NULL,
  `background_color` varchar(32) DEFAULT NULL,
  `text_color` varchar(32) DEFAULT NULL,
  `button_color` varchar(32) DEFAULT NULL,
  `accent_color` varchar(32) DEFAULT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `phone` varchar(80) DEFAULT NULL,
  `whatsapp` varchar(80) DEFAULT NULL,
  `reopening_at` datetime DEFAULT NULL,
  `countdown_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `seo_title` varchar(255) DEFAULT NULL,
  `seo_description` text DEFAULT NULL,
  `cta_text` varchar(255) DEFAULT NULL,
  `cta_url` varchar(1000) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `media_assets`
--

CREATE TABLE `media_assets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `storage_key` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `byte_size` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `sha256` char(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `media_assets`
--

INSERT INTO `media_assets` (`id`, `storage_key`, `original_name`, `mime_type`, `byte_size`, `created_at`, `sha256`) VALUES
(1, 'f67bc3ae84fa75481cdebff6926c3dce5f475f6b5ed1d2f7.png', 'Accessories-510x287.png', 'image/png', 217881, '2026-08-11 10:04:55', NULL),
(3, '87c06817b82ba4f9dc88e9400f24c850bbf1628753c6352b.webp', 'tmp62kx9r7b-380x380.webp', 'image/webp', 17448, '2026-08-11 10:12:38', NULL),
(5, 'a9883e5f9a10dd5ebb5dbcf7a41e487071f38aa953bc0835.webp', 'tmp8xxyi04q.webp', 'image/webp', 41972, '2026-08-11 10:14:54', NULL),
(7, '3b4c6d64a054cfe4ce575e525107caa6f7c2799771032749.webp', 'tmp8xxyi04q.webp', 'image/webp', 41972, '2026-08-11 10:16:15', NULL),
(8, 'products/53403b47843ac34235e9.webp', 'tmpd4u30s5j.webp', 'image/webp', 47240, '2026-08-11 11:57:11', '53403b47843ac34235e9f279e42afc5cc5afa319f9975fb5383171554cf82814'),
(9, 'products/0b5fe8f62b7719686502.webp', 'tmpcun2ch4x.webp', 'image/webp', 51128, '2026-08-11 11:57:11', '0b5fe8f62b7719686502424c2a8f706b7a3550d6973f137892658ef15c6887b8'),
(10, 'products/1d6bdf336902cccac3e1.webp', 'tmp3vedgctk.webp', 'image/webp', 72194, '2026-08-11 11:57:11', '1d6bdf336902cccac3e13808094a7e9b6f3fb758cf9725b5358a4490c3072853'),
(11, 'products/6ff783f0ce43a3e55e3d.webp', 'tmptyco_d20.webp', 'image/webp', 51594, '2026-08-11 11:57:11', '6ff783f0ce43a3e55e3de062e6a88b8daa1da0e152929ec5f226bebe331b45fd'),
(12, 'products/7cf94d656cb00dd5ec76.webp', 'tmpt27ms1pv.webp', 'image/webp', 53172, '2026-08-11 11:57:11', '7cf94d656cb00dd5ec769bccd4f9013ea2c8df84b9b0be8aafe4c75cab92e65a'),
(13, 'products/d724ce3c225a67b5b758.webp', 'tmp6r064zt_.webp', 'image/webp', 47982, '2026-08-11 11:57:11', 'd724ce3c225a67b5b758da48a88e6ac7bcf035d80de1d5e9217d954392859e1b'),
(14, 'products/c3467b98d013763d1fdd.webp', 'tmpdxjp4jfs.webp', 'image/webp', 88148, '2026-08-11 11:57:11', 'c3467b98d013763d1fdd862892d236d0b7df193c3793e6442100a1310de4a2be'),
(15, 'products/b4ba7b3a06f326de5758.webp', 'tmp0evb1bc5.webp', 'image/webp', 49812, '2026-08-11 11:57:11', 'b4ba7b3a06f326de5758f862a930d4f7edf2ce045ee3b68e3956e773baa5ecf4'),
(16, 'products/5575a1a011628c1c332e.webp', 'tmp4qyn6l0a.webp', 'image/webp', 43754, '2026-08-11 11:57:11', '5575a1a011628c1c332e69b5d37fa3f0e254b5e84ee0325cf005f535c617fa36'),
(17, 'products/620901a7c5f1ee03a313.webp', 'tmpo0e8ibcx.webp', 'image/webp', 32896, '2026-08-11 11:57:11', '620901a7c5f1ee03a3133e7fd6565ef61421494cce70e2c98fc29cbbd1d6d90c'),
(18, 'products/c08f1de4f265f4de14c4.webp', 'tmp_t_4o6_e.webp', 'image/webp', 35338, '2026-08-11 11:57:11', 'c08f1de4f265f4de14c469c9e43d391dc0fa9af812c19de24ff6cd5bd88fa217'),
(19, 'products/b4f9be9beeb280057c67.webp', 'tmpz96cj41r.webp', 'image/webp', 34436, '2026-08-11 11:57:11', 'b4f9be9beeb280057c6734a83219b0a9e2152806ab531bd94bcc112e7b41b6bc'),
(20, 'products/084b7fab0025ad67d60e.webp', 'tmp_8u3t43r.webp', 'image/webp', 59870, '2026-08-11 11:57:11', '084b7fab0025ad67d60e60aee9ae4f4d45ae7d3d924a1d234153cfdf377972c0'),
(21, 'products/6aa0d32881d8c1b82912.webp', 'tmp5g3w9wns.webp', 'image/webp', 44080, '2026-08-11 11:57:11', '6aa0d32881d8c1b8291243e8706fa1a146af6700590a9e1cf2a93a50993ad074'),
(22, 'products/b68d5b397e8abfc9522d.webp', 'tmpm_9b09ye.webp', 'image/webp', 102126, '2026-08-11 11:57:11', 'b68d5b397e8abfc9522d5c62c9d8a02343b5ad289502f0065fc7aece2dacbe04'),
(23, 'products/e9d7d3859209a8844025.webp', 'tmp7s5ayavs.webp', 'image/webp', 41898, '2026-08-11 11:57:11', 'e9d7d3859209a8844025251a54ec247854ef08fb4d8645dc64b065114e39a722'),
(24, 'products/e00e4b7fe637f6dd5d69.webp', 'tmpki6eue79.webp', 'image/webp', 34798, '2026-08-11 11:57:11', 'e00e4b7fe637f6dd5d69931cfc837632e7d7b57b85adce3fd8e6d1edbf842d71'),
(25, 'products/726ea7218022df3834bf.webp', 'tmp4r6sb__z.webp', 'image/webp', 49610, '2026-08-11 11:57:11', '726ea7218022df3834bf7f5dc4fa2cca4de0bbd7a2919d9293c5af010e7ad183'),
(26, 'products/052319ba0431eb3304bf.webp', 'tmp7zpz5xl3.webp', 'image/webp', 45014, '2026-08-11 11:57:11', '052319ba0431eb3304bf0399a9ef5ff4f34c009e1ff25eb4b9c86df5e84939ad'),
(27, 'products/8c5f3f4ddcd7bbf4dcfa.webp', 'tmp6vjg9aiu.webp', 'image/webp', 34102, '2026-08-11 11:57:11', '8c5f3f4ddcd7bbf4dcfacdd71f312cd75436187950f10d6e53ed8c5257da56a5'),
(28, 'products/80af435a263bdffc6ea4.webp', 'tmp62kx9r7b.webp', 'image/webp', 41546, '2026-08-11 11:57:11', '80af435a263bdffc6ea4f2c75db30901bb5e753a453cc1f855299781a28f4d31'),
(29, 'products/3df6602a01d8569d7fb4.webp', 'tmp8xxyi04q.webp', 'image/webp', 41972, '2026-08-11 11:57:11', '3df6602a01d8569d7fb4e0bcb9a0da9a6b69ea3e08d68ef99b8484308c87e5b7'),
(30, 'products/dd76f011605bc25cda68.webp', 'tmp_w3tcil8.webp', 'image/webp', 43590, '2026-08-11 11:57:11', 'dd76f011605bc25cda6826b06b15296ab0398acba86258d1a8aacf1dab9f05b5'),
(31, 'products/222f335f4a9bc3ae8ba2.webp', 'tmp0howu22a.webp', 'image/webp', 39664, '2026-08-11 11:57:11', '222f335f4a9bc3ae8ba28f71eda978584cb824827b9253aa488df27a3618f6be'),
(32, 'products/44bdbdf63b0be09e57d6.webp', 'tmpuw8f0ckx.webp', 'image/webp', 38706, '2026-08-11 11:57:12', '44bdbdf63b0be09e57d67d6e95d862caff73f2c6e0e32ae6182f46559bb7eaf0'),
(33, 'products/d1045f887e4ced64496e.webp', 'tmp4if602qu.webp', 'image/webp', 52956, '2026-08-11 11:57:12', 'd1045f887e4ced64496e3cde4ab68ad213f60fc42fec2dd3424d29dfbee13d82'),
(34, 'products/2a6cbfdcfe5bfc46cff0.webp', 'tmp16db60ud.webp', 'image/webp', 50522, '2026-08-11 11:57:12', '2a6cbfdcfe5bfc46cff07670a4784e8acc3f3e789802aa8d285d808879bad420'),
(35, 'products/060593661ff33e8b247e.webp', 'tmplw3i7wtr.webp', 'image/webp', 47710, '2026-08-11 11:57:12', '060593661ff33e8b247e16e3b57173472717d6c9b899244ac7171fbf43cfd1aa'),
(36, 'products/2b25d92f1039086b0c84.webp', 'tmpkl2wyu_c.webp', 'image/webp', 50530, '2026-08-11 11:57:12', '2b25d92f1039086b0c84fa8433b3aa0809881a7ed7c76cb52a25184746fed252'),
(37, 'products/12ce687f8572e1d9a67d.webp', 'tmpebk2xzf7.webp', 'image/webp', 66334, '2026-08-11 11:57:12', '12ce687f8572e1d9a67d6d1c7fecced3bb1a8d950277c176006af781c89d0245'),
(38, 'products/67e162ab57a18e8da8f7.webp', 'tmpfqxx7xwj.webp', 'image/webp', 60274, '2026-08-11 11:57:12', '67e162ab57a18e8da8f7fd1151e63ec9747af6e067ea1c8ba18edc4cc4cc0f6f'),
(39, 'products/b27b384276599ad1e72f.webp', 'tmpiz180bfe.webp', 'image/webp', 84854, '2026-08-11 11:57:12', 'b27b384276599ad1e72f8ca5c1353f898ebdc44c1068a733337005eed702c46e'),
(40, 'products/ea583e576f8e089c6462.webp', 'tmpk46izcpi.webp', 'image/webp', 82516, '2026-08-11 11:57:12', 'ea583e576f8e089c646241032710b384d42e33174aade3cd342ef00f7e41679a'),
(41, 'products/6f7af5db3c275a5ac92d.webp', 'tmpd9_mu6ai.webp', 'image/webp', 77714, '2026-08-11 11:57:12', '6f7af5db3c275a5ac92d29ec8fffa475c1071d2163a8376295b4c8201b411ba0'),
(42, 'products/48c18d3521503d426ecd.webp', 'tmp2637m73j.webp', 'image/webp', 63140, '2026-08-11 11:57:12', '48c18d3521503d426ecdd762f01ae7d6631f6b268d5b10caa00f569744edb14c'),
(43, 'products/17035fabb3e87eed6539.webp', 'tmpdcl2c2f4.webp', 'image/webp', 61594, '2026-08-11 11:57:12', '17035fabb3e87eed6539f47a4b8787e3e2c33ebcb2bdd7086c8614bf05114fbb'),
(44, 'products/3462c314875db47bf61b.webp', 'tmp895sinku.webp', 'image/webp', 61732, '2026-08-11 11:57:12', '3462c314875db47bf61bf559270c59d6f8a3a6f77b28507ad4c77e24ba91832b'),
(45, 'products/1ec87598997574f197f3.webp', 'tmptmqcb3em.webp', 'image/webp', 57600, '2026-08-11 11:57:12', '1ec87598997574f197f33a0c7626173217147d2d22dee011d3d8706aac15243f'),
(46, 'products/5a7a3a4461c661aba6a4.webp', 'tmpszw704mf.webp', 'image/webp', 110362, '2026-08-11 11:57:12', '5a7a3a4461c661aba6a4a1a97ea09ec09b95e93178fdc6c30a25e210536f6a9d'),
(47, 'products/b08a2ee484ab294b9c57.webp', 'tmp2rzzvzg6.webp', 'image/webp', 22406, '2026-08-11 11:57:12', 'b08a2ee484ab294b9c5740b09334416c13240d8227eb60b61ef9a5cf79825e2d'),
(48, 'products/8d0695c2fe0b931ffb2e.webp', 'tmp86svm09x.webp', 'image/webp', 47844, '2026-08-11 11:57:12', '8d0695c2fe0b931ffb2e533160e88714c6d0094cfeb0de8ccd6c40459d507560'),
(49, 'products/a8b3585fcd5426e1ea46.webp', 'tmpsn69q32i.webp', 'image/webp', 43142, '2026-08-11 11:57:12', 'a8b3585fcd5426e1ea4602113e12238f69babfddcab01fb7e6aab44175858176'),
(50, 'products/0c6f0df188ae1d57757f.webp', 'tmp_1zh0rv3.webp', 'image/webp', 92862, '2026-08-11 11:57:12', '0c6f0df188ae1d57757fdac5e6f29302e5bac2969060d98b92fee88b471eb519'),
(51, 'products/b5d7a1f465254cf11d7c.webp', 'tmpu8va6ixj.webp', 'image/webp', 37976, '2026-08-11 11:57:12', 'b5d7a1f465254cf11d7ceba91ddff0fdec85ebcba287e80fbb74070ee83c2dbb'),
(52, 'products/4ff737c6606e51bf3c49.jpg', 'WhatsApp-Image-2026-05-07-at-09.16.23.jpeg', 'image/jpeg', 407882, '2026-08-11 11:57:12', '4ff737c6606e51bf3c49da663c83df415e944cf258b344419e8d7ba4c117fa57'),
(53, 'products/b45b6fb9a973d817a2c4.png', '1.png', 'image/png', 923270, '2026-08-11 11:57:12', 'b45b6fb9a973d817a2c43f56c27d1d573adfe9792aee6817073c1807d6463b52'),
(54, 'products/ebd513cadf58327e5f27.png', '2.png', 'image/png', 846045, '2026-08-11 11:57:12', 'ebd513cadf58327e5f27c7e7ffa11c121fabf258c379acbfed2ab696ba2bab8f'),
(55, 'products/1db2098bf94092b2d65b.png', '3.png', 'image/png', 1183347, '2026-08-11 11:57:12', '1db2098bf94092b2d65b8656706535e1e87b72b2aa5802b81dc32244ee0b443e'),
(56, 'products/72070c432af768391003.png', '4.png', 'image/png', 1153306, '2026-08-11 11:57:12', '72070c432af768391003c9edfafe910adc60c87ea566cde5848f90368d216767'),
(57, 'products/1387f1048332b27545d6.png', '5.png', 'image/png', 1079195, '2026-08-11 11:57:12', '1387f1048332b27545d6a307e24ed6b717e0d13837b2b4625db0be3d636207ee'),
(58, 'products/06af900af3cc9fe67067.png', '6.png', 'image/png', 898787, '2026-08-11 11:57:12', '06af900af3cc9fe67067a78ae58dff9219328a51b2826be20529eec7008cd150'),
(59, 'products/8df8944303bd98e894bd.png', 'Fire-and-Dine_Fireplace-ForgeF100.png', 'image/png', 1635255, '2026-08-11 11:57:12', '8df8944303bd98e894bd786d68b75fc289d88f6944bc7536ed20f1f5d768ee12'),
(61, '57fab01691287ddf99ebb47e287b5866ebfb41a256a2c977.jpg', 'WhatsApp Image 2026-08-11 at 14.46.27.jpeg', 'image/jpeg', 177955, '2026-08-11 12:55:28', NULL),
(62, '9301de92069f050511c9c71f9cdc019a942e9c1701944157.jpg', 'WhatsApp Image 2026-08-07 at 08.51.04 (2).jpeg', 'image/jpeg', 177955, '2026-08-19 10:25:18', NULL),
(63, '7485371841cb70d9bdd0dad4f7da321f5aa737f7822bd9ee.jpg', 'WhatsApp Image 2026-08-07 at 08.51.06 (1).jpeg', 'image/jpeg', 71696, '2026-08-19 10:25:18', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `media_assets_legacy_20260811`
--

-- Clean-install omission: legacy/raw staging statement removed.


--
-- Dumping data for table `media_assets_legacy_20260811`
--

-- Privacy sanitisation: data rows for `media_assets_legacy_20260811` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` varchar(100) NOT NULL,
  `order_number` varchar(100) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `payment_status` varchar(50) NOT NULL DEFAULT 'unpaid',
  `payment_provider` varchar(50) DEFAULT NULL,
  `currency` varchar(8) NOT NULL DEFAULT 'ZAR',
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `discount_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `shipping_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tax_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `coupon_code` varchar(100) DEFAULT NULL,
  `customer_email` varchar(255) NOT NULL,
  `customer_first_name` varchar(150) DEFAULT NULL,
  `customer_last_name` varchar(150) DEFAULT NULL,
  `customer_phone` varchar(80) DEFAULT NULL,
  `shipping_address_json` longtext DEFAULT NULL,
  `billing_address_json` longtext DEFAULT NULL,
  `customer_note` text DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `purchase_event_id` varchar(100) DEFAULT NULL,
  `attribution_json` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `product_name` varchar(190) NOT NULL,
  `category_name` varchar(190) DEFAULT NULL,
  `variant_name` varchar(190) DEFAULT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `unit_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_value` decimal(12,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items_legacy_20260811`
--

-- Clean-install omission: legacy/raw staging statement removed.


-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `request_ip_hash` char(64) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_transactions`
--

CREATE TABLE `payment_transactions` (
  `id` varchar(100) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `provider` varchar(50) NOT NULL DEFAULT 'payfast',
  `transaction_id` varchar(255) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `status` varchar(50) NOT NULL,
  `notification_hash` varchar(255) DEFAULT NULL,
  `processed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(190) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `slug` varchar(190) NOT NULL,
  `description` text DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `regular_price` decimal(12,2) DEFAULT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `thumbnail_media_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `catalog_id` bigint(20) UNSIGNED DEFAULT NULL,
  `short_description` text DEFAULT NULL,
  `sale_price` decimal(12,2) DEFAULT NULL,
  `stock_status` varchar(30) NOT NULL DEFAULT 'in_stock',
  `brand` varchar(190) DEFAULT NULL,
  `tags` varchar(1000) DEFAULT NULL,
  `specifications` longtext DEFAULT NULL,
  `weight` decimal(10,3) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `seo_title` varchar(255) DEFAULT NULL,
  `seo_description` varchar(500) DEFAULT NULL,
  `source_system` varchar(40) DEFAULT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_type` varchar(30) NOT NULL DEFAULT 'simple',
  `visibility` varchar(30) NOT NULL DEFAULT 'visible',
  `backorders` varchar(20) NOT NULL DEFAULT 'no',
  `sold_individually` tinyint(1) NOT NULL DEFAULT 0,
  `length_mm` decimal(10,2) DEFAULT NULL,
  `width_mm` decimal(10,2) DEFAULT NULL,
  `height_mm` decimal(10,2) DEFAULT NULL,
  `attributes_json` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `slug`, `description`, `category_id`, `regular_price`, `stock_quantity`, `status`, `featured`, `thumbnail_media_id`, `created_at`, `updated_at`, `catalog_id`, `short_description`, `sale_price`, `stock_status`, `brand`, `tags`, `specifications`, `weight`, `sort_order`, `seo_title`, `seo_description`, `source_system`, `source_id`, `product_type`, `visibility`, `backorders`, `sold_individually`, `length_mm`, `width_mm`, `height_mm`, `attributes_json`) VALUES
(75, 'Premium DIY Range', 'wc-370', 'premium-diy-range', NULL, 3, NULL, 0, 'active', 0, 8, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, '<strong>DIY Pizza Oven Range</strong> Perfect for the DIY enthusiast, the Fire &amp; Dine DIY Pizza Oven Range brings authentic wood-fired cooking to your backyard. With easy installation and four available sizes, this range is ideal for families and small gatherings, offering a fun and rewarding project with delicious results.\r\\n\r\\n<strong>Sizes</strong>\r\\n\r\\nFront to back: Small (93cm) Medium (105cm) Large (120cm)\r\\n\r\\nSide to side: Small (82cm) Medium (92cm) Large (100cm)\r\\n\r\\nInner Diameter:Small (70cm) Medium (80cm) Large (90cm)\r\\n\r\\n<strong>Easy Setup:</strong> The dome and floor come as one fully assembled unit, making installation quick and simple. You can have your oven ready to use in less than an hour! See the DIY installation guide on our website for full details.\r\\n\r\\n<strong>Extra Options:</strong>\r\\n\r\\n<strong>Coastal Upgrade:</strong> Add a 304 stainless brushed storm cowl and flue with an aluminum door for extra durability in coastal areas. <strong>Built-in Thermometer:</strong> Monitor oven temperature with precision for perfect results every time. <strong>Choose Your Finish:</strong> Customize your oven with a smooth or textured finish, and select your ideal brick face to match your style. See image in gallery. <strong>Mosaic:</strong> Optional extra to add a unique touch to your oven. Need help or interested in customizing with mosaic tiles?\r\\n\r\\n📧<strong> Email:</strong><a href=\"mailto:info@fireanddine.co.za\"> </a><a href=\"mailto:info@fireanddine.co.za\">info@fireanddine.co.za</a> or <a href=\"mailto:andre@fireanddine.co.za\">andre@fireanddine.co.za</a> 📞 <strong>Phone:</strong> +27 83 438 1485\r\\n\r\\n📧 <strong>For Garden Route orders</strong>: email: <a href=\"mailto:willie@fireanddine.co.za\">willie@fireanddine.co.za</a> 📞<strong> Phone:</strong> +27 82 824 7265\r\\n\r\\n<strong>Shipping:</strong> Dependent on location. Contact the office for your route. <strong>Delivery:</strong> Please ensure 4 people are available to assist with delivery.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 370, 'variable', 'visible', 'no', 1, NULL, NULL, NULL, '{\"Size\":[\"Small\",\"Medium\",\"Large\"],\"Coastal Upgrade\":[\"Yes\",\"No\"],\"Thermometer\":[\"Yes\",\"No\"]}'),
(76, 'Stainless Steel Paddle', 'wc-1168', 'stainless-steel-paddle', NULL, 1, 650.00, 0, 'active', 0, 17, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, '<strong>Stainless Steel Pizza Oven Paddle: Perfect Your Pizzeria Experience</strong>\r\\n\r\\nTake your pizza-making skills to the next level with our Stainless Steel Pizza Oven Paddle! Engineered for both amateur cooks and professional chefs, this essential tool is designed to help you effortlessly slide pizzas in and out of your oven while ensuring optimal results every time.\r\\n\r\\n<strong>Features:</strong>\r\\n<ul>\r\\n 	<li><strong>Durable Stainless Steel Construction:</strong> Made from high-quality, food-grade stainless steel, this paddle is built to withstand high temperatures and resist warping, ensuring it will last for years to come.</li>\r\\n 	<li><strong>Extra-Wide Surface:</strong> The generous paddle surface accommodates large pizzas, calzones, and even bread, allowing you to easily maneuver your creations without fear of sticking.</li>\r\\n 	<li><strong>Comfortable Handle:</strong> Featuring an ergonomic, heat-resistant handle, our paddle provides a secure grip, making it easy to slide your pizzas in and out while keeping your hands safe from heat.</li>\r\\n 	<li><strong>Versatile Use:</strong> Ideal for wood-fired, gas, or electric ovens, this paddle is perfect for home kitchens, backyard barbecues, or professional pizza setups.</li>\r\\n 	<li><strong>Easy to Clean:</strong> The smooth surface allows for a quick and hassle-free cleanup, so you can focus on what matters most—creating delicious pizzas!</li>\r\\n</ul>\r\\nElevate your outdoor cooking experience with the Stainless Steel Pizza Oven Paddle. Whether you’re hosting a pizza night with friends or experimenting with new recipes, this paddle is your go-to tool for achieving pizzeria-quality results in the comfort of your home.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1168, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(77, 'Stainless Steel Coal Rake', 'wc-1202', 'stainless-steel-coal-rake', NULL, 1, 400.00, 0, 'active', 0, 18, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, '<strong>Stainless Steel Coal Rake: The Essential Tool for Perfectly Managed Fires</strong>\r\\n\r\\nElevate your grilling and outdoor cooking experience with our Stainless Steel Coal Rake! Designed for both enthusiasts and professionals, this robust tool makes it easy to manage your charcoal or wood fires, ensuring even heat distribution and optimal cooking conditions.\r\\n\r\\n<strong>Features:</strong>\r\\n<ul>\r\\n 	<li><strong>Premium Stainless Steel Construction:</strong> Crafted from high-quality, food-grade stainless steel, this coal rake is built to withstand high temperatures and resist rust, ensuring durability for years of outdoor cooking.</li>\r\\n 	<li><strong>Efficient Design:</strong> The long, sturdy prongs allow you to easily maneuver and redistribute coals, helping you achieve the perfect heat for grilling, smoking, or roasting your favorite dishes.</li>\r\\n 	<li><strong>Ergonomic Handle:</strong> Designed for comfort, the heat-resistant handle provides a secure grip, making it easy to adjust your fire while keeping your hands safely away from the heat.</li>\r\\n 	<li><strong>Versatile Use:</strong> Perfect for charcoal grills, fire pits, and outdoor wood-burning stoves, this coal rake is an essential addition to your outdoor cooking toolkit.</li>\r\\n 	<li><strong>Easy to Clean:</strong> The smooth surface allows for quick cleanup, so you can spend more time enjoying your food and less time scrubbing tools.</li>\r\\n</ul>\r\\nTake control of your outdoor cooking with the Stainless Steel Coal Rake. Whether you’re grilling steaks, smoking ribs, or roasting vegetables, this essential tool ensures that your fire is always just right, making every meal a delicious success!', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1202, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(78, 'Ash Shovel', 'wc-1204', 'ash-shovel', NULL, 1, 680.00, 0, 'active', 0, 19, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, '<strong>Stainless Steel Pizza Oven Ash Shovel: The Perfect Companion for Your Outdoor Cooking</strong>\r\\n\r\\nElevate your pizza-making experience with our Stainless Steel Pizza Oven Ash Shovel! Designed for both convenience and durability, this essential tool makes cleaning and maintaining your outdoor pizza oven a breeze.\r\\n\r\\n<strong>Features:</strong>\r\\n<ul>\r\\n 	<li><strong>Premium Stainless Steel Construction:</strong> Crafted from high-quality stainless steel, this ash shovel is built to withstand high temperatures and resist rust, ensuring long-lasting performance.</li>\r\\n 	<li><strong>Efficient Design:</strong> The wide, flat scoop allows for easy collection and removal of ash and debris, keeping your pizza oven clean and ready for your next culinary masterpiece.</li>\r\\n 	<li><strong>Ergonomic Handle:</strong> Featuring a comfortable, heat-resistant handle, this shovel provides a secure grip while keeping your hands safely away from heat.</li>\r\\n 	<li><strong>Versatile Use:</strong> Perfect for not just pizza ovens, but also wood-fired grills, fireplaces, and fire pits, making it a versatile addition to your outdoor cooking toolkit.</li>\r\\n 	<li><strong>Easy Storage:</strong> Its sleek design and lightweight build make for convenient storage, so you can keep your outdoor area organized and clutter-free.</li>\r\\n</ul>\r\\nTransform your outdoor cooking setup with the Stainless Steel Pizza Oven Ash Shovel—because every great pizza starts with a clean oven! Enjoy effortless maintenance and unleash your creativity as you craft delicious, restaurant-quality pizzas at home.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1204, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(79, 'Flatpack Braai', 'wc-1215', 'flatpack-braai', NULL, 1, 850.00, 0, 'active', 0, 20, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Flatpack Braai\r\\nThe Fire &amp; Dine Flatpack Braai is a compact, foldable steel grill designed for easy transport and quick setup. Built for convenience without compromising on durability, this braai packs flat to save space and is perfect for camping, picnics, or any outdoor gathering. Whether you\'re at the beach or in your backyard, it\'s your go-to solution for hassle-free, authentic braai experiences anywhere!\r\\n\r\\nStainless Steel available on custom order!', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1215, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(80, 'Rib Rack', 'wc-1216', 'rib-rack', NULL, 1, 620.00, 0, 'active', 0, 21, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, '<strong>Stainless Steel Rib Rack: Elevate Your Grilling Game</strong>\r\\n\r\\nUnleash the full potential of your BBQ with our premium Stainless Steel Rib Rack! Designed for both amateur grillers and seasoned pitmasters, this durable rack is perfect for holding up to 6 racks of ribs, allowing for even cooking and maximum flavor absorption.\r\\n\r\\n<strong>Features:</strong>\r\\n<ul>\r\\n 	<li>High-Quality Stainless Steel: Crafted from food-grade stainless steel, this rack resists rust and corrosion, ensuring longevity and easy cleaning.</li>\r\\n 	<li>Optimal Design: The angled slots ensure that your ribs cook evenly and stay upright, maximizing grill space and promoting perfect heat circulation.</li>\r\\n 	<li>Versatile Use: Ideal for grilling, smoking, or roasting, this rib rack is perfect for all types of meats, from baby back ribs to spare ribs and beyond.</li>\r\\n 	<li>Easy Storage: Its compact design allows for simple storage when not in use, fitting conveniently in any kitchen or outdoor cooking space.</li>\r\\n</ul>\r\\nElevate your next BBQ gathering with the Stainless Steel Rib Rack—where delicious flavor meets functional design. Perfect for gatherings, competitions, or just a weekend cookout, this rack is your new secret weapon for mouthwatering ribs every time!', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1216, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(81, 'Accessory Hanger', 'wc-1217', 'accessory-hanger', NULL, 1, 300.00, 0, 'active', 0, 22, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, '<strong>Fire &amp; Dine Accessory Hanger</strong>\r\\nKeep your pizza tools organised and within reach with the Fire &amp; Dine Accessory Hanger. Crafted from durable steel and featuring the stylish F&amp;D logo, this wall-mounted hanger is perfect for storing paddles, ash shovels, cutters, and more. A sleek and practical addition to any pizza-making space!', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1217, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(82, 'Accessory Hanger With Shelf', 'wc-1219', 'accessory-hanger-with-shelf', NULL, 1, 680.00, 0, 'active', 0, 23, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Accessory Hanger With Shelf\r\\nMaximise your pizza prep space with the Fire &amp; Dine Accessory Hanger with Shelf. Designed for both function and style, this sturdy wall-mounted unit features multiple hooks for hanging tools and a convenient top shelf for storing spices, cutters, or small accessories. A must-have for any serious pizza enthusiast!', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1219, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(83, 'Rib Rack', 'wc-1220', 'rib-rack-wc-1220', NULL, 1, 580.00, 0, 'active', 0, 24, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Unleash the full potential of your BBQ with our premium Rib Rack! Designed for both amateur grillers and seasoned pitmasters, this durable rack is perfect for holding up to 5 racks of ribs, allowing for even cooking and maximum flavor absorption.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1220, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(84, 'Bosca Limit 360', 'wc-1221', 'bosca-limit-360', NULL, 4, 23999.00, 0, 'active', 0, 25, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, '<strong>Bosca Limit 360 Closed Combustion Fireplace</strong>\r\\nSimplicity is key with the Bosca Limit 360 Closed Combustion Fireplace. With its modern geometric design, the Bosca Limit is the ideal edition to effectively heat your home. The Bosca Limit 360 offers a hermetic closing system that ensures the doors are fully closed, so no fumes enter your household and all the heat is retained. Equipped with space to store wood in the bottom cavity and ideal to use to dry wood in that space whilst your fireplace is in use.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1221, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(85, 'Bosca Gold 500', 'wc-1222', 'bosca-gold-500', NULL, 4, 31999.00, 0, 'active', 0, 26, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Bosca Gold 500 Charcoal Closed Combustion Fireplace\r\\nThe Bosca Gold 500 Charcoal Closed Combustion Fireplace is a modern piece with geometric accents that will add the perfect finishing touch to your large open-plan room. Using less wood with its double combustion system it generates more heat for a longer period of time, warming up a space of up to 220m². Easy and convenient cleaning with its own ashpan included. Available in charcoal, this eco-friendly fireplace has a controlled air function that allows low to high airflow depending on the expected heat output required. This fireplace is safe to have with children running about. Finished off with a wood holder at the base this unit really does have it all.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1222, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(86, 'Bosca Gold 380', 'wc-1223', 'bosca-gold-380', NULL, 4, 27999.00, 0, 'active', 0, 27, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Bosca Gold 380 Charcoal Closed Combustion Fireplace\r\\nThe Bosca Gold 380 Charcoal is very modern with geometric accents, Bosca Gold 380 Charcoal is the ultimate statement piece for your home. Not only will it impress guests, but it will also heat up any room with its closed combustion design. Eco friendly, the Bosca Gold 380 Closed Combustion Fireplace is coated on the inside to keep the heat that is generated for longer, leaving your home warm and ready to entertain.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1223, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(87, 'Bosca Firepoint 380', 'wc-1224', 'bosca-firepoint-380', NULL, 4, 26999.00, 0, 'active', 0, 28, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Bosca Firepoint 380 Closed Combustion Fireplace\r\\nThe Bosca Firepoint 380 offers a stylish design for your household whilst providing a high heat range. This closed combustion fireplace has a very long lifespan and is the most effective way to heat your home with 68% heat retention rate.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1224, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(88, 'Bailey 6kW', 'wc-1227', 'bailey-6kw', NULL, 4, 8499.00, 0, 'active', 0, 29, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Bailey 6kW Cast Iron Fireplace\r\\nSleek, small, and packed with power. Our Megamaster Bailey 6kW Cast Iron Fireplace is effective in heating rooms ranging between 48-60m² in size. Built with a closed combustion system, the Bailey 6kW Cast Iron Fireplace heats up much hotter than a conventional open fireplace. Heat generated inside is locked in and will burn at higher temperatures with the door closed. For optimal heat, ensure that the room is well insulated.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1227, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(89, 'Walden 8kW', 'wc-1228', 'walden-8kw', NULL, 4, 11499.00, 0, 'active', 0, 30, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Walden 8kW Cast Iron Fireplace\r\\nRetro with streamline design and finishes, our Megamaster Walden 8kW Cast Iron Fireplace is effective in heating rooms ranging between 64-80m² in size. Built with a closed combustion system, the Walden 8kW Cast Iron Fireplace heats up much hotter than a conventional open fireplace. Heat generated inside is locked in and will burn at higher temperatures with the door closed. For optimal heat, ensure that the room is well insulated.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1228, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(90, 'Andiron 14kW', 'wc-1229', 'andiron-14kw', NULL, 4, 20999.00, 0, 'active', 0, 31, '2026-08-11 11:57:11', '2026-08-11 11:57:11', NULL, 'Andiron 14kW Cast Iron Fireplace\r\\nPart of our built-in cast iron fireplace range, our Megamaster Andiron 14kW Cast Iron Fireplace will add value to your home for keeps. It is effective in heating rooms ranging between 112-140m² in size. Built with a closed combustion system, the Andiron 14kW Cast Iron Fireplace heats up much hotter than a conventional open fireplace. Heat generated inside is locked in and will burn at higher temperatures with the door closed. For optimal heat, ensure that the room is well insulated.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1229, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(91, 'Ontario 12kW', 'wc-1230', 'ontario-12kw', NULL, 4, 14999.00, 0, 'active', 0, 32, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'Ontario 12kW Cast Iron Fireplace\r\\nImpress your guests with our Megamaster Ontario 12kW Cast Iron Fireplace, big enough to keep everyone (and the dog) warm. It is effective in heating rooms ranging between 96-120m² in size. Built with a closed combustion system, the Ontario 12kW Cast Iron Fireplace heats up much hotter than a conventional open fireplace. Heat generated inside is locked in and will burn at higher temperatures with the door closed. For optimal heat, ensure that the room is well insulated.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1230, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(92, 'Tarragon 16kW', 'wc-1231', 'tarragon-16kw', NULL, 4, 17999.00, 0, 'active', 0, 33, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'Tarragon 16kW Cast Iron Fireplace\r\\nThe hero of any large living room, our Megamaster Tarragon 16kW Cast Iron Fireplace is big enough to keep your home toasty and warm. It is effective in heating rooms ranging between 144-160m² in size. Built with a closed combustion system, the Tarragon 16kW Cast Iron Fireplace heats up much hotter than a conventional open fireplace. Heat generated inside is locked in and will burn at higher temperatures with the door closed. For optimal heat, ensure that the room is well insulated.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1231, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(93, 'Neapolitan Commercial Range', 'wc-1233', 'neapolitan-commercial-range', NULL, 3, 0.00, 0, 'active', 1, 34, '2026-08-11 11:57:12', '2026-08-19 13:42:57', NULL, 'Neapolitan Pizza Oven Range\r\n\\n\r\n\\nCrafted to bring the art of Neapolitan pizza to your kitchen, the Fire &amp; Dine Neapolitan Pizza Oven Range is designed for restaurant owners and professional chefs who demand excellence. Engineered for high temperatures and rapid cooking times, these ovens deliver an authentic, traditional pizza experience with every bake.\r\n\\n\r\n\\nSizes\r\n\\n\r\n\\nFront to back: Piccolo (100cm) Classico (120cm) Grande (150cm) Meastro (180cm)\r\n\\n\r\n\\nSide to side: Piccolo (110cm) Classico (125cm) Grande (160cm) Meastro (169cm)\r\n\\n\r\n\\nInner Diameter: Piccolo (80cm) Classico (95cm) Grande (120cm) Meastro (150cm)\r\n\\n\r\n\\nExtra Options:\r\n\\n\r\n\\nCoastal Upgrade: Enhance durability with a 304 stainless brushed storm cowl and flue, paired with an aluminum door—perfect for coastal environments. Built-in Thermometer: Monitor cooking temperatures with precision to ensure perfect results every time. Choose Your Finish: Customize your oven with a smooth or textured finish and select from a variety of brick face options. See images in the gallery. Mosaic: A mosaic face is included, with the option to customize the entire oven. Need help or interested in customizing with mosaic tiles?\r\n\\n\r\n\\n📧 Email: info@fireanddine.co.za or andre@fireanddine.co.za 📞 Phone: +27 83 438 1485\r\n\\n\r\n\\n📧 For Garden Route orders email: willie@fireanddine.co.za 📞 Phone: +27 82 824 7265\r\n\\n\r\n\\nShipping: Dependent on location. Contact the office for your route. Delivery: Please ensure 4 people are available to assist with delivery.', NULL, 'out_of_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1233, 'variable', 'visible', 'no', 0, NULL, NULL, NULL, '{\"Size\":[\"Piccolo\",\"Classico\",\"Grande\",\"Meastro\"],\"Coastal Upgrade\":[\"Yes\",\"No\"],\"Built in Thermometer\":[\"Yes\",\"No\"]}'),
(94, 'Fabricato Commercial Range', 'wc-1250', 'fabricato-commercial-range', NULL, 3, NULL, 0, 'active', 0, 39, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'Pre-Fabricato Commercial Oven Range\r\\n\r\\nBuilt for high-volume use, the Fire &amp; Dine Pre-Fabricato Commercial Oven Range combines durability with performance, making it the top choice for commercial kitchens and professional chefs. Designed to withstand the demands of busy kitchens, each oven provides generous cooking space and exceptional heat retention, ensuring consistent, high-quality results.\r\\n\r\\nSizes\r\\n\r\\nFront to back: Standard (125cm) Grande (135cm) Superior (150cm) Ultra (180cm)\r\\n\r\\nSide to side: Standard (115cm) Grande (125cm) Superior (150cm) Ultra (180cm)\r\\n\r\\nInner Diameter:Standard (80cm) Grande (90cm) Superior (114cm) Ultra (130cm)\r\\n\r\\nExtra Options:\r\\n\r\\nCoastal Upgrade: Enhance durability with a 304 stainless brushed storm cowl, flue, and aluminum door—perfect for coastal environments. Built-in Thermometer: Maintain precise control over oven temperature to achieve consistent cooking results. Choose Your Finish: Customize your oven with a smooth or textured finish and select from a variety of brick face options. See images in the gallery. Mosaic: Optional extra to add a personalized touch to your oven. Need help or interested in customizing with mosaic tiles?\r\\n\r\\n📧 Email: info@fireanddine.co.za or andre@fireanddine.co.za 📞 Phone: +27 83 438 1485\r\\n\r\\n📧 For Garden Route orders: email: willie@fireanddine.co.za 📞 Phone: +27 82 824 7265\r\\n\r\\nShipping: Dependent on location. Contact the office for your route. Delivery: Please ensure 4 people are available to assist with delivery.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1250, 'variable', 'visible', 'no', 0, NULL, NULL, NULL, '{\"Size\":[\"Standard\",\"Grande\",\"Superior\",\"Ultra\"],\"Coastal Upgrade\":[\"Yes\",\"No\"],\"Built in Thermometer\":[\"Yes\",\"No\"]}'),
(95, 'Premium Mobile Range', 'wc-1267', 'premium-mobile-range', NULL, 3, 0.00, 0, 'active', 1, 42, '2026-08-11 11:57:12', '2026-08-19 13:42:49', NULL, 'Premium Mobile Oven Range\r\n\\n\r\n\\nTake your outdoor cooking to the next level with our Premium Mobile Oven Range, designed to bring authentic wood-fired flavour to any setting. Perfect for outdoor gatherings, events, and even enhancing your restaurant’s outdoor dining experience, these versatile ovens offer the unmatched quality and flavor that Fire &amp; Dine is known for.\r\n\\n\r\n\\nSizes\r\n\\n\r\n\\nFront to back: Small (95cm) Medium (105cm) Large (120cm)\r\n\\n\r\n\\nSide to side: Small (82cm) Medium (92cm) Large (100cm)\r\n\\n\r\n\\nInner Diameter:Small (70cm) Medium (80cm) Large (90cm)\r\n\\n\r\n\\nFeatures:\r\n\\n\r\n\\nCoastal Upgrade: Add a 304 stainless brushed storm cowl and flue with an aluminum door for enhanced durability in coastal areas. Built-in Thermometer: Monitor oven temperature with precision for perfect cooking results. Portability: Designed for easy mobility, making it ideal for events, catering, and flexible outdoor use. Complete Set Option: Includes oven, trolley, pizza paddle, and ash rake for a ready-to-go solution. Customization: Choose your ideal finish and accessories to match your style. Need help or interested in customizing your mobile oven?\r\n\\n\r\n\\n📧 Email: info@fireanddine.co.za or andre@fireanddine.co.za 📞 Phone: +27 83 438 1485\r\n\\n\r\n\\n📧 For Garden Route orders: email: willie@fireanddine.co.za 📞 Phone: +27 82 824 7265\r\n\\n\r\n\\nShipping: Dependent on location. Contact the office for your route. Delivery: Please ensure 4 people are available to assist with delivery.', NULL, 'out_of_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1267, 'variable', 'visible', 'no', 0, NULL, NULL, NULL, '{\"Size\":[\"Small\",\"Medium\",\"Large\"],\"Trolley With Side Table\":[\"No\",\"Yes\"],\"Trolley Without Side Table\":[\"Yes\",\"No\"]}'),
(96, 'Steel Oven Range', 'wc-1280', 'steel-oven-range', NULL, 3, NULL, 0, 'active', 0, 45, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'Steel Oven Range\r\\n\r\\nDesigned for durability, performance, and versatility, the Steel Oven Range meets the needs of home chefs, commercial kitchens, and mobile vendors. Crafted from premium materials, these ovens offer excellent heat retention and efficient wood-fired cooking for any dish. Whether hosting family gatherings or managing a busy restaurant, the Steel Oven Range delivers consistent, high-quality results.\r\\n\r\\nSizes\r\\n\r\\nFront to back: Small (102cm) Medium (102cm) Large (126cm)\r\\n\r\\nSide to side: Small (60cm) Medium (97cm) Large (118cm)\r\\n\r\\nFeatures:\r\\n\r\\nCoastal Upgrade: Add a 304 stainless brushed storm cowl and flue with an aluminum door for enhanced durability in coastal environments. Built-in Thermometer: Achieve precise cooking temperatures for perfect results every time. Choose Your Finish: Customize with a smooth or textured finish and select your ideal brick face. View options in the gallery. Mosaic: Optional mosaic tile customization for a personal touch. Need help or interested in customizing with mosaic tiles?\r\\n\r\\n📧 Email: info@fireanddine.co.za or andre@fireanddine.co.za 📞 Phone: +27 83 438 1485\r\\n\r\\n📧 For Garden Route orders: email: willie@fireanddine.co.za 📞 Phone: +27 82 824 7265\r\\n\r\\nShipping: Dependent on location. Contact the office for your route. Delivery: Please ensure 4 people are available to assist with delivery.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1280, 'variable', 'visible', 'no', 0, NULL, NULL, NULL, '{\"Size\":[\"Small\",\"Medium\",\"Large\"],\"Coastal Upgrade\":[\"No\",\"Yes\"],\"Built In Thermometer\":[\"No\",\"Yes\"]}'),
(97, 'Countertop Oven', 'wc-1293', 'countertop-oven', NULL, 3, NULL, 0, 'active', 0, 51, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'Countertop Oven\r\\n\r\\nCompact, versatile, and efficient, the Countertop Oven brings wood-fired flavor to your kitchen or outdoor space. Perfect for home use or compact commercial settings, it’s designed for pizzas, breads, roasts, and more, all with authentic wood-fired taste. Its compact size makes it a space-saving solution without compromising performance.\r\\n\r\\nSizes\r\\n\r\\nFront to back: 64cm\r\\n\r\\nSide to side: 92cm\r\\n\r\\nFeatures:\r\\n\r\\nCoastal Upgrade: Add a 304 stainless brushed storm cowl and flue with an aluminum door for extra durability. Built-in Thermometer: Monitor temperature with precision for perfect results. Choose Your Finish: Customize with a smooth or textured finish and your ideal brick face. See image in the gallery. Mosaic: Optional mosaic tile customization available. Need help or interested in customizing with mosaic tiles?\r\\n\r\\n📧 Email: info@fireanddine.co.za or andre@fireanddine.co.za 📞 Phone: +27 83 438 1485\r\\n\r\\n📧 For Garden Route orders: email: willie@fireanddine.co.za 📞 Phone: +27 82 824 7265\r\\n\r\\nShipping: Dependent on location. Contact the office for your route. Delivery: Please ensure 4 people are available to assist with delivery.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1293, 'variable', 'visible', 'no', 0, NULL, NULL, NULL, '{\"Coastal Upgrade\":[\"Yes\",\"No\"],\"Built in Thermometer\":[\"No\",\"Yes\"]}'),
(98, 'Mobile Countertop Oven', 'wc-1486', 'mobile-countertop-oven', '<p data-start=\"70\" data-end=\"94\">MOBILE COUNTERTOP OVEN</p>\r\\n<p data-start=\"96\" data-end=\"416\">The Mobile Countertop Oven is the ultimate space-saving solution for authentic wood-fired cooking. Perfect for home kitchens or compact commercial setups, its mobile stand design offers added flexibility and convenience. Ideal for pizzas, breads, and roasts! Also available in a gas version or can be converted to gas.\r\\n\r\\nOven Specifications:\r\\n• Dimensions: 640mm x 920mm<br data-start=\"466\" data-end=\"469\" />• Structure: One-piece floor and dome design for quick installation.<br data-start=\"537\" data-end=\"540\" />• Capacity: Fits up to 2 pizzas at a time\r\\n\r\\nOPTIONAL EXTRAS:\r\\n• Countertop trolley without side table R5600<br data-start=\"735\" data-end=\"738\" />• Countertop trolley with side table R6000<br data-start=\"780\" data-end=\"783\" />• Optional Extra Gas Conversion R2600</p>', 3, 18900.00, 0, 'active', 0, 52, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, '<p data-start=\"70\" data-end=\"94\">MOBILE COUNTERTOP OVEN</p>\r\\n<p data-start=\"96\" data-end=\"416\">The Mobile Countertop Oven is the ultimate space-saving solution for authentic wood-fired cooking. Perfect for home kitchens or compact commercial setups, its mobile stand design offers added flexibility and convenience. Ideal for pizzas, breads, and roasts! Also available in a gas version or can be converted to gas.\r\\n\r\\nOven Specifications:\r\\n• Dimensions: 640mm x 920mm<br data-start=\"466\" data-end=\"469\" />• Structure: One-piece floor and dome design for quick installation.<br data-start=\"537\" data-end=\"540\" />• Capacity: Fits up to 2 pizzas at a time\r\\n\r\\nOPTIONAL EXTRAS:\r\\n• Countertop trolley without side table R5600<br data-start=\"735\" data-end=\"738\" />• Countertop trolley with side table R6000<br data-start=\"780\" data-end=\"783\" />• Optional Extra Gas Conversion R2600</p>', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1486, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(99, 'Forge i50 Built-In Closed Combustion Fireplace', 'wc-1499', 'forge-i50-built-in-closed-combustion-fireplace', '<p data-start=\"582\" data-end=\"867\">Transform your living space with the Forge i50 Built-In Closed Combustion Fireplace – designed for homeowners who want both efficient heating and modern aesthetics. Its sleek built-in design creates a premium finish while delivering excellent heat output for comfortable indoor living.</p>\r\\n<p data-start=\"869\" data-end=\"1142\">The large glass viewing window provides a beautiful flame display, while advanced air curtain technology helps keep the glass cleaner for longer. Combined with top and bottom air inlet systems, the Forge i50 is engineered for improved combustion efficiency and performance.</p>\r\\n<p data-start=\"1144\" data-end=\"1159\"><strong data-start=\"1144\" data-end=\"1157\">Features:</strong></p>\r\\n<p data-start=\"1161\" data-end=\"1455\">✔ Large glass viewing window<br data-start=\"1189\" data-end=\"1192\" />✔ Closed combustion technology for improved efficiency<br data-start=\"1246\" data-end=\"1249\" />✔ Air curtain technology helps maintain cleaner glass<br data-start=\"1302\" data-end=\"1305\" />✔ Top &amp; bottom air inlet system<br data-start=\"1336\" data-end=\"1339\" />✔ Removable ashtray for easier cleaning and maintenance<br data-start=\"1394\" data-end=\"1397\" />✔ Modern built-in design suitable for contemporary homes</p>\r\\n<p data-start=\"1457\" data-end=\"1622\">Whether you\'re creating a cozy family atmosphere or upgrading your home\'s heating solution, the Forge i50 offers the perfect balance between functionality and style.</p>', 4, 26995.00, 0, 'active', 0, 53, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, '<p data-start=\"229\" data-end=\"494\">The Forge i50 Built-In Closed Combustion Fireplace combines modern design with efficient heating performance. Featuring a large glass viewing window, air curtain technology, and top &amp; bottom air inlets, it delivers warmth, style, and efficiency to any living space.\r\\n\r\\nLarge glass viewing window<br data-start=\"1189\" data-end=\"1192\" />Closed combustion technology for improved efficiency<br data-start=\"1246\" data-end=\"1249\" />Air curtain technology helps maintain cleaner glass<br data-start=\"1302\" data-end=\"1305\" />Top &amp; bottom air inlet system<br data-start=\"1336\" data-end=\"1339\" />Removable ashtray for easier cleaning and maintenance<br data-start=\"1394\" data-end=\"1397\" />Modern built-in design suitable for contemporary homes</p>', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1499, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(100, 'Forge i120 Built-In Closed Combustion Fireplace', 'wc-1501', 'forge-i120-built-in-closed-combustion-fireplace', '<p data-start=\"511\" data-end=\"820\">Designed for larger spaces and premium installations, the Forge i120 Built-In Closed Combustion Fireplace combines impressive heating power with contemporary styling. With a wide 1200mm design and powerful 20kW output, this fireplace provides exceptional warmth while becoming a standout feature in your home.</p>\r\\n<p data-start=\"822\" data-end=\"1098\">The large glass viewing window creates a beautiful flame display, while air curtain technology helps keep the glass cleaner for longer. Its closed combustion system is designed for improved heating efficiency, and the removable ashtray makes maintenance simple and convenient.</p>\r\\n<p data-start=\"1100\" data-end=\"1115\"><strong data-start=\"1100\" data-end=\"1113\">Features:</strong></p>\r\\n<p data-start=\"1117\" data-end=\"1414\">✔ 1200mm wide design<br data-start=\"1137\" data-end=\"1140\" />✔ Powerful 20kW heat output<br data-start=\"1167\" data-end=\"1170\" />✔ Closed combustion technology for improved efficiency<br data-start=\"1224\" data-end=\"1227\" />✔ Air curtain technology helps maintain cleaner glass<br data-start=\"1280\" data-end=\"1283\" />✔ Large glass viewing window<br data-start=\"1311\" data-end=\"1314\" />✔ Removable ashtray for easy cleaning and maintenance<br data-start=\"1367\" data-end=\"1370\" />✔ Premium built-in design for modern homes</p>\r\\n<p data-start=\"1416\" data-end=\"1543\">Perfect for open-plan living areas, entertainment spaces, and modern homes, the Forge i120 delivers both performance and style.</p>', 4, 48495.00, 0, 'active', 0, 54, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'The Forge i120 Built-In Closed Combustion Fireplace delivers powerful heating performance with a sleek modern design. Featuring a large glass viewing window, 20kW heat output, air curtain technology, and removable ashtray, it is built to create warmth and style in larger living spaces.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1501, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(101, 'Forge F120 Built-In Closed Combustion Fireplace', 'wc-1503', 'forge-f120-built-in-closed-combustion-fireplace', '<p data-start=\"455\" data-end=\"506\"><strong data-start=\"455\" data-end=\"506\">Forge f120 Built-In Closed Combustion Fireplace</strong></p>\r\\n<p data-start=\"508\" data-end=\"795\">Create a striking focal point in your home with the Forge i120 Built-In Closed Combustion Fireplace. Designed with a modern panoramic glass design and engineered for exceptional heating performance, this fireplace offers powerful 20kW output while maintaining efficient fuel consumption.</p>\r\\n<p data-start=\"797\" data-end=\"1097\">Its wide 1200mm design provides an expansive flame display through the panoramic glass window, creating a premium visual experience. Built with efficient combustion technology, precise control systems, and a durable thick gauge steel grate, the Forge i120 is built for both performance and longevity.</p>\r\\n<p data-start=\"1099\" data-end=\"1246\">Whether installed in open-plan living areas, entertainment spaces, or luxury homes, the Forge i120 delivers premium heating with modern aesthetics.</p>\r\\n<p data-start=\"1248\" data-end=\"1263\"><strong data-start=\"1248\" data-end=\"1261\">Features:</strong></p>\r\\n<p data-start=\"1265\" data-end=\"1545\">✔ 1200mm wide design<br data-start=\"1285\" data-end=\"1288\" />✔ Powerful 20kW heat output<br data-start=\"1315\" data-end=\"1318\" />✔ Panoramic glass viewing design<br data-start=\"1350\" data-end=\"1353\" />✔ Efficient burn technology for improved performance<br data-start=\"1405\" data-end=\"1408\" />✔ Precise airflow and burn control<br data-start=\"1442\" data-end=\"1445\" />✔ Heavy-duty thick gauge steel grate<br data-start=\"1481\" data-end=\"1484\" />✔ Modern built-in design suitable for premium installations</p>', 4, 48495.00, 0, 'active', 0, 55, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'The Forge f120 Built-In Closed Combustion Fireplace combines powerful heating with contemporary design. Featuring a panoramic glass viewing window, 20kW output, precise airflow control, and efficient combustion technology, it delivers warmth, performance, and style for modern homes.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1503, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(102, 'Forge F70 Freestanding Closed Combustion Fireplace', 'wc-1505', 'forge-f70-freestanding-closed-combustion-fireplace', '<p data-start=\"506\" data-end=\"822\">The Forge f70 Freestanding Closed Combustion Fireplace is designed for homeowners looking for efficient heating combined with contemporary style. With its compact 700mm wide design and powerful 12kW heat output, the f70 is ideal for creating a warm and inviting atmosphere while becoming a feature piece in any room.</p>\r\\n<p data-start=\"824\" data-end=\"1127\">Its panoramic glass viewing window offers an impressive flame display, while efficient combustion technology ensures improved fuel efficiency and heat performance. Built with precise control systems and a durable thick gauge steel grate, the Forge f70 delivers reliability, performance, and ease of use.</p>\r\\n<p data-start=\"1129\" data-end=\"1270\">The integrated wood storage compartment adds both practicality and style, making this fireplace an excellent choice for modern living spaces.</p>\r\\n<p data-start=\"1272\" data-end=\"1287\"><strong data-start=\"1272\" data-end=\"1285\">Features:</strong></p>\r\\n<p data-start=\"1289\" data-end=\"1651\">✔ 700mm wide design<br data-start=\"1308\" data-end=\"1311\" />✔ Powerful 12kW heat output<br data-start=\"1338\" data-end=\"1341\" />✔ Freestanding closed combustion design<br data-start=\"1380\" data-end=\"1383\" />✔ Panoramic glass viewing window<br data-start=\"1415\" data-end=\"1418\" />✔ Efficient burn technology for improved performance<br data-start=\"1470\" data-end=\"1473\" />✔ Precise airflow and burn control<br data-start=\"1507\" data-end=\"1510\" />✔ Heavy-duty thick gauge steel grate<br data-start=\"1546\" data-end=\"1549\" />✔ Integrated wood storage compartment<br data-start=\"1586\" data-end=\"1589\" />✔ Modern freestanding design suitable for contemporary homes</p>', 4, 26995.00, 0, 'active', 0, 56, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'The Forge f70 Freestanding Closed Combustion Fireplace combines modern freestanding design with powerful 12kW heating performance. Featuring panoramic glass, efficient burn technology, and precise control systems, it delivers warmth, style, and practicality for modern homes.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1505, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(103, 'Forge F40 Freestanding Closed Combustion Fireplace', 'wc-1507', 'forge-f40-freestanding-closed-combustion-fireplace', '<p data-start=\"450\" data-end=\"504\"><strong data-start=\"450\" data-end=\"504\">Forge f40 Freestanding Closed Combustion Fireplace</strong></p>\r\\n<p data-start=\"506\" data-end=\"814\">The Forge f40 Freestanding Closed Combustion Fireplace is designed to deliver powerful heating performance while maintaining a sleek, space-saving design. With a 10kW heat output capable of heating areas up to approximately 100m², the f40 is ideal for creating comfortable living spaces during colder months.</p>\r\\n<p data-start=\"816\" data-end=\"1089\">Featuring a panoramic glass viewing window and advanced air curtain technology, the fireplace provides a stunning flame display while helping keep the glass cleaner for longer. Its precise airflow control system allows for efficient combustion and improved heat management.</p>\r\\n<p data-start=\"1091\" data-end=\"1264\">Constructed using durable thick gauge steel and designed with convenient ash removal and integrated wood storage, the Forge f40 combines practicality with modern aesthetics.</p>\r\\n<p data-start=\"1266\" data-end=\"1281\"><strong data-start=\"1266\" data-end=\"1279\">Features:</strong></p>\r\\n<p data-start=\"1283\" data-end=\"1658\">✔ 10kW heat output (heats up to approximately 100m²)<br data-start=\"1335\" data-end=\"1338\" />✔ Freestanding closed combustion design<br data-start=\"1377\" data-end=\"1380\" />✔ Panoramic glass viewing window<br data-start=\"1412\" data-end=\"1415\" />✔ Air curtain technology for cleaner glass<br data-start=\"1457\" data-end=\"1460\" />✔ Precise airflow and burn control<br data-start=\"1494\" data-end=\"1497\" />✔ Heavy-duty thick gauge steel grate<br data-start=\"1533\" data-end=\"1536\" />✔ Convenient ash removal system<br data-start=\"1567\" data-end=\"1570\" />✔ Integrated wood storage compartment<br data-start=\"1607\" data-end=\"1610\" />✔ Compact modern design for contemporary homes</p>\r\\n<p data-start=\"1660\" data-end=\"1700\"><strong data-start=\"1660\" data-end=\"1675\">Dimensions:</strong><br data-start=\"1675\" data-end=\"1678\" />695 × 400 × 720 mm</p>', 4, 18995.00, 0, 'active', 0, 57, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'The Forge f40 Freestanding Closed Combustion Fireplace delivers efficient heating performance in a compact modern design. With 10kW output, panoramic glass, air curtain technology, and integrated wood storage, it provides warmth, efficiency, and style for contemporary homes.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1507, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(104, 'Forge TEN Wood Burning Closed Combustion Fireplace', 'wc-1509', 'forge-ten-wood-burning-closed-combustion-fireplace', '<p data-start=\"414\" data-end=\"450\"><strong data-start=\"414\" data-end=\"450\">Forge TEN Wood Burning Closed Combustion Fireplace</strong></p>\r\n\\n<p data-start=\"452\" data-end=\"698\">Bring warmth and atmosphere into your home with the Forge TEN Wood Burning Closed Combustion Fireplace. Designed for efficient heating and modern aesthetics, this fireplace offers reliable performance with a compact footprint that suits a variety of living spaces.</p>\r\n\\n<p data-start=\"700\" data-end=\"915\">With a heat output range of 10–12kW and a nominal output of 10kW, the Forge TEN is capable of heating areas up to approximately 108m² while providing excellent heat retention thanks to its vermiculite-lined firebox.</p>\r\n\\n<p data-start=\"917\" data-end=\"1107\">Built for both performance and durability, the fireplace features a top flue outlet configuration, clean modern styling, and a practical design that makes it suitable for contemporary homes.</p>\r\n\\n<p data-start=\"1109\" data-end=\"1124\"><strong data-start=\"1109\" data-end=\"1122\">Features:</strong></p>\r\n\\n<p data-start=\"1126\" data-end=\"1481\">✔ Heat output: 10–12kW<br data-start=\"1148\" data-end=\"1151\" />✔ Nominal heat output: 10kW<br data-start=\"1178\" data-end=\"1181\" />✔ Heating area up to approximately 108m²<br data-start=\"1221\" data-end=\"1224\" />✔ Heating volume: 270m³<br data-start=\"1247\" data-end=\"1250\" />✔ Vermiculite-lined firebox for improved heat retention<br data-start=\"1305\" data-end=\"1308\" />✔ Wood burning design for efficient heating performance<br data-start=\"1363\" data-end=\"1366\" />✔ Top flue outlet (130mm)<br data-start=\"1391\" data-end=\"1394\" />✔ Modern compact freestanding design<br data-start=\"1430\" data-end=\"1433\" />✔ Durable construction built for long-term use</p>\r\n\\n<p data-start=\"1483\" data-end=\"1523\"><strong data-start=\"1483\" data-end=\"1498\">Dimensions:</strong><br data-start=\"1498\" data-end=\"1501\" />426 × 454 × 700 mm</p>', 4, 16495.00, 0, 'active', 1, 58, '2026-08-11 11:57:12', '2026-08-19 13:44:13', NULL, 'The Forge TEN Wood Burning Closed Combustion Fireplace combines compact design with powerful heating performance. Featuring a 10–12kW output, vermiculite-lined firebox, and modern freestanding design, it delivers efficient heating and timeless style for modern living spaces.', NULL, 'out_of_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1509, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]'),
(105, 'Forge F100 Closed Combustion Fireplace', 'wc-1511', 'forge-f100-closed-combustion-fireplace', '<p data-start=\"454\" data-end=\"763\">Transform your living space with the Forge F100 Closed Combustion Fireplace— designed to deliver powerful heating performance while becoming a stylish centrepiece in your home. Featuring a modern panoramic design and advanced closed combustion technology, the F100 provides efficient heating while maximizing fuel performance.</p>\r\\n<p data-start=\"765\" data-end=\"1049\">With an impressive 17kW heating output, the Forge F100 is built to comfortably warm larger spaces while creating a cozy atmosphere through its expansive flame viewing window. Its freestanding design, combined with integrated wood storage, creates both functionality and visual appeal.</p>\r\\n<p data-start=\"1051\" data-end=\"1186\">Built for homeowners who want both performance and premium aesthetics, the Forge F100 delivers warmth, efficiency, and timeless design.</p>\r\\n<p data-start=\"1188\" data-end=\"1203\"><strong data-start=\"1188\" data-end=\"1201\">Features:</strong></p>\r\\n<p data-start=\"1205\" data-end=\"1547\">✔ Powerful 17kW heating output<br data-start=\"1235\" data-end=\"1238\" />✔ Modern panoramic glass design<br data-start=\"1269\" data-end=\"1272\" />✔ Closed combustion technology for improved efficiency<br data-start=\"1326\" data-end=\"1329\" />✔ Large flame viewing window<br data-start=\"1357\" data-end=\"1360\" />✔ Freestanding contemporary design<br data-start=\"1394\" data-end=\"1397\" />✔ Integrated wood storage compartment<br data-start=\"1434\" data-end=\"1437\" />✔ Designed for efficient heat distribution<br data-start=\"1479\" data-end=\"1482\" />✔ Premium construction for durability and long-term performance</p>\r\\n<p data-start=\"1549\" data-end=\"1683\">Whether you\'re creating a cozy family environment or upgrading your heating solution, the Forge F100 brings warmth and style together.</p>', 4, 36495.00, 0, 'active', 0, 59, '2026-08-11 11:57:12', '2026-08-11 11:57:12', NULL, 'The Forge F100 Fireplace combines powerful heating performance with a sleek panoramic design, delivering efficient closed combustion heating for modern homes. With 17kW heating power and contemporary styling, it creates the perfect balance between warmth, efficiency, and aesthetics.', NULL, 'in_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, 'woocommerce', 1511, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, '[]');
INSERT INTO `products` (`id`, `name`, `sku`, `slug`, `description`, `category_id`, `regular_price`, `stock_quantity`, `status`, `featured`, `thumbnail_media_id`, `created_at`, `updated_at`, `catalog_id`, `short_description`, `sale_price`, `stock_status`, `brand`, `tags`, `specifications`, `weight`, `sort_order`, `seo_title`, `seo_description`, `source_system`, `source_id`, `product_type`, `visibility`, `backorders`, `sold_individually`, `length_mm`, `width_mm`, `height_mm`, `attributes_json`) VALUES
(106, 'FLINT 1', '1231', 'flint-1', 'Absolutely — based on the FLINT 1 brochure, here’s a strong website-ready product description:\r\n\r\n**FLINT 1 Compact Wood-Fired Oven**\r\n\r\nThe FLINT 1 is a compact, portable wood-fired oven designed for authentic outdoor cooking wherever you want it — at home, on the farm, at the campsite, or around the braai. Built for people who want real wood-fired flavour without a permanent outdoor kitchen, FLINT 1 is table-ready, requires no gas or electricity, and heats from cold to full baking temperature in approximately 25 minutes. \r\n\r\nIts double ceramic insulation and refractory ceramic cooking floor are engineered to build heat quickly and retain it efficiently, reaching floor temperatures of up to **400°C**. The adjustable rear oxygen vent gives you direct control over airflow and heat, while the choice of hardwood or charcoal lets you switch between smoky high-heat cooking and longer, steadier burns. \r\n\r\nFLINT 1 is made for more than just pizza. Use it for high-temperature Neapolitan-style pizza, bread, baking, roasting, braising, casseroles, and slow cooking. At full temperature, pizza can cook directly on the ceramic floor in approximately **90 seconds**. \r\n\r\n**Key features:** 25-minute heat-up, up to 400°C floor temperature, double ceramic insulation, refractory ceramic cooking stone, hardwood or charcoal fuel, adjustable oxygen vent, high-heat/bake/slow-cook modes, and compact portable construction suitable for home, camping, braais, and farm use. \r\n\r\n**Manufactured in South Africa by Fire & Dine.**', 3, 11000.00, 0, 'active', 1, 62, '2026-08-11 12:55:28', '2026-08-19 10:25:18', NULL, 'Compact, portable wood-fired oven with double ceramic insulation, a refractory cooking floor, adjustable airflow, and a 25-minute heat-up time. Perfect for pizza, bread, roasting, and slow cooking at home, at the braai, or on the go.', 9800.00, 'out_of_stock', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'simple', 'visible', 'no', 0, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `products_legacy_20260811`
--

-- Clean-install omission: legacy/raw staging statement removed.


--
-- Dumping data for table `products_legacy_20260811`
--

-- Privacy sanitisation: data rows for `products_legacy_20260811` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `product_gallery_legacy_20260811`
--

-- Clean-install omission: legacy/raw staging statement removed.


-- --------------------------------------------------------

--
-- Table structure for table `product_import_jobs`
--

-- Clean-install omission: legacy/raw staging statement removed.


-- --------------------------------------------------------

--
-- Table structure for table `product_import_runs`
--

-- Clean-install omission: legacy/raw staging statement removed.


--
-- Dumping data for table `product_import_runs`
--

-- Privacy sanitisation: data rows for `product_import_runs` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `product_media`
--

CREATE TABLE `product_media` (
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `media_id` bigint(20) UNSIGNED NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_media`
--

INSERT INTO `product_media` (`product_id`, `media_id`, `sort_order`, `is_primary`) VALUES
(1, 3, 0, 0),
(2, 5, 0, 0),
(2, 7, 0, 0),
(75, 9, 1, 0),
(75, 10, 2, 0),
(75, 11, 3, 0),
(75, 12, 4, 0),
(75, 13, 5, 0),
(75, 14, 6, 0),
(75, 15, 7, 0),
(75, 16, 8, 0),
(76, 17, 1, 0),
(93, 15, 1, 0),
(93, 16, 2, 0),
(93, 35, 3, 0),
(93, 36, 4, 0),
(93, 37, 5, 0),
(93, 38, 6, 0),
(94, 15, 3, 0),
(94, 16, 2, 0),
(94, 40, 1, 0),
(94, 41, 4, 0),
(95, 15, 1, 0),
(95, 16, 2, 0),
(95, 43, 3, 0),
(95, 44, 4, 0),
(96, 16, 2, 0),
(96, 46, 1, 0),
(96, 47, 3, 0),
(96, 48, 4, 0),
(96, 49, 5, 0),
(96, 50, 6, 0),
(97, 15, 2, 0),
(97, 16, 1, 0),
(106, 61, 0, 0),
(106, 63, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_source_rows`
--

-- Clean-install omission: legacy/raw staging statement removed.


--
-- Dumping data for table `product_source_rows`
--

-- Privacy sanitisation: data rows for `product_source_rows` intentionally excluded.

-- Privacy sanitisation: data rows for `product_source_rows` intentionally excluded.

-- Privacy sanitisation: data rows for `product_source_rows` intentionally excluded.

-- Privacy sanitisation: data rows for `product_source_rows` intentionally excluded.

-- Privacy sanitisation: data rows for `product_source_rows` intentionally excluded.

-- Privacy sanitisation: data rows for `product_source_rows` intentionally excluded.

-- Privacy sanitisation: data rows for `product_source_rows` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `product_variations`
--

CREATE TABLE `product_variations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `source_system` varchar(40) DEFAULT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `regular_price` decimal(12,2) DEFAULT NULL,
  `sale_price` decimal(12,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT NULL,
  `stock_status` varchar(30) NOT NULL DEFAULT 'in_stock',
  `backorders` varchar(20) NOT NULL DEFAULT 'no',
  `weight` decimal(10,3) DEFAULT NULL,
  `length_mm` decimal(10,2) DEFAULT NULL,
  `width_mm` decimal(10,2) DEFAULT NULL,
  `height_mm` decimal(10,2) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `attributes_json` longtext NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_variations`
--

INSERT INTO `product_variations` (`id`, `product_id`, `source_system`, `source_id`, `sku`, `regular_price`, `sale_price`, `stock_quantity`, `stock_status`, `backorders`, `weight`, `length_mm`, `width_mm`, `height_mm`, `position`, `attributes_json`, `enabled`, `created_at`, `updated_at`) VALUES
(1, 75, 'woocommerce', 1032, NULL, 13955.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 1, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"Yes\",\"Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(2, 75, 'woocommerce', 1058, NULL, 12255.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 2, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"Yes\",\"Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(3, 75, 'woocommerce', 1059, NULL, 12000.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 3, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"No\",\"Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(4, 75, 'woocommerce', 1060, NULL, 10300.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 4, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"No\",\"Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(5, 75, 'woocommerce', 1061, NULL, 15455.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 5, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"Yes\",\"Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(6, 75, 'woocommerce', 1062, NULL, 13755.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 6, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"Yes\",\"Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(7, 75, 'woocommerce', 1063, NULL, 13500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 7, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"No\",\"Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(8, 75, 'woocommerce', 1064, NULL, 11800.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 8, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"No\",\"Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(9, 75, 'woocommerce', 1065, NULL, 17255.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 9, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"Yes\",\"Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(10, 75, 'woocommerce', 1066, NULL, 15555.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 10, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"Yes\",\"Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(11, 75, 'woocommerce', 1067, NULL, 15300.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 11, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"No\",\"Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(12, 75, 'woocommerce', 1068, NULL, 13600.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 12, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"No\",\"Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(13, 93, 'woocommerce', 1234, NULL, 37760.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 1, '{\"Size\":\"Piccolo\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(14, 93, 'woocommerce', 1235, NULL, 37760.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 2, '{\"Size\":\"Piccolo\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(15, 93, 'woocommerce', 1236, NULL, 37760.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 3, '{\"Size\":\"Piccolo\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(16, 93, 'woocommerce', 1237, NULL, 37760.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 4, '{\"Size\":\"Piccolo\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(17, 93, 'woocommerce', 1238, NULL, 54280.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 5, '{\"Size\":\"Classico\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(18, 93, 'woocommerce', 1239, NULL, 54280.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 6, '{\"Size\":\"Classico\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(19, 93, 'woocommerce', 1240, NULL, 54280.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 7, '{\"Size\":\"Classico\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(20, 93, 'woocommerce', 1241, NULL, 54280.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 8, '{\"Size\":\"Classico\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(21, 93, 'woocommerce', 1242, NULL, 71980.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 9, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(22, 93, 'woocommerce', 1243, NULL, 71980.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 10, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(23, 93, 'woocommerce', 1244, NULL, 71980.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 11, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(24, 93, 'woocommerce', 1245, NULL, 71980.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 12, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(25, 93, 'woocommerce', 1246, NULL, 88500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 13, '{\"Size\":\"Meastro\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(26, 93, 'woocommerce', 1247, NULL, 88500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 14, '{\"Size\":\"Meastro\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(27, 93, 'woocommerce', 1248, NULL, 88500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 15, '{\"Size\":\"Meastro\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(28, 93, 'woocommerce', 1249, NULL, 88500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 16, '{\"Size\":\"Meastro\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(29, 94, 'woocommerce', 1251, NULL, 35655.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 1, '{\"Size\":\"Standard\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(30, 94, 'woocommerce', 1252, NULL, 33955.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 2, '{\"Size\":\"Standard\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(31, 94, 'woocommerce', 1253, NULL, 33700.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 3, '{\"Size\":\"Standard\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(32, 94, 'woocommerce', 1254, NULL, 32000.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 4, '{\"Size\":\"Standard\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(33, 94, 'woocommerce', 1255, NULL, 42655.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 5, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(34, 94, 'woocommerce', 1256, NULL, 40955.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 6, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(35, 94, 'woocommerce', 1257, NULL, 40700.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 7, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(36, 94, 'woocommerce', 1258, NULL, 39000.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 8, '{\"Size\":\"Grande\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(37, 94, 'woocommerce', 1259, NULL, 58655.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 9, '{\"Size\":\"Superior\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(38, 94, 'woocommerce', 1260, NULL, 56955.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 10, '{\"Size\":\"Superior\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(39, 94, 'woocommerce', 1261, NULL, 56700.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 11, '{\"Size\":\"Superior\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(40, 94, 'woocommerce', 1262, NULL, 55000.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 12, '{\"Size\":\"Superior\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(41, 94, 'woocommerce', 1263, NULL, 69655.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 13, '{\"Size\":\"Ultra\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(42, 94, 'woocommerce', 1264, NULL, 67955.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 14, '{\"Size\":\"Ultra\",\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(43, 94, 'woocommerce', 1265, NULL, 67700.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 15, '{\"Size\":\"Ultra\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(44, 94, 'woocommerce', 1266, NULL, 66000.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 16, '{\"Size\":\"Ultra\",\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(45, 95, 'woocommerce', 1268, NULL, 18500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 2, '{\"Size\":\"Small\",\"Trolley With Side Table\":\"No\",\"Trolley Without Side Table\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(46, 95, 'woocommerce', 1269, NULL, 16800.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 1, '{\"Size\":\"Small\",\"Trolley With Side Table\":\"No\",\"Trolley Without Side Table\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(47, 95, 'woocommerce', 1270, NULL, 20455.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 4, '{\"Size\":\"Small\",\"Trolley With Side Table\":\"Yes\",\"Trolley Without Side Table\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(48, 95, 'woocommerce', 1271, NULL, 18755.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 3, '{\"Size\":\"Small\",\"Trolley With Side Table\":\"Yes\",\"Trolley Without Side Table\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(49, 95, 'woocommerce', 1272, NULL, 25300.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 6, '{\"Size\":\"Medium\",\"Trolley With Side Table\":\"No\",\"Trolley Without Side Table\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(50, 95, 'woocommerce', 1273, NULL, 23600.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 5, '{\"Size\":\"Medium\",\"Trolley With Side Table\":\"No\",\"Trolley Without Side Table\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(51, 95, 'woocommerce', 1274, NULL, 27255.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 8, '{\"Size\":\"Medium\",\"Trolley With Side Table\":\"Yes\",\"Trolley Without Side Table\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(52, 95, 'woocommerce', 1275, NULL, 25555.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 7, '{\"Size\":\"Medium\",\"Trolley With Side Table\":\"Yes\",\"Trolley Without Side Table\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(53, 95, 'woocommerce', 1276, NULL, 28900.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 10, '{\"Size\":\"Large\",\"Trolley With Side Table\":\"No\",\"Trolley Without Side Table\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(54, 95, 'woocommerce', 1277, NULL, 27200.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 9, '{\"Size\":\"Large\",\"Trolley With Side Table\":\"No\",\"Trolley Without Side Table\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(55, 95, 'woocommerce', 1278, NULL, 30855.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 12, '{\"Size\":\"Large\",\"Trolley With Side Table\":\"Yes\",\"Trolley Without Side Table\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(56, 95, 'woocommerce', 1279, NULL, 29155.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 11, '{\"Size\":\"Large\",\"Trolley With Side Table\":\"Yes\",\"Trolley Without Side Table\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(57, 96, 'woocommerce', 1281, NULL, 13800.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 1, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"No\",\"Built In Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(58, 96, 'woocommerce', 1282, NULL, 15500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 2, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"No\",\"Built In Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(59, 96, 'woocommerce', 1283, NULL, 15755.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 3, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"Yes\",\"Built In Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(60, 96, 'woocommerce', 1284, NULL, 17455.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 4, '{\"Size\":\"Small\",\"Coastal Upgrade\":\"Yes\",\"Built In Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(61, 96, 'woocommerce', 1285, NULL, 26000.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 5, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"No\",\"Built In Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(62, 96, 'woocommerce', 1286, NULL, 27700.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 6, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"No\",\"Built In Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(63, 96, 'woocommerce', 1287, NULL, 27955.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 7, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"Yes\",\"Built In Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(64, 96, 'woocommerce', 1288, NULL, 29655.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 8, '{\"Size\":\"Medium\",\"Coastal Upgrade\":\"Yes\",\"Built In Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(65, 96, 'woocommerce', 1289, NULL, 39500.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 9, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"No\",\"Built In Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(66, 96, 'woocommerce', 1290, NULL, 41200.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 10, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"No\",\"Built In Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(67, 96, 'woocommerce', 1291, NULL, 41455.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 11, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"Yes\",\"Built In Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(68, 96, 'woocommerce', 1292, NULL, 43155.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 12, '{\"Size\":\"Large\",\"Coastal Upgrade\":\"Yes\",\"Built In Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(69, 97, 'woocommerce', 1447, NULL, 13555.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 1, '{\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(70, 97, 'woocommerce', 1448, NULL, 15255.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 2, '{\"Coastal Upgrade\":\"Yes\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(71, 97, 'woocommerce', 1449, NULL, 11600.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 3, '{\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"No\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12'),
(72, 97, 'woocommerce', 1450, NULL, 13300.00, NULL, NULL, 'in_stock', 'no', NULL, NULL, NULL, NULL, 4, '{\"Coastal Upgrade\":\"No\",\"Built in Thermometer\":\"Yes\"}', 1, '2026-08-11 11:57:12', '2026-08-11 11:57:12');

-- --------------------------------------------------------

--
-- Table structure for table `quote_email_log`
--

CREATE TABLE `quote_email_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quote_id` bigint(20) UNSIGNED NOT NULL,
  `email_type` varchar(50) NOT NULL,
  `recipient` varchar(190) NOT NULL,
  `status` varchar(30) NOT NULL,
  `error_message` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quote_email_log`
--

-- Privacy sanitisation: data rows for `quote_email_log` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `quote_history`
--

CREATE TABLE `quote_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quote_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(40) NOT NULL,
  `event_type` varchar(80) NOT NULL,
  `summary` varchar(500) DEFAULT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_hash` char(64) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quote_history`
--

-- Privacy sanitisation: data rows for `quote_history` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `quote_items`
--

CREATE TABLE `quote_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quote_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `variation_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_name` varchar(190) NOT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `image_media_id` bigint(20) UNSIGNED DEFAULT NULL,
  `variation_snapshot` longtext DEFAULT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `discount_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `line_total` decimal(12,2) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quote_items`
--

-- Privacy sanitisation: data rows for `quote_items` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `quote_requests`
--

CREATE TABLE `quote_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quote_number` varchar(40) DEFAULT NULL,
  `status` varchar(40) NOT NULL DEFAULT 'new_enquiry',
  `revision_number` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `full_name` varchar(190) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(60) NOT NULL,
  `company` varchar(190) DEFAULT NULL,
  `address_line` varchar(255) NOT NULL,
  `suburb` varchar(120) NOT NULL,
  `city` varchar(120) NOT NULL,
  `province` varchar(120) NOT NULL,
  `postal_code` varchar(30) NOT NULL,
  `country` varchar(120) NOT NULL,
  `customer_notes` text DEFAULT NULL,
  `delivery_charge` decimal(12,2) NOT NULL DEFAULT 0.00,
  `installation_charge` decimal(12,2) NOT NULL DEFAULT 0.00,
  `additional_charges` decimal(12,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `vat_rate` decimal(6,3) NOT NULL DEFAULT 0.000,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `preparation_time` varchar(190) DEFAULT NULL,
  `dispatch_time` varchar(190) DEFAULT NULL,
  `transit_time` varchar(190) DEFAULT NULL,
  `lead_time` varchar(190) DEFAULT NULL,
  `valid_days` int(10) UNSIGNED NOT NULL DEFAULT 14,
  `expires_at` date DEFAULT NULL,
  `customer_notes_admin` text DEFAULT NULL,
  `internal_notes` text DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `public_token_hash` char(64) DEFAULT NULL,
  `submitted_ip_hash` char(64) DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `prepared_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `accepted_at` datetime DEFAULT NULL,
  `declined_at` datetime DEFAULT NULL,
  `decline_reason` varchar(1000) DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quote_requests`
--

-- Privacy sanitisation: data rows for `quote_requests` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `quote_revisions`
--

CREATE TABLE `quote_revisions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quote_id` bigint(20) UNSIGNED NOT NULL,
  `revision_number` int(10) UNSIGNED NOT NULL,
  `display_number` varchar(50) NOT NULL,
  `snapshot_json` longtext NOT NULL,
  `pdf_path` varchar(255) DEFAULT NULL,
  `issued_at` datetime NOT NULL DEFAULT current_timestamp(),
  `issued_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quote_sequences`
--

CREATE TABLE `quote_sequences` (
  `quote_year` smallint(5) UNSIGNED NOT NULL,
  `last_number` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quote_sequences`
--

-- Privacy sanitisation: data rows for `quote_sequences` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `recovery_email_tokens`
--

CREATE TABLE `recovery_email_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `secure_settings`
--

CREATE TABLE `secure_settings` (
  `key` varchar(255) NOT NULL,
  `encrypted_value` longtext DEFAULT NULL,
  `public_value` longtext DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `security_events`
--

CREATE TABLE `security_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `actor_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `target_type` varchar(60) DEFAULT NULL,
  `target_id` varchar(100) DEFAULT NULL,
  `ip_hash` char(64) DEFAULT NULL,
  `user_agent_hash` char(64) DEFAULT NULL,
  `metadata_json` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `security_events`
--

-- Privacy sanitisation: data rows for `security_events` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `setting_key` varchar(100) NOT NULL,
  `setting_value` longtext DEFAULT NULL,
  `is_secret` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`setting_key`, `setting_value`, `is_secret`, `updated_at`) VALUES
('google_auto_sync', '0', 0, '2026-08-20 15:52:35'),
('maintenance_accent', '#d6a14a', 0, '2026-08-18 11:34:34'),
('maintenance_background', '#0b0c0c', 0, '2026-08-18 11:34:34'),
('maintenance_cta_text', 'Contact our team', 0, '2026-08-18 11:34:34'),
('maintenance_cta_url', 'mailto:Info@fireanddine.co.za', 0, '2026-08-18 11:34:34'),
('maintenance_enabled', '1', 0, '2026-08-18 11:34:41'),
('maintenance_eyebrow', 'A short pause to tend the fire', 0, '2026-08-18 11:34:34'),
('maintenance_heading', 'We\'re preparing something worth gathering around.', 0, '2026-08-18 11:40:21'),
('maintenance_message', 'Fire & Dine is temporarily offline while we make a few careful improvements. Our team is still available if you need product, installation or quote assistance.', 0, '2026-08-18 11:34:34'),
('maintenance_reopening', '2026-08-19T13:34', 0, '2026-08-18 11:34:34'),
('maintenance_secondary_cta_text', 'WhatsApp us', 0, '2026-08-18 11:34:34'),
('maintenance_secondary_cta_url', 'https://wa.me/27834381485', 0, '2026-08-18 11:34:34'),
('maintenance_title', 'Well be back soon | Fire & Dine', 0, '2026-08-18 11:37:40'),
('payfast_enabled', '0', 0, '2026-08-20 15:52:35'),
('payfast_sandbox', '0', 0, '2026-08-20 15:52:35');

-- --------------------------------------------------------

--
-- Table structure for table `store_settings`
--

CREATE TABLE `store_settings` (
  `key` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `updated_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tracking_events`
--

CREATE TABLE `tracking_events` (
  `event_id` varchar(100) NOT NULL,
  `event_name` varchar(100) NOT NULL,
  `occurred_at` datetime NOT NULL DEFAULT current_timestamp(),
  `session_id` varchar(100) DEFAULT NULL,
  `visitor_id` varchar(100) DEFAULT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `lead_id` varchar(100) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `page_url` text DEFAULT NULL,
  `referrer` text DEFAULT NULL,
  `utm_source` varchar(255) DEFAULT NULL,
  `utm_medium` varchar(255) DEFAULT NULL,
  `utm_campaign` varchar(255) DEFAULT NULL,
  `utm_content` varchar(255) DEFAULT NULL,
  `utm_term` varchar(255) DEFAULT NULL,
  `click_ids_json` longtext DEFAULT NULL,
  `event_value` decimal(14,2) DEFAULT NULL,
  `currency` varchar(8) DEFAULT NULL,
  `consent_state` longtext DEFAULT NULL,
  `payload_json` longtext DEFAULT NULL,
  `browser_event_status` varchar(50) NOT NULL DEFAULT 'pending',
  `server_event_status` varchar(50) NOT NULL DEFAULT 'pending',
  `source` varchar(50) NOT NULL DEFAULT 'browser'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tracking_event_deliveries`
--

CREATE TABLE `tracking_event_deliveries` (
  `id` varchar(100) NOT NULL,
  `event_id` varchar(100) NOT NULL,
  `platform` varchar(50) NOT NULL,
  `attempt_number` int(11) NOT NULL DEFAULT 1,
  `http_response_code` int(11) DEFAULT NULL,
  `platform_response` longtext DEFAULT NULL,
  `delivery_status` varchar(50) NOT NULL DEFAULT 'pending',
  `last_attempt_at` datetime DEFAULT NULL,
  `retry_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tracking_event_mappings`
--

CREATE TABLE `tracking_event_mappings` (
  `id` varchar(255) NOT NULL,
  `internal_event` varchar(100) NOT NULL,
  `platform` varchar(50) NOT NULL,
  `platform_event` varchar(100) NOT NULL,
  `conversion_id` varchar(255) DEFAULT NULL,
  `conversion_label` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tracking_settings`
--

CREATE TABLE `tracking_settings` (
  `id` varchar(255) NOT NULL,
  `platform` varchar(50) NOT NULL,
  `setting_name` varchar(100) NOT NULL,
  `public_value` longtext DEFAULT NULL,
  `encrypted_value` longtext DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(190) NOT NULL,
  `recovery_email` varchar(190) DEFAULT NULL,
  `recovery_email_verified_at` datetime DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `role` varchar(40) NOT NULL DEFAULT 'viewer',
  `status` varchar(30) NOT NULL DEFAULT 'invited',
  `must_change_password` tinyint(1) NOT NULL DEFAULT 0,
  `session_version` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip_hash` char(64) DEFAULT NULL,
  `failed_login_attempts` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

-- Privacy sanitisation: data rows for `users` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `user_invitations`
--

CREATE TABLE `user_invitations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE `user_sessions` (
  `id` char(64) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `session_version` int(10) UNSIGNED NOT NULL,
  `ip_hash` char(64) DEFAULT NULL,
  `user_agent_hash` char(64) DEFAULT NULL,
  `last_seen_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_sessions`
--

-- Privacy sanitisation: data rows for `user_sessions` intentionally excluded.


-- --------------------------------------------------------

--
-- Table structure for table `visitor_attribution`
--

CREATE TABLE `visitor_attribution` (
  `visitor_id` varchar(100) NOT NULL,
  `first_landing_page` text DEFAULT NULL,
  `first_referrer` text DEFAULT NULL,
  `first_touch_json` longtext DEFAULT NULL,
  `latest_touch_json` longtext DEFAULT NULL,
  `click_ids_json` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `last_visit_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admins_email_unique` (`email`);

--
-- Indexes for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- Indexes for table `admin_sessions`
--
ALTER TABLE `admin_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `admin_sessions_admin_idx` (`admin_id`),
  ADD KEY `admin_sessions_expiry_idx` (`expires_at`);

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_users_email_unique` (`email`);

--
-- Indexes for table `analytics_audit_log`
--
ALTER TABLE `analytics_audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_audit_time_idx` (`occurred_at`);

--
-- Indexes for table `analytics_blocked_events`
--
ALTER TABLE `analytics_blocked_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_blocked_time_idx` (`occurred_at`);

--
-- Indexes for table `analytics_consents`
--
ALTER TABLE `analytics_consents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_consents_time_idx` (`occurred_at`);

--
-- Indexes for table `analytics_conversions`
--
ALTER TABLE `analytics_conversions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_conversions_time_idx` (`occurred_at`);

--
-- Indexes for table `analytics_daily_summaries`
--
ALTER TABLE `analytics_daily_summaries`
  ADD PRIMARY KEY (`summary_date`,`metric_key`,`dimension_key`);

--
-- Indexes for table `analytics_errors`
--
ALTER TABLE `analytics_errors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_errors_time_idx` (`occurred_at`);

--
-- Indexes for table `analytics_events`
--
ALTER TABLE `analytics_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_events_type_time_idx` (`event_type`,`occurred_at`),
  ADD KEY `analytics_events_session_idx` (`session_id`);

--
-- Indexes for table `analytics_form_events`
--
ALTER TABLE `analytics_form_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_form_events_time_idx` (`occurred_at`);

--
-- Indexes for table `analytics_pageviews`
--
ALTER TABLE `analytics_pageviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_pageviews_session_idx` (`session_id`),
  ADD KEY `analytics_pageviews_time_idx` (`occurred_at`);

--
-- Indexes for table `analytics_sessions`
--
ALTER TABLE `analytics_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `analytics_sessions_started_idx` (`started_at`),
  ADD KEY `analytics_sessions_visitor_idx` (`visitor_id`);

--
-- Indexes for table `analytics_settings`
--
ALTER TABLE `analytics_settings`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `app_meta`
--
ALTER TABLE `app_meta`
  ADD PRIMARY KEY (`meta_key`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_created_idx` (`created_at`);

--
-- Indexes for table `auth_attempts`
--
ALTER TABLE `auth_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `auth_attempts_identity_time_idx` (`identity_hash`,`attempted_at`);

--
-- Indexes for table `auth_rate_limits`
--
ALTER TABLE `auth_rate_limits`
  ADD PRIMARY KEY (`rate_key`);

--
-- Indexes for table `brochures`
--
ALTER TABLE `brochures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brochure_active_idx` (`enabled`,`updated_at`);

--
-- Indexes for table `brochure_downloads`
--
ALTER TABLE `brochure_downloads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brochure_download_recent_idx` (`brochure_id`,`downloaded_at`);

--
-- Indexes for table `catalogs`
--
ALTER TABLE `catalogs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `catalogs_active_sort_idx` (`is_active`,`sort_order`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `categories_catalog_idx` (`catalog_id`),
  ADD KEY `categories_parent_idx` (`parent_id`);

--
-- Indexes for table `categories_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `coupon_redemptions`
--
ALTER TABLE `coupon_redemptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `coupon_redemption_order_unique` (`coupon_id`,`order_id`),
  ADD KEY `coupon_redemptions_customer_idx` (`coupon_id`,`customer_email`),
  ADD KEY `fk_coupon_redemption_order` (`order_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `enquiries`
--
ALTER TABLE `enquiries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `enquiries_status_created` (`status`,`created_at`);

--
-- Indexes for table `gallery_media`
--
ALTER TABLE `gallery_media`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `gallery_legacy_unique` (`legacy_key`),
  ADD KEY `gallery_public_idx` (`media_type`,`enabled`,`display_order`);

--
-- Indexes for table `google_reviews`
--
ALTER TABLE `google_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `google_review_id` (`google_review_id`);

--
-- Indexes for table `maintenance_settings`
--
ALTER TABLE `maintenance_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `media_assets`
--
ALTER TABLE `media_assets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `storage_key` (`storage_key`),
  ADD UNIQUE KEY `media_assets_sha256_unique` (`sha256`);

--
-- Indexes for table `media_assets_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD UNIQUE KEY `orders_purchase_event_unique` (`purchase_event_id`),
  ADD KEY `orders_created_idx` (`created_at`),
  ADD KEY `orders_status_idx` (`status`,`payment_status`),
  ADD KEY `orders_email_idx` (`customer_email`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_idx` (`order_id`);

--
-- Indexes for table `order_items_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `password_reset_user_idx` (`user_id`,`expires_at`);

--
-- Indexes for table `payment_transactions`
--
ALTER TABLE `payment_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `notification_hash` (`notification_hash`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `products_source_unique` (`source_system`,`source_id`),
  ADD KEY `products_category_fk` (`category_id`),
  ADD KEY `products_media_fk` (`thumbnail_media_id`),
  ADD KEY `products_catalog_idx` (`catalog_id`);

--
-- Indexes for table `products_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `product_gallery_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `product_import_jobs`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `product_import_runs`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `product_media`
--
ALTER TABLE `product_media`
  ADD PRIMARY KEY (`product_id`,`media_id`),
  ADD KEY `product_media_order_idx` (`product_id`,`sort_order`);

--
-- Indexes for table `product_source_rows`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Indexes for table `product_variations`
--
ALTER TABLE `product_variations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_variations_source_unique` (`source_system`,`source_id`),
  ADD UNIQUE KEY `product_variations_sku_unique` (`sku`),
  ADD KEY `product_variations_parent_idx` (`product_id`,`enabled`,`position`);

--
-- Indexes for table `quote_email_log`
--
ALTER TABLE `quote_email_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quote_email_idx` (`quote_id`,`created_at`);

--
-- Indexes for table `quote_history`
--
ALTER TABLE `quote_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quote_history_idx` (`quote_id`,`created_at`);

--
-- Indexes for table `quote_items`
--
ALTER TABLE `quote_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quote_items_quote_idx` (`quote_id`,`sort_order`),
  ADD KEY `quote_items_product_idx` (`product_id`),
  ADD KEY `quote_items_variation_idx` (`variation_id`);

--
-- Indexes for table `quote_requests`
--
ALTER TABLE `quote_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quote_number` (`quote_number`),
  ADD UNIQUE KEY `public_token_hash` (`public_token_hash`),
  ADD KEY `quote_search_idx` (`status`,`submitted_at`),
  ADD KEY `quote_customer_idx` (`email`,`phone`),
  ADD KEY `quote_location_idx` (`province`,`city`);

--
-- Indexes for table `quote_revisions`
--
ALTER TABLE `quote_revisions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quote_revision_unique` (`quote_id`,`revision_number`);

--
-- Indexes for table `quote_sequences`
--
ALTER TABLE `quote_sequences`
  ADD PRIMARY KEY (`quote_year`);

--
-- Indexes for table `recovery_email_tokens`
--
ALTER TABLE `recovery_email_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `recovery_email_user_idx` (`user_id`,`expires_at`);

--
-- Indexes for table `secure_settings`
--
ALTER TABLE `secure_settings`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `security_events`
--
ALTER TABLE `security_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `security_events_created_idx` (`created_at`),
  ADD KEY `security_events_user_idx` (`user_id`,`created_at`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_key`);

--
-- Indexes for table `store_settings`
--
ALTER TABLE `store_settings`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `tracking_events`
--
ALTER TABLE `tracking_events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `tracking_events_time_idx` (`occurred_at`),
  ADD KEY `tracking_events_name_idx` (`event_name`,`occurred_at`);

--
-- Indexes for table `tracking_event_deliveries`
--
ALTER TABLE `tracking_event_deliveries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tracking_delivery_attempt_unique` (`event_id`,`platform`,`attempt_number`),
  ADD KEY `tracking_deliveries_retry_idx` (`delivery_status`,`retry_at`);

--
-- Indexes for table `tracking_event_mappings`
--
ALTER TABLE `tracking_event_mappings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tracking_mapping_event_platform_unique` (`internal_event`,`platform`);

--
-- Indexes for table `tracking_settings`
--
ALTER TABLE `tracking_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tracking_settings_platform_name_unique` (`platform`,`setting_name`),
  ADD KEY `tracking_settings_platform_idx` (`platform`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_recovery_email_unique` (`recovery_email`),
  ADD KEY `users_role_status_idx` (`role`,`status`);

--
-- Indexes for table `user_invitations`
--
ALTER TABLE `user_invitations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `invitation_user_idx` (`user_id`,`expires_at`);

--
-- Indexes for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_sessions_user_idx` (`user_id`,`expires_at`);

--
-- Indexes for table `visitor_attribution`
--
ALTER TABLE `visitor_attribution`
  ADD PRIMARY KEY (`visitor_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_attempts`
--
ALTER TABLE `auth_attempts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `brochures`
--
ALTER TABLE `brochures`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `brochure_downloads`
--
ALTER TABLE `brochure_downloads`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `catalogs`
--
ALTER TABLE `catalogs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `enquiries`
--
ALTER TABLE `enquiries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gallery_media`
--
ALTER TABLE `gallery_media`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=220;

--
-- AUTO_INCREMENT for table `media_assets`
--
ALTER TABLE `media_assets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `product_import_runs`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- AUTO_INCREMENT for table `product_source_rows`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- AUTO_INCREMENT for table `product_variations`
--
ALTER TABLE `product_variations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `quote_email_log`
--
ALTER TABLE `quote_email_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `quote_history`
--
ALTER TABLE `quote_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `quote_items`
--
ALTER TABLE `quote_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `quote_requests`
--
ALTER TABLE `quote_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `quote_revisions`
--
ALTER TABLE `quote_revisions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recovery_email_tokens`
--
ALTER TABLE `recovery_email_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `security_events`
--
ALTER TABLE `security_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user_invitations`
--
ALTER TABLE `user_invitations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `coupon_redemptions`
--
ALTER TABLE `coupon_redemptions`
  ADD CONSTRAINT `fk_coupon_redemption_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`),
  ADD CONSTRAINT `fk_coupon_redemption_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_media_fk` FOREIGN KEY (`thumbnail_media_id`) REFERENCES `media_assets` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `products_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Constraints for table `product_gallery_legacy_20260811`
--
-- Clean-install omission: legacy/raw staging statement removed.


--
-- Constraints for table `product_variations`
--
ALTER TABLE `product_variations`
  ADD CONSTRAINT `product_variations_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tracking_event_deliveries`
--
ALTER TABLE `tracking_event_deliveries`
  ADD CONSTRAINT `fk_tracking_delivery_event` FOREIGN KEY (`event_id`) REFERENCES `tracking_events` (`event_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
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


-- ============================================================
-- PHASES 5, 6 AND 7 MIGRATION
-- ============================================================

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


-- ============================================================
-- PHASES 8, 9 AND 10 MIGRATION
-- ============================================================

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


-- ============================================================
-- RELEASE CORRECTION MIGRATION
-- ============================================================

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


-- Fire & Dine final release-gate corrections
-- Mirrors database/migrations/20260823_fire_dine_release_gate_fixes.sql.
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
UPDATE `quote_requests` SET `has_confirmed_amount`=IF(`subtotal`>0 OR `vat_amount`>0 OR `total`>0,1,0),`tax_enabled`=IF(`vat_amount`>0 AND `vat_rate`>0,1,0);
UPDATE `quote_items` SET `confirmed_line_total`=ROUND(`final_confirmed_price`*`quantity`,2) WHERE `final_confirmed_price` IS NOT NULL;

INSERT INTO `settings` (`setting_key`,`setting_value`,`is_secret`,`updated_at`) VALUES
 ('quote_tax_enabled','0',0,NOW()),('quote_tax_rate','0',0,NOW())
ON DUPLICATE KEY UPDATE `setting_value`=VALUES(`setting_value`),`is_secret`=0,`updated_at`=VALUES(`updated_at`);

CREATE TABLE IF NOT EXISTS `enquiry_status_history` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enquiry_id` bigint(20) UNSIGNED NOT NULL,
  `old_status` varchar(40) DEFAULT NULL,
  `new_status` varchar(40) NOT NULL,
  `summary` varchar(500) NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),KEY `enquiry_status_history_enquiry_idx` (`enquiry_id`,`created_at`),
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
  PRIMARY KEY (`id`),KEY `enquiry_email_log_enquiry_idx` (`enquiry_id`,`created_at`),
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
INSERT INTO `product_related_products` (`product_id`,`related_product_id`,`context_label`,`display_order`,`is_active`) VALUES (98,80,'Optional Rib Rack',30,1)
ON DUPLICATE KEY UPDATE `context_label`=VALUES(`context_label`),`display_order`=VALUES(`display_order`),`is_active`=1;
UPDATE `gallery_media` SET `enabled`=0 WHERE `title`='Luxurious Sunset Fireplace Retreat';
UPDATE `gallery_media` SET `enabled`=0 WHERE `id` IN (65,75) OR `title` IN ('Flint 1','Flint 1 Pizza oven');

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


-- Clean-install production reset. No users, sessions, test quotes, enquiries,
-- tokens, logs or raw legacy/import staging data are distributed.
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE `product_confirmation_history`;
DROP TABLE IF EXISTS `categories_legacy_20260811`;
DROP TABLE IF EXISTS `media_assets_legacy_20260811`;
DROP TABLE IF EXISTS `products_legacy_20260811`;
DROP TABLE IF EXISTS `product_gallery_legacy_20260811`;
DROP TABLE IF EXISTS `order_items_legacy_20260811`;
DROP TABLE IF EXISTS `product_source_rows`;
DROP TABLE IF EXISTS `product_import_runs`;
DROP TABLE IF EXISTS `product_import_jobs`;
SET FOREIGN_KEY_CHECKS=1;
DELETE FROM `app_meta` WHERE `meta_key` LIKE '%test%';
UPDATE `settings` SET `setting_value`='0' WHERE `setting_key`='maintenance_enabled';


CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `migration` varchar(255) NOT NULL,
  `checksum` char(64) NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`migration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `schema_migrations` (`migration`,`checksum`,`applied_at`) VALUES
('20260823_fire_dine_phases_2_3_4.sql','3b99d6df4c8974343fbc9871f39b13f00d9fbccfeda63be3c4a62e4a411e9cbf',NOW()),
('20260823_fire_dine_phases_5_6_7.sql','2cb66ea5559990cccf25b09d04147208b0f62e9c7d01e45896fa38bb31b864ae',NOW()),
('20260823_fire_dine_phases_8_9_10.sql','d3b3e1f3690b3be585b3d79d318e05aa5112789246af7e91860c8d904633256e',NOW()),
('20260823_fire_dine_release_corrections.sql','cef4cbb7425cb1fd07a7559d212189e789a070005872d4bb30202fe41db27099',NOW()),
('20260823_fire_dine_release_gate_fixes.sql','ee82fde74200c2744a685dcbd87a0ba244c0baa028b1732b46a8f44152a63cdc',NOW())
ON DUPLICATE KEY UPDATE `checksum`=VALUES(`checksum`);

-- Deployment administrator. Password is stored only as a bcrypt hash.
INSERT INTO `users`
  (`first_name`,`last_name`,`email`,`password_hash`,`role`,`status`,`must_change_password`,`session_version`,`password_changed_at`)
VALUES
  ('Fire & Dine','Administrator','info@fireanddine.co.za','$2y$12$XI6zEi7itoMi24oLMmce0O3AsXrsDkYWYxskfRWEvyf3HXV04I/AK','super_admin','active',0,1,NOW())
ON DUPLICATE KEY UPDATE
  `first_name`=VALUES(`first_name`),`last_name`=VALUES(`last_name`),
  `password_hash`=VALUES(`password_hash`),`role`='super_admin',`status`='active',
  `must_change_password`=0,`failed_login_attempts`=0,`locked_until`=NULL,
  `password_changed_at`=NOW(),`session_version`=`session_version`+1;
