-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.3 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db_e_commerce
CREATE DATABASE IF NOT EXISTS `db_e_commerce` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_e_commerce`;

-- Dumping structure for table db_e_commerce.audit_logs
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `actor_id` bigint unsigned DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject_id` bigint unsigned DEFAULT NULL,
  `before_state` json DEFAULT NULL,
  `after_state` json DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_logs_subject` (`subject_type`,`subject_id`),
  KEY `fk_audit_logs_actor` (`actor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.audit_logs: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.banners
CREATE TABLE IF NOT EXISTS `banners` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `media` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `starts_at` timestamp NULL DEFAULT NULL,
  `ends_at` timestamp NULL DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.banners: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.brands
CREATE TABLE IF NOT EXISTS `brands` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `brands_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.brands: ~16 rows (approximately)
INSERT INTO `brands` (`id`, `name`, `slug`, `logo`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'HyperX', 'hyperx', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(2, 'Logitech G', 'logitech', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(3, 'Razer', 'razer', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(4, 'AULA', 'aula', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(5, 'Ajazz', 'ajazz', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(6, 'ASUS ROG', 'asus-rog', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(7, 'MSI', 'msi', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(8, 'Flydigi', 'flydigi', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(9, 'Fantech', 'fantech', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(10, 'ARTISAN', 'artisan', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(11, 'Secretlab', 'secretlab', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(12, 'UGREEN', 'ugreen', NULL, 'active', '2026-08-30 23:37:35', '2026-08-30 23:37:35'),
	(13, 'Vortix Audio', 'vortix-audio', NULL, 'active', '2026-08-31 19:36:26', '2026-08-31 19:36:26'),
	(14, 'Vortix', 'vortix', NULL, 'active', '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(15, 'Hyperion Gaming', 'hyperion', NULL, 'active', '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(16, 'CyberTech', 'cybertech', NULL, 'active', '2026-08-31 19:36:57', '2026-08-31 19:36:57');

-- Dumping structure for table db_e_commerce.cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.cache: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.cache_locks: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.carts
CREATE TABLE IF NOT EXISTS `carts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `session_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IDR',
  `status` enum('active','converted','abandoned') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `carts_user_id_foreign` (`user_id`),
  KEY `carts_session_id_index` (`session_id`),
  CONSTRAINT `carts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.carts: ~0 rows (approximately)
INSERT INTO `carts` (`id`, `user_id`, `session_id`, `currency`, `status`, `expires_at`, `created_at`, `updated_at`) VALUES
	(1, 1, NULL, 'IDR', 'active', NULL, '2026-08-30 23:52:59', '2026-08-30 23:52:59'),
	(2, 4, NULL, 'IDR', 'active', NULL, '2026-08-31 18:51:15', '2026-08-31 18:51:15');

-- Dumping structure for table db_e_commerce.cart_items
CREATE TABLE IF NOT EXISTS `cart_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cart_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `cart_items_cart_id_index` (`cart_id`),
  KEY `cart_items_variant_id_index` (`variant_id`),
  CONSTRAINT `cart_items_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_variant_id_foreign` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.cart_items: ~1 rows (approximately)
INSERT INTO `cart_items` (`id`, `cart_id`, `variant_id`, `quantity`) VALUES
	(1, 1, 5, 1);

-- Dumping structure for table db_e_commerce.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint unsigned DEFAULT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(170) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('draft','published','archived') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `sort_order` int NOT NULL DEFAULT '0',
  `meta_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `categories_slug_unique` (`slug`),
  KEY `categories_parent_id_index` (`parent_id`),
  CONSTRAINT `categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.categories: ~4 rows (approximately)
INSERT INTO `categories` (`id`, `parent_id`, `name`, `slug`, `status`, `sort_order`, `meta_title`, `meta_description`, `created_at`, `updated_at`) VALUES
	(1, NULL, 'Gaming Headsets', 'gaming-headsets', 'published', 1, NULL, NULL, '2026-08-31 19:36:24', '2026-08-31 19:36:24'),
	(2, NULL, 'Mechanical Keyboards', 'mechanical-keyboards', 'published', 2, NULL, NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(3, NULL, 'Gaming Mice', 'gaming-mice', 'published', 3, NULL, NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(4, NULL, 'Gaming Monitors', 'gaming-monitors', 'published', 4, NULL, NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57');

-- Dumping structure for table db_e_commerce.category_product
CREATE TABLE IF NOT EXISTS `category_product` (
  `category_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`category_id`,`product_id`),
  KEY `category_product_product_id_foreign` (`product_id`),
  CONSTRAINT `category_product_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `category_product_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.category_product: ~10 rows (approximately)
INSERT INTO `category_product` (`category_id`, `product_id`) VALUES
	(1, 1),
	(1, 2),
	(2, 3),
	(3, 4),
	(4, 5),
	(2, 6),
	(1, 7),
	(1, 8),
	(1, 9),
	(1, 10);

-- Dumping structure for table db_e_commerce.coupons
CREATE TABLE IF NOT EXISTS `coupons` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('percentage','fixed_amount','free_shipping') COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` bigint unsigned NOT NULL DEFAULT '0',
  `min_order` bigint unsigned DEFAULT NULL,
  `max_discount` bigint unsigned DEFAULT NULL,
  `usage_limit` int unsigned DEFAULT NULL,
  `usage_limit_per_user` int unsigned DEFAULT NULL,
  `starts_at` timestamp NULL DEFAULT NULL,
  `ends_at` timestamp NULL DEFAULT NULL,
  `status` enum('active','inactive','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `coupons_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.coupons: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.coupon_categories
