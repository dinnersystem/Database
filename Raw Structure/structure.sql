-- MySQL dump 10.16  Distrib 10.1.45-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: dinnersys
-- ------------------------------------------------------
-- Server version	10.1.45-MariaDB-0+deb9u1
CREATE DATABASE IF NOT exists dinnersys_structure;
use dinnersys_structure;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attempt`
--

DROP TABLE IF EXISTS `attempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attempt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `until` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `log` int(11) NOT NULL DEFAULT '1',
  `uid` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `to_user_idx` (`uid`),
  KEY `attempt_to_log_idx` (`log`),
  CONSTRAINT `attempt_to_log` FOREIGN KEY (`log`) REFERENCES `log` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attempt_to_user` FOREIGN KEY (`uid`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=85989 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `buffet`
--

DROP TABLE IF EXISTS `buffet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buffet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `to_dish_idx` (`dish`),
  KEY `to_order_idx` (`order`),
  CONSTRAINT `to_dish` FOREIGN KEY (`dish`) REFERENCES `dish` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `to_order` FOREIGN KEY (`order`) REFERENCES `orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=212453 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cargo`
--

DROP TABLE IF EXISTS `cargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cargo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `get` tinyint(4) NOT NULL,
  `freeze_datetime` datetime NOT NULL,
  `get_datetime` datetime DEFAULT NULL,
  `able_datetime` datetime NOT NULL,
  `reversable` tinyint(4) NOT NULL,
  `logistics_info` int(11) NOT NULL DEFAULT '1',
  `tag` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `to_logstics_idx` (`logistics_info`),
  CONSTRAINT `to_logstics` FOREIGN KEY (`logistics_info`) REFERENCES `logistics_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=123025 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `class` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) NOT NULL,
  `grade` int(11) NOT NULL,
  `class_no` int(11) NOT NULL,
  `members` varchar(4096) COLLATE utf8_unicode_ci DEFAULT '610089,610000,610001',
  `dinnerman_id` int(11) DEFAULT '610089',
  `leader_id` int(11) DEFAULT '610089',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dinnerman_id` (`dinnerman_id`),
  UNIQUE KEY `leader_id` (`leader_id`),
  KEY `grade` (`grade`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `factory` int(11) NOT NULL,
  `father_department` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `to_factory_idx` (`factory`),
  CONSTRAINT `to_factory` FOREIGN KEY (`factory`) REFERENCES `factory` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dish`
--

DROP TABLE IF EXISTS `dish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dish` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish_name` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT '閒置中的餐點',
  `charge` int(11) NOT NULL DEFAULT '0',
  `is_vegetarian` int(11) NOT NULL DEFAULT '0',
  `is_idle` tinyint(4) NOT NULL DEFAULT '0',
  `department_id` int(11) NOT NULL DEFAULT '1',
  `daily_limit` int(11) NOT NULL DEFAULT '-1',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sum` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dish_to_department_idx` (`department_id`),
  CONSTRAINT `dish_to_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=701 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dish_history`
--

DROP TABLE IF EXISTS `dish_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dish_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish_id` int(11) NOT NULL,
  `dish_name` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `charge` int(11) NOT NULL,
  `vege` int(11) NOT NULL DEFAULT '0',
  `daily_limit` int(11) NOT NULL,
  `born_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `die_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dish_key_idx` (`dish_id`),
  KEY `born_idx` (`born_at`),
  KEY `die_idx` (`die_at`),
  CONSTRAINT `dish_key` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=28064 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log`
--

DROP TABLE IF EXISTS `error_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log` int(11) NOT NULL,
  `output` varchar(4096) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `error_to_log_idx` (`log`),
  CONSTRAINT `error_to_log` FOREIGN KEY (`log`) REFERENCES `log` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=168844 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_report`
--

