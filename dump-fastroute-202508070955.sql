-- MySQL dump 10.13  Distrib 9.3.0, for macos13.7 (arm64)
--
-- Host: server.aptech.io    Database: fastroute
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_logs`
--
Create database fastroute;
use fastroute;

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `status_id` smallint DEFAULT NULL,
  `action_timestamp` datetime(6) DEFAULT NULL,
  `actor_id` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `record_id` bigint DEFAULT NULL,
  `role_id` bigint DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `table_name` varchar(255) DEFAULT NULL,
  `action_type` enum('CREATE','DELETE','LOGIN','LOGOUT','UPDATE') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5wnh8r1e5ffup2wu2shpwywak` (`actor_id`),
  KEY `FK6cubi1liqrhpr7gwos6xu1ngm` (`role_id`),
  KEY `FKe9yfn8ry46vaw8gk2ll2bxyh0` (`status_id`),
  CONSTRAINT `FK5wnh8r1e5ffup2wu2shpwywak` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK6cubi1liqrhpr7gwos6xu1ngm` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `FKe9yfn8ry46vaw8gk2ll2bxyh0` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `floor_number` varchar(10) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `address` varchar(500) NOT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_name` varchar(255) DEFAULT NULL,
  `address_type` enum('DELIVERY','PICKUP','RETURN') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsv7a6xjwuwlcwxbq98p0gqna` (`order_id`),
  CONSTRAINT `FKsv7a6xjwuwlcwxbq98p0gqna` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `is_active` bit(1) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `description` text,
  `name` varchar(255) NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `FKsaok720gsu4u2wrgbk10b5n8d` (`parent_id`),
  CONSTRAINT `FKsaok720gsu4u2wrgbk10b5n8d` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deliveries`
--

DROP TABLE IF EXISTS `deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deliveries` (
  `delivery_attempts` int DEFAULT NULL,
  `delivery_fee` decimal(38,2) DEFAULT NULL,
  `late_delivery_risk` int NOT NULL,
  `actual_delivery_time` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `driver_id` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_date` datetime(6) NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `pickup_date` datetime(6) DEFAULT NULL,
  `route_id` bigint DEFAULT NULL,
  `schedule_delivery_time` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `vehicle_id` bigint NOT NULL,
  `delivery_notes` text,
  `service_type` enum('EXPRESS','PRIORITY','STANDARD') DEFAULT NULL,
  `transport_mode` enum('AIR','RAIL','ROAD','SEA') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKm4ubh4uobntck32iawsw1mlvq` (`driver_id`),
  KEY `FK7isx0rnbgqr1dcofd5putl6jw` (`order_id`),
  KEY `FKsr9655vvbw7n7qjhlr2dnw447` (`route_id`),
  KEY `FKgjj47cndyarbxrqimqu8q16n8` (`vehicle_id`),
  CONSTRAINT `FK7isx0rnbgqr1dcofd5putl6jw` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FKgjj47cndyarbxrqimqu8q16n8` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  CONSTRAINT `FKm4ubh4uobntck32iawsw1mlvq` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKsr9655vvbw7n7qjhlr2dnw447` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deliveries`
--

LOCK TABLES `deliveries` WRITE;
/*!40000 ALTER TABLE `deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_proofs`
--

DROP TABLE IF EXISTS `delivery_proofs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_proofs` (
  `captured_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `uploaded_by` bigint DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `notes` text,
  `recipient_name` varchar(255) DEFAULT NULL,
  `recipient_signature` varchar(255) DEFAULT NULL,
  `proof_type` enum('AUDIO','DOCUMENT','PHOTO','RECEIPT','SIGNATURE','VIDEO') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKmtwhwmhau28b7ioxf578o1adt` (`order_id`),
  KEY `FK4hed6fties4fpgjmcgm0ce7it` (`uploaded_by`),
  CONSTRAINT `FK4hed6fties4fpgjmcgm0ce7it` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`),
  CONSTRAINT `FKmtwhwmhau28b7ioxf578o1adt` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_proofs`
--

LOCK TABLES `delivery_proofs` WRITE;
/*!40000 ALTER TABLE `delivery_proofs` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_proofs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_tracking`
--