CREATE TABLE IF NOT EXISTS `coupon_categories` (
  `coupon_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`coupon_id`,`category_id`),
  KEY `coupon_categories_category_id_foreign` (`category_id`),
  CONSTRAINT `coupon_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `coupon_categories_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.coupon_categories: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.coupon_products
CREATE TABLE IF NOT EXISTS `coupon_products` (
  `coupon_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`coupon_id`,`product_id`),
  KEY `coupon_products_product_id_foreign` (`product_id`),
  CONSTRAINT `coupon_products_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `coupon_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.coupon_products: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.coupon_usages
CREATE TABLE IF NOT EXISTS `coupon_usages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `order_id` bigint unsigned NOT NULL,
  `amount` bigint unsigned NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `coupon_usages_coupon_id_index` (`coupon_id`),
  KEY `coupon_usages_user_id_index` (`user_id`),
  KEY `coupon_usages_order_id_index` (`order_id`),
  CONSTRAINT `coupon_usages_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`),
  CONSTRAINT `coupon_usages_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `coupon_usages_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.coupon_usages: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.customer_addresses
CREATE TABLE IF NOT EXISTS `customer_addresses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `recipient` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `village` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `province` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postal_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Indonesia',
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_addresses_user_id_foreign` (`user_id`),
  CONSTRAINT `customer_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.customer_addresses: ~0 rows (approximately)
INSERT INTO `customer_addresses` (`id`, `user_id`, `recipient`, `phone`, `street`, `village`, `district`, `city`, `province`, `postal_code`, `country`, `latitude`, `longitude`, `is_default`, `created_at`, `updated_at`) VALUES
	(1, 1, 'Aris Maulana', '8579258407', 'Jalan Pulau Saelus II', 'Sesetan', 'kec kuta', 'Denpasar', 'Bali', '80114', 'Indonesia', -8.6855770, 115.2111725, 0, '2026-08-26 19:38:08', '2026-08-26 19:38:08'),
	(2, 2, 'Saipul ajah', '8579258999', 'Jalan Pulau Saelus II', 'Sesetan', NULL, 'Denpasar', 'Bali', '80114', 'Indonesia', -8.6855839, 115.2112729, 1, '2026-08-27 22:49:36', '2026-08-27 22:49:36'),
	(3, 1, 'Aris Maulana', '8579258407', 'Jl.Raya canggu no 37', 'br silayukti', 'kuta utara', 'Denpasar', 'bali', '80114', 'Indonesia', NULL, NULL, 0, '2026-09-01 23:50:35', '2026-09-01 23:50:35');

-- Dumping structure for table db_e_commerce.customer_notes
CREATE TABLE IF NOT EXISTS `customer_notes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_notes_user` (`user_id`),
  KEY `fk_customer_notes_creator` (`created_by`),
  CONSTRAINT `fk_customer_notes_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_customer_notes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.customer_notes: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.exports
CREATE TABLE IF NOT EXISTS `exports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filters` json DEFAULT NULL,
  `status` enum('queued','processing','completed','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requested_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_exports_user` (`requested_by`),
  CONSTRAINT `fk_exports_user` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.exports: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.failed_jobs: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.inventories
