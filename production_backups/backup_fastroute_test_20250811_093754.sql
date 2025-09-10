-- MySQL dump 10.13  Distrib 9.3.0, for macos13.7 (arm64)
--
-- Host: server.aptech.io    Database: fastroute_test
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

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của nhật ký hoạt động',
  `actor_id` bigint DEFAULT NULL COMMENT 'ID người dùng thực hiện hành động',
  `role_id` bigint NOT NULL COMMENT 'Vai trò của người dùng tại thời điểm thực hiện',
  `status_id` tinyint unsigned NOT NULL COMMENT 'Trạng thái hoàn thành hành động',
  `action_type` varchar(50) NOT NULL COMMENT 'Loại hành động (TẠO, CẬP NHẬT, XÓA, ĐĂNG NHẬP, v.v.)',
  `table_name` varchar(255) DEFAULT NULL,
  `record_id` bigint DEFAULT NULL COMMENT 'ID của bản ghi bị ảnh hưởng',
  `action_timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời điểm xảy ra hành động',
  `metadata` json DEFAULT NULL COMMENT 'Metadata bổ sung (giá trị cũ/mới, IP, v.v.)',
  PRIMARY KEY (`id`),
  KEY `fk_activity_logs_role_id` (`role_id`),
  KEY `fk_activity_logs_status_id` (`status_id`),
  KEY `idx_activity_logs_actor` (`actor_id`) COMMENT 'Log theo người thực hiện',
  KEY `idx_activity_logs_action_time` (`action_timestamp` DESC) COMMENT 'Log theo thời gian hành động',
  KEY `idx_activity_logs_table` (`table_name`) COMMENT 'Log theo bảng bị ảnh hưởng',
  KEY `idx_activity_logs_action_type` (`action_type`) COMMENT 'Log theo loại hành động',
  KEY `idx_activity_logs_record` (`table_name`,`record_id`) COMMENT 'Log theo bản ghi cụ thể',
  CONSTRAINT `FK5wnh8r1e5ffup2wu2shpwywak` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_activity_logs_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_activity_logs_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
INSERT INTO `activity_logs` VALUES (1,1,1,1,'LOGIN',NULL,NULL,'2025-08-07 16:40:37',NULL),(2,1,1,1,'LOGIN',NULL,NULL,'2025-08-07 16:41:24',NULL),(3,1,1,1,'LOGIN',NULL,NULL,'2025-08-07 16:43:54',NULL),(4,1,1,1,'LOGIN',NULL,NULL,'2025-08-07 16:45:31',NULL),(5,1,1,1,'LOGIN',NULL,NULL,'2025-08-07 16:50:06',NULL),(6,1,1,1,'LOGIN',NULL,NULL,'2025-08-07 16:56:18',NULL),(7,1,1,1,'LOGIN',NULL,NULL,'2025-08-07 17:25:00',NULL),(8,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 01:46:53',NULL),(9,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 02:31:49',NULL),(10,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 02:51:11',NULL),(11,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 02:55:40',NULL),(12,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 02:58:44',NULL),(13,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 02:58:44',NULL),(14,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 02:58:55',NULL),(15,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 02:59:14',NULL),(16,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:02:37',NULL),(17,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:04:26',NULL),(18,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:05:44',NULL),(19,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:07:49',NULL),(20,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:08:18',NULL),(21,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:09:06',NULL),(22,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:12:32',NULL),(23,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:18:09',NULL),(24,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:18:31',NULL),(25,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:19:17',NULL),(26,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:22:13',NULL),(27,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:22:28',NULL),(28,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:24:27',NULL),(29,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:26:07',NULL),(30,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:26:19',NULL),(31,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:29:52',NULL),(32,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:32:54',NULL),(33,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:34:09',NULL),(34,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:34:13',NULL),(35,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:34:33',NULL),(36,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:34:32',NULL),(37,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:34:58',NULL),(38,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:36:35',NULL),(39,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:39:39',NULL),(40,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:41:57',NULL),(41,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:42:12',NULL),(42,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:43:34',NULL),(43,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:44:06',NULL),(44,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:44:28',NULL),(45,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:45:14',NULL),(46,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:46:03',NULL),(47,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:50:05',NULL),(48,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:53:17',NULL),(49,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:53:26',NULL),(50,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:53:46',NULL),(51,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:55:14',NULL),(52,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 03:55:17',NULL),(53,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:57:49',NULL),(54,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:57:57',NULL),(55,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:58:16',NULL),(56,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 03:59:12',NULL),(57,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 03:59:24',NULL),(58,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 04:00:34',NULL),(59,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 04:00:39',NULL),(60,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:01:43',NULL),(61,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:01:59',NULL),(62,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:03:00',NULL),(63,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 04:04:41',NULL),(64,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:05:23',NULL),(65,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 04:05:33',NULL),(66,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:05:55',NULL),(67,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:08:52',NULL),(68,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:14:03',NULL),(69,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 04:15:18',NULL),(74,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 04:45:17',NULL),(76,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:08:11',NULL),(77,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:10:35',NULL),(78,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:25:00',NULL),(79,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:25:15',NULL),(80,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:34:16',NULL),(81,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 06:34:30',NULL),(82,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:36:46',NULL),(83,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:36:56',NULL),(84,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:40:56',NULL),(85,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:41:10',NULL),(86,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:44:41',NULL),(87,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 06:47:08',NULL),(88,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:01:54',NULL),(89,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:03:56',NULL),(90,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:07:06',NULL),(91,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:09:14',NULL),(92,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:10:28',NULL),(93,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:10:56',NULL),(94,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:12:30',NULL),(96,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:16:35',NULL),(97,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:17:35',NULL),(98,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:18:07',NULL),(99,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 07:24:23',NULL),(101,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 07:33:39',NULL),(102,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 07:34:57',NULL),(103,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 07:35:01',NULL),(104,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 07:36:09',NULL),(105,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 07:36:40',NULL),(106,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:37:56',NULL),(107,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:42:40',NULL),(108,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:43:01',NULL),(109,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:46:40',NULL),(110,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:48:22',NULL),(111,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 07:55:12',NULL),(112,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 07:58:14',NULL),(113,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 08:03:32',NULL),(114,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:06:31',NULL),(115,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 08:06:41',NULL),(116,11,4,1,'LOGIN',NULL,NULL,'2025-08-08 08:07:20',NULL),(117,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:07:52',NULL),(118,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:13:39',NULL),(119,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 08:15:20',NULL),(120,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:15:58',NULL),(121,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:19:37',NULL),(122,11,4,1,'LOGIN',NULL,NULL,'2025-08-08 08:19:44',NULL),(123,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:19:48',NULL),(124,13,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:19:57',NULL),(125,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 08:26:16',NULL),(126,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 08:26:45',NULL),(127,11,4,1,'LOGIN',NULL,NULL,'2025-08-08 08:27:22',NULL),(128,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 08:28:27',NULL),(129,11,4,1,'LOGIN',NULL,NULL,'2025-08-08 08:32:00',NULL),(130,11,4,1,'LOGIN',NULL,NULL,'2025-08-08 08:35:38',NULL),(131,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 08:35:48',NULL),(132,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:36:35',NULL),(133,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:39:19',NULL),(134,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 08:48:17',NULL),(135,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 08:54:35',NULL),(136,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 09:08:08',NULL),(137,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 09:30:39',NULL),(138,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 09:32:24',NULL),(139,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 09:39:47',NULL),(140,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 09:51:39',NULL),(141,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 09:52:26',NULL),(142,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 09:56:16',NULL),(143,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 09:56:47',NULL),(144,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:00:59',NULL),(145,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 10:01:09',NULL),(146,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 10:03:09',NULL),(147,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:03:53',NULL),(148,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:19:44',NULL),(149,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:27:36',NULL),(150,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 10:27:58',NULL),(151,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 10:28:36',NULL),(152,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:29:06',NULL),(153,11,4,1,'LOGIN',NULL,NULL,'2025-08-08 10:29:08',NULL),(154,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:37:32',NULL),(155,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 10:37:55',NULL),(156,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:38:25',NULL),(157,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 10:39:16',NULL),(158,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:39:34',NULL),(159,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:43:06',NULL),(160,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 10:50:13',NULL),(161,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 10:58:40',NULL),(162,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 11:00:26',NULL),(163,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 11:01:26',NULL),(164,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 11:15:47',NULL),(165,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 11:25:35',NULL),(166,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 11:35:38',NULL),(167,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 11:35:55',NULL),(168,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 11:36:12',NULL),(169,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 11:36:29',NULL),(170,1,1,1,'LOGIN',NULL,NULL,'2025-08-08 11:36:48',NULL),(171,6,3,1,'LOGIN',NULL,NULL,'2025-08-08 11:37:00',NULL),(172,3,2,1,'LOGIN',NULL,NULL,'2025-08-08 11:39:10',NULL),(173,1,1,1,'LOGIN',NULL,NULL,'2025-08-09 02:44:15',NULL),(174,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 02:44:56',NULL),(175,1,1,1,'LOGIN',NULL,NULL,'2025-08-09 02:53:53',NULL),(176,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 02:56:48',NULL),(177,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:12:40',NULL),(178,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:15:41',NULL),(179,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:16:38',NULL),(180,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:16:54',NULL),(181,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:17:30',NULL),(182,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:24:28',NULL),(183,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:24:54',NULL),(184,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:25:40',NULL),(185,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:25:47',NULL),(186,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 03:34:35',NULL),(187,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 05:22:35',NULL),(188,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 05:27:07',NULL),(189,1,1,1,'LOGIN',NULL,NULL,'2025-08-09 05:34:15',NULL),(190,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 05:44:48',NULL),(191,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 05:48:11',NULL),(192,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 05:48:42',NULL),(193,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 05:51:22',NULL),(194,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 05:53:19',NULL),(195,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 09:13:03',NULL),(196,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 09:46:56',NULL),(197,3,2,1,'LOGIN',NULL,NULL,'2025-08-09 09:47:09',NULL),(198,1,1,1,'LOGIN',NULL,NULL,'2025-08-09 09:47:28',NULL),(199,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 09:52:53',NULL),(200,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 10:04:19',NULL),(201,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 10:21:29',NULL),(202,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 10:28:52',NULL),(203,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 10:31:26',NULL),(204,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 15:08:48',NULL),(205,1,1,1,'LOGIN',NULL,NULL,'2025-08-09 15:11:24',NULL),(206,3,2,1,'LOGIN',NULL,NULL,'2025-08-09 15:12:05',NULL),(207,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 15:13:36',NULL),(208,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 15:21:34',NULL),(209,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 15:22:33',NULL),(210,1,1,1,'LOGIN',NULL,NULL,'2025-08-09 15:23:03',NULL),(211,3,2,1,'LOGIN',NULL,NULL,'2025-08-09 15:42:32',NULL),(212,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 15:48:17',NULL),(213,3,2,1,'LOGIN',NULL,NULL,'2025-08-09 15:53:16',NULL),(214,11,4,1,'LOGIN',NULL,NULL,'2025-08-09 15:54:05',NULL),(215,6,3,1,'LOGIN',NULL,NULL,'2025-08-09 16:00:54',NULL),(216,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 02:57:15',NULL),(217,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 03:05:42',NULL),(218,3,2,1,'LOGIN',NULL,NULL,'2025-08-10 03:20:29',NULL),(219,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 03:20:56',NULL),(220,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 04:10:54',NULL),(221,3,2,1,'LOGIN',NULL,NULL,'2025-08-10 04:11:15',NULL),(222,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 04:11:44',NULL),(223,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 04:23:29',NULL),(224,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 04:25:31',NULL),(225,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 09:20:55',NULL),(226,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 09:21:16',NULL),(227,3,2,1,'LOGIN',NULL,NULL,'2025-08-10 09:21:30',NULL),(228,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 09:22:18',NULL),(229,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 09:24:59',NULL),(230,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 09:28:20',NULL),(231,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 13:48:45',NULL),(232,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 13:49:29',NULL),(233,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 13:55:41',NULL),(234,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 13:58:27',NULL),(235,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 14:00:17',NULL),(236,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 14:12:56',NULL),(237,3,2,1,'LOGIN',NULL,NULL,'2025-08-10 14:20:13',NULL),(238,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 14:21:13',NULL),(239,3,2,1,'LOGIN',NULL,NULL,'2025-08-10 14:31:43',NULL),(240,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 14:31:53',NULL),(241,6,3,1,'LOGIN',NULL,NULL,'2025-08-10 14:32:03',NULL),(242,11,4,1,'LOGIN',NULL,NULL,'2025-08-10 14:32:30',NULL),(243,1,1,1,'LOGIN',NULL,NULL,'2025-08-10 14:33:48',NULL),(244,6,3,1,'LOGIN',NULL,NULL,'2025-08-11 01:56:19',NULL),(245,6,3,1,'LOGIN',NULL,NULL,'2025-08-11 02:05:19',NULL),(246,6,3,1,'LOGIN',NULL,NULL,'2025-08-11 02:07:23',NULL),(247,1,1,1,'LOGIN',NULL,NULL,'2025-08-11 02:12:48',NULL),(248,3,2,1,'LOGIN',NULL,NULL,'2025-08-11 02:13:19',NULL),(249,1,1,1,'LOGIN',NULL,NULL,'2025-08-11 02:24:36',NULL),(250,3,2,1,'LOGIN',NULL,NULL,'2025-08-11 02:24:49',NULL),(251,1,1,1,'LOGIN',NULL,NULL,'2025-08-11 02:25:11',NULL),(252,6,3,1,'LOGIN',NULL,NULL,'2025-08-11 02:25:34',NULL);
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của địa chỉ',
  `order_id` bigint NOT NULL COMMENT 'Mã đơn hàng liên quan',
  `address_type` varchar(50) NOT NULL COMMENT 'Loại địa chỉ (giao hàng, lấy hàng, trả hàng)',
  `address` varchar(500) NOT NULL COMMENT 'Địa chỉ đầy đủ (số nhà, đường, phường/xã)',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'Tọa độ vĩ độ (GPS)',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'Tọa độ kinh độ (GPS)',
  `city` varchar(100) DEFAULT NULL COMMENT 'Thành phố/Tỉnh',
  `state` varchar(100) DEFAULT NULL COMMENT 'Bang/Khu vực',
  `country` varchar(100) DEFAULT 'Vietnam' COMMENT 'Quốc gia',
  `region` varchar(100) DEFAULT NULL COMMENT 'Vùng miền/Khu vực',
  `postal_code` varchar(20) DEFAULT NULL COMMENT 'Mã bưu điện',
  `contact_name` varchar(255) DEFAULT NULL COMMENT 'Tên người liên hệ tại địa chỉ',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT 'Số điện thoại người liên hệ',
  `contact_email` varchar(255) DEFAULT NULL COMMENT 'Email người liên hệ',
  `floor_number` varchar(10) DEFAULT NULL COMMENT 'Số tầng/lầu của tòa nhà',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo địa chỉ',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật địa chỉ cuối cùng',
  PRIMARY KEY (`id`),
  KEY `idx_addresses_order` (`order_id`) COMMENT 'Địa chỉ theo đơn hàng',
  KEY `idx_addresses_type` (`address_type`) COMMENT 'Địa chỉ theo loại',
  KEY `idx_addresses_city` (`city`) COMMENT 'Địa chỉ theo thành phố',
  KEY `idx_addresses_coordinates` (`latitude`,`longitude`) COMMENT 'Tìm kiếm theo tọa độ GPS',
  CONSTRAINT `fk_addresses_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của danh mục',
  `external_id` bigint DEFAULT NULL,
  `category_id` varchar(50) NOT NULL COMMENT 'Mã danh mục nghiệp vụ (dễ đọc)',
  `name` varchar(255) NOT NULL COMMENT 'Tên hiển thị của danh mục',
  `description` text COMMENT 'Mô tả chi tiết về danh mục',
  `parent_id` bigint DEFAULT NULL COMMENT 'ID danh mục cha (cho cấu trúc cây)',
  `is_active` bit(1) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo danh mục',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật danh mục cuối cùng',
  `notes` text COMMENT 'Ghi chú bổ sung về danh mục',
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_id` (`category_id`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `idx_categories_parent` (`parent_id`) COMMENT 'Danh mục theo danh mục cha',
  KEY `idx_categories_active` (`is_active`) COMMENT 'Danh mục đang hoạt động',
  KEY `idx_categories_category_id` (`category_id`) COMMENT 'Tìm theo mã danh mục',
  CONSTRAINT `fk_categories_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,NULL,'1','Electronics','Electronic devices',NULL,_binary '','2025-08-11 09:29:12','2025-08-11 09:29:12',NULL),(2,NULL,'2','Furniture','Household furniture',NULL,_binary '','2025-08-11 09:29:12','2025-08-11 09:29:12',NULL),(3,NULL,'3','Clothing','Apparel and fashion',NULL,_binary '','2025-08-11 09:29:12','2025-08-11 09:29:12',NULL),(4,NULL,'4','Food','Groceries and food items',NULL,_binary '','2025-08-11 09:29:12','2025-08-11 09:29:12',NULL);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deliveries`
--

DROP TABLE IF EXISTS `deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deliveries` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của giao hàng',
  `order_id` bigint NOT NULL COMMENT 'Đơn hàng liên kết đang được giao',
  `delivery_fee` decimal(38,2) DEFAULT NULL,
  `transport_mode` varchar(50) DEFAULT 'ROAD' COMMENT 'Phương thức vận chuyển (đường bộ, hàng không, đường biển, đường sắt)',
  `service_type` varchar(50) DEFAULT 'STANDARD' COMMENT 'Mức dịch vụ (tiêu chuẩn, nhanh, ưu tiên)',
  `order_date` datetime NOT NULL COMMENT 'Thời điểm đặt hàng',
  `pickup_date` datetime DEFAULT NULL COMMENT 'Thời điểm lấy hàng',
  `schedule_delivery_time` datetime DEFAULT NULL COMMENT 'Thời gian giao hàng dự kiến',
  `actual_delivery_time` datetime DEFAULT NULL COMMENT 'Thời gian hoàn thành giao hàng thực tế',
  `late_delivery_risk` int NOT NULL,
  `vehicle_id` bigint NOT NULL COMMENT 'Phương tiện được phân công cho giao hàng này',
  `driver_id` bigint DEFAULT NULL COMMENT 'Tài xế được phân công cho giao hàng này',
  `tracking_id` bigint DEFAULT NULL COMMENT 'Bản ghi theo dõi GPS cho giao hàng này',
  `route_id` bigint DEFAULT NULL COMMENT 'Tuyến đường tối ưu cho giao hàng này',
  `delivery_attempts` int DEFAULT '0' COMMENT 'Số lần thử giao hàng đã thực hiện',
  `delivery_notes` text COMMENT 'Hướng dẫn đặc biệt và ghi chú cho giao hàng',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo bản ghi giao hàng',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật bản ghi giao hàng cuối cùng',
  PRIMARY KEY (`id`),
  KEY `idx_deliveries_vehicle` (`vehicle_id`) COMMENT 'Tìm giao hàng theo phương tiện',
  KEY `idx_deliveries_driver` (`driver_id`) COMMENT 'Tìm giao hàng theo tài xế',
  KEY `idx_deliveries_schedule_time` (`schedule_delivery_time`) COMMENT 'Sắp xếp theo thời gian giao hàng dự kiến',
  KEY `idx_deliveries_route` (`route_id`) COMMENT 'Tìm giao hàng theo tuyến đường',
  KEY `idx_deliveries_order` (`order_id`) COMMENT 'Tìm giao hàng theo đơn hàng',
  KEY `idx_deliveries_tracking` (`tracking_id`) COMMENT 'Tìm giao hàng theo tracking',
  CONSTRAINT `fk_deliveries_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_deliveries_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_deliveries_route_id` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`),
  CONSTRAINT `fk_deliveries_tracking_id` FOREIGN KEY (`tracking_id`) REFERENCES `delivery_tracking` (`id`),
  CONSTRAINT `fk_deliveries_vehicle_id` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  CONSTRAINT `chk_delivery_attempts` CHECK ((`delivery_attempts` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của bằng chứng giao hàng',
  `proof_type` varchar(50) NOT NULL DEFAULT 'PHOTO' COMMENT 'Loại bằng chứng (ảnh, chữ ký, ghi âm)',
  `file_path` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL COMMENT 'Tên file bằng chứng gốc',
  `recipient_name` varchar(255) DEFAULT NULL COMMENT 'Tên người nhận hàng thực tế',
  `recipient_signature` varchar(255) DEFAULT NULL,
  `captured_at` datetime DEFAULT NULL COMMENT 'Thời gian chụp/ghi nhận bằng chứng',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo bản ghi bằng chứng',
  `order_id` bigint NOT NULL COMMENT 'Mã đơn hàng liên quan đến bằng chứng',
  `uploaded_by` bigint DEFAULT NULL COMMENT 'ID người dùng (tài xế) upload bằng chứng',
  `notes` text COMMENT 'Ghi chú bổ sung về bằng chứng giao hàng',
  PRIMARY KEY (`id`),
  KEY `idx_delivery_proofs_order` (`order_id`) COMMENT 'Bằng chứng theo đơn hàng',
  KEY `idx_delivery_proofs_type` (`proof_type`) COMMENT 'Bằng chứng theo loại',
  KEY `idx_delivery_proofs_uploader` (`uploaded_by`) COMMENT 'Bằng chứng theo người upload',
  KEY `idx_delivery_proofs_captured` (`captured_at` DESC) COMMENT 'Bằng chứng theo thời gian chụp',
  CONSTRAINT `fk_delivery_proofs_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_delivery_proofs_uploaded_by` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của điểm theo dõi',
  `vehicle_id` bigint NOT NULL COMMENT 'Mã phương tiện đang được theo dõi',
  `status_id` tinyint unsigned NOT NULL COMMENT 'Trạng thái giao hàng tại thời điểm này',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'Tọa độ vĩ độ hiện tại',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'Tọa độ kinh độ hiện tại',
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian ghi nhận điểm theo dõi',
  `location` varchar(255) DEFAULT NULL COMMENT 'Tên địa điểm hiện tại (dễ đọc)',
  `notes` text COMMENT 'Ghi chú bổ sung tại điểm theo dõi',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo bản ghi theo dõi',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật bản ghi cuối cùng',
  `delivery_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_delivery_tracking_vehicle` (`vehicle_id`) COMMENT 'Tracking theo phương tiện',
  KEY `idx_delivery_tracking_vehicle_time` (`vehicle_id`,`timestamp` DESC) COMMENT 'Tracking theo thời gian mới nhất',
  KEY `idx_delivery_tracking_status` (`status_id`) COMMENT 'Tracking theo trạng thái',
  KEY `idx_delivery_tracking_timestamp` (`timestamp` DESC) COMMENT 'Sắp xếp tracking theo thời gian',
  KEY `FKa7752nojalt7df2ssnia9er56` (`delivery_id`),
  CONSTRAINT `fk_delivery_tracking_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `fk_delivery_tracking_vehicle_id` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  CONSTRAINT `FKa7752nojalt7df2ssnia9er56` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`id`)
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của mục hàng',
  `external_id` bigint DEFAULT NULL,
  `order_id` bigint NOT NULL COMMENT 'Mã đơn hàng chứa mục hàng này',
  `product_id` bigint NOT NULL COMMENT 'Mã sản phẩm trong mục hàng',
  `quantity` int NOT NULL COMMENT 'Số lượng sản phẩm đặt mua',
  `unit_price` decimal(38,2) DEFAULT NULL,
  `shipping_fee` decimal(38,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo mục hàng',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật mục hàng cuối cùng',
  `notes` text COMMENT 'Ghi chú đặc biệt cho mục hàng này',
  PRIMARY KEY (`id`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `idx_order_items_order` (`order_id`) COMMENT 'Tìm items theo đơn hàng',
  KEY `idx_order_items_product` (`product_id`) COMMENT 'Tìm items theo sản phẩm',
  KEY `idx_order_items_order_product` (`order_id`,`product_id`) COMMENT 'Composite index cho order-product',
  CONSTRAINT `fk_order_items_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_order_items_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `chk_order_item_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của đơn hàng',
  `external_id` bigint DEFAULT NULL,
  `status_id` tinyint unsigned NOT NULL COMMENT 'Trạng thái đơn hàng (chờ xử lý, đang xử lý, hoàn thành, hủy)',
  `store_id` bigint DEFAULT NULL COMMENT 'ID cửa hàng liên kết, NULL cho đơn hàng online',
  `description` text COMMENT 'Mô tả và chi tiết đơn hàng',
  `total_amount` decimal(15,2) DEFAULT '0.00' COMMENT 'Tổng số tiền đơn hàng bao gồm phí',
  `benefit_per_order` decimal(15,2) DEFAULT '0.00' COMMENT 'Lợi nhuận/biên lãi dự kiến từ đơn hàng này',
  `order_profit_per_order` decimal(15,2) DEFAULT '0.00' COMMENT 'Lợi nhuận được tính toán cho đơn hàng này',
  `notes` text COMMENT 'Ghi chú bổ sung về đơn hàng',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo đơn hàng',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật đơn hàng cuối cùng',
  `created_by` bigint DEFAULT NULL COMMENT 'ID người dùng tạo đơn hàng này',
  PRIMARY KEY (`id`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `idx_orders_status` (`status_id`) COMMENT 'Tìm đơn hàng theo trạng thái',
  KEY `idx_orders_status_created` (`status_id`,`created_at`) COMMENT 'Sắp xếp đơn hàng theo trạng thái và thời gian',
  KEY `idx_orders_store` (`store_id`) COMMENT 'Tìm đơn hàng theo cửa hàng',
  KEY `idx_orders_created_by` (`created_by`) COMMENT 'Tìm đơn hàng theo người tạo',
  CONSTRAINT `fk_orders_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_orders_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `fk_orders_store_id` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của thanh toán',
  `order_id` bigint NOT NULL COMMENT 'Mã đơn hàng được thanh toán',
  `amount` decimal(15,2) NOT NULL COMMENT 'Tổng số tiền thanh toán',
  `payment_method` varchar(50) NOT NULL DEFAULT 'CASH' COMMENT 'Phương thức thanh toán (tiền mặt, thẻ, chuyển khoản)',
  `status_id` tinyint unsigned NOT NULL COMMENT 'Trạng thái thanh toán (thành công, thất bại, chờ xử lý)',
  `transaction_id` varchar(255) DEFAULT NULL COMMENT 'Mã giao dịch từ cổng thanh toán',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo bản ghi thanh toán',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật thanh toán cuối cùng',
  `created_by` bigint DEFAULT NULL COMMENT 'ID người dùng tạo bản ghi thanh toán',
  `notes` text COMMENT 'Ghi chú bổ sung về thanh toán',
  PRIMARY KEY (`id`),
  KEY `fk_payments_created_by` (`created_by`),
  KEY `idx_payments_order` (`order_id`) COMMENT 'Thanh toán theo đơn hàng',
  KEY `idx_payments_status` (`status_id`) COMMENT 'Thanh toán theo trạng thái',
  KEY `idx_payments_method` (`payment_method`) COMMENT 'Thanh toán theo phương thức',
  KEY `idx_payments_transaction` (`transaction_id`) COMMENT 'Thanh toán theo mã giao dịch',
  KEY `idx_payments_created` (`created_at` DESC) COMMENT 'Thanh toán theo thời gian tạo',
  CONSTRAINT `fk_payments_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_payments_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_payments_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của sản phẩm',
  `external_id` bigint DEFAULT NULL,
  `product_code` varchar(50) NOT NULL COMMENT 'Mã SKU/mã nội bộ sản phẩm',
  `name` varchar(255) NOT NULL COMMENT 'Tên hiển thị sản phẩm',
  `description` text COMMENT 'Mô tả chi tiết sản phẩm',
  `category_id` bigint NOT NULL COMMENT 'Phân loại danh mục sản phẩm',
  `unit_price` decimal(15,2) NOT NULL COMMENT 'Giá bán trên một đơn vị',
  `weight` decimal(10,3) DEFAULT '0.000' COMMENT 'Trọng lượng sản phẩm (kg)',
  `volume` decimal(10,3) DEFAULT '0.000' COMMENT 'Thể tích sản phẩm (m3)',
  `is_fragile` tinyint NOT NULL DEFAULT '0',
  `stock_quantity` int NOT NULL DEFAULT '0' COMMENT 'Số lượng tồn kho hiện tại',
  `product_image` varchar(500) DEFAULT NULL COMMENT 'URL/đường dẫn ảnh sản phẩm',
  `product_status` enum('ACTIVE','INACTIVE') NOT NULL,
  `warehouse_id` bigint DEFAULT NULL COMMENT 'Kho chính chứa sản phẩm này',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo sản phẩm',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật sản phẩm cuối cùng',
  `created_by` bigint DEFAULT NULL COMMENT 'ID người dùng tạo sản phẩm này',
  `notes` text COMMENT 'Ghi chú bổ sung về sản phẩm',
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_code` (`product_code`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `fk_products_created_by` (`created_by`),
  KEY `idx_products_category` (`category_id`) COMMENT 'Tìm sản phẩm theo danh mục',
  KEY `idx_products_warehouse` (`warehouse_id`) COMMENT 'Tìm sản phẩm theo kho',
  KEY `idx_products_status` (`product_status`) COMMENT 'Tìm sản phẩm theo trạng thái',
  KEY `idx_products_code` (`product_code`) COMMENT 'Tìm sản phẩm theo mã SKU',
  CONSTRAINT `fk_products_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `fk_products_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_products_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`),
  CONSTRAINT `chk_product_price_positive` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `chk_product_weight_volume` CHECK (((`weight` >= 0) and (`volume` >= 0)))
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của vai trò',
  `role_name` varchar(50) NOT NULL COMMENT 'Tên vai trò (admin, điều phối, tài xế, xem)',
  `permission` json DEFAULT NULL COMMENT 'Đối tượng JSON chứa quyền và quyền truy cập của vai trò',
  `description` text COMMENT 'Mô tả chi tiết trách nhiệm của vai trò',
  `is_active` bit(1) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo vai trò',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật vai trò cuối cùng',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`),
  KEY `idx_roles_active` (`is_active`) COMMENT 'Vai trò đang hoạt động',
  KEY `idx_roles_name` (`role_name`) COMMENT 'Tìm vai trò theo tên'
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (2,'ADMIN',NULL,'Administrator role',_binary '','2025-08-11 09:35:08','2025-08-11 09:35:08'),(3,'MANAGER',NULL,'Manager role',_binary '','2025-08-11 09:35:08','2025-08-11 09:35:08'),(4,'USER',NULL,'Standard user role',_binary '','2025-08-11 09:35:08','2025-08-11 09:35:08'),(5,'CUSTOMER',NULL,'Default customer role',_binary '','2025-08-11 09:35:08','2025-08-11 09:35:08');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của tuyến đường',
  `name` varchar(255) NOT NULL COMMENT 'Tên tuyến đường (mô tả ngắn)',
  `waypoints` json NOT NULL COMMENT 'Danh sách các điểm dừng trên tuyến (JSON)',
  `estimated_distance_km` decimal(10,2) DEFAULT '0.00' COMMENT 'Khoảng cách dự kiến (km)',
  `estimated_duration_minutes` int DEFAULT '0' COMMENT 'Thời gian dự kiến (phút)',
  `estimated_cost` decimal(15,2) DEFAULT '0.00' COMMENT 'Chi phí dự kiến cho tuyến',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo tuyến đường',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật tuyến cuối cùng',
  `completed_at` datetime DEFAULT NULL COMMENT 'Thời gian hoàn thành tuyến đường',
  `created_by` bigint DEFAULT NULL COMMENT 'ID người dùng tạo tuyến đường',
  `notes` text COMMENT 'Ghi chú bổ sung về tuyến đường',
  PRIMARY KEY (`id`),
  KEY `idx_routes_created_by` (`created_by`) COMMENT 'Tuyến đường theo người tạo',
  KEY `idx_routes_completed` (`completed_at`) COMMENT 'Tuyến đường đã hoàn thành',
  KEY `idx_routes_estimated_cost` (`estimated_cost`) COMMENT 'Sắp xếp theo chi phí dự kiến',
  CONSTRAINT `fk_routes_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh trạng thái duy nhất (1-255)',
  `type` varchar(50) NOT NULL COMMENT 'Phân loại trạng thái (phương tiện, đơn hàng, thanh toán, người dùng, v.v.)',
  `name` varchar(100) NOT NULL COMMENT 'Tên trạng thái dễ đọc',
  `description` text COMMENT 'Mô tả chi tiết ý nghĩa của trạng thái',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo trạng thái',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật trạng thái cuối cùng',
  PRIMARY KEY (`id`),
  KEY `idx_status_type` (`type`) COMMENT 'Trạng thái theo loại',
  KEY `idx_status_name` (`name`) COMMENT 'Tìm trạng thái theo tên'
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,'ORDER','Pending','Awaiting processing','2025-08-11 09:34:51','2025-08-11 09:34:51'),(2,'ORDER','Completed','Order completed','2025-08-11 09:34:51','2025-08-11 09:34:51'),(3,'ORDER','Cancelled','Order cancelled','2025-08-11 09:34:51','2025-08-11 09:34:51'),(4,'ORDER','Processing','Order being processed','2025-08-11 09:34:51','2025-08-11 09:34:51'),(5,'ORDER','Shipped','Order shipped','2025-08-11 09:34:51','2025-08-11 09:34:51'),(6,'ORDER','Delivered','Order delivered','2025-08-11 09:34:51','2025-08-11 09:34:51'),(7,'USER','Active','Currently active','2025-08-11 09:34:51','2025-08-11 09:34:51'),(8,'USER','Inactive','Currently inactive','2025-08-11 09:34:51','2025-08-11 09:34:51'),(9,'USER','Suspended','Account suspended','2025-08-11 09:34:51','2025-08-11 09:34:51'),(10,'PAYMENT','Pending','Payment pending','2025-08-11 09:34:51','2025-08-11 09:34:51'),(11,'PAYMENT','Completed','Payment completed','2025-08-11 09:34:51','2025-08-11 09:34:51'),(12,'PAYMENT','Failed','Payment failed','2025-08-11 09:34:51','2025-08-11 09:34:51'),(13,'DELIVERY','Scheduled','Delivery scheduled','2025-08-11 09:34:51','2025-08-11 09:34:51'),(14,'DELIVERY','In Transit','Package in transit','2025-08-11 09:34:51','2025-08-11 09:34:51'),(15,'DELIVERY','Delivered','Package delivered','2025-08-11 09:34:51','2025-08-11 09:34:51'),(16,'DELIVERY','Failed','Delivery failed','2025-08-11 09:34:51','2025-08-11 09:34:51'),(17,'VEHICLE','AVAILABLE','Vehicle available for use','2025-08-11 09:34:51','2025-08-11 09:34:51'),(18,'VEHICLE','IN_USE','Vehicle currently in use','2025-08-11 09:34:51','2025-08-11 09:34:51'),(19,'VEHICLE','MAINTENANCE','Vehicle under maintenance','2025-08-11 09:34:51','2025-08-11 09:34:51'),(20,'ORDER','Pending','Awaiting processing','2025-08-11 09:35:08','2025-08-11 09:35:08'),(21,'ORDER','Completed','Order completed','2025-08-11 09:35:08','2025-08-11 09:35:08'),(22,'ORDER','Cancelled','Order cancelled','2025-08-11 09:35:08','2025-08-11 09:35:08'),(23,'ORDER','Processing','Order being processed','2025-08-11 09:35:08','2025-08-11 09:35:08'),(24,'ORDER','Shipped','Order shipped','2025-08-11 09:35:08','2025-08-11 09:35:08'),(25,'ORDER','Delivered','Order delivered','2025-08-11 09:35:08','2025-08-11 09:35:08'),(26,'USER','Active','Currently active','2025-08-11 09:35:08','2025-08-11 09:35:08'),(27,'USER','Inactive','Currently inactive','2025-08-11 09:35:08','2025-08-11 09:35:08'),(28,'USER','Suspended','Account suspended','2025-08-11 09:35:08','2025-08-11 09:35:08'),(29,'PAYMENT','Pending','Payment pending','2025-08-11 09:35:08','2025-08-11 09:35:08'),(30,'PAYMENT','Completed','Payment completed','2025-08-11 09:35:08','2025-08-11 09:35:08'),(31,'PAYMENT','Failed','Payment failed','2025-08-11 09:35:08','2025-08-11 09:35:08'),(32,'DELIVERY','Scheduled','Delivery scheduled','2025-08-11 09:35:08','2025-08-11 09:35:08'),(33,'DELIVERY','In Transit','Package in transit','2025-08-11 09:35:08','2025-08-11 09:35:08'),(34,'DELIVERY','Delivered','Package delivered','2025-08-11 09:35:08','2025-08-11 09:35:08'),(35,'DELIVERY','Failed','Delivery failed','2025-08-11 09:35:08','2025-08-11 09:35:08'),(36,'VEHICLE','AVAILABLE','Vehicle available for use','2025-08-11 09:35:08','2025-08-11 09:35:08'),(37,'VEHICLE','IN_USE','Vehicle currently in use','2025-08-11 09:35:08','2025-08-11 09:35:08'),(38,'VEHICLE','MAINTENANCE','Vehicle under maintenance','2025-08-11 09:35:08','2025-08-11 09:35:08');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stores`
--

DROP TABLE IF EXISTS `stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stores` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của cửa hàng',
  `external_id` bigint DEFAULT NULL,
  `store_name` varchar(255) NOT NULL COMMENT 'Tên hiển thị của cửa hàng',
  `email` varchar(255) DEFAULT NULL COMMENT 'Email liên hệ của cửa hàng',
  `phone` varchar(20) NOT NULL COMMENT 'Số điện thoại liên hệ cửa hàng',
  `address` text NOT NULL COMMENT 'Địa chỉ đầy đủ của cửa hàng',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'Tọa độ vĩ độ cửa hàng',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'Tọa độ kinh độ cửa hàng',
  `is_active` bit(1) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo cửa hàng',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật cửa hàng cuối cùng',
  `created_by` bigint DEFAULT NULL COMMENT 'ID người dùng tạo cửa hàng này',
  `notes` text COMMENT 'Ghi chú bổ sung về cửa hàng',
  PRIMARY KEY (`id`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `fk_stores_created_by` (`created_by`),
  KEY `idx_stores_active` (`is_active`) COMMENT 'Cửa hàng đang hoạt động',
  KEY `idx_stores_coordinates` (`latitude`,`longitude`) COMMENT 'Tìm cửa hàng theo tọa độ',
  CONSTRAINT `fk_stores_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của người dùng',
  `external_id` bigint DEFAULT NULL,
  `username` varchar(100) NOT NULL COMMENT 'Tên đăng nhập duy nhất',
  `email` varchar(255) NOT NULL COMMENT 'Địa chỉ email để đăng nhập và nhận thông báo',
  `password` varchar(255) NOT NULL COMMENT 'Mật khẩu đã mã hóa để xác thực',
  `full_name` varchar(255) DEFAULT NULL COMMENT 'Họ tên đầy đủ để hiển thị',
  `phone` varchar(20) DEFAULT NULL COMMENT 'Số điện thoại liên hệ',
  `role_id` bigint NOT NULL COMMENT 'Vai trò người dùng (admin, điều phối, tài xế, xem)',
  `status_id` tinyint unsigned DEFAULT NULL COMMENT 'Trạng thái tài khoản (hoạt động, ngừng hoạt động, tạm khóa)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo tài khoản',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật tài khoản cuối cùng',
  `notes` text COMMENT 'Ghi chú bổ sung về người dùng',
  `google_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `idx_users_role` (`role_id`) COMMENT 'Người dùng theo vai trò',
  KEY `idx_users_status` (`status_id`) COMMENT 'Người dùng theo trạng thái',
  KEY `idx_users_email` (`email`) COMMENT 'Tìm người dùng theo email',
  KEY `idx_users_username` (`username`) COMMENT 'Tìm người dùng theo username',
  CONSTRAINT `fk_users_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_users_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,NULL,'dispatcher','dispatcher@fr.com','1234','tram','12345',1,1,'2025-08-07 21:44:59','2025-08-08 07:09:02',NULL,NULL),(3,NULL,'admin','admin@fr.com','123123','tien','123456',2,1,'2025-08-08 09:50:19','2025-08-08 07:41:24',NULL,NULL),(6,NULL,'fleet','fleet@fr.com','1234','huy','1234',3,1,'2025-08-08 10:41:46','2025-08-08 10:43:29',NULL,NULL),(11,NULL,'operations','operations@fr.com','12345','hung','12345',4,1,'2025-08-08 15:06:49','2025-08-08 15:06:49',NULL,NULL),(13,NULL,'users','quynh@fr.com','123456','Phan quynh','0123456789',2,1,'2025-08-08 08:09:59','2025-08-08 08:09:59',NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của phương tiện',
  `license_plate` varchar(20) NOT NULL COMMENT 'Biển số xe',
  `vehicle_type` varchar(50) NOT NULL DEFAULT 'TRUCK' COMMENT 'Loại phương tiện (xe tải, xe van, xe máy, ô tô)',
  `capacity_weight_kg` decimal(10,2) DEFAULT '0.00' COMMENT 'Trọng tải tối đa của phương tiện (kg)',
  `capacity_volume_m3` decimal(10,2) DEFAULT '0.00' COMMENT 'Thể tích chứa hàng tối đa (m3)',
  `status_id` tinyint unsigned NOT NULL COMMENT 'Trạng thái xe (hoạt động, bảo trì, ngừng hoạt động)',
  `current_driver_id` bigint DEFAULT NULL COMMENT 'ID tài xế hiện tại, NULL nếu chưa phân công',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo bản ghi',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật cuối cùng',
  `notes` text COMMENT 'Ghi chú bổ sung về phương tiện',
  PRIMARY KEY (`id`),
  UNIQUE KEY `license_plate` (`license_plate`),
  KEY `idx_vehicles_status` (`status_id`) COMMENT 'Phương tiện theo trạng thái',
  KEY `idx_vehicles_driver` (`current_driver_id`) COMMENT 'Phương tiện theo tài xế hiện tại',
  KEY `idx_vehicles_type` (`vehicle_type`) COMMENT 'Phương tiện theo loại',
  KEY `idx_vehicles_license` (`license_plate`) COMMENT 'Phương tiện theo biển số',
  CONSTRAINT `fk_vehicles_current_driver_id` FOREIGN KEY (`current_driver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_vehicles_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `chk_vehicle_capacity` CHECK (((`capacity_weight_kg` >= 0) and (`capacity_volume_m3` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,'51A-00001','TRUCK',0.00,0.00,1,3,'2025-08-11 09:29:04','2025-08-11 09:29:04',NULL),(2,'51A-00002','TRUCK',0.00,0.00,1,3,'2025-08-11 09:29:04','2025-08-11 09:29:04',NULL),(3,'51A-00003','TRUCK',0.00,0.00,1,3,'2025-08-11 09:29:04','2025-08-11 09:29:04',NULL),(4,'51A-00004','TRUCK',0.00,0.00,1,3,'2025-08-11 09:29:04','2025-08-11 09:29:04',NULL);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouse_transactions`
--

DROP TABLE IF EXISTS `warehouse_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouse_transactions` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của giao dịch kho bãi',
  `product_id` bigint NOT NULL COMMENT 'Mã sản phẩm tham gia giao dịch',
  `warehouse_id` bigint NOT NULL COMMENT 'Mã kho hàng thực hiện giao dịch',
  `status_id` tinyint unsigned NOT NULL COMMENT 'Trạng thái giao dịch (thành công, thất bại, chờ xử lý)',
  `transaction_type` varchar(50) NOT NULL DEFAULT 'IN' COMMENT 'Loại giao dịch (nhập kho=IN, xuất kho=OUT, chuyển kho=TRANSFER)',
  `quantity` int NOT NULL COMMENT 'Số lượng sản phẩm trong giao dịch',
  `unit_cost` decimal(15,2) DEFAULT '0.00' COMMENT 'Giá vốn trên một đơn vị sản phẩm',
  `transaction_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian thực hiện giao dịch kho bãi',
  `order_id` bigint DEFAULT NULL COMMENT 'Mã đơn hàng liên quan (nếu có)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo bản ghi giao dịch',
  `created_by` bigint DEFAULT NULL COMMENT 'ID người dùng tạo giao dịch',
  `notes` text COMMENT 'Ghi chú bổ sung về giao dịch kho bãi',
  PRIMARY KEY (`id`),
  KEY `fk_warehouse_transactions_status_id` (`status_id`),
  KEY `fk_warehouse_transactions_created_by` (`created_by`),
  KEY `idx_warehouse_trans_product` (`product_id`) COMMENT 'Giao dịch theo sản phẩm',
  KEY `idx_warehouse_trans_warehouse` (`warehouse_id`) COMMENT 'Giao dịch theo kho',
  KEY `idx_warehouse_trans_date` (`transaction_date` DESC) COMMENT 'Giao dịch theo thời gian',
  KEY `idx_warehouse_trans_type` (`transaction_type`) COMMENT 'Giao dịch theo loại',
  KEY `idx_warehouse_trans_order` (`order_id`) COMMENT 'Giao dịch theo đơn hàng',
  KEY `idx_warehouse_trans_product_date` (`product_id`,`transaction_date` DESC) COMMENT 'Lịch sử giao dịch sản phẩm',
  CONSTRAINT `fk_warehouse_transactions_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_warehouse_transactions_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_warehouse_transactions_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_warehouse_transactions_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `fk_warehouse_transactions_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Mã định danh duy nhất của kho bãi',
  `warehouse_code` varchar(50) NOT NULL COMMENT 'Mã kho nghiệp vụ (dễ đọc)',
  `name` varchar(255) NOT NULL COMMENT 'Tên hiển thị của kho bãi',
  `address` text NOT NULL COMMENT 'Địa chỉ đầy đủ của kho bãi',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'Tọa độ vĩ độ kho bãi',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'Tọa độ kinh độ kho bãi',
  `capacity_m3` decimal(10,2) DEFAULT '0.00' COMMENT 'Sức chứa tối đa của kho (m3)',
  `is_active` bit(1) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo kho bãi',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật kho bãi cuối cùng',
  `created_by` bigint DEFAULT NULL COMMENT 'ID người dùng tạo kho bãi này',
  `notes` text COMMENT 'Ghi chú bổ sung về kho bãi',
  PRIMARY KEY (`id`),
  UNIQUE KEY `warehouse_code` (`warehouse_code`),
  KEY `fk_warehouses_created_by` (`created_by`),
  KEY `idx_warehouses_active` (`is_active`) COMMENT 'Kho đang hoạt động',
  KEY `idx_warehouses_code` (`warehouse_code`) COMMENT 'Tìm kho theo mã',
  KEY `idx_warehouses_coordinates` (`latitude`,`longitude`) COMMENT 'Tìm kho theo tọa độ',
  CONSTRAINT `fk_warehouses_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouses`
--

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'fastroute_test'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-11  9:38:00