DROP TABLE IF EXISTS `error_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`uid`),
  CONSTRAINT `users` FOREIGN KEY (`uid`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `factory`
--

DROP TABLE IF EXISTS `factory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'KrabbyPatty',
  `lower_bound` time(1) NOT NULL DEFAULT '09:00:00.0',
  `upper_bound` time(1) NOT NULL DEFAULT '15:00:00.0',
  `pre_time` time(1) NOT NULL DEFAULT '00:30:00.0',
  `payment_time` time NOT NULL DEFAULT '02:00:00',
  `avail_lower_bound` time NOT NULL DEFAULT '05:00:00',
  `avail_upper_bound` time NOT NULL DEFAULT '10:00:00',
  `daily_limit` int(11) NOT NULL,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sum` int(11) NOT NULL,
  `allow_custom` tinyint(4) NOT NULL,
  `pos_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `minimum` int(11) NOT NULL DEFAULT '10',
  `boss_id` int(11) NOT NULL DEFAULT '1',
  `activated` tinyint(1) NOT NULL,
  `external` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`(255)),
  KEY `to_user_idx` (`boss_id`),
  CONSTRAINT `to_user` FOREIGN KEY (`boss_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(128) COLLATE utf8_unicode_ci DEFAULT 'guest',
  `prev_sum` int(11) DEFAULT '-1',
  `query_detail` varchar(4096) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'backend.php?',
  `input` varchar(4096) COLLATE utf8_unicode_ci NOT NULL,
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '54.87.54.87',
  `oper_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `device_id` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2460379 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logistics_info`
--

DROP TABLE IF EXISTS `logistics_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `esti_recv_datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recv_datetime` (`esti_recv_datetime`)
) ENGINE=InnoDB AUTO_INCREMENT=140617 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `money_info`
--

DROP TABLE IF EXISTS `money_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `money_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `money_sum` int(11) NOT NULL,
  `status` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=140738 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `money_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `logistics_id` int(11) NOT NULL,
  `disabled` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_orders_money_trace1_idx` (`money_id`),
  UNIQUE KEY `fk_orders_item_info1_idx` (`logistics_id`),
  KEY `fk_orders_users1_idx` (`user_id`),
  KEY `disabled` (`disabled`),
  CONSTRAINT `fk_orders_item_info1` FOREIGN KEY (`logistics_id`) REFERENCES `logistics_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_money_trace1` FOREIGN KEY (`money_id`) REFERENCES `money_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=140610 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `max_external` int(11) NOT NULL,
  `external_sum` int(11) NOT NULL,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paid` tinyint(4) NOT NULL DEFAULT '0',
  `freeze_datetime` datetime NOT NULL,
  `able_datetime` datetime NOT NULL,
  `paid_datetime` datetime DEFAULT NULL,
  `reversable` tinyint(4) NOT NULL,
  `money_info` int(11) NOT NULL,
  `tag` varchar(64) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `paid_idx` (`paid`),
  KEY `to_money_idx` (`money_info`),
  CONSTRAINT `money` FOREIGN KEY (`money_info`) REFERENCES `money_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=256464 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_information`
--

DROP TABLE IF EXISTS `user_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_information` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bank_id` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `daily_limit` int(11) NOT NULL DEFAULT '5',
  `sum` int(11) NOT NULL DEFAULT '0',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '吳邦寧',
  `is_vegetarian` int(11) NOT NULL DEFAULT '0',
  `gender` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'MALE',
  `class_no` int(11) NOT NULL,
  `school_id` int(11) DEFAULT '610089',
  `seat_id` int(11) DEFAULT '11707',
  PRIMARY KEY (`id`),
  KEY `class_no` (`class_no`),
  KEY `school_id` (`school_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13238 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login_id` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `prev_sum` int(11) NOT NULL DEFAULT '0',
  `PIN` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT '123',
  `class_id` int(11) NOT NULL,
  `info_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `device_id` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'device_id would be NULL when logout.\ndevice_id means ',
  PRIMARY KEY (`id`),
  KEY `users_ibfk_1` (`info_id`),
  KEY `users_ibfk_2` (`class_id`),
  KEY `users_organization_idx` (`organization_id`),
  KEY `login` (`login_id`),
  CONSTRAINT `user_to_organization` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`info_id`) REFERENCES `user_information` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13236 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-08-16 19:42:38