DROP TABLE IF EXISTS `delivery_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_tracking` (
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `status_id` smallint DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `delivery_id` bigint NOT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `timestamp` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `vehicle_id` bigint DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `FKa7752nojalt7df2ssnia9er56` (`delivery_id`),
  KEY `FKd6knotam8v73fit5fy27ndx3i` (`status_id`),
  KEY `FK90u8fjlmxnktxvbrieqhopj1p` (`vehicle_id`),
  CONSTRAINT `FK90u8fjlmxnktxvbrieqhopj1p` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  CONSTRAINT `FKa7752nojalt7df2ssnia9er56` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`id`),
  CONSTRAINT `FKd6knotam8v73fit5fy27ndx3i` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_tracking`
--

LOCK TABLES `delivery_tracking` WRITE;
/*!40000 ALTER TABLE `delivery_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `quantity` int NOT NULL,
  `shipping_fee` decimal(38,2) DEFAULT NULL,
  `unit_price` decimal(38,2) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `FKbioxgbv59vetrxe0ejfubep1w` (`order_id`),
  KEY `FKocimc7dtr037rh4ls4l95nlfi` (`product_id`),
  CONSTRAINT `FKbioxgbv59vetrxe0ejfubep1w` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FKocimc7dtr037rh4ls4l95nlfi` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `benefit_per_order` decimal(15,2) DEFAULT NULL,
  `order_profit_per_order` decimal(15,2) DEFAULT NULL,
  `status_id` smallint DEFAULT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `description` text,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `FKtjwuphstqm46uffgc7l1r27a9` (`created_by`),
  KEY `FKnoettwqr56yaai4i8nwxg4huo` (`status_id`),
  KEY `FKnqkwhwveegs6ne9ra90y1gq0e` (`store_id`),
  CONSTRAINT `FKnoettwqr56yaai4i8nwxg4huo` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `FKnqkwhwveegs6ne9ra90y1gq0e` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  CONSTRAINT `FKtjwuphstqm46uffgc7l1r27a9` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `amount` decimal(15,2) NOT NULL,
  `status_id` smallint DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `notes` text,
  `transaction_id` varchar(255) DEFAULT NULL,
  `payment_method` enum('BANK_TRANSFER','CASH','CREDIT_CARD','STRIPE') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK44957q7sogi6mtk6hs19kgycu` (`created_by`),
  KEY `FK81gagumt0r8y3rmudcgpbk42l` (`order_id`),
  KEY `FKbo8xfx3js3yc1j11d3goimta5` (`status_id`),
  CONSTRAINT `FK44957q7sogi6mtk6hs19kgycu` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `FK81gagumt0r8y3rmudcgpbk42l` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FKbo8xfx3js3yc1j11d3goimta5` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `is_fragile` tinyint NOT NULL DEFAULT '0',
  `stock_quantity` int NOT NULL DEFAULT '0',
  `unit_price` decimal(15,2) NOT NULL,
  `volume` decimal(10,3) DEFAULT NULL,
  `weight` decimal(10,3) DEFAULT NULL,
  `category_id` bigint NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `updated_at` datetime(6) DEFAULT NULL,
  `warehouse_id` bigint DEFAULT NULL,
  `product_image` varchar(500) DEFAULT NULL,
  `description` text,
  `name` varchar(255) NOT NULL,
  `notes` text,
  `product_status` enum('ACTIVE','INACTIVE') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKog2rp4qthbtt2lfyhfo32lsw9` (`category_id`),
  KEY `FKl0lce8i162ldn9n01t2a6lcix` (`created_by`),
  KEY `FK71egr0nqa3sut2fdk34e7o9eq` (`warehouse_id`),
  CONSTRAINT `FK71egr0nqa3sut2fdk34e7o9eq` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`),
  CONSTRAINT `FKl0lce8i162ldn9n01t2a6lcix` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `FKog2rp4qthbtt2lfyhfo32lsw9` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `is_active` bit(1) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `updated_at` datetime(6) DEFAULT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` text,
  `permission` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK716hgxp60ym1lifrdgp67xt5k` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `estimated_cost` decimal(15,2) DEFAULT NULL,
  `estimated_distance_km` decimal(10,2) DEFAULT NULL,
  `estimated_duration_minutes` int DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `updated_at` datetime(6) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `notes` text,
  `waypoints` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKo7qer9ki3o4s9p797spq6qmrs` (`created_by`),
  CONSTRAINT `FKo7qer9ki3o4s9p797spq6qmrs` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `type` enum('ORDER','PAYMENT','USER','VEHICLE') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stores`
--

DROP TABLE IF EXISTS `stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stores` (
  `is_active` bit(1) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `updated_at` datetime(6) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `notes` text,
  `store_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3tmg8nrwxp3j154hicgymbo8e` (`created_by`),
  CONSTRAINT `FK3tmg8nrwxp3j154hicgymbo8e` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stores`
--