CREATE TABLE IF NOT EXISTS `inventories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `quantity_on_hand` int NOT NULL DEFAULT '0',
  `quantity_reserved` int NOT NULL DEFAULT '0',
  `reorder_level` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inventories_warehouse_variant` (`warehouse_id`,`variant_id`),
  KEY `fk_inventories_variant` (`variant_id`),
  CONSTRAINT `fk_inventories_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_inventories_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.inventories: ~4 rows (approximately)
INSERT INTO `inventories` (`id`, `warehouse_id`, `variant_id`, `quantity_on_hand`, `quantity_reserved`, `reorder_level`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, 42, 0, 5, '2026-09-02 20:00:31', '2026-09-02 20:19:11'),
	(2, 1, 5, 20, 0, 5, '2026-09-02 20:00:31', '2026-09-02 20:00:31'),
	(3, 1, 10, 77, 0, 5, '2026-09-02 20:00:31', '2026-09-02 20:00:31'),
	(4, 1, 11, 17, 0, 5, '2026-09-02 20:00:31', '2026-09-02 20:00:31');

-- Dumping structure for table db_e_commerce.inventory_movements
CREATE TABLE IF NOT EXISTS `inventory_movements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `type` enum('in','out','adjustment','reservation','release') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `quantity_before` int NOT NULL,
  `quantity_after` int NOT NULL,
  `reference_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_id` bigint unsigned DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_inv_movements_variant_created` (`variant_id`,`created_at`),
  KEY `fk_inv_movements_warehouse` (`warehouse_id`),
  KEY `inventory_movements_created_by_foreign` (`created_by`),
  CONSTRAINT `fk_inv_movements_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`),
  CONSTRAINT `fk_inv_movements_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`),
  CONSTRAINT `inventory_movements_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.inventory_movements: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.jobs: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.job_batches: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.migrations: ~29 rows (approximately)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '0001_01_01_000001_create_cache_table', 1),
	(3, '0001_01_01_000002_create_jobs_table', 1),
	(4, '2026_08_27_022956_create_customer_addresses_table', 2),
	(131, '2026_08_31_030715_add_foreign_keys_to_permission_role_table', 4),
	(132, '2026_08_31_030715_add_foreign_keys_to_role_user_table', 4),
	(133, '2026_08_31_000001_create_brands_table', 5),
	(134, '2026_08_31_000002_create_products_table', 5),
	(135, '2026_08_31_000003_create_product_options_table', 5),
	(136, '2026_08_31_000004_create_product_option_values_table', 5),
	(137, '2026_08_31_000005_create_product_variants_table', 5),
	(138, '2026_08_31_000006_create_product_images_table', 5),
	(139, '2026_08_31_000007_create_categories_table', 5),
	(140, '2026_08_31_000008_create_category_product_table', 5),
	(141, '2026_08_31_000009_create_product_variant_option_values_table', 5),
	(142, '2026_08_31_000010_create_carts_table', 5),
	(143, '2026_08_31_000011_create_cart_items_table', 5),
	(144, '2026_08_31_000012_create_orders_table', 5),
	(145, '2026_08_31_000013_create_order_items_table', 5),
	(146, '2026_08_31_000014_create_order_addresses_table', 5),
	(147, '2026_08_31_000015_create_order_status_histories_table', 5),
	(148, '2026_08_31_000016_create_payments_table', 5),
	(149, '2026_08_31_000017_create_coupons_table', 5),
	(150, '2026_08_31_000018_create_coupon_products_table', 5),
	(151, '2026_08_31_000019_create_coupon_categories_table', 5),
	(152, '2026_08_31_000020_create_coupon_usages_table', 5),
	(153, '2026_08_31_000021_create_shipping_methods_table', 5),
	(154, '2026_08_31_000022_create_product_reviews_table', 5),
	(157, '2026_09_01_080001_add_stock_to_product_variants_table', 6),
	(158, '2026_08_31_030712_create_warehouses_table', 7),
	(159, '2026_08_31_030712_create_promotions_table', 8),
	(160, '2026_08_31_030712_create_webhook_logs_table', 9),
	(161, '2026_08_31_030712_create_pages_table', 10),
	(162, '2026_08_31_030712_create_payment_transactions_table', 11),
	(163, '2026_08_31_030712_create_refunds_table', 12),
	(164, '2026_08_31_030712_create_returns_table', 13),
	(165, '2026_08_31_030712_create_wishlists_table', 14),
	(166, '2026_08_31_030712_create_exports_table', 15),
	(167, '2026_08_31_030712_create_settings_table', 16),
	(168, '2026_08_31_030712_create_customer_notes_table', 17),
	(169, '2026_08_31_030712_create_inventories_table', 18),
	(170, '2026_08_31_030712_create_inventory_movements_table', 19),
	(171, '2026_08_31_030712_create_stock_reservations_table', 20),
	(172, '2026_08_31_030712_create_shipments_table', 21),
	(173, '2026_08_31_030712_create_shipment_items_table', 22),
	(174, '2026_08_31_030712_create_refund_items_table', 23),
	(175, '2026_08_31_030712_create_return_items_table', 24),
	(176, '2026_08_31_030712_create_promotion_rules_table', 25),
	(177, '2026_08_31_030712_create_promotion_actions_table', 26),
	(178, '2026_08_31_030712_create_wishlist_items_table', 27),
	(179, '2026_08_31_030715_add_foreign_keys_to_payment_transactions_table', 28),
	(180, '2026_08_31_030715_add_foreign_keys_to_refunds_table', 29),
	(181, '2026_08_31_030715_add_foreign_keys_to_returns_table', 30),
	(182, '2026_08_31_030715_add_foreign_keys_to_wishlists_table', 31),
	(183, '2026_08_31_030715_add_foreign_keys_to_exports_table', 32),
	(184, '2026_08_31_030715_add_foreign_keys_to_customer_notes_table', 33),
	(185, '2026_08_31_030715_add_foreign_keys_to_inventories_table', 34),
	(186, '2026_08_31_030715_add_foreign_keys_to_inventory_movements_table', 35),
	(187, '2026_08_31_030715_add_foreign_keys_to_stock_reservations_table', 36),
	(188, '2026_08_31_030715_add_foreign_keys_to_shipments_table', 37),
	(189, '2026_08_31_030715_add_foreign_keys_to_shipment_items_table', 38),
	(190, '2026_08_31_030715_add_foreign_keys_to_refund_items_table', 39),
	(191, '2026_08_31_030715_add_foreign_keys_to_return_items_table', 40),
	(192, '2026_08_31_030715_add_foreign_keys_to_promotion_rules_table', 41),
	(193, '2026_08_31_030715_add_foreign_keys_to_promotion_actions_table', 42),
	(194, '2026_08_31_030715_add_foreign_keys_to_wishlist_items_table', 43),
	(195, '2026_09_03_040355_add_reason_and_created_by_to_inventory_movements_table', 44);

