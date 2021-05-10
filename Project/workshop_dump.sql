-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: workshop
-- ------------------------------------------------------
-- Server version	8.0.23

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
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `user_id` bigint unsigned NOT NULL,
  `birthday` date NOT NULL,
  `client_status` varchar(30) DEFAULT NULL,
  `city` varchar(130) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_clients_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Клиенты';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (7,'1980-01-01','simple','Москва'),(8,'1991-01-05','simple','Novosibirsk');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `doc_number` varchar(255) DEFAULT NULL,
  `from_organisation_id` bigint unsigned NOT NULL,
  `manager` bigint unsigned NOT NULL,
  `to_organisation_id` bigint unsigned NOT NULL,
  `client` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_documents_from_organisation` (`from_organisation_id`),
  KEY `fk_documents_manager` (`manager`),
  KEY `fk_documents_to_organisation` (`to_organisation_id`),
  KEY `fk_documents_client` (`client`),
  CONSTRAINT `fk_documents_client` FOREIGN KEY (`client`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_documents_from_organisation` FOREIGN KEY (`from_organisation_id`) REFERENCES `organisation` (`id`),
  CONSTRAINT `fk_documents_manager` FOREIGN KEY (`manager`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_documents_to_organisation` FOREIGN KEY (`to_organisation_id`) REFERENCES `organisation` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (1,'№ 1323',1,1,4,7),(2,'№ 1324',1,2,4,7),(3,'№ 1354',1,1,4,8),(4,'№ 1316',3,4,1,1),(5,'№ 1323',1,1,4,7),(6,'№ 1324',1,2,4,7),(7,'№ 1354',1,1,4,8),(8,'№ 1316',3,4,1,1);
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_worker_in_from_organisation` BEFORE INSERT ON `documents` FOR EACH ROW BEGIN
	IF NEW.manager NOT IN (SELECT o.id_users FROM organisation_to_worker o WHERE o.id_organisation = NEW.from_organisation_id ) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Manager not in Organisation';
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_worker_in_to_organisation` BEFORE INSERT ON `documents` FOR EACH ROW BEGIN
	IF NEW.client NOT IN (SELECT o.id_users FROM organisation_to_worker o WHERE o.id_organisation = NEW.to_organisation_id ) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client not in Organisation';
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `log_ins_documents` AFTER INSERT ON `documents` FOR EACH ROW BEGIN
	INSERT INTO logs (id_in, date_time, name, table_log)
	VALUES (NEW.id, now(), NEW.id, 'documents');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `instruments`
--

DROP TABLE IF EXISTS `instruments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instruments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `id_manufacturer` bigint unsigned NOT NULL,
  `id_model` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_instruments_manufacturer` (`id_manufacturer`),
  KEY `fk_instruments_model` (`id_model`),
  CONSTRAINT `fk_instruments_manufacturer` FOREIGN KEY (`id_manufacturer`) REFERENCES `manufacturer` (`id`),
  CONSTRAINT `fk_instruments_model` FOREIGN KEY (`id_model`) REFERENCES `model` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instruments`
--

LOCK TABLES `instruments` WRITE;
/*!40000 ALTER TABLE `instruments` DISABLE KEYS */;
/*!40000 ALTER TABLE `instruments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_in` int unsigned DEFAULT NULL,
  `date_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) DEFAULT NULL COMMENT 'поле имени из таблицы',
  `table_log` varchar(64) DEFAULT NULL COMMENT 'имя таблицы',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='таблица логирования';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,5,'2021-05-09 18:21:39','5','documents'),(2,6,'2021-05-09 18:21:39','6','documents'),(3,7,'2021-05-09 18:21:39','7','documents'),(4,8,'2021-05-09 18:21:39','8','documents'),(5,7,'2021-05-09 19:00:29','7','works_to_transport'),(6,8,'2021-05-09 19:00:29','8','works_to_transport'),(7,9,'2021-05-09 19:00:29','9','works_to_transport'),(8,10,'2021-05-09 19:00:29','10','works_to_transport'),(9,11,'2021-05-09 19:00:29','11','works_to_transport'),(10,12,'2021-05-09 19:00:29','12','works_to_transport'),(11,15,'2021-05-10 01:08:12','15','works_to_transport');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer`
--

DROP TABLE IF EXISTS `manufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manufacturer` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT 'Название производителя',
  `country` varchar(130) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer`
--

LOCK TABLES `manufacturer` WRITE;
/*!40000 ALTER TABLE `manufacturer` DISABLE KEYS */;
INSERT INTO `manufacturer` VALUES (1,'Mersedes','gdr'),(2,'Dirt','India'),(3,'Crovok','China'),(4,'Warta','Russia');
/*!40000 ALTER TABLE `manufacturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model`
--

DROP TABLE IF EXISTS `model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `catalog_num` varchar(255) DEFAULT NULL COMMENT 'Каталожный номер',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model`
--

LOCK TABLES `model` WRITE;
/*!40000 ALTER TABLE `model` DISABLE KEYS */;
INSERT INTO `model` VALUES (8,'CR_0012'),(9,'FG_879-85'),(10,'juT-098-988'),(11,'899-445-545'),(12,'weel'),(13,'325315423'),(14,'rte-23');
/*!40000 ALTER TABLE `model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organisation`
--

DROP TABLE IF EXISTS `organisation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organisation` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT 'Название фирмы',
  `adress` varchar(130) DEFAULT NULL,
  `phone` char(11) DEFAULT NULL,
  `site` varchar(130) DEFAULT NULL,
  `pay_data` varchar(130) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `phone_check1` CHECK (regexp_like(`phone`,_utf8mb4'^[0-9]{11}$'))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Поставщики';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organisation`
--

LOCK TABLES `organisation` WRITE;
/*!40000 ALTER TABLE `organisation` DISABLE KEYS */;
INSERT INTO `organisation` VALUES (1,'Велоцентр','Ленина 45','79139132348',NULL,NULL),(2,'Инструмент центр','Набережная 28','79233454345',NULL,NULL),(3,'Мир запчастей','Полевая 77','79899999999',NULL,NULL),(4,'Частное лицо','','99999999999',NULL,NULL);
/*!40000 ALTER TABLE `organisation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organisation_to_worker`
--

DROP TABLE IF EXISTS `organisation_to_worker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organisation_to_worker` (
  `id_users` bigint unsigned NOT NULL,
  `id_organisation` bigint unsigned NOT NULL,
  PRIMARY KEY (`id_users`,`id_organisation`),
  KEY `fk_organisation_to_worker_users_organisation` (`id_organisation`),
  CONSTRAINT `fk_organisation_to_worker_users_organisation` FOREIGN KEY (`id_organisation`) REFERENCES `organisation` (`id`),
  CONSTRAINT `fk_organisation_to_worker_users_users` FOREIGN KEY (`id_users`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Работники организаций';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organisation_to_worker`
--

LOCK TABLES `organisation_to_worker` WRITE;
/*!40000 ALTER TABLE `organisation_to_worker` DISABLE KEYS */;
INSERT INTO `organisation_to_worker` VALUES (1,1),(2,1),(3,2),(4,3),(7,4),(8,4);
/*!40000 ALTER TABLE `organisation_to_worker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spare_part`
--

DROP TABLE IF EXISTS `spare_part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spare_part` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `id_manufacturer` bigint unsigned NOT NULL,
  `id_model` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_spare_part_manufacturer` (`id_manufacturer`),
  KEY `fk_spare_parts_model` (`id_model`),
  CONSTRAINT `fk_spare_part_manufacturer` FOREIGN KEY (`id_manufacturer`) REFERENCES `manufacturer` (`id`),
  CONSTRAINT `fk_spare_parts_model` FOREIGN KEY (`id_model`) REFERENCES `model` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spare_part`
--

LOCK TABLES `spare_part` WRITE;
/*!40000 ALTER TABLE `spare_part` DISABLE KEYS */;
INSERT INTO `spare_part` VALUES (1,'колесо',1,14),(2,'рама',1,13),(3,'диск тормозной',2,12),(4,'фара',2,11);
/*!40000 ALTER TABLE `spare_part` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transport`
--

DROP TABLE IF EXISTS `transport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_clients` bigint unsigned NOT NULL,
  `id_manufacturer` bigint unsigned NOT NULL,
  `id_model` bigint unsigned NOT NULL,
  `num` varchar(255) DEFAULT NULL COMMENT 'номер рамы',
  PRIMARY KEY (`id`),
  KEY `fk_transport_clients` (`id_clients`),
  KEY `fk_transport_manufacturer` (`id_manufacturer`),
  KEY `fk_transport_model` (`id_model`),
  CONSTRAINT `fk_transport_clients` FOREIGN KEY (`id_clients`) REFERENCES `clients` (`user_id`),
  CONSTRAINT `fk_transport_manufacturer` FOREIGN KEY (`id_manufacturer`) REFERENCES `manufacturer` (`id`),
  CONSTRAINT `fk_transport_model` FOREIGN KEY (`id_model`) REFERENCES `model` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport`
--

LOCK TABLES `transport` WRITE;
/*!40000 ALTER TABLE `transport` DISABLE KEYS */;
INSERT INTO `transport` VALUES (1,7,1,8,'34589-0940'),(2,7,2,9,'346524'),(3,7,3,10,'30940'),(4,8,1,8,'78648-0940');
/*!40000 ALTER TABLE `transport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(145) NOT NULL,
  `last_name` varchar(145) NOT NULL,
  `email` varchar(145) NOT NULL,
  `phone` char(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_idx` (`email`),
  UNIQUE KEY `phone_idx` (`phone`),
  CONSTRAINT `phone_check` CHECK (regexp_like(`phone`,_utf8mb4'^[0-9]{11}$'))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Люди';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Петр','Иванов','1232@mail.ru','79899999999','2021-05-08 20:30:36'),(2,'Мария','Облачная','1233@mail.ru','79899999989','2021-05-08 20:30:36'),(3,'Кузьма','Прутков','1234@mail.ru','79899999979','2021-05-08 20:30:36'),(4,'Сергей','Белый','1235@mail.ru','79899999969','2021-05-08 20:30:36'),(7,'Виктор','Петров','1242@mail.ru','79899999959','2021-05-08 22:54:27'),(8,'Ольга','Ветренная','1253@mail.ru','79899999589','2021-05-08 22:54:27');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_doc_and_works`
--

DROP TABLE IF EXISTS `view_doc_and_works`;
/*!50001 DROP VIEW IF EXISTS `view_doc_and_works`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_doc_and_works` AS SELECT 
 1 AS `id`,
 1 AS `doc_num`,
 1 AS `manager`,
 1 AS `client`,
 1 AS `work_name`,
 1 AS `time_work`,
 1 AS `sum_work`,
 1 AS `manuf`,
 1 AS `modil_num`,
 1 AS `detail`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_peope_in_org`
--

DROP TABLE IF EXISTS `view_peope_in_org`;
/*!50001 DROP VIEW IF EXISTS `view_peope_in_org`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_peope_in_org` AS SELECT 
 1 AS `name`,
 1 AS `org`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `works`
--

DROP TABLE IF EXISTS `works`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `works` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `time_to_end` time DEFAULT NULL,
  `sum_of_work` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `works`
--

LOCK TABLES `works` WRITE;
/*!40000 ALTER TABLE `works` DISABLE KEYS */;
INSERT INTO `works` VALUES (6,'замена колеса','00:00:15',200),(7,'ремонт шины','00:00:30',300),(8,'регулировка тормозов','00:00:20',1000),(9,'самазка звёздочки','00:00:50',500),(10,'подкачка колёс','00:00:10',50);
/*!40000 ALTER TABLE `works` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `works_to_transport`
--

DROP TABLE IF EXISTS `works_to_transport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `works_to_transport` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `works_id` bigint unsigned NOT NULL,
  `transport_id` bigint unsigned NOT NULL,
  `spare_part_id` bigint unsigned NOT NULL,
  `organisation_to_worker_user_id` bigint unsigned NOT NULL,
  `documents_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_works_to_transport_works` (`works_id`),
  KEY `fk_works_to_transport_transport` (`transport_id`),
  KEY `fk_works_to_transport_spare_part` (`spare_part_id`),
  KEY `fk_works_to_transport_organisation_to_worker_user` (`organisation_to_worker_user_id`),
  KEY `fk_works_to_transport_documents` (`documents_id`),
  CONSTRAINT `fk_works_to_transport_documents` FOREIGN KEY (`documents_id`) REFERENCES `documents` (`id`),
  CONSTRAINT `fk_works_to_transport_organisation_to_worker_user` FOREIGN KEY (`organisation_to_worker_user_id`) REFERENCES `organisation_to_worker` (`id_users`),
  CONSTRAINT `fk_works_to_transport_spare_part` FOREIGN KEY (`spare_part_id`) REFERENCES `spare_part` (`id`),
  CONSTRAINT `fk_works_to_transport_transport` FOREIGN KEY (`transport_id`) REFERENCES `transport` (`id`),
  CONSTRAINT `fk_works_to_transport_works` FOREIGN KEY (`works_id`) REFERENCES `works` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `works_to_transport`
--

LOCK TABLES `works_to_transport` WRITE;
/*!40000 ALTER TABLE `works_to_transport` DISABLE KEYS */;
INSERT INTO `works_to_transport` VALUES (7,6,1,1,1,1),(8,7,1,1,1,1),(9,8,1,3,1,1),(10,6,2,1,2,2),(11,7,2,1,2,2),(12,8,2,3,2,2),(15,9,2,2,2,2);
/*!40000 ALTER TABLE `works_to_transport` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `log_ins_works_to_transport` AFTER INSERT ON `works_to_transport` FOR EACH ROW BEGIN
	INSERT INTO logs (id_in, date_time, name, table_log)
	VALUES (NEW.id, now(), NEW.id, 'works_to_transport');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `view_doc_and_works`
--

/*!50001 DROP VIEW IF EXISTS `view_doc_and_works`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_doc_and_works` AS select `doc`.`id` AS `id`,`doc`.`doc_number` AS `doc_num`,(select concat(`u`.`first_name`,' ',`u`.`last_name`) from `users` `u` where (`doc`.`manager` = `u`.`id`)) AS `manager`,(select concat(`u`.`first_name`,' ',`u`.`last_name`) from `users` `u` where (`doc`.`client` = `u`.`id`)) AS `client`,`w`.`name` AS `work_name`,`w`.`time_to_end` AS `time_work`,`w`.`sum_of_work` AS `sum_work`,(select `man`.`name` from `manufacturer` `man` where (`tr`.`id_manufacturer` = `man`.`id`)) AS `manuf`,(select `model`.`catalog_num` from `model` where (`tr`.`id_model` = `model`.`id`)) AS `modil_num`,`sp`.`name` AS `detail` from ((((`works_to_transport` `wtt` join `documents` `doc` on((`wtt`.`documents_id` = `doc`.`id`))) join `works` `w` on((`wtt`.`works_id` = `w`.`id`))) join `transport` `tr` on((`wtt`.`transport_id` = `tr`.`id`))) join `spare_part` `sp` on((`wtt`.`spare_part_id` = `sp`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_peope_in_org`
--

/*!50001 DROP VIEW IF EXISTS `view_peope_in_org`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_peope_in_org` AS select concat(`name_u`.`first_name`,' ',`name_u`.`last_name`) AS `name`,`o`.`name` AS `org` from ((`organisation_to_worker` `otw` join `users` `name_u` on((`otw`.`id_users` = `name_u`.`id`))) join `organisation` `o` on((`otw`.`id_organisation` = `o`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-10 17:43:56