LOCK TABLES `stores` WRITE;
/*!40000 ALTER TABLE `stores` DISABLE KEYS */;
/*!40000 ALTER TABLE `stores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `status_id` smallint DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `google_id` varchar(100) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `notes` text,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  KEY `FKp56c1712k691lhsyewcssf40f` (`role_id`),
  KEY `FK3m08uc0bd36m6tgp3g65m20dl` (`status_id`),
  CONSTRAINT `FK3m08uc0bd36m6tgp3g65m20dl` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `FKp56c1712k691lhsyewcssf40f` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `capacity_volume_m3` decimal(10,2) DEFAULT '0.00',
  `capacity_weight_kg` decimal(10,2) DEFAULT '0.00',
  `status_id` smallint NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `current_driver_id` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `updated_at` datetime(6) DEFAULT NULL,
  `license_plate` varchar(20) NOT NULL,
  `notes` text,
  `vehicle_type` varchar(50) NOT NULL DEFAULT 'TRUCK',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK9vovnbiegxevdhqfcwvp2g8pj` (`license_plate`),
  KEY `FK4yrgen35vwtcaohnh3f6ytlhf` (`current_driver_id`),
  KEY `FKqn210wvgtyjs89dhgq0s24ch1` (`status_id`),
  CONSTRAINT `FK4yrgen35vwtcaohnh3f6ytlhf` FOREIGN KEY (`current_driver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKqn210wvgtyjs89dhgq0s24ch1` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouse_transactions`
--

DROP TABLE IF EXISTS `warehouse_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouse_transactions` (
  `quantity` int NOT NULL,
  `status_id` smallint NOT NULL,
  `unit_cost` decimal(15,2) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint NOT NULL,
  `transaction_date` datetime(6) DEFAULT NULL,
  `warehouse_id` bigint NOT NULL,
  `notes` text,
  `transaction_type` enum('ADJUSTMENT','IN','OUT','TRANSFER') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKii7cqst2f5v46m9vw89bsoagb` (`created_by`),
  KEY `FK6ng5771b627624vkpb4gpnt8v` (`order_id`),
  KEY `FKm7x929mp5cskfp9crl6vwnbcu` (`product_id`),
  KEY `FKtit1cp176fxb7eb68i4n20fwy` (`status_id`),
  KEY `FK1k616ccc707y4tev1wutl5js3` (`warehouse_id`),
  CONSTRAINT `FK1k616ccc707y4tev1wutl5js3` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`),
  CONSTRAINT `FK6ng5771b627624vkpb4gpnt8v` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FKii7cqst2f5v46m9vw89bsoagb` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `FKm7x929mp5cskfp9crl6vwnbcu` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FKtit1cp176fxb7eb68i4n20fwy` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouse_transactions`
--

LOCK TABLES `warehouse_transactions` WRITE;
/*!40000 ALTER TABLE `warehouse_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `warehouse_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouses`
--

DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouses` (
  `capacity_m3` decimal(10,2) NOT NULL,
  `is_active` bit(1) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `updated_at` datetime(6) DEFAULT NULL,
  `address` text NOT NULL,
  `name` varchar(255) NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `FK21mnq798od8r3ua4p16t539qi` (`created_by`),
  CONSTRAINT `FK21mnq798od8r3ua4p16t539qi` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouses`
--

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'fastroute'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- 
-- Xóa dữ liệu cho các orders ID cụ thể
-- Thứ tự xóa: từ bảng con đến bảng cha để tránh lỗi khóa ngoại
--

-- Tắt kiểm tra khóa ngoại tạm thời để xóa dễ dàng hơn
SET FOREIGN_KEY_CHECKS = 0;

-- Xóa delivery_tracking (liên quan gián tiếp qua deliveries)
DELETE FROM delivery_tracking 
WHERE delivery_id IN (
    SELECT id FROM deliveries 
    WHERE order_id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8)
);

-- Xóa delivery_proofs
DELETE FROM delivery_proofs 
WHERE order_id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8);

-- Xóa deliveries
DELETE FROM deliveries 
WHERE order_id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8);

-- Xóa warehouse_transactions
DELETE FROM warehouse_transactions 
WHERE order_id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8);

-- Xóa payments
DELETE FROM payments 
WHERE order_id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8);

-- Xóa order_items
DELETE FROM order_items 
WHERE order_id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8);

-- Xóa addresses
DELETE FROM addresses 
WHERE order_id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8);

-- Cuối cùng xóa orders
DELETE FROM orders 
WHERE id IN (3, 5, 7, 65762, 65763, 65764, 1, 2, 4, 6, 8);

-- Bật lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;

-- Hiển thị số lượng orders còn lại
SELECT COUNT(*) as remaining_orders FROM orders;

-- Dump completed on 2025-08-07  9:55:08