-- Dumping structure for table db_e_commerce.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `contact_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_phone` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IDR',
  `subtotal` bigint unsigned NOT NULL DEFAULT '0',
  `discount_total` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_total` bigint unsigned NOT NULL DEFAULT '0',
  `tax_total` bigint unsigned NOT NULL DEFAULT '0',
  `fee_total` bigint unsigned NOT NULL DEFAULT '0',
  `grand_total` bigint unsigned NOT NULL DEFAULT '0',
  `order_status` enum('pending_payment','confirmed','processing','packed','shipped','completed','cancelled','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending_payment',
  `payment_status` enum('unpaid','pending','paid','failed','expired','partially_refunded','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unpaid',
  `fulfillment_status` enum('unfulfilled','processing','partially_fulfilled','fulfilled','returned') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unfulfilled',
  `placed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `orders_order_number_unique` (`order_number`),
  KEY `orders_user_id_order_status_created_at_index` (`user_id`,`order_status`,`created_at`),
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.orders: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.order_addresses
CREATE TABLE IF NOT EXISTS `order_addresses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `type` enum('billing','shipping') COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `province` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postal_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Indonesia',
  PRIMARY KEY (`id`),
  KEY `order_addresses_order_id_index` (`order_id`),
  CONSTRAINT `order_addresses_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.order_addresses: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.order_items
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned DEFAULT NULL,
  `variant_id` bigint unsigned DEFAULT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variant_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `discount_amount` bigint unsigned NOT NULL DEFAULT '0',
  `tax_amount` bigint unsigned NOT NULL DEFAULT '0',
  `cost_price` bigint unsigned DEFAULT NULL,
  `total` bigint unsigned NOT NULL,
  `metadata` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_index` (`order_id`),
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.order_items: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.order_status_histories
CREATE TABLE IF NOT EXISTS `order_status_histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `from_status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `changed_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_status_histories_changed_by_foreign` (`changed_by`),
  KEY `order_status_histories_order_id_index` (`order_id`),
  CONSTRAINT `order_status_histories_changed_by_foreign` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_status_histories_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.order_status_histories: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.pages
CREATE TABLE IF NOT EXISTS `pages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(280) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `status` enum('draft','published') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `meta_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pages_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.pages: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.password_reset_tokens: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.payments
CREATE TABLE IF NOT EXISTS `payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider_reference` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` bigint unsigned NOT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IDR',
  `status` enum('pending','paid','failed','expired','partially_refunded','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payments_order_id_foreign` (`order_id`),
  KEY `payments_provider_reference_status_index` (`provider_reference`,`status`),
  CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.payments: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.payment_transactions
CREATE TABLE IF NOT EXISTS `payment_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` bigint unsigned NOT NULL,
  `type` enum('charge','capture','refund','void','notification') COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider_tx_id` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` bigint unsigned NOT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_payload` json DEFAULT NULL,
  `response_payload` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_payment_tx_payment` (`payment_id`),
  CONSTRAINT `fk_payment_tx_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.payment_transactions: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_permissions_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.permissions: ~7 rows (approximately)
INSERT INTO `permissions` (`id`, `name`, `slug`, `created_at`, `updated_at`) VALUES
	(1, 'Manage Products', 'manage_products', '2026-08-30 21:58:09', '2026-08-30 21:58:09'),
	(2, 'Manage Inventory', 'manage_inventory', '2026-08-30 21:58:09', '2026-08-30 21:58:09'),
	(3, 'Manage Orders', 'manage_orders', '2026-08-30 21:58:09', '2026-08-30 21:58:09'),
	(4, 'Manage Payments', 'manage_payments', '2026-08-30 21:58:09', '2026-08-30 21:58:09'),
	(5, 'Manage Customers', 'manage_customers', '2026-08-30 21:58:09', '2026-08-30 21:58:09'),
	(6, 'View Reports', 'view_reports', '2026-08-30 21:58:09', '2026-08-30 21:58:09'),
	(7, 'Manage Settings', 'manage_settings', '2026-08-30 21:58:09', '2026-08-30 21:58:09');

-- Dumping structure for table db_e_commerce.permission_role
CREATE TABLE IF NOT EXISTS `permission_role` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `fk_permission_role_role` (`role_id`),
  CONSTRAINT `fk_permission_role_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_permission_role_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.permission_role: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `brand_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(280) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('simple','variable','digital','service') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'simple',
  `status` enum('draft','published','archived') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `short_description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `meta_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_slug_unique` (`slug`),
  KEY `products_brand_id_foreign` (`brand_id`),
  KEY `products_status_published_at_index` (`status`,`published_at`),
  CONSTRAINT `products_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.products: ~10 rows (approximately)
INSERT INTO `products` (`id`, `brand_id`, `name`, `slug`, `type`, `status`, `short_description`, `description`, `meta_title`, `meta_description`, `published_at`, `deleted_at`, `created_at`, `updated_at`) VALUES
	(1, NULL, 'Vortix Apex Pro Wireless Headset (Updated V2)', 'vortix-apex-pro-wireless-headset-updated-v2', 'simple', 'published', 'Headset gaming nirkabel tingkat profesional dengan audio 7.1 surround.', 'Vortix Apex Pro menghadirkan suara berkualitas studio dengan latensi rendah 2.4GHz.', 'Vortix Apex Pro Wireless Headset - VGS', 'Beli Vortix Apex Pro Wireless Headset di Vortix Gaming Store.', '2026-08-31 19:36:27', NULL, '2026-08-31 19:36:27', '2026-08-31 19:36:27'),
	(2, 14, 'Vortix Wireless Pro RGB Headset', 'vortix-wireless-pro-rgb-headset', 'simple', 'published', 'Headset nirkabel 2.4GHz ultra-low latency dengan driver neodinium 50mm.', 'Vortix Wireless Pro RGB menghadirkan kenyamanan busa memori premium, suara surround 7.1 presisi tinggi, dan pencahayaan RGB yang dapat disesuaikan.', NULL, NULL, '2026-08-31 19:36:57', NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(3, 15, 'Hyperion Strike X Mechanical Keyboard', 'hyperion-strike-x-mechanical-keyboard', 'simple', 'published', 'Keyboard mekanik TKL dengan sakelar hotswap Red Linear dan piringan aluminium.', 'Performa respon secepat kilat dengan sakelar mekanikal yang siap untuk pertempuran eSports terberat.', NULL, NULL, '2026-08-31 19:36:57', NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(4, 16, 'CyberTech Viper Lightweight Mouse', 'cybertech-viper-lightweight-mouse', 'simple', 'published', 'Mouse gaming ultra-ringan 58 gram dengan sensor optik 26.000 DPI.', 'Didesain khusus untuk pemain FPS yang membutuhkan kecepatan gerakan tanpa hambatan dan akurasi pixel-perfect.', NULL, NULL, '2026-08-31 19:36:57', NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(5, 14, 'Vortix OLED Curved 240Hz Gaming Monitor', 'vortix-oled-curved-240hz-gaming-monitor', 'simple', 'published', 'Layar OLED 27 inci 1440p 240Hz 0.03ms respon time.', 'Pengalaman visual imersif tanpa tanding dengan rasio kontras tak terhingga dan warna hitam pekat sempurna.', NULL, NULL, '2026-08-31 19:36:57', NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(6, 6, 'Keyboard.test', 'keyboardtest', 'simple', 'published', NULL, 'blaaaa blaaa blaaa', NULL, NULL, '2026-09-01 19:59:06', '2026-09-01 20:16:44', '2026-09-01 19:59:06', '2026-09-01 20:16:44'),
	(7, NULL, 'Produk Uji Stock Test', 'produk-uji-stock', 'simple', 'draft', NULL, 'Produk uji untuk verifikasi fitur stock.', NULL, NULL, NULL, '2026-09-01 21:01:10', '2026-09-01 20:55:51', '2026-09-01 21:01:10'),
	(8, NULL, 'Tinker Stock Test', 'tinker-stock-test', 'simple', 'draft', NULL, NULL, NULL, NULL, NULL, '2026-09-01 21:01:10', '2026-09-01 20:57:26', '2026-09-01 21:01:10'),
	(9, NULL, 'Tinker Stock Test 2', 'tinker-stock-test-2', 'simple', 'draft', NULL, NULL, NULL, NULL, NULL, '2026-09-01 21:01:11', '2026-09-01 21:00:35', '2026-09-01 21:01:11'),
	(10, NULL, 'Produk Uji Stock Final', 'produk-uji-stock-final', 'simple', 'draft', NULL, 'Uji final.', NULL, NULL, NULL, '2026-09-01 21:04:28', '2026-09-01 21:02:01', '2026-09-01 21:04:28');

-- Dumping structure for table db_e_commerce.product_images
CREATE TABLE IF NOT EXISTS `product_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned DEFAULT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_images_variant_id_foreign` (`variant_id`),
  KEY `product_images_product_id_index` (`product_id`),
  CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_images_variant_id_foreign` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.product_images: ~13 rows (approximately)
INSERT INTO `product_images` (`id`, `product_id`, `variant_id`, `path`, `alt_text`, `sort_order`, `is_primary`, `created_at`) VALUES
	(1, 1, NULL, 'products/test_apex_pro_main.jpg', 'Vortix Apex Pro Wireless Headset', 0, 1, NULL),
	(2, 1, NULL, 'products/test_apex_pro_side.jpg', 'Vortix Apex Pro Wireless Headset', 1, 0, NULL),
	(3, 2, NULL, 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800&auto=format&fit=crop&q=80', 'Vortix Wireless Pro RGB Headset', 0, 1, NULL),
	(4, 2, NULL, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80', 'Vortix Wireless Pro RGB Headset', 1, 0, NULL),
	(5, 3, NULL, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800&auto=format&fit=crop&q=80', 'Hyperion Strike X Mechanical Keyboard', 0, 1, NULL),
	(6, 4, NULL, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=800&auto=format&fit=crop&q=80', 'CyberTech Viper Lightweight Mouse', 0, 1, NULL),
	(7, 5, NULL, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=800&auto=format&fit=crop&q=80', 'Vortix OLED Curved 240Hz Gaming Monitor', 0, 1, NULL),
	(8, 6, NULL, 'products/rslfXR5lUPEwWK3T8F2kS7aAzSHAGiNpjBwDQbD6.png', NULL, 0, 1, NULL),
	(9, 6, NULL, 'products/1tewjxbP8njHf0xuNVHs5AEtFHUwRF68qsJCpBz2.png', NULL, 1, 0, NULL),
	(10, 6, NULL, 'products/GvQM9lU7B9oPw1YND3rhCSQ77qm7Mlfn0XMC6msk.png', NULL, 2, 0, NULL),
	(11, 6, NULL, 'products/V3OqGIYUv8OUQxf67gNrQhipzheNSl0mWjlTXegl.png', NULL, 3, 0, NULL),
	(12, 7, NULL, 'products/MMScWLoFTQgNvs9GQXYl9oLs2BtGxNa6bOAtRgRp.png', NULL, 0, 1, NULL),
	(13, 10, NULL, 'products/2Vtmj0KYCaLg2zdGhlGs0pC0l15m0ynKhhENGaJO.png', NULL, 0, 1, NULL);

-- Dumping structure for table db_e_commerce.product_options
CREATE TABLE IF NOT EXISTS `product_options` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_options_product_id_index` (`product_id`),
  CONSTRAINT `product_options_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.product_options: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.product_option_values
CREATE TABLE IF NOT EXISTS `product_option_values` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `option_id` bigint unsigned NOT NULL,
  `value` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_option_values_option_id_index` (`option_id`),
  CONSTRAINT `product_option_values_option_id_foreign` FOREIGN KEY (`option_id`) REFERENCES `product_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.product_option_values: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.product_reviews
CREATE TABLE IF NOT EXISTS `product_reviews` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `order_item_id` bigint unsigned DEFAULT NULL,
  `rating` tinyint unsigned NOT NULL,
  `review` text COLLATE utf8mb4_unicode_ci,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_reviews_user_id_foreign` (`user_id`),
  KEY `product_reviews_order_item_id_foreign` (`order_item_id`),
  KEY `product_reviews_product_id_status_index` (`product_id`,`status`),
  CONSTRAINT `product_reviews_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.product_reviews: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.product_variants
CREATE TABLE IF NOT EXISTS `product_variants` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `barcode` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` bigint unsigned NOT NULL DEFAULT '0',
  `compare_at_price` bigint unsigned DEFAULT NULL,
  `cost_price` bigint unsigned DEFAULT NULL,
  `weight_grams` int unsigned DEFAULT NULL,
  `length_mm` int unsigned DEFAULT NULL,
  `width_mm` int unsigned DEFAULT NULL,
  `height_mm` int unsigned DEFAULT NULL,
  `stock` int unsigned NOT NULL DEFAULT '0',
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_variants_sku_unique` (`sku`),
  KEY `product_variants_product_id_index` (`product_id`),
  CONSTRAINT `product_variants_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.product_variants: ~11 rows (approximately)
INSERT INTO `product_variants` (`id`, `product_id`, `sku`, `barcode`, `price`, `compare_at_price`, `cost_price`, `weight_grams`, `length_mm`, `width_mm`, `height_mm`, `stock`, `status`, `deleted_at`, `created_at`, `updated_at`) VALUES
	(1, 1, 'VGS-APEX-BLK-V2', NULL, 1399000, 1799000, NULL, NULL, NULL, NULL, NULL, 42, 'active', NULL, '2026-08-31 19:36:27', '2026-09-01 20:54:25'),
	(2, 2, 'VGS-HEADSET-01', NULL, 1299000, 1599000, 850000, NULL, NULL, NULL, NULL, 0, 'active', NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(3, 3, 'VGS-KB-STRIKE-R', NULL, 899000, 1099000, 550000, NULL, NULL, NULL, NULL, 0, 'active', NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(4, 4, 'VGS-MOUSE-VIPER', NULL, 649000, 799000, 400000, NULL, NULL, NULL, NULL, 0, 'active', NULL, '2026-08-31 19:36:57', '2026-08-31 19:36:57'),
	(5, 5, 'VGS-MON-OLED27', NULL, 8499000, 9999000, NULL, NULL, NULL, NULL, NULL, 20, 'active', NULL, '2026-08-31 19:36:57', '2026-09-01 21:13:59'),
	(6, 6, 'warna abu', NULL, 200, 200, NULL, NULL, NULL, NULL, NULL, 0, 'active', NULL, '2026-09-01 19:59:06', '2026-09-01 19:59:06'),
	(7, 6, 'warna biru premium', NULL, 270, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'active', NULL, '2026-09-01 19:59:06', '2026-09-01 19:59:06'),
	(8, 7, 'UJI-STOCK-0001', NULL, 100000, 120000, NULL, NULL, NULL, NULL, NULL, 0, 'active', NULL, '2026-09-01 20:55:51', '2026-09-01 20:55:51'),
	(9, 8, 'TNK-STOCK-0001', NULL, 99999, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'active', NULL, '2026-09-01 20:57:26', '2026-09-01 20:57:26'),
	(10, 9, 'TNK-STOCK-0002', NULL, 99999, NULL, NULL, NULL, NULL, NULL, NULL, 77, 'active', NULL, '2026-09-01 21:00:35', '2026-09-01 21:00:35'),
	(11, 10, 'UJI-FINAL-0001', NULL, 100000, 120000, NULL, NULL, NULL, NULL, NULL, 17, 'active', NULL, '2026-09-01 21:02:01', '2026-09-01 21:02:01');

-- Dumping structure for table db_e_commerce.product_variant_option_values
CREATE TABLE IF NOT EXISTS `product_variant_option_values` (
  `variant_id` bigint unsigned NOT NULL,
  `option_value_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`variant_id`,`option_value_id`),
  KEY `product_variant_option_values_option_value_id_foreign` (`option_value_id`),
  CONSTRAINT `product_variant_option_values_option_value_id_foreign` FOREIGN KEY (`option_value_id`) REFERENCES `product_option_values` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_variant_option_values_variant_id_foreign` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.product_variant_option_values: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.promotions
CREATE TABLE IF NOT EXISTS `promotions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `starts_at` timestamp NULL DEFAULT NULL,
  `ends_at` timestamp NULL DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `priority` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.promotions: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.promotion_actions
CREATE TABLE IF NOT EXISTS `promotion_actions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` bigint unsigned NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `configuration` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_promotion_actions_promotion` (`promotion_id`),
  CONSTRAINT `fk_promotion_actions_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.promotion_actions: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.promotion_rules
CREATE TABLE IF NOT EXISTS `promotion_rules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` bigint unsigned NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `configuration` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_promotion_rules_promotion` (`promotion_id`),
  CONSTRAINT `fk_promotion_rules_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.promotion_rules: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.refunds
CREATE TABLE IF NOT EXISTS `refunds` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `payment_id` bigint unsigned NOT NULL,
  `amount` bigint unsigned NOT NULL,
  `status` enum('pending','processed','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_refunds_order` (`order_id`),
  KEY `fk_refunds_payment` (`payment_id`),
  CONSTRAINT `fk_refunds_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_refunds_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.refunds: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.refund_items
CREATE TABLE IF NOT EXISTS `refund_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `refund_id` bigint unsigned NOT NULL,
  `order_item_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `restock` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_refund_items_refund` (`refund_id`),
  KEY `fk_refund_items_order_item` (`order_item_id`),
  CONSTRAINT `fk_refund_items_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`),
  CONSTRAINT `fk_refund_items_refund` FOREIGN KEY (`refund_id`) REFERENCES `refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.refund_items: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.returns
CREATE TABLE IF NOT EXISTS `returns` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('requested','approved','rejected','received','resolved') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'requested',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_returns_order` (`order_id`),
  CONSTRAINT `fk_returns_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.returns: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.return_items
CREATE TABLE IF NOT EXISTS `return_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `return_id` bigint unsigned NOT NULL,
  `order_item_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `condition_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resolution` enum('refund','replacement','store_credit','rejected') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_return_items_return` (`return_id`),
  KEY `fk_return_items_order_item` (`order_item_id`),
  CONSTRAINT `fk_return_items_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`),
  CONSTRAINT `fk_return_items_return` FOREIGN KEY (`return_id`) REFERENCES `returns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.return_items: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_roles_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.roles: ~8 rows (approximately)
INSERT INTO `roles` (`id`, `name`, `slug`, `created_at`, `updated_at`) VALUES
	(1, 'Super Admin', 'super_admin', '2026-08-30 21:58:00', '2026-08-30 21:58:00'),
	(2, 'Admin', 'admin', '2026-08-30 21:58:00', '2026-08-30 21:58:00'),
	(3, 'Catalog Manager', 'catalog_manager', '2026-08-30 21:58:00', '2026-08-30 21:58:00'),
	(4, 'Inventory Manager', 'inventory_manager', '2026-08-30 21:58:00', '2026-08-30 21:58:00'),
	(5, 'Order Manager', 'order_manager', '2026-08-30 21:58:00', '2026-08-30 21:58:00'),
	(6, 'Finance Operator', 'finance_operator', '2026-08-30 21:58:00', '2026-08-30 21:58:00'),
	(7, 'Customer Service', 'customer_service', '2026-08-30 21:58:00', '2026-08-30 21:58:00'),
	(8, 'Customer', 'customer', '2026-08-30 21:58:00', '2026-08-30 21:58:00');

-- Dumping structure for table db_e_commerce.role_user
CREATE TABLE IF NOT EXISTS `role_user` (
  `role_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`user_id`),
  KEY `fk_role_user_user` (`user_id`),
  CONSTRAINT `fk_role_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_user_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.role_user: ~1 rows (approximately)
INSERT INTO `role_user` (`role_id`, `user_id`) VALUES
	(1, 4);

-- Dumping structure for table db_e_commerce.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.sessions: ~13 rows (approximately)
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
	('eOtVQLVYHEkH1vhlIwmTZDFcAF32zsQn9739573P', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiI3M1dkSUFCNTZ0eFhFTlNVejZvdjJSRDJqUjFSS1lOV01BMWg5enJKIiwidXJsIjp7ImludGVuZGVkIjoiaHR0cDpcL1wvMTI3LjAuMC4xOjgwMDBcL2FkbWluXC9wcm9kdWN0c1wvNVwvZWRpdCJ9LCJfcHJldmlvdXMiOnsidXJsIjoiaHR0cDpcL1wvMTI3LjAuMC4xOjgwMDBcL2FkbWluXC9wcm9kdWN0c1wvNFwvZWRpdCIsInJvdXRlIjoiYWRtaW4ucHJvZHVjdHMuZWRpdCJ9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX0sImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjo0fQ==', 1788403445),
	('USeTYMXxJjpmuNEx41r8D64GMPcdWIWQ09fVj9Ue', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJwbnkwMUVNRmplWU9Rd0R3c2xvNXFBeFEwWW4xNVVqYmlyczRIMUlsIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwIiwicm91dGUiOiJob21lIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1788401942),
	('Xy3QMNCypzYyNE9b3MPzWELr4DTPU5IlQZnzKfYM', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJmd28yeVp1MVZZaXBKSHVuVzJETjlNSXlBblluVmVNdlR5NkxsUDU4IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwIiwicm91dGUiOiJob21lIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1788410729),
	('YWG77m478S27JB4Fi2bTTZQcDmQMME7OLdbd4vxQ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJES0paaFl2MVVGWDFDOGQycnQxdDZ0Nm5aS1NGWnFrOWc1cFZlTGFvIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwIiwicm91dGUiOiJob21lIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1788410775);

-- Dumping structure for table db_e_commerce.settings
CREATE TABLE IF NOT EXISTS `settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `type` enum('string','integer','boolean','json') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'string',
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_settings_group_key` (`group`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.settings: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.shipments
CREATE TABLE IF NOT EXISTS `shipments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `method_id` bigint unsigned DEFAULT NULL,
  `courier` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tracking_number` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cost` bigint unsigned NOT NULL DEFAULT '0',
  `status` enum('pending','packed','shipped','in_transit','delivered','returned') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `shipped_at` timestamp NULL DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_shipments_order` (`order_id`),
  KEY `fk_shipments_warehouse` (`warehouse_id`),
  KEY `fk_shipments_method` (`method_id`),
  CONSTRAINT `fk_shipments_method` FOREIGN KEY (`method_id`) REFERENCES `shipping_methods` (`id`),
  CONSTRAINT `fk_shipments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_shipments_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.shipments: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.shipment_items
CREATE TABLE IF NOT EXISTS `shipment_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint unsigned NOT NULL,
  `order_item_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_shipment_items_shipment` (`shipment_id`),
  KEY `fk_shipment_items_order_item` (`order_item_id`),
  CONSTRAINT `fk_shipment_items_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`),
  CONSTRAINT `fk_shipment_items_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.shipment_items: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.shipping_methods
CREATE TABLE IF NOT EXISTS `shipping_methods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `service` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_price` bigint unsigned NOT NULL DEFAULT '0',
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shipping_methods_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.shipping_methods: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.stock_reservations
CREATE TABLE IF NOT EXISTS `stock_reservations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `variant_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `status` enum('active','committed','released','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_stock_res_status_expires` (`status`,`expires_at`),
  KEY `fk_stock_res_warehouse` (`warehouse_id`),
  KEY `fk_stock_res_variant` (`variant_id`),
  CONSTRAINT `fk_stock_res_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`),
  CONSTRAINT `fk_stock_res_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.stock_reservations: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('active','inactive','banned') NOT NULL DEFAULT 'active',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_e_commerce.users: ~4 rows (approximately)
INSERT INTO `users` (`id`, `name`, `email`, `phone`, `password`, `status`, `last_login_at`, `email_verified_at`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, 'Aris Maulana', 'arismaulana06445@gmail.com', '085792584079', '$2y$12$hqEUgaQnCJYj2Xys.mC1b.N4Y1NYFBcS779POk6hi6Y4UW3sGhd46', 'active', NULL, NULL, NULL, '2026-08-25 20:08:47', '2026-08-25 20:08:47'),
	(2, 'saipul', 'arismaulana06477@gmail.com', '085792584999', '$2y$12$px.YL76/Zs/Jhepnahbm/.Bok.UGQPOB2UMeqRRRfNYQFZBo.AMAa', 'active', NULL, NULL, NULL, '2026-08-27 22:48:13', '2026-08-27 22:48:13'),
	(3, 'Test User', 'test@example.com', '0812-3456-7890', '$2y$12$vzhMntKnJzA6zgFvVeDNl.wChZ9FDSjgFi2hsFMsuxETe2wux/A8e', 'active', NULL, NULL, NULL, '2026-08-30 21:27:19', '2026-08-30 23:37:32'),
	(4, 'Super Admin', 'admin@vgs.test', '08123456789', '$2y$12$ZYvDkGiG9KA3JquHsJtP4O9XjE2JkS7P0K02uhe1v56Zzv/kWT9c2', 'active', NULL, NULL, NULL, '2026-08-30 21:27:22', '2026-08-31 23:29:01');

-- Dumping structure for table db_e_commerce.warehouses
CREATE TABLE IF NOT EXISTS `warehouses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_warehouses_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.warehouses: ~1 rows (approximately)
INSERT INTO `warehouses` (`id`, `name`, `code`, `address`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'Gudang Utama', 'MAIN', 'Jl. Raya Mangga Dua No. 8, Jakarta Utara', 'active', '2026-09-02 19:57:25', '2026-09-02 19:57:25');

-- Dumping structure for table db_e_commerce.webhook_logs
CREATE TABLE IF NOT EXISTS `webhook_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_id` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `headers` json DEFAULT NULL,
  `payload` json DEFAULT NULL,
  `status` enum('received','processed','failed','ignored') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'received',
  `error` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_webhook_logs_provider_event` (`provider`,`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.webhook_logs: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.wishlists
CREATE TABLE IF NOT EXISTS `wishlists` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'My Wishlist',
  PRIMARY KEY (`id`),
  KEY `fk_wishlists_user` (`user_id`),
  CONSTRAINT `fk_wishlists_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.wishlists: ~0 rows (approximately)

-- Dumping structure for table db_e_commerce.wishlist_items
CREATE TABLE IF NOT EXISTS `wishlist_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `wishlist_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_wishlist_items_wishlist` (`wishlist_id`),
  KEY `fk_wishlist_items_product` (`product_id`),
  CONSTRAINT `fk_wishlist_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wishlist_items_wishlist` FOREIGN KEY (`wishlist_id`) REFERENCES `wishlists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_e_commerce.wishlist_items: ~0 rows (approximately)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
