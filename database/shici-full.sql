-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: shici
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `allusions`
--

DROP TABLE IF EXISTS `allusions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allusions` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(200) NOT NULL COMMENT '典故名称',
  `content` text COMMENT '典故内容',
  `location_id` bigint DEFAULT NULL COMMENT '相关地点ID',
  `dynasty` varchar(50) DEFAULT NULL COMMENT '朝代',
  `source` varchar(500) DEFAULT NULL COMMENT '出处',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_location` (`location_id`),
  CONSTRAINT `allusions_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='典故信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allusions`
--

LOCK TABLES `allusions` WRITE;
/*!40000 ALTER TABLE `allusions` DISABLE KEYS */;
INSERT INTO `allusions` VALUES (1,'曲江流饮','唐代进士及第后，在曲江宴会饮酒，称为曲江流饮。新科进士在此饮酒作诗，是当时最风雅的社交活动。',1,'唐','唐摭言','2026-03-16 19:38:48','2026-03-16 19:38:48'),(2,'雁塔题名','唐代新科进士在慈恩寺大雁塔题名留念，白居易有\"慈恩塔下题名处，十七人中最少年\"的诗句。',1,'唐','唐摭言','2026-03-16 19:38:48','2026-03-16 19:38:48'),(3,'灞桥折柳','长安东灞桥是送别之地，古人折柳送别，取\"留\"的谐音。李白有\"年年柳色，灞陵伤别\"之句。',1,'唐','三辅黄图','2026-03-16 19:38:48','2026-03-16 19:38:48'),(4,'金龟换酒','贺知章在长安初见李白，读其《蜀道难》，赞其为\"谪仙人\"，解下所佩金龟换酒共饮。',1,'唐','本事诗','2026-03-16 19:38:48','2026-03-16 19:38:48'),(5,'梅妻鹤子','北宋诗人林逋隐居西湖孤山，植梅养鹤，终身不仕不娶，人称\"梅妻鹤子\"。',5,'宋','梦溪笔谈','2026-03-16 19:38:48','2026-03-16 19:38:48'),(6,'苏堤春晓','苏轼任杭州知州时疏浚西湖，筑成苏堤，后成为西湖十景之首。',5,'宋','西湖游览志','2026-03-16 19:38:48','2026-03-16 19:38:48'),(7,'三生石','传说唐代李源与圆观和尚在杭州天竺寺三生石前结下三世因缘。',5,'唐','甘泽谣','2026-03-16 19:38:48','2026-03-16 19:38:48'),(8,'白堤烟柳','白居易任杭州刺史时修建白堤，堤上植柳，成为西湖胜景。',5,'唐','西湖志','2026-03-16 19:38:48','2026-03-16 19:38:48'),(9,'文君当垆','汉代卓文君与司马相如在成都当垆卖酒，传为千古佳话。',3,'汉','史记','2026-03-16 19:38:48','2026-03-16 19:38:48'),(10,'杜甫草堂','杜甫避乱入蜀，在成都浣花溪畔筑草堂居住四年，创作240余首诗。',3,'唐','杜甫年谱','2026-03-16 19:38:48','2026-03-16 19:38:48'),(11,'薛涛制笺','唐代女诗人薛涛在成都浣花溪创制深红色小彩笺，后人称为\"薛涛笺\"。',3,'唐','牧竖闲谈','2026-03-16 19:38:48','2026-03-16 19:38:48'),(12,'洛阳纸贵','西晋左思作《三都赋》，豪贵之家竞相传写，洛阳为之纸贵。',2,'晋','晋书','2026-03-16 19:38:48','2026-03-16 19:38:48'),(13,'七步成诗','曹植被曹丕逼迫，在洛阳七步之内作诗：\"煮豆燃豆萁，豆在釜中泣。本是同根生，相煎何太急。\"',2,'三国','世说新语','2026-03-16 19:38:48','2026-03-16 19:38:48'),(14,'天津晓月','洛阳天津桥是唐代著名景点，晓月当空时景色最美，刘禹锡有\"天津桥下冰初结，洛阳陌上人行绝\"诗句。',2,'唐','洛阳伽蓝记','2026-03-16 19:38:48','2026-03-16 19:38:48'),(15,'二十四桥','扬州二十四桥是唐代著名景点，杜牧有\"二十四桥明月夜，玉人何处教吹箫\"名句。',4,'唐','扬州画舫录','2026-03-16 19:38:48','2026-03-16 19:38:48'),(16,'骑鹤上扬州','传说有客相约：愿为扬州刺史、腰缠万贯、骑鹤上扬州，后成为富贵的象征。',4,'唐','殷芸小说','2026-03-16 19:38:48','2026-03-16 19:38:48'),(17,'琼花观','扬州琼花天下无双，隋炀帝曾专程到扬州观赏琼花。',4,'隋','扬州府志','2026-03-16 19:38:48','2026-03-16 19:38:48'),(18,'乌衣巷','东晋王导、谢安等世家大族居南京乌衣巷，刘禹锡有\"旧时王谢堂前燕，飞入寻常百姓家\"名句。',8,'东晋','世说新语','2026-03-16 19:38:48','2026-03-16 19:38:48'),(19,'桃叶渡','王献之在此迎接爱妾桃叶，作《桃叶歌》三首。',8,'东晋','乐府诗集','2026-03-16 19:38:48','2026-03-16 19:38:48'),(20,'秦淮八艳','明末清初南京秦淮河畔的八位名妓，才貌双全，与文人雅士交往密切。',8,'明','板桥杂记','2026-03-16 19:38:48','2026-03-16 19:38:48'),(21,'虎溪三笑','东晋慧远大师在庐山东林寺，送客不过虎溪。一日送陶渊明、陆修静，谈兴正浓，不觉过溪，虎啸警示，三人大笑而别。',21,'东晋','庐山记','2026-03-16 19:38:48','2026-03-16 19:38:48'),(22,'香炉瀑布','李白《望庐山瀑布》\"日照香炉生紫烟\"即描写庐山香炉峰瀑布。',21,'唐','庐山志','2026-03-16 19:38:48','2026-03-16 19:38:48'),(23,'曲江流饮','唐代进士及第后，在曲江宴会饮酒，称为曲江流饮。新科进士在此饮酒作诗，是当时最风雅的社交活动。',1,'唐','唐摭言','2026-03-16 19:52:00','2026-03-16 19:52:00'),(24,'雁塔题名','唐代新科进士在慈恩寺大雁塔题名留念，白居易有\"慈恩塔下题名处，十七人中最少年\"的诗句。',1,'唐','唐摭言','2026-03-16 19:52:00','2026-03-16 19:52:00'),(25,'灞桥折柳','长安东灞桥是送别之地，古人折柳送别，取\"留\"的谐音。李白有\"年年柳色，灞陵伤别\"之句。',1,'唐','三辅黄图','2026-03-16 19:52:00','2026-03-16 19:52:00'),(26,'金龟换酒','贺知章在长安初见李白，读其《蜀道难》，赞其为\"谪仙人\"，解下所佩金龟换酒共饮。',1,'唐','本事诗','2026-03-16 19:52:00','2026-03-16 19:52:00'),(27,'梅妻鹤子','北宋诗人林逋隐居西湖孤山，植梅养鹤，终身不仕不娶，人称\"梅妻鹤子\"。',5,'宋','梦溪笔谈','2026-03-16 19:52:00','2026-03-16 19:52:00'),(28,'苏堤春晓','苏轼任杭州知州时疏浚西湖，筑成苏堤，后成为西湖十景之首。',5,'宋','西湖游览志','2026-03-16 19:52:00','2026-03-16 19:52:00'),(29,'三生石','传说唐代李源与圆观和尚在杭州天竺寺三生石前结下三世因缘。',5,'唐','甘泽谣','2026-03-16 19:52:00','2026-03-16 19:52:00'),(30,'白堤烟柳','白居易任杭州刺史时修建白堤，堤上植柳，成为西湖胜景。',5,'唐','西湖志','2026-03-16 19:52:00','2026-03-16 19:52:00'),(31,'文君当垆','汉代卓文君与司马相如在成都当垆卖酒，传为千古佳话。',3,'汉','史记','2026-03-16 19:52:00','2026-03-16 19:52:00'),(32,'杜甫草堂','杜甫避乱入蜀，在成都浣花溪畔筑草堂居住四年，创作240余首诗。',3,'唐','杜甫年谱','2026-03-16 19:52:00','2026-03-16 19:52:00'),(33,'薛涛制笺','唐代女诗人薛涛在成都浣花溪创制深红色小彩笺，后人称为\"薛涛笺\"。',3,'唐','牧竖闲谈','2026-03-16 19:52:00','2026-03-16 19:52:00'),(34,'洛阳纸贵','西晋左思作《三都赋》，豪贵之家竞相传写，洛阳为之纸贵。',2,'晋','晋书','2026-03-16 19:52:00','2026-03-16 19:52:00'),(35,'七步成诗','曹植被曹丕逼迫，在洛阳七步之内作诗：\"煮豆燃豆萁，豆在釜中泣。本是同根生，相煎何太急。\"',2,'三国','世说新语','2026-03-16 19:52:00','2026-03-16 19:52:00'),(36,'天津晓月','洛阳天津桥是唐代著名景点，晓月当空时景色最美，刘禹锡有\"天津桥下冰初结，洛阳陌上人行绝\"诗句。',2,'唐','洛阳伽蓝记','2026-03-16 19:52:00','2026-03-16 19:52:00'),(37,'二十四桥','扬州二十四桥是唐代著名景点，杜牧有\"二十四桥明月夜，玉人何处教吹箫\"名句。',4,'唐','扬州画舫录','2026-03-16 19:52:00','2026-03-16 19:52:00'),(38,'骑鹤上扬州','传说有客相约：愿为扬州刺史、腰缠万贯、骑鹤上扬州，后成为富贵的象征。',4,'唐','殷芸小说','2026-03-16 19:52:00','2026-03-16 19:52:00'),(39,'琼花观','扬州琼花天下无双，隋炀帝曾专程到扬州观赏琼花。',4,'隋','扬州府志','2026-03-16 19:52:00','2026-03-16 19:52:00'),(40,'乌衣巷','东晋王导、谢安等世家大族居南京乌衣巷，刘禹锡有\"旧时王谢堂前燕，飞入寻常百姓家\"名句。',8,'东晋','世说新语','2026-03-16 19:52:00','2026-03-16 19:52:00'),(41,'桃叶渡','王献之在此迎接爱妾桃叶，作《桃叶歌》三首。',8,'东晋','乐府诗集','2026-03-16 19:52:00','2026-03-16 19:52:00'),(42,'秦淮八艳','明末清初南京秦淮河畔的八位名妓，才貌双全，与文人雅士交往密切。',8,'明','板桥杂记','2026-03-16 19:52:00','2026-03-16 19:52:00'),(43,'虎溪三笑','东晋慧远大师在庐山东林寺，送客不过虎溪。一日送陶渊明、陆修静，谈兴正浓，不觉过溪，虎啸警示，三人大笑而别。',21,'东晋','庐山记','2026-03-16 19:52:00','2026-03-16 19:52:00'),(44,'香炉瀑布','李白《望庐山瀑布》\"日照香炉生紫烟\"即描写庐山香炉峰瀑布。',21,'唐','庐山志','2026-03-16 19:52:00','2026-03-16 19:52:00'),(45,'曲江流饮','唐代进士及第后，在曲江宴会饮酒，称为曲江流饮。新科进士在此饮酒作诗，是当时最风雅的社交活动。',1,'唐','唐摭言','2026-03-18 17:21:48','2026-03-18 17:21:48'),(46,'雁塔题名','唐代新科进士在慈恩寺大雁塔题名留念，白居易有\"慈恩塔下题名处，十七人中最少年\"的诗句。',1,'唐','唐摭言','2026-03-18 17:21:48','2026-03-18 17:21:48'),(47,'灞桥折柳','长安东灞桥是送别之地，古人折柳送别，取\"留\"的谐音。李白有\"年年柳色，灞陵伤别\"之句。',1,'唐','三辅黄图','2026-03-18 17:21:48','2026-03-18 17:21:48'),(48,'金龟换酒','贺知章在长安初见李白，读其《蜀道难》，赞其为\"谪仙人\"，解下所佩金龟换酒共饮。',1,'唐','本事诗','2026-03-18 17:21:48','2026-03-18 17:21:48'),(49,'梅妻鹤子','北宋诗人林逋隐居西湖孤山，植梅养鹤，终身不仕不娶，人称\"梅妻鹤子\"。',5,'宋','梦溪笔谈','2026-03-18 17:21:48','2026-03-18 17:21:48'),(50,'苏堤春晓','苏轼任杭州知州时疏浚西湖，筑成苏堤，后成为西湖十景之首。',5,'宋','西湖游览志','2026-03-18 17:21:48','2026-03-18 17:21:48'),(51,'三生石','传说唐代李源与圆观和尚在杭州天竺寺三生石前结下三世因缘。',5,'唐','甘泽谣','2026-03-18 17:21:48','2026-03-18 17:21:48'),(52,'白堤烟柳','白居易任杭州刺史时修建白堤，堤上植柳，成为西湖胜景。',5,'唐','西湖志','2026-03-18 17:21:48','2026-03-18 17:21:48'),(53,'文君当垆','汉代卓文君与司马相如在成都当垆卖酒，传为千古佳话。',3,'汉','史记','2026-03-18 17:21:48','2026-03-18 17:21:48'),(54,'杜甫草堂','杜甫避乱入蜀，在成都浣花溪畔筑草堂居住四年，创作240余首诗。',3,'唐','杜甫年谱','2026-03-18 17:21:48','2026-03-18 17:21:48'),(55,'薛涛制笺','唐代女诗人薛涛在成都浣花溪创制深红色小彩笺，后人称为\"薛涛笺\"。',3,'唐','牧竖闲谈','2026-03-18 17:21:48','2026-03-18 17:21:48'),(56,'洛阳纸贵','西晋左思作《三都赋》，豪贵之家竞相传写，洛阳为之纸贵。',2,'晋','晋书','2026-03-18 17:21:48','2026-03-18 17:21:48'),(57,'七步成诗','曹植被曹丕逼迫，在洛阳七步之内作诗：\"煮豆燃豆萁，豆在釜中泣。本是同根生，相煎何太急。\"',2,'三国','世说新语','2026-03-18 17:21:48','2026-03-18 17:21:48'),(58,'天津晓月','洛阳天津桥是唐代著名景点，晓月当空时景色最美，刘禹锡有\"天津桥下冰初结，洛阳陌上人行绝\"诗句。',2,'唐','洛阳伽蓝记','2026-03-18 17:21:48','2026-03-18 17:21:48'),(59,'二十四桥','扬州二十四桥是唐代著名景点，杜牧有\"二十四桥明月夜，玉人何处教吹箫\"名句。',4,'唐','扬州画舫录','2026-03-18 17:21:48','2026-03-18 17:21:48'),(60,'骑鹤上扬州','传说有客相约：愿为扬州刺史、腰缠万贯、骑鹤上扬州，后成为富贵的象征。',4,'唐','殷芸小说','2026-03-18 17:21:48','2026-03-18 17:21:48'),(61,'琼花观','扬州琼花天下无双，隋炀帝曾专程到扬州观赏琼花。',4,'隋','扬州府志','2026-03-18 17:21:48','2026-03-18 17:21:48'),(62,'乌衣巷','东晋王导、谢安等世家大族居南京乌衣巷，刘禹锡有\"旧时王谢堂前燕，飞入寻常百姓家\"名句。',8,'东晋','世说新语','2026-03-18 17:21:48','2026-03-18 17:21:48'),(63,'桃叶渡','王献之在此迎接爱妾桃叶，作《桃叶歌》三首。',8,'东晋','乐府诗集','2026-03-18 17:21:48','2026-03-18 17:21:48'),(64,'秦淮八艳','明末清初南京秦淮河畔的八位名妓，才貌双全，与文人雅士交往密切。',8,'明','板桥杂记','2026-03-18 17:21:48','2026-03-18 17:21:48'),(65,'虎溪三笑','东晋慧远大师在庐山东林寺，送客不过虎溪。一日送陶渊明、陆修静，谈兴正浓，不觉过溪，虎啸警示，三人大笑而别。',21,'东晋','庐山记','2026-03-18 17:21:48','2026-03-18 17:21:48'),(66,'香炉瀑布','李白《望庐山瀑布》\"日照香炉生紫烟\"即描写庐山香炉峰瀑布。',21,'唐','庐山志','2026-03-18 17:21:48','2026-03-18 17:21:48'),(67,'姑苏城外寒山寺','张继《枫桥夜泊》\"姑苏城外寒山寺，夜半钟声到客船\"，寒山寺因此诗闻名天下。',7,'唐','枫桥夜泊','2026-03-18 17:36:46','2026-03-18 17:36:46'),(68,'吴王宫阙','苏州为春秋吴国都城，吴王阖闾建城，夫差曾在此建馆娃宫宠幸西施。',7,'春秋','吴越春秋','2026-03-18 17:36:46','2026-03-18 17:36:46'),(69,'东京梦华','北宋都城开封繁华无比，孟元老著《东京梦华录》记载其盛况。',6,'宋','东京梦华录','2026-03-18 17:36:46','2026-03-18 17:36:46'),(70,'清明上河图','张择端绘《清明上河图》，描绘北宋开封清明时节的繁华景象。',6,'宋','清明上河图','2026-03-18 17:36:46','2026-03-18 17:36:46'),(71,'燕京八景','北京有燕京八景：太液秋风、琼岛春阴、金台夕照、蓟门烟树、西山晴雪、玉泉趵突、卢沟晓月、居庸叠翠。',NULL,'金','北京志','2026-03-18 17:36:46','2026-03-18 17:36:46'),(72,'锦官城外柏森森','杜甫《蜀相》\"丞相祠堂何处寻，锦官城外柏森森\"，描写成都武侯祠。',3,'唐','杜工部集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(73,'琴台故径','司马相如与卓文君在成都琴台卖酒，传为千古佳话。',3,'汉','史记','2026-03-18 17:36:46','2026-03-18 17:36:46'),(74,'黄鹤楼','崔颢《黄鹤楼》\"昔人已乘黄鹤去，此地空余黄鹤楼\"，李白见之搁笔。',17,'唐','全唐诗','2026-03-18 17:36:46','2026-03-18 17:36:46'),(75,'晴川历历汉阳树','崔颢《黄鹤楼》\"晴川历历汉阳树，芳草萋萋鹦鹉洲\"，描绘武汉风光。',17,'唐','全唐诗','2026-03-18 17:36:46','2026-03-18 17:36:46'),(76,'滕王阁','王勃《滕王阁序》\"落霞与孤鹜齐飞，秋水共长天一色\"，千古名句。',15,'唐','滕王阁序','2026-03-18 17:36:46','2026-03-18 17:36:46'),(77,'物华天宝','王勃《滕王阁序》\"物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻\"。',15,'唐','滕王阁序','2026-03-18 17:36:46','2026-03-18 17:36:46'),(78,'浔阳江头夜送客','白居易《琵琶行》\"浔阳江头夜送客，枫叶荻花秋瑟瑟\"，九江因此诗闻名。',16,'唐','白氏长庆集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(79,'采菊东篱下','陶渊明《饮酒》\"采菊东篱下，悠然见南山\"，描写九江田园生活。',16,'东晋','陶渊明集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(80,'四面荷花三面柳','刘凤诰咏大明湖\"四面荷花三面柳，一城山色半城湖\"，描绘济南风光。',24,'清','济南府志','2026-03-18 17:36:46','2026-03-18 17:36:46'),(81,'易安居士','李清照号易安居士，济南人，为千古第一才女。',24,'宋','宋史','2026-03-18 17:36:46','2026-03-18 17:36:46'),(82,'兰亭集序','王羲之在绍兴兰亭与友人修禊，作《兰亭集序》，被誉为天下第一行书。',28,'东晋','兰亭集序','2026-03-18 17:36:46','2026-03-18 17:36:46'),(83,'会稽山阴','王羲之《兰亭集序》\"永和九年，岁在癸丑，暮春之初，会于会稽山阴之兰亭\"。',28,'东晋','兰亭集序','2026-03-18 17:36:46','2026-03-18 17:36:46'),(84,'京口瓜洲一水间','王安石《泊船瓜洲》\"京口瓜洲一水间，钟山只隔数重山\"，京口即镇江。',29,'宋','临川集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(85,'何处望神州','辛弃疾《永遇乐》\"何处望神州？满眼风光北固楼\"，北固楼在镇江。',29,'宋','稼轩词','2026-03-18 17:36:46','2026-03-18 17:36:46'),(86,'隆中对','诸葛亮在襄阳隆中与刘备纵论天下大势，提出三分天下之策。',18,'三国','三国志','2026-03-18 17:36:46','2026-03-18 17:36:46'),(87,'襄阳好风日','王维《汉江临泛》\"襄阳好风日，留醉与山翁\"，赞美襄阳风光。',18,'唐','王右丞集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(88,'大意失荆州','关羽镇守荆州，因轻敌大意被吕蒙偷袭，失去荆州，后败走麦城。',17,'三国','三国演义','2026-03-18 17:36:46','2026-03-18 17:36:46'),(89,'千里江陵一日还','李白《早发白帝城》\"朝辞白帝彩云间，千里江陵一日还\"，江陵即荆州。',17,'唐','李太白集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(90,'海上丝绸之路','广州是海上丝绸之路起点，唐代设市舶司，为对外贸易重镇。',19,'唐','唐书','2026-03-18 17:36:46','2026-03-18 17:36:46'),(91,'日啖荔枝三百颗','苏轼《惠州一绝》\"日啖荔枝三百颗，不辞长作岭南人\"，描写岭南生活。',19,'宋','东坡全集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(92,'敦煌飞天','敦煌莫高窟壁画中的飞天形象，为中国艺术瑰宝。',20,'唐','敦煌志','2026-03-18 17:36:46','2026-03-18 17:36:46'),(93,'西出阳关无故人','王维《送元二使安西》\"劝君更尽一杯酒，西出阳关无故人\"，阳关在敦煌附近。',20,'唐','王右丞集','2026-03-18 17:36:46','2026-03-18 17:36:46'),(94,'孔子讲学','孔子在曲阜讲学授徒，有弟子三千，贤人七十二。',25,'春秋','论语','2026-03-18 17:36:46','2026-03-18 17:36:46'),(95,'杏坛','孔子在曲阜杏坛讲学，后成为教育圣地的象征。',25,'春秋','庄子','2026-03-18 17:36:46','2026-03-18 17:36:46'),(96,'桂林山水甲天下','王正功\"桂林山水甲天下\"，使桂林成为山水名胜的代表。',21,'宋','桂林志','2026-03-18 17:36:46','2026-03-18 17:36:46'),(97,'象鼻山','桂林象鼻山形似巨象饮水，为桂林标志性景观。',21,'唐','桂林风土记','2026-03-18 17:36:46','2026-03-18 17:36:46'),(98,'岳阳楼记','范仲淹《岳阳楼记》\"先天下之忧而忧，后天下之乐而乐\"，成为千古名句。',84,'宋','岳阳楼记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(99,'洞庭天下水','洞庭湖为中国第二大淡水湖，岳阳楼临湖而建，有\"洞庭天下水，岳阳天下楼\"之称。',84,'唐','岳阳楼记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(100,'桃花源记','陶渊明《桃花源记》描绘的理想社会，据传在常德桃源县。',85,'东晋','陶渊明集','2026-03-18 18:46:27','2026-03-18 18:46:27'),(101,'武陵渔人','陶渊明笔下武陵渔人误入桃花源，后成为避世理想国的象征。',85,'东晋','桃花源记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(102,'橘子洲头','毛泽东《沁园春·长沙》\"独立寒秋，湘江北去，橘子洲头\"，描绘长沙秋景。',87,'现代','毛泽东诗词','2026-03-18 18:46:27','2026-03-18 18:46:27'),(103,'岳麓书院','岳麓书院为中国四大书院之一，朱熹曾在此讲学。',87,'宋','岳麓书院志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(104,'海上丝绸之路','泉州为海上丝绸之路起点，宋元时期为东方第一大港，马可波罗称为\"光明之城\"。',95,'宋','马可波罗游记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(105,'刺桐城','泉州古称刺桐，因遍植刺桐树而得名，宋元时期繁华无比。',95,'宋','泉州府志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(106,'三顾茅庐','刘备三顾茅庐请诸葛亮出山，发生地在南阳卧龙岗。',111,'三国','三国志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(107,'躬耕南阳','诸葛亮《出师表》\"臣本布衣，躬耕于南阳\"，表明其隐居之地。',111,'三国','出师表','2026-03-18 18:46:27','2026-03-18 18:46:27'),(108,'曹操挟天子以令诸侯','曹操迎汉献帝至许昌，以天子名义号令天下。',110,'三国','三国志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(109,'建安文学','曹操父子在许昌开创建安文学，形成慷慨悲凉的建安风骨。',110,'三国','建安七子集','2026-03-18 18:46:27','2026-03-18 18:46:27'),(110,'殷墟甲骨','安阳殷墟出土大量甲骨文，是中国最早的成熟文字系统。',109,'商','殷墟发掘报告','2026-03-18 18:46:27','2026-03-18 18:46:27'),(111,'妇好墓','殷墟妇好墓是中国考古史上重大发现，妇好是中国第一位女将军。',109,'商','殷墟发掘报告','2026-03-18 18:46:27','2026-03-18 18:46:27'),(112,'云冈石窟','云冈石窟为北魏时期开凿，是中国四大石窟之一，艺术价值极高。',124,'北魏','云冈石窟志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(113,'北魏都城','北魏孝文帝迁都洛阳前，大同（平城）为北魏都城近百年。',124,'北魏','魏书','2026-03-18 18:46:27','2026-03-18 18:46:27'),(114,'伏羲画卦','天水为伏羲故里，相传伏羲在此画八卦，开创中华文明。',152,'上古','周易','2026-03-18 18:46:27','2026-03-18 18:46:27'),(115,'麦积山石窟','麦积山石窟为中国四大石窟之一，以泥塑艺术著称。',152,'后秦','麦积山志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(116,'火焰山','《西游记》中火焰山原型，吐鲁番夏季酷热，有\"火洲\"之称。',178,'唐','西游记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(117,'高昌古城','高昌古城为西域重镇，玄奘西行曾在此讲经。',178,'唐','大唐西域记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(118,'丝绸之路重镇','喀什为古丝绸之路重镇，东西方文化交汇之地。',185,'汉','汉书·西域传','2026-03-18 18:46:27','2026-03-18 18:46:27'),(119,'香妃墓','喀什香妃墓为乾隆帝香妃之墓，建筑风格独特。',185,'清','西域图志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(120,'盛京故宫','沈阳故宫为清朝入关前的皇宫，是中国现存两大皇宫之一。',191,'清','清史稿','2026-03-18 18:46:27','2026-03-18 18:46:27'),(121,'努尔哈赤迁都','努尔哈赤迁都沈阳，奠定了清朝基业。',191,'清','清史稿','2026-03-18 18:46:27','2026-03-18 18:46:27'),(122,'冰城','哈尔滨冬季冰雪大世界闻名遐迩，有\"冰城\"之称。',214,'现代','哈尔滨志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(123,'东方莫斯科','哈尔滨建筑风格独特，有\"东方莫斯科\"之称。',214,'现代','哈尔滨志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(124,'遵义会议','1935年遵义会议确立了毛泽东的领导地位，是中国革命转折点。',229,'现代','中共党史','2026-03-18 18:46:27','2026-03-18 18:46:27'),(125,'茅台酒乡','遵义仁怀茅台镇为中国国酒茅台产地。',229,'清','遵义府志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(126,'黄果树瀑布','黄果树瀑布为中国第一大瀑布，徐霞客曾赞叹其壮观。',230,'明','徐霞客游记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(127,'龙宫','安顺龙宫为溶洞奇观，有\"天下第一洞\"之称。',230,'明','安顺府志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(128,'梵净山','梵净山为弥勒道场，是中国五大佛教名山之一。',232,'明','梵净山志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(129,'三峡门户','宜昌为长江三峡门户，三峡大坝所在地。',100,'现代','宜昌志','2026-03-18 18:46:27','2026-03-18 18:46:27'),(130,'屈原故里','宜昌秭归为爱国诗人屈原故里，端午文化发源地。',100,'战国','史记','2026-03-18 18:46:27','2026-03-18 18:46:27'),(131,'东坡赤壁','苏轼贬谪黄州（今黄冈），创作《赤壁赋》《念奴娇·赤壁怀古》等名篇。',108,'宋','东坡全集','2026-03-18 18:46:27','2026-03-18 18:46:27'),(132,'文赤壁','黄冈赤壁因苏轼作品而闻名，与三国赤壁（武赤壁）相区别。',108,'宋','东坡全集','2026-03-18 18:46:27','2026-03-18 18:46:27'),(133,'岳阳楼记','范仲淹《岳阳楼记》\"先天下之忧而忧，后天下之乐而乐\"，成为千古名句。',84,'宋','岳阳楼记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(134,'洞庭天下水','洞庭湖为中国第二大淡水湖，岳阳楼临湖而建，有\"洞庭天下水，岳阳天下楼\"之称。',84,'唐','岳阳楼记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(135,'桃花源记','陶渊明《桃花源记》描绘的理想社会，据传在常德桃源县。',85,'东晋','陶渊明集','2026-03-18 19:06:00','2026-03-18 19:06:00'),(136,'武陵渔人','陶渊明笔下武陵渔人误入桃花源，后成为避世理想国的象征。',85,'东晋','桃花源记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(137,'橘子洲头','毛泽东《沁园春·长沙》\"独立寒秋，湘江北去，橘子洲头\"，描绘长沙秋景。',87,'现代','毛泽东诗词','2026-03-18 19:06:00','2026-03-18 19:06:00'),(138,'岳麓书院','岳麓书院为中国四大书院之一，朱熹曾在此讲学。',87,'宋','岳麓书院志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(139,'海上丝绸之路','泉州为海上丝绸之路起点，宋元时期为东方第一大港，马可波罗称为\"光明之城\"。',95,'宋','马可波罗游记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(140,'刺桐城','泉州古称刺桐，因遍植刺桐树而得名，宋元时期繁华无比。',95,'宋','泉州府志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(141,'三顾茅庐','刘备三顾茅庐请诸葛亮出山，发生地在南阳卧龙岗。',111,'三国','三国志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(142,'躬耕南阳','诸葛亮《出师表》\"臣本布衣，躬耕于南阳\"，表明其隐居之地。',111,'三国','出师表','2026-03-18 19:06:00','2026-03-18 19:06:00'),(143,'曹操挟天子以令诸侯','曹操迎汉献帝至许昌，以天子名义号令天下。',110,'三国','三国志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(144,'建安文学','曹操父子在许昌开创建安文学，形成慷慨悲凉的建安风骨。',110,'三国','建安七子集','2026-03-18 19:06:00','2026-03-18 19:06:00'),(145,'殷墟甲骨','安阳殷墟出土大量甲骨文，是中国最早的成熟文字系统。',109,'商','殷墟发掘报告','2026-03-18 19:06:00','2026-03-18 19:06:00'),(146,'妇好墓','殷墟妇好墓是中国考古史上重大发现，妇好是中国第一位女将军。',109,'商','殷墟发掘报告','2026-03-18 19:06:00','2026-03-18 19:06:00'),(147,'云冈石窟','云冈石窟为北魏时期开凿，是中国四大石窟之一，艺术价值极高。',124,'北魏','云冈石窟志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(148,'北魏都城','北魏孝文帝迁都洛阳前，大同（平城）为北魏都城近百年。',124,'北魏','魏书','2026-03-18 19:06:00','2026-03-18 19:06:00'),(149,'伏羲画卦','天水为伏羲故里，相传伏羲在此画八卦，开创中华文明。',152,'上古','周易','2026-03-18 19:06:00','2026-03-18 19:06:00'),(150,'麦积山石窟','麦积山石窟为中国四大石窟之一，以泥塑艺术著称。',152,'后秦','麦积山志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(151,'火焰山','《西游记》中火焰山原型，吐鲁番夏季酷热，有\"火洲\"之称。',178,'唐','西游记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(152,'高昌古城','高昌古城为西域重镇，玄奘西行曾在此讲经。',178,'唐','大唐西域记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(153,'丝绸之路重镇','喀什为古丝绸之路重镇，东西方文化交汇之地。',185,'汉','汉书·西域传','2026-03-18 19:06:00','2026-03-18 19:06:00'),(154,'香妃墓','喀什香妃墓为乾隆帝香妃之墓，建筑风格独特。',185,'清','西域图志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(155,'盛京故宫','沈阳故宫为清朝入关前的皇宫，是中国现存两大皇宫之一。',191,'清','清史稿','2026-03-18 19:06:00','2026-03-18 19:06:00'),(156,'努尔哈赤迁都','努尔哈赤迁都沈阳，奠定了清朝基业。',191,'清','清史稿','2026-03-18 19:06:00','2026-03-18 19:06:00'),(157,'冰城','哈尔滨冬季冰雪大世界闻名遐迩，有\"冰城\"之称。',214,'现代','哈尔滨志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(158,'东方莫斯科','哈尔滨建筑风格独特，有\"东方莫斯科\"之称。',214,'现代','哈尔滨志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(159,'遵义会议','1935年遵义会议确立了毛泽东的领导地位，是中国革命转折点。',229,'现代','中共党史','2026-03-18 19:06:00','2026-03-18 19:06:00'),(160,'茅台酒乡','遵义仁怀茅台镇为中国国酒茅台产地。',229,'清','遵义府志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(161,'黄果树瀑布','黄果树瀑布为中国第一大瀑布，徐霞客曾赞叹其壮观。',230,'明','徐霞客游记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(162,'龙宫','安顺龙宫为溶洞奇观，有\"天下第一洞\"之称。',230,'明','安顺府志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(163,'梵净山','梵净山为弥勒道场，是中国五大佛教名山之一。',232,'明','梵净山志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(164,'三峡门户','宜昌为长江三峡门户，三峡大坝所在地。',100,'现代','宜昌志','2026-03-18 19:06:00','2026-03-18 19:06:00'),(165,'屈原故里','宜昌秭归为爱国诗人屈原故里，端午文化发源地。',100,'战国','史记','2026-03-18 19:06:00','2026-03-18 19:06:00'),(166,'东坡赤壁','苏轼贬谪黄州（今黄冈），创作《赤壁赋》《念奴娇·赤壁怀古》等名篇。',108,'宋','东坡全集','2026-03-18 19:06:00','2026-03-18 19:06:00'),(167,'文赤壁','黄冈赤壁因苏轼作品而闻名，与三国赤壁（武赤壁）相区别。',108,'宋','东坡全集','2026-03-18 19:06:00','2026-03-18 19:06:00');
/*!40000 ALTER TABLE `allusions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dynasty` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'李白','唐','/files/images/author/libai.jpg','李白，字太白，号青莲居士，被誉为诗仙。其诗豪放飘逸，想象丰富。','2026-02-14 00:33:41'),(2,'杜甫','唐','/files/images/author/dufu.jpg','杜甫，字子美，被誉为诗圣，其诗多反映社会现实。','2026-02-14 00:33:41'),(3,'白居易','唐','/files/images/author/baijuyi.jpg','白居易，字乐天，号香山居士，诗风通俗易懂。','2026-02-14 00:33:41');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creation_comment`
--

DROP TABLE IF EXISTS `creation_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creation_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `parent_id` bigint DEFAULT NULL COMMENT '父评论ID，用于回复',
  `like_count` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_work_id` (`work_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='作品评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creation_comment`
--

LOCK TABLES `creation_comment` WRITE;
/*!40000 ALTER TABLE `creation_comment` DISABLE KEYS */;
INSERT INTO `creation_comment` VALUES (7,3,2,'123123',NULL,0,'2026-03-08 22:23:29'),(8,1,2,'111',NULL,0,'2026-03-08 22:23:34'),(9,5,2,'123',NULL,0,'2026-03-08 22:23:51'),(10,3,2,'123123123',NULL,0,'2026-03-10 22:07:58'),(11,1,2,'123123',NULL,0,'2026-03-11 22:21:00'),(12,21,2,'1111',NULL,0,'2026-03-12 22:46:26'),(13,19,2,'111',NULL,0,'2026-03-13 16:36:08'),(14,21,2,'1111111111',NULL,0,'2026-03-14 00:05:57'),(15,23,2,'111111111111',NULL,0,'2026-03-14 00:07:19'),(16,21,1,'很好',NULL,0,'2026-03-14 01:08:36'),(17,29,2,'good',NULL,0,'2026-05-12 10:49:02'),(18,31,2,'good',NULL,0,'2026-05-12 16:06:34'),(19,33,2,'good',NULL,0,'2026-05-13 09:06:54');
/*!40000 ALTER TABLE `creation_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creation_mention`
--

DROP TABLE IF EXISTS `creation_mention`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creation_mention` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_id` bigint NOT NULL,
  `user_id` bigint NOT NULL COMMENT '被@的用户ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_work_user` (`work_id`,`user_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='作品@用户关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creation_mention`
--

LOCK TABLES `creation_mention` WRITE;
/*!40000 ALTER TABLE `creation_mention` DISABLE KEYS */;
/*!40000 ALTER TABLE `creation_mention` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creation_tag`
--

DROP TABLE IF EXISTS `creation_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creation_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名称',
  `use_count` int NOT NULL DEFAULT '0' COMMENT '使用次数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='创作标签表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creation_tag`
--

LOCK TABLES `creation_tag` WRITE;
/*!40000 ALTER TABLE `creation_tag` DISABLE KEYS */;
INSERT INTO `creation_tag` VALUES (1,'唐诗',19,'2026-03-08 21:04:01'),(2,'宋词',17,'2026-03-08 21:04:01'),(3,'元曲',12,'2026-03-08 21:04:01'),(4,'现代诗',21,'2026-03-08 21:04:01'),(5,'古风',18,'2026-03-08 21:04:01'),(6,'书法',10,'2026-03-08 21:04:01'),(7,'原创',25,'2026-03-08 21:04:01'),(8,'临摹',5,'2026-03-08 21:04:01');
/*!40000 ALTER TABLE `creation_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creation_work`
--

DROP TABLE IF EXISTS `creation_work`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creation_work` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '创作者ID',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创作类型: poem/ci/fu/couplet/modern/calligraphy',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '作品标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '作品正文',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创作说明',
  `images` json DEFAULT NULL COMMENT '配图URL数组',
  `audio_url` varchar(255) DEFAULT NULL COMMENT '音频文件地址',
  `video_url` varchar(255) DEFAULT NULL COMMENT '视频文件地址',
  `privacy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'public' COMMENT '隐私设置: public/friends/private',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞数',
  `comment_count` int NOT NULL DEFAULT '0' COMMENT '评论数',
  `save_count` int NOT NULL DEFAULT '0' COMMENT '收藏数',
  `view_count` int NOT NULL DEFAULT '0' COMMENT '浏览数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_created_at` (`created_at`) USING BTREE,
  KEY `idx_engagement` (`like_count`,`comment_count`,`save_count`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='创作作品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creation_work`
--

LOCK TABLES `creation_work` WRITE;
/*!40000 ALTER TABLE `creation_work` DISABLE KEYS */;
INSERT INTO `creation_work` VALUES (1,1,'poem','春江花月夜','春江潮水连海平，海上明月共潮生。\n滟滟随波千万里，何处春江无月明。','模仿张若虚的名篇，尝试描绘春江月夜的意境',NULL,NULL,NULL,'public',129,47,33,894,'2026-03-05 10:30:00','2026-03-11 22:21:03'),(2,1,'ci','水调歌头·明月几时有','明月几时有？把酒问青天。\n不知天上宫阙，今夕是何年。','中秋佳节有感而发',NULL,NULL,NULL,'public',96,32,28,655,'2026-03-03 14:20:00','2026-05-12 16:06:19'),(3,1,'modern','致橡树','我如果爱你，\n绝不像攀援的凌霄花，\n借你的高枝炫耀自己。','表达独立平等的爱情观',NULL,NULL,NULL,'public',204,69,56,1253,'2026-03-01 09:15:00','2026-03-13 16:31:34'),(4,1,'couplet','春联一副','上联：春回大地千山秀\n下联：日照神州万木荣\n横批：春意盎然','为新春佳节创作',NULL,NULL,NULL,'public',54,18,15,432,'2026-02-28 16:45:00','2026-03-08 21:04:01'),(5,2,'poem','1','1','','[\"data:image/jpeg;base64,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\"]',NULL,NULL,'public',1,1,1,4,'2026-03-08 21:36:50','2026-03-08 22:23:53'),(6,2,'couplet','123123','123123123','123123123','[\"/uploads/478c82ad59ee4de99dbb531cebe7be8f.jpg\"]',NULL,NULL,'private',0,0,0,1,'2026-03-10 21:34:14','2026-03-10 21:34:40'),(8,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:32','2026-03-12 22:45:32'),(9,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:34','2026-03-12 22:45:34'),(10,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:35','2026-03-12 22:45:35'),(11,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:36','2026-03-12 22:45:36'),(12,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:37','2026-03-12 22:45:37'),(13,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:37','2026-03-12 22:45:37'),(14,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:38','2026-03-12 22:45:38'),(15,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:38','2026-03-12 22:45:38'),(16,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:38','2026-03-12 22:45:38'),(17,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:38','2026-03-12 22:45:38'),(18,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:38','2026-03-12 22:45:38'),(19,2,'ci','','1111','',NULL,NULL,NULL,'public',1,1,0,1,'2026-03-12 22:45:38','2026-03-13 16:36:08'),(20,2,'ci','','1111','',NULL,NULL,NULL,'public',0,0,0,0,'2026-03-12 22:45:38','2026-03-12 22:45:38'),(21,2,'ci','','1111','',NULL,NULL,NULL,'public',2,3,1,5,'2026-03-12 22:45:39','2026-03-14 01:08:36'),(22,2,'poem','','111222','',NULL,NULL,NULL,'public',1,0,0,1,'2026-03-12 22:46:07','2026-05-12 10:49:14'),(23,2,'poem','111','1111','1111',NULL,NULL,NULL,'public',1,1,0,2,'2026-03-14 00:06:38','2026-04-09 09:29:05'),(29,2,'fu','111','111','111','[\"/uploads/images/2026/05/12/e8de52b1-35c0-4398-b2a8-54612725ebc5.png\"]',NULL,NULL,'public',1,1,0,2,'2026-05-12 10:48:38','2026-05-12 10:49:12'),(31,2,'poem','111','1111','','[\"/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg\"]','/uploads/audio/be120114-4972-44ce-96be-405143001d80.mp3','/uploads/video/acd2b32c-d914-459a-b5b3-db762bf20e67.mp4','public',1,1,1,16,'2026-05-12 15:59:25','2026-05-13 08:43:38');
/*!40000 ALTER TABLE `creation_work` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creation_work_tag`
--

DROP TABLE IF EXISTS `creation_work_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creation_work_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_work_tag` (`work_id`,`tag_id`) USING BTREE,
  KEY `idx_work_id` (`work_id`) USING BTREE,
  KEY `idx_tag_id` (`tag_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='作品标签关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creation_work_tag`
--

LOCK TABLES `creation_work_tag` WRITE;
/*!40000 ALTER TABLE `creation_work_tag` DISABLE KEYS */;
INSERT INTO `creation_work_tag` VALUES (1,6,3,'2026-03-10 21:34:14'),(2,7,3,'2026-03-10 22:08:40'),(3,7,4,'2026-03-10 22:08:40'),(4,23,1,'2026-03-14 00:06:38'),(9,29,2,'2026-05-12 10:48:38'),(10,29,1,'2026-05-12 10:48:38'),(11,31,3,'2026-05-12 15:59:25'),(12,31,2,'2026-05-12 15:59:25'),(13,32,2,'2026-05-13 08:59:42'),(14,32,3,'2026-05-13 08:59:42'),(15,33,2,'2026-05-13 09:06:40'),(16,33,1,'2026-05-13 09:06:40'),(17,34,2,'2026-05-13 09:25:48'),(18,34,1,'2026-05-13 09:25:48');
/*!40000 ALTER TABLE `creation_work_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ff_game_answer`
--

DROP TABLE IF EXISTS `ff_game_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ff_game_answer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '答题记录ID',
  `session_id` bigint NOT NULL COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `topic_id` bigint NOT NULL COMMENT '主题ID',
  `keyword` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关键字',
  `user_sentence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户输入诗句',
  `user_sentence_clean` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '清洗后的用户输入',
  `matched_sentence_id` bigint DEFAULT NULL COMMENT '命中的诗句ID',
  `is_correct` tinyint NOT NULL COMMENT '是否正确 1是0否',
  `score_award` int DEFAULT '0' COMMENT '本次得分',
  `hint_used` tinyint DEFAULT '0' COMMENT '是否使用提示',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_session_id` (`session_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_topic_id` (`topic_id`) USING BTREE,
  KEY `idx_keyword` (`keyword`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='飞花令答题记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ff_game_answer`
--

LOCK TABLES `ff_game_answer` WRITE;
/*!40000 ALTER TABLE `ff_game_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `ff_game_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ff_game_session`
--

DROP TABLE IF EXISTS `ff_game_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ff_game_session` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `current_topic_id` bigint NOT NULL COMMENT '当前主题ID',
  `current_keyword` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '当前关键字',
  `score` int DEFAULT '0' COMMENT '本局得分',
  `correct_count` int DEFAULT '0' COMMENT '答对次数',
  `wrong_count` int DEFAULT '0' COMMENT '答错次数',
  `skip_count` int DEFAULT '0' COMMENT '跳过次数',
  `status` tinyint DEFAULT '1' COMMENT '1进行中 2已结束',
  `started_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `ended_at` datetime DEFAULT NULL COMMENT '结束时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_topic_id` (`current_topic_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=373 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='飞花令游戏会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ff_game_session`
--

LOCK TABLES `ff_game_session` WRITE;
/*!40000 ALTER TABLE `ff_game_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `ff_game_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ff_sentence`
--

DROP TABLE IF EXISTS `ff_sentence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ff_sentence` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '诗句ID',
  `keyword` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属关键字，如花、月、山',
  `sentence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '完整诗句',
  `sentence_clean` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '去标点后诗句，用于校验',
  `poem_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '诗题',
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '作者',
  `dynasty` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '朝代',
  `source_text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '原文片段/上下文',
  `difficulty` int DEFAULT '1' COMMENT '难度 1-5',
  `is_active` tinyint DEFAULT '1' COMMENT '1有效 0无效',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_keyword` (`keyword`) USING BTREE,
  KEY `idx_sentence_clean` (`sentence_clean`) USING BTREE,
  KEY `idx_author` (`author`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='飞花令真实诗句库';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ff_sentence`
--

LOCK TABLES `ff_sentence` WRITE;
/*!40000 ALTER TABLE `ff_sentence` DISABLE KEYS */;
/*!40000 ALTER TABLE `ff_sentence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ff_topic`
--

DROP TABLE IF EXISTS `ff_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ff_topic` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主题ID',
  `keyword` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '飞花令关键字，如花、山、风、春',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主题标题',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主题封面图',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主题描述',
  `sort_num` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '1启用 0停用',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `keyword` (`keyword`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='飞花令主题表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ff_topic`
--

LOCK TABLES `ff_topic` WRITE;
/*!40000 ALTER TABLE `ff_topic` DISABLE KEYS */;
/*!40000 ALTER TABLE `ff_topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_comment`
--

DROP TABLE IF EXISTS `forum_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `parent_id` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_comment`
--

LOCK TABLES `forum_comment` WRITE;
/*!40000 ALTER TABLE `forum_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_post`
--

DROP TABLE IF EXISTS `forum_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_post` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `season_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `images` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_post`
--

LOCK TABLES `forum_post` WRITE;
/*!40000 ALTER TABLE `forum_post` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_entry`
--

DROP TABLE IF EXISTS `game_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_entry` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `weekly_no` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `sort_no` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_game_week` (`weekly_no`,`sort_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_entry`
--

LOCK TABLES `game_entry` WRITE;
/*!40000 ALTER TABLE `game_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_options`
--

DROP TABLE IF EXISTS `game_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_options` (
  `option_id` int NOT NULL AUTO_INCREMENT,
  `moment_id` int NOT NULL,
  `poet_id` int NOT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`option_id`),
  KEY `moment_id` (`moment_id`),
  KEY `poet_id` (`poet_id`),
  CONSTRAINT `game_options_ibfk_1` FOREIGN KEY (`moment_id`) REFERENCES `poet_moments` (`moment_id`),
  CONSTRAINT `game_options_ibfk_2` FOREIGN KEY (`poet_id`) REFERENCES `poet_info` (`poet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_options`
--

LOCK TABLES `game_options` WRITE;
/*!40000 ALTER TABLE `game_options` DISABLE KEYS */;
INSERT INTO `game_options` VALUES (1,1,1,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(2,1,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(3,1,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(4,1,4,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(5,2,1,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(6,2,5,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(7,2,6,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(8,2,7,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(9,3,1,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(10,3,8,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(11,3,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(12,3,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(13,4,2,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(14,4,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(15,4,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(16,4,4,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(17,5,2,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(18,5,5,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(19,5,6,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(20,5,7,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(21,6,2,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(22,6,8,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(23,6,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(24,6,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(25,7,3,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(26,7,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(27,7,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(28,7,4,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(29,8,3,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(30,8,5,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(31,8,6,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(32,8,7,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(33,9,3,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(34,9,8,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(35,9,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(36,9,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(37,10,4,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(38,10,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(39,10,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(40,10,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(41,11,4,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(42,11,5,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(43,11,6,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(44,11,7,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(45,12,4,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(46,12,8,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(47,12,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(48,12,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(49,13,5,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(50,13,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(51,13,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(52,13,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(53,14,5,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(54,14,4,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(55,14,6,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(56,14,7,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(57,15,5,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(58,15,8,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(59,15,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(60,15,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(61,16,6,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(62,16,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(63,16,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(64,16,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(65,17,6,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(66,17,4,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(67,17,5,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(68,17,7,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(69,18,6,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(70,18,8,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(71,18,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(72,18,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(73,19,7,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(74,19,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(75,19,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(76,19,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(77,20,7,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(78,20,4,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(79,20,5,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(80,20,6,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(81,21,7,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(82,21,8,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(83,21,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(84,21,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(85,22,8,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(86,22,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(87,22,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(88,22,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(89,23,8,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(90,23,4,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(91,23,5,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(92,23,6,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(93,24,8,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(94,24,7,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(95,24,9,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(96,24,10,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(97,25,9,1,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(98,25,1,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(99,25,2,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(100,25,3,0,'2026-04-04 16:49:47','2026-04-04 16:49:47'),(101,26,9,1,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(102,26,4,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(103,26,5,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(104,26,6,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(105,27,9,1,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(106,27,7,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(107,27,8,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(108,27,10,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(109,28,10,1,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(110,28,1,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(111,28,2,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(112,28,3,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(113,29,10,1,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(114,29,4,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(115,29,5,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(116,29,6,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(117,30,10,1,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(118,30,7,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(119,30,8,0,'2026-04-04 16:49:48','2026-04-04 16:49:48'),(120,30,9,0,'2026-04-04 16:49:48','2026-04-04 16:49:48');
/*!40000 ALTER TABLE `game_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poem_match_fragment`
--

DROP TABLE IF EXISTS `game_poem_match_fragment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poem_match_fragment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_id` bigint NOT NULL COMMENT '所属诗句组ID',
  `fragment_text` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '片段文字',
  `fragment_order` int NOT NULL DEFAULT '1' COMMENT '片段顺序 1/2/3',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用 0停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_group_id` (`group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='诗词消消乐片段表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poem_match_fragment`
--

LOCK TABLES `game_poem_match_fragment` WRITE;
/*!40000 ALTER TABLE `game_poem_match_fragment` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_poem_match_fragment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poem_match_group`
--

DROP TABLE IF EXISTS `game_poem_match_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poem_match_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `level_id` bigint NOT NULL COMMENT '所属关卡ID',
  `poem_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '诗题',
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '作者',
  `dynasty` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '朝代',
  `group_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '同一首诗的分组编码',
  `full_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '整句原文',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用 0停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_level_id` (`level_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='诗词消消乐诗句组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poem_match_group`
--

LOCK TABLES `game_poem_match_group` WRITE;
/*!40000 ALTER TABLE `game_poem_match_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_poem_match_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poem_match_level`
--

DROP TABLE IF EXISTS `game_poem_match_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poem_match_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关卡标题',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关卡说明',
  `time_limit_sec` int NOT NULL DEFAULT '480' COMMENT '限时秒数，默认8分钟',
  `slot_limit` int NOT NULL DEFAULT '6' COMMENT '槽位数量',
  `poem_count` int NOT NULL DEFAULT '20' COMMENT '诗句数量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用 0停用',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='诗词消消乐关卡表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poem_match_level`
--

LOCK TABLES `game_poem_match_level` WRITE;
/*!40000 ALTER TABLE `game_poem_match_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_poem_match_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poem_match_record`
--

DROP TABLE IF EXISTS `game_poem_match_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poem_match_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `level_id` bigint NOT NULL COMMENT '关卡ID',
  `score` int NOT NULL DEFAULT '0' COMMENT '得分',
  `matched_count` int NOT NULL DEFAULT '0' COMMENT '成功配对诗句数',
  `is_passed` tinyint NOT NULL DEFAULT '0' COMMENT '是否通关 1是0否',
  `used_seconds` int NOT NULL DEFAULT '0' COMMENT '用时秒数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_level_id` (`level_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='诗词消消乐对局记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poem_match_record`
--

LOCK TABLES `game_poem_match_record` WRITE;
/*!40000 ALTER TABLE `game_poem_match_record` DISABLE KEYS */;
INSERT INTO `game_poem_match_record` VALUES (95,2,1,0,0,0,0,'2026-04-14 17:17:01'),(96,2,1,0,0,0,0,'2026-04-14 17:34:45'),(97,2,1,0,0,0,0,'2026-04-14 20:22:45'),(98,2,1,0,0,0,0,'2026-04-14 22:20:09');
/*!40000 ALTER TABLE `game_poem_match_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poem_maze_level`
--

DROP TABLE IF EXISTS `game_poem_maze_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poem_maze_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `season_no` int NOT NULL DEFAULT '1' COMMENT '赛季',
  `level_no` int NOT NULL DEFAULT '1' COMMENT '关卡号',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关卡名称',
  `poem_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '诗名',
  `poem_author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '作者',
  `size_n` int NOT NULL DEFAULT '8' COMMENT '迷宫尺寸',
  `grid_json` json NOT NULL COMMENT '整个字阵',
  `lines_json` json NOT NULL COMMENT '本关所有诗句',
  `paths_json` json NOT NULL COMMENT '每句对应路径',
  `difficulty` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'easy' COMMENT '难度',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态',
  `sort_no` int NOT NULL DEFAULT '1' COMMENT '排序',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_level` (`season_no`,`level_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='迷宫关卡表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poem_maze_level`
--

LOCK TABLES `game_poem_maze_level` WRITE;
/*!40000 ALTER TABLE `game_poem_maze_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_poem_maze_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poem_maze_record`
--

DROP TABLE IF EXISTS `game_poem_maze_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poem_maze_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `season_no` int NOT NULL,
  `level_no` int NOT NULL,
  `total_score` int NOT NULL DEFAULT '0' COMMENT '总分（句数）',
  `pass_count` int NOT NULL DEFAULT '0' COMMENT '完成句数',
  `error_count` int NOT NULL DEFAULT '0' COMMENT '错误次数',
  `duration_ms` bigint NOT NULL DEFAULT '0' COMMENT '耗时',
  `is_pass` tinyint NOT NULL DEFAULT '0' COMMENT '是否通关',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_rank` (`season_no`,`level_no`,`total_score`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='迷宫记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poem_maze_record`
--

LOCK TABLES `game_poem_maze_record` WRITE;
/*!40000 ALTER TABLE `game_poem_maze_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_poem_maze_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poet_profile`
--

DROP TABLE IF EXISTS `game_poet_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poet_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `dynasty` varchar(32) DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `persona_title` varchar(128) DEFAULT NULL,
  `persona_desc` text,
  `representative_works` varchar(255) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `sort_no` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status_sort` (`status`,`sort_no`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poet_profile`
--

LOCK TABLES `game_poet_profile` WRITE;
/*!40000 ALTER TABLE `game_poet_profile` DISABLE KEYS */;
INSERT INTO `game_poet_profile` VALUES (9001,'李白','唐',NULL,'浪漫自由派','根据数据分析:你的直觉与想象力超群，情绪如同江水般澎湃，来得快去得也快。热爱绝对的自由与冒险，表达方式外放且富有感染力，总能从平凡的日常中挖掘出璀璨的闪光点。你天生带有一种不羁的浪漫感，生活在你的笔下从不平淡，是那个永远追逐星辰大海的梦想家。','《将进酒》,《静夜思》','豪放,自由,浪漫',1,10,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9002,'杜甫','唐',NULL,'现实关怀派','根据数据分析:你具有极其重视社会责任与真实感，是那种在困境中也能默默扛起重担的人。你有着极其敏锐的观察力，能够捕捉到社会最细微的脉动，并愿意倾尽全力照顾他人。你的表达克制、严谨而厚重，每一句话都饱含着对家国情怀的深沉关切，在喧嚣中守望着良知。','《春望》,《茅屋为秋风所破歌》','沉稳,责任,现实',1,20,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9003,'苏轼','宋',NULL,'豁达智慧派','根据数据分析:你拥有卓越的自我调节能力，深谙“此心安处是吾乡”的智慧。你善于转换视角看待世界，能将人生的坎坷与困境化作绝美的风景。通透、幽默且极具生活情趣，你不仅是精神上的导师，更是生活中的达人，无论身处何地都能活出自我，展现出一种超越时空的豁达。','《念奴娇·赤壁怀古》,《定风波》','豁达,通透,幽默',1,30,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9004,'李清照','宋',NULL,'细腻感知派','根据数据分析:你的情绪分辨率极高，心思细腻且敏锐，对世界的感知带有某种天生的含蓄美。你极度珍视记忆与情感体验，拥有极强的审美直觉，表达方式委婉却余韵悠长。你擅长在细节中捕捉转瞬即逝的美，即便在离愁别绪中，也能品味出生命的层次感。','《声声慢》,《如梦令》','细腻,敏感,审美',1,40,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9005,'王维','唐',NULL,'空灵静观派','根据数据分析:你更偏爱安静与适度的留白，喜欢在自然的山水与内心的宁静中寻找力量。你感知敏锐，行动节奏不急不躁，倾向于在静谧处沉淀自我。你追求一种“禅意”的生活方式，将复杂的人生简化为纯粹的观照，即便在喧嚣的尘世中，内心也拥有一片永不凋零的桃源。','《山居秋暝》,《鹿柴》','清寂,自然,禅意',1,50,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9006,'白居易','唐',NULL,'平易共情派','根据数据分析:你的表达清晰且直白，拥有极强的同理心与讲故事的天赋。你从不故作高深，而是坚持用最平实的文字记录普通人的喜怒哀乐。你关注社会民生，带着一种温柔而坚定的责任感，你的文字就像冬日里的一盆炭火，温暖着每一个平凡的灵魂。','《琵琶行》,《卖炭翁》','叙事,共情,直白',1,60,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9007,'辛弃疾','宋',NULL,'热血担当派','根据数据分析:你拥有极强的行动力与明确的目标感，面对困难和挑战时，你更倾向于正面迎击而非退缩。外表豪迈狂放，内心却细腻深情，既有战场上的杀伐果断，也有对理想的至死不渝。你是一团永不熄灭的火焰，无论身处何种境地，都始终保持着高昂的战斗意志与英雄气概。','《破阵子》,《青玉案·元夕》','豪情,担当,战意',1,70,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9008,'陶渊明','晋',NULL,'淡泊田园派','根据数据分析:你拒绝内耗，崇尚简单而纯粹的生活节奏。你极度重视内心的自由与平和，不愿在名利场中迷失自我。你向往一种松弛且自洽的状态，将自我与自然完美融合，在晨兴理荒秽、带月荷锄归的劳作中，找到了生命最本真的意义。','《归园田居》,《饮酒》','淡泊,松弛,田园',1,80,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9009,'柳永','宋',NULL,'市井风月派','根据数据分析:你的情感表达浓郁而外露，深谙人情世故与都市的情绪脉络。你爱繁华的热闹，也懂深夜的落寞，擅长将最私密的个人情感转化为极具代入感的文字。你笔下的离愁别绪总能触动人心最柔软的地方，是那个游走在市井烟火与儿女情长之间的性情中人。','《雨霖铃》,《八声甘州》','情绪,都市,代入',1,90,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9010,'王昌龄','唐',NULL,'边塞豪气派','根据数据分析:你充满挑战精神，对边界感与正义感有着极高的要求。你讲义气、重承诺，气质利落洒脱，从不拖泥带水。你对胜负、荣誉以及集体的责任感比较在意，在快节奏的竞争中总能保持冷静与决断，是一位天生的统帅与值得信赖的伙伴。','《出塞》,《从军行》','边塞,豪气,义气',1,100,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9011,'纳兰性德','清',NULL,'深情自省派','根据数据分析:你性情温柔且极度敏感，容易沉浸在过往的回忆中自我反刍。你的情感深邃而不张扬，更在意灵魂深处的契合与理解，而非表面的热闹与虚华。你带有一种天然的忧郁气质，对美好的事物消逝有着极强的哀悼感，是那个在深秋月下独自品味孤独的守望者。','《木兰词》,《长相思》','深情,自省,怀旧',1,110,'2026-03-31 22:39:17','2026-04-02 10:03:44'),(9012,'屈原','楚',NULL,'理想执着派','根据数据分析:你的价值感极强，拥有宁折不弯的骨气与理想主义。一旦认定了某种信念，你便会不计代价地坚持到底，绝不妥协。你极度在意生命的意义与信仰的纯粹，内心极其容易被理想点燃，也容易因现实的残酷而感到剧痛，你用生命谱写了一曲悲壮的忠诚赞歌。','《离骚》,《九歌》','理想,执着,信念',1,120,'2026-03-31 22:39:17','2026-04-02 10:03:44');
/*!40000 ALTER TABLE `game_poet_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poet_quiz`
--

DROP TABLE IF EXISTS `game_poet_quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poet_quiz` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `title` varchar(128) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `cover_url` varchar(255) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `sort_no` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_status_sort` (`status`,`sort_no`)
) ENGINE=InnoDB AUTO_INCREMENT=9101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poet_quiz`
--

LOCK TABLES `game_poet_quiz` WRITE;
/*!40000 ALTER TABLE `game_poet_quiz` DISABLE KEYS */;
INSERT INTO `game_poet_quiz` VALUES (9100,'poet_persona_v1','测一测:你的性格最像哪位诗人的性格？','20道题更稳定地匹配你的诗人气质画像。',NULL,1,10,'2026-03-31 22:39:17','2026-04-02 19:39:26');
/*!40000 ALTER TABLE `game_poet_quiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poet_quiz_answer`
--

DROP TABLE IF EXISTS `game_poet_quiz_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poet_quiz_answer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `attempt_id` bigint NOT NULL,
  `question_id` bigint NOT NULL,
  `option_id` bigint NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attempt_question` (`attempt_id`,`question_id`),
  KEY `idx_attempt` (`attempt_id`)
) ENGINE=InnoDB AUTO_INCREMENT=531 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poet_quiz_answer`
--

LOCK TABLES `game_poet_quiz_answer` WRITE;
/*!40000 ALTER TABLE `game_poet_quiz_answer` DISABLE KEYS */;
INSERT INTO `game_poet_quiz_answer` VALUES (400,34,9201,93013,'2026-04-02 09:45:41'),(401,34,9202,93022,'2026-04-02 09:45:43'),(402,34,9203,93031,'2026-04-02 09:45:44'),(403,34,9204,93042,'2026-04-02 09:45:45'),(404,34,9205,93051,'2026-04-02 09:45:46'),(405,34,9206,93063,'2026-04-02 09:45:47'),(406,34,9207,93073,'2026-04-02 09:45:48'),(407,34,9208,93081,'2026-04-02 09:45:48'),(408,34,9209,93092,'2026-04-02 09:45:49'),(409,34,9210,93103,'2026-04-02 09:45:50'),(410,34,9211,93112,'2026-04-02 09:45:51'),(411,34,9212,93121,'2026-04-02 09:45:52'),(412,34,9213,93133,'2026-04-02 09:45:53'),(413,34,9214,93144,'2026-04-02 09:45:54'),(414,34,9215,93153,'2026-04-02 09:45:55'),(415,34,9216,93164,'2026-04-02 09:45:57'),(416,34,9217,93174,'2026-04-02 09:46:00'),(417,34,9218,93184,'2026-04-02 09:46:02'),(418,34,9219,93192,'2026-04-02 09:46:03'),(419,34,9220,93203,'2026-04-02 09:46:04'),(420,36,9201,93012,'2026-04-02 10:05:22'),(421,36,9202,93022,'2026-04-02 10:05:24'),(422,36,9203,93031,'2026-04-02 10:05:25'),(423,36,9204,93043,'2026-04-02 10:05:26'),(424,36,9205,93052,'2026-04-02 10:05:28'),(425,36,9206,93064,'2026-04-02 10:05:30'),(426,36,9207,93072,'2026-04-02 10:05:31'),(427,36,9208,93081,'2026-04-02 10:05:32'),(428,36,9209,93092,'2026-04-02 10:05:33'),(429,36,9210,93103,'2026-04-02 10:05:34'),(430,36,9211,93112,'2026-04-02 10:05:36'),(431,36,9212,93123,'2026-04-02 10:05:37'),(432,36,9213,93131,'2026-04-02 10:05:38'),(433,36,9214,93143,'2026-04-02 10:05:39'),(434,36,9215,93153,'2026-04-02 10:05:41'),(435,36,9216,93153,'2026-04-02 10:05:41'),(436,36,9217,93174,'2026-04-02 10:05:42'),(437,36,9218,93182,'2026-04-02 10:05:44'),(438,36,9219,93191,'2026-04-02 10:05:45'),(439,36,9220,93203,'2026-04-02 10:05:48'),(449,39,9201,93011,'2026-04-02 11:43:41'),(450,39,9202,93022,'2026-04-02 11:43:43'),(451,39,9204,93042,'2026-04-02 11:43:44'),(452,39,9205,93052,'2026-04-02 11:43:45'),(453,39,9206,93062,'2026-04-02 11:43:47'),(454,39,9208,93082,'2026-04-02 11:43:47'),(455,39,9210,93102,'2026-04-02 11:43:48'),(456,39,9212,93122,'2026-04-02 11:43:48'),(457,39,9213,93132,'2026-04-02 11:43:48'),(458,39,9214,93142,'2026-04-02 11:43:49'),(459,39,9216,93162,'2026-04-02 11:43:49'),(460,39,9218,93182,'2026-04-02 11:43:50'),(461,39,9219,93192,'2026-04-02 11:43:50'),(462,39,9220,93201,'2026-04-02 11:43:52'),(468,39,9203,93032,'2026-04-02 11:44:22'),(472,39,9207,93072,'2026-04-02 11:44:27'),(474,39,9209,93092,'2026-04-02 11:44:30'),(476,39,9211,93112,'2026-04-02 11:44:33'),(480,39,9215,93152,'2026-04-02 11:44:38'),(482,39,9217,93172,'2026-04-02 11:44:41'),(486,46,9201,93012,'2026-04-02 23:07:49'),(487,46,9202,93023,'2026-04-02 23:07:50'),(488,46,9203,93033,'2026-04-02 23:07:52'),(489,46,9204,93043,'2026-04-02 23:07:59'),(490,46,9205,93052,'2026-04-02 23:08:01'),(491,46,9206,93062,'2026-04-02 23:08:03'),(492,46,9207,93073,'2026-04-02 23:08:04'),(493,46,9208,93084,'2026-04-02 23:08:06'),(494,46,9209,93093,'2026-04-02 23:08:07'),(495,46,9210,93103,'2026-04-02 23:08:10'),(496,46,9211,93113,'2026-04-02 23:08:12'),(497,46,9212,93122,'2026-04-02 23:08:14'),(498,46,9213,93133,'2026-04-02 23:08:16'),(499,46,9214,93142,'2026-04-02 23:08:17'),(500,46,9215,93153,'2026-04-02 23:08:20'),(501,46,9216,93164,'2026-04-02 23:08:21'),(502,46,9217,93171,'2026-04-02 23:08:23'),(503,46,9218,93182,'2026-04-02 23:08:24'),(504,46,9219,93192,'2026-04-02 23:08:25'),(505,46,9220,93203,'2026-04-02 23:08:27'),(506,49,9201,93013,'2026-04-05 14:59:36'),(507,49,9202,93024,'2026-04-05 14:59:39'),(508,50,9201,93012,'2026-04-14 15:56:29'),(509,50,9202,93023,'2026-04-14 15:56:31'),(510,50,9203,93034,'2026-04-14 15:56:33'),(511,50,9204,93042,'2026-04-14 15:56:35'),(512,50,9205,93054,'2026-04-14 15:56:36'),(513,50,9206,93061,'2026-04-14 15:56:38'),(514,51,9201,93012,'2026-04-14 17:17:10'),(515,51,9202,93023,'2026-04-14 17:17:11'),(516,51,9203,93031,'2026-04-14 17:17:13'),(517,51,9204,93043,'2026-04-14 17:17:14'),(518,53,9201,93013,'2026-04-14 22:20:19'),(519,53,9202,93022,'2026-04-14 22:20:20'),(520,53,9203,93031,'2026-04-14 22:20:22'),(521,53,9204,93043,'2026-04-14 22:20:25'),(522,53,9205,93051,'2026-04-14 22:20:28'),(523,55,9201,93011,'2026-04-14 23:28:35'),(524,55,9202,93023,'2026-04-14 23:28:36'),(525,55,9203,93031,'2026-04-14 23:28:38'),(526,55,9204,93043,'2026-04-14 23:28:40'),(527,55,9205,93052,'2026-04-14 23:28:42'),(528,55,9206,93064,'2026-04-14 23:28:45'),(529,55,9207,93071,'2026-04-14 23:28:48'),(530,55,9208,93082,'2026-04-14 23:28:49');
/*!40000 ALTER TABLE `game_poet_quiz_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poet_quiz_attempt`
--

DROP TABLE IF EXISTS `game_poet_quiz_attempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poet_quiz_attempt` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `quiz_id` bigint NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'in_progress',
  `total_questions` int NOT NULL DEFAULT '0',
  `answered_count` int NOT NULL DEFAULT '0',
  `result_poet_id` bigint DEFAULT NULL,
  `result_score` int DEFAULT NULL,
  `result_scores_snapshot` text,
  `started_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`,`created_at`),
  KEY `idx_quiz` (`quiz_id`,`created_at`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poet_quiz_attempt`
--

LOCK TABLES `game_poet_quiz_attempt` WRITE;
/*!40000 ALTER TABLE `game_poet_quiz_attempt` DISABLE KEYS */;
INSERT INTO `game_poet_quiz_attempt` VALUES (1,2,9100,'ongoing',20,0,NULL,NULL,NULL,'2026-03-31 23:00:48',NULL,'2026-03-31 23:00:48','2026-03-31 23:00:48'),(34,2,9100,'finished',20,20,9003,9,'[{\"poetId\":9003,\"score\":9,\"name\":\"苏轼\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9001,\"score\":8,\"name\":\"李白\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9008,\"score\":8,\"name\":\"陶渊明\",\"dynasty\":\"晋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9002,\"score\":7,\"name\":\"杜甫\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9006,\"score\":7,\"name\":\"白居易\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9004,\"score\":5,\"name\":\"李清照\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9005,\"score\":5,\"name\":\"王维\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9011,\"score\":4,\"name\":\"纳兰性德\",\"dynasty\":\"清\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9007,\"score\":3,\"name\":\"辛弃疾\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9009,\"score\":3,\"name\":\"柳永\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9012,\"score\":1,\"name\":\"屈原\",\"dynasty\":\"楚\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9010,\"score\":0,\"name\":\"王昌龄\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null}]','2026-04-02 09:45:39','2026-04-02 09:46:04','2026-04-02 09:45:39','2026-04-02 09:46:04'),(35,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 09:50:06',NULL,'2026-04-02 09:50:06','2026-04-02 09:50:06'),(36,2,9100,'finished',20,20,9002,12,'[{\"poetId\":9002,\"score\":12,\"name\":\"杜甫\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9003,\"score\":10,\"name\":\"苏轼\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9001,\"score\":7,\"name\":\"李白\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9006,\"score\":7,\"name\":\"白居易\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9005,\"score\":6,\"name\":\"王维\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9008,\"score\":5,\"name\":\"陶渊明\",\"dynasty\":\"晋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9007,\"score\":4,\"name\":\"辛弃疾\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9004,\"score\":3,\"name\":\"李清照\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9011,\"score\":2,\"name\":\"纳兰性德\",\"dynasty\":\"清\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9012,\"score\":2,\"name\":\"屈原\",\"dynasty\":\"楚\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9009,\"score\":1,\"name\":\"柳永\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9010,\"score\":1,\"name\":\"王昌龄\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null}]','2026-04-02 10:05:18','2026-04-02 10:05:48','2026-04-02 10:05:18','2026-04-02 10:05:48'),(38,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 10:15:36',NULL,'2026-04-02 10:15:36','2026-04-02 10:15:36'),(39,2,9100,'finished',20,20,9002,32,'[{\"poetId\":9002,\"score\":32,\"name\":\"杜甫\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9006,\"score\":14,\"name\":\"白居易\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9001,\"score\":4,\"name\":\"李白\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9010,\"score\":4,\"name\":\"王昌龄\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9012,\"score\":4,\"name\":\"屈原\",\"dynasty\":\"楚\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9008,\"score\":1,\"name\":\"陶渊明\",\"dynasty\":\"晋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9009,\"score\":1,\"name\":\"柳永\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9003,\"score\":0,\"name\":\"苏轼\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9004,\"score\":0,\"name\":\"李清照\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9005,\"score\":0,\"name\":\"王维\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9007,\"score\":0,\"name\":\"辛弃疾\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9011,\"score\":0,\"name\":\"纳兰性德\",\"dynasty\":\"清\",\"avatarUrl\":null,\"poetName\":null}]','2026-04-02 11:43:36','2026-04-02 11:44:45','2026-04-02 11:43:36','2026-04-02 11:44:45'),(40,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 17:27:51',NULL,'2026-04-02 17:27:51','2026-04-02 17:27:51'),(41,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 17:28:08',NULL,'2026-04-02 17:28:08','2026-04-02 17:28:08'),(42,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 17:34:55',NULL,'2026-04-02 17:34:55','2026-04-02 17:34:55'),(43,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 17:38:59',NULL,'2026-04-02 17:38:59','2026-04-02 17:38:59'),(44,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 18:14:47',NULL,'2026-04-02 18:14:47','2026-04-02 18:14:47'),(45,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-02 19:39:41',NULL,'2026-04-02 19:39:41','2026-04-02 19:39:41'),(46,2,9100,'finished',20,20,9003,14,'[{\"poetId\":9003,\"score\":14,\"name\":\"苏轼\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9002,\"score\":12,\"name\":\"杜甫\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9006,\"score\":9,\"name\":\"白居易\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9005,\"score\":7,\"name\":\"王维\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9008,\"score\":6,\"name\":\"陶渊明\",\"dynasty\":\"晋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9004,\"score\":4,\"name\":\"李清照\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9010,\"score\":3,\"name\":\"王昌龄\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9001,\"score\":2,\"name\":\"李白\",\"dynasty\":\"唐\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9007,\"score\":2,\"name\":\"辛弃疾\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9011,\"score\":1,\"name\":\"纳兰性德\",\"dynasty\":\"清\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9009,\"score\":0,\"name\":\"柳永\",\"dynasty\":\"宋\",\"avatarUrl\":null,\"poetName\":null},{\"poetId\":9012,\"score\":0,\"name\":\"屈原\",\"dynasty\":\"楚\",\"avatarUrl\":null,\"poetName\":null}]','2026-04-02 23:07:45','2026-04-02 23:08:27','2026-04-02 23:07:45','2026-04-02 23:08:27'),(47,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-03 10:48:21',NULL,'2026-04-03 10:48:21','2026-04-03 10:48:21'),(48,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-05 14:57:05',NULL,'2026-04-05 14:57:05','2026-04-05 14:57:05'),(49,2,9100,'in_progress',20,2,NULL,NULL,NULL,'2026-04-05 14:59:31',NULL,'2026-04-05 14:59:31','2026-04-05 14:59:39'),(50,2,9100,'in_progress',20,6,NULL,NULL,NULL,'2026-04-14 15:56:24',NULL,'2026-04-14 15:56:24','2026-04-14 15:56:38'),(51,2,9100,'in_progress',20,4,NULL,NULL,NULL,'2026-04-14 17:17:07',NULL,'2026-04-14 17:17:07','2026-04-14 17:17:14'),(52,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-14 20:22:50',NULL,'2026-04-14 20:22:50','2026-04-14 20:22:50'),(53,2,9100,'in_progress',20,5,NULL,NULL,NULL,'2026-04-14 22:20:16',NULL,'2026-04-14 22:20:16','2026-04-14 22:20:28'),(54,2,9100,'in_progress',20,0,NULL,NULL,NULL,'2026-04-14 23:17:10',NULL,'2026-04-14 23:17:10','2026-04-14 23:17:10'),(55,2,9100,'in_progress',20,8,NULL,NULL,NULL,'2026-04-14 23:28:11',NULL,'2026-04-14 23:28:11','2026-04-14 23:28:49');
/*!40000 ALTER TABLE `game_poet_quiz_attempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poet_quiz_option`
--

DROP TABLE IF EXISTS `game_poet_quiz_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poet_quiz_option` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `question_id` bigint NOT NULL,
  `option_no` int NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_q_no` (`question_id`,`option_no`),
  KEY `idx_question` (`question_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=93205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poet_quiz_option`
--

LOCK TABLES `game_poet_quiz_option` WRITE;
/*!40000 ALTER TABLE `game_poet_quiz_option` DISABLE KEYS */;
INSERT INTO `game_poet_quiz_option` VALUES (93011,9201,1,'说走就走：散步/旅行/看夜色',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93012,9201,2,'把生活打理好：整理/读书/做饭',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93013,9201,3,'与人热闹：小聚/逛街/聊天',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93014,9201,4,'一个人安静：听歌/发呆/写东西',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93021,9202,1,'换个环境先让情绪流动起来',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93022,9202,2,'把问题拆开，按优先级解决',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93023,9202,3,'自我调侃，想办法让自己松下来',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93024,9202,4,'记录与消化，慢慢把情绪理顺',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93031,9203,1,'夸张热烈，越说越有劲',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93032,9203,2,'克制准确，把事实讲清楚',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93033,9203,3,'通透洒脱，带点机智与幽默',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93034,9203,4,'细节绵密，含蓄但有画面',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93041,9204,1,'一起冒险的热情与胆量',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93042,9204,2,'可靠与担当，说到做到',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93043,9204,3,'开阔与包容，能一起变通',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93044,9204,4,'理解与共情，能听懂沉默',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93051,9205,1,'自由：奔赴与江湖',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93052,9205,2,'责任：看见更大的世界与苦难',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93053,9205,3,'心境：走到哪里都能自得其乐',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93054,9205,4,'回忆：想起就泛起涟漪',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93061,9206,1,'壮阔景色与豪情瞬间',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93062,9206,2,'平凡人的坚韧与努力',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93063,9206,3,'生活小确幸与豁然开朗',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93064,9206,4,'细微之美：雨声/花影/旧信',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93071,9207,1,'当场表达态度，不吐不快',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93072,9207,2,'准备证据与逻辑，再出手',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93073,9207,3,'先稳住局面，找更聪明的解法',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93074,9207,4,'先护住重要的人与自己',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93081,9208,1,'快：灵感来了立刻出发',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93082,9208,2,'稳：按计划推进最踏实',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93083,9208,3,'松：留白给生活慢慢来',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93084,9208,4,'柔：随心而动情绪到了再说',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93091,9209,1,'高山与旷野：风很大也很爽',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93092,9209,2,'人间烟火：街巷与人声',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93093,9209,3,'江湖边塞：利落、干脆、带劲',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93094,9209,4,'林泉清寂：安静、空灵、有光',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93101,9210,1,'直来直往，先把话说开',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93102,9210,2,'把规则讲清楚，按规矩来',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93103,9210,3,'先缓和气氛，再找台阶',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93104,9210,4,'先退一步，回头再想怎么说',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93111,9211,1,'结交与经历：见人见事见世界',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93112,9211,2,'耕耘与积累：把一件事做扎实',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93113,9211,3,'品味与生活：吃喝读写都要好',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93114,9211,4,'独处与沉思：把自己理清楚',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93121,9212,1,'要自由：我想活得更像自己',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93122,9212,2,'要有用：能解决问题、能照顾人',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93123,9212,3,'要通透：不拧巴、能自洽',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93124,9212,4,'要深情：把爱与遗憾都记得',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93131,9213,1,'燃：热烈、冲动、容易上头',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93132,9213,2,'沉：稳重、克制、少说多做',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93133,9213,3,'淡：松弛、随缘、不太内耗',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93134,9213,4,'敏：细腻、心软、容易共情',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93141,9214,1,'“你很浪漫，也很敢。”',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93142,9214,2,'“你很靠谱，能扛事。”',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93143,9214,3,'“你很通透，挺有智慧。”',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93144,9214,4,'“你很细腻，懂得美。”',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93151,9215,1,'随性走：地图只是参考',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93152,9215,2,'深度走：每一步都做功课',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93153,9215,3,'慢慢走：走到哪算哪也很美',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93154,9215,4,'有故事走：为一个人或一段记忆',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93161,9216,1,'心动与热烈：爱就要大声',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93162,9216,2,'稳定与责任：一起把日子过好',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93163,9216,3,'相处舒服：不控制也不消耗',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93164,9216,4,'理解与共鸣：懂你比陪你更重要',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93171,9217,1,'出去走走：换风景就换心情',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93172,9217,2,'把问题写下来：一条条解决',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93173,9217,3,'喝杯酒/睡一觉：醒来再说',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93174,9217,4,'躲起来安静：先让自己缓过来',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93181,9218,1,'我更愿意打破：规则是用来挑战的',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93182,9218,2,'我更愿意遵守：边界让人安心',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93183,9218,3,'我更愿意变通：看情境更重要',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93184,9218,4,'我更愿意远离：别把自己卷进去',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93191,9219,1,'为了表达：把胸中之气吐出来',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93192,9219,2,'为了记录：把人间故事留下来',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93193,9219,3,'为了自洽：写着写着就想通了',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93194,9219,4,'为了怀念：把情绪与记忆封存',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93201,9220,1,'自由',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93202,9220,2,'担当',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93203,9220,3,'通透',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(93204,9220,4,'深情',1,'2026-03-31 22:39:17','2026-03-31 22:39:17');
/*!40000 ALTER TABLE `game_poet_quiz_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poet_quiz_option_score`
--

DROP TABLE IF EXISTS `game_poet_quiz_option_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poet_quiz_option_score` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `option_id` bigint NOT NULL,
  `poet_id` bigint NOT NULL,
  `score` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_option_poet` (`option_id`,`poet_id`),
  KEY `idx_option` (`option_id`),
  KEY `idx_poet` (`poet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poet_quiz_option_score`
--

LOCK TABLES `game_poet_quiz_option_score` WRITE;
/*!40000 ALTER TABLE `game_poet_quiz_option_score` DISABLE KEYS */;
INSERT INTO `game_poet_quiz_option_score` VALUES (1,93011,9001,2,'2026-03-31 22:39:18'),(2,93011,9010,1,'2026-03-31 22:39:18'),(3,93012,9002,2,'2026-03-31 22:39:18'),(4,93012,9006,1,'2026-03-31 22:39:18'),(5,93013,9009,2,'2026-03-31 22:39:18'),(6,93013,9003,1,'2026-03-31 22:39:18'),(7,93014,9004,2,'2026-03-31 22:39:18'),(8,93014,9011,1,'2026-03-31 22:39:18'),(9,93021,9001,2,'2026-03-31 22:39:18'),(10,93021,9007,1,'2026-03-31 22:39:18'),(11,93022,9002,2,'2026-03-31 22:39:18'),(12,93022,9012,1,'2026-03-31 22:39:18'),(13,93023,9003,2,'2026-03-31 22:39:18'),(14,93023,9008,1,'2026-03-31 22:39:18'),(15,93024,9004,2,'2026-03-31 22:39:18'),(16,93024,9011,1,'2026-03-31 22:39:18'),(17,93031,9001,2,'2026-03-31 22:39:18'),(18,93031,9007,1,'2026-03-31 22:39:18'),(19,93032,9002,2,'2026-03-31 22:39:18'),(20,93032,9006,1,'2026-03-31 22:39:18'),(21,93033,9003,2,'2026-03-31 22:39:18'),(22,93033,9005,1,'2026-03-31 22:39:18'),(23,93034,9004,2,'2026-03-31 22:39:18'),(24,93034,9011,1,'2026-03-31 22:39:18'),(25,93041,9010,2,'2026-03-31 22:39:18'),(26,93041,9001,1,'2026-03-31 22:39:18'),(27,93042,9002,2,'2026-03-31 22:39:18'),(28,93042,9006,1,'2026-03-31 22:39:18'),(29,93043,9003,2,'2026-03-31 22:39:18'),(30,93043,9008,1,'2026-03-31 22:39:18'),(31,93044,9004,2,'2026-03-31 22:39:18'),(32,93044,9011,1,'2026-03-31 22:39:18'),(33,93051,9001,2,'2026-03-31 22:39:18'),(34,93051,9007,1,'2026-03-31 22:39:18'),(35,93052,9002,2,'2026-03-31 22:39:18'),(36,93052,9006,1,'2026-03-31 22:39:18'),(37,93053,9003,2,'2026-03-31 22:39:18'),(38,93053,9008,1,'2026-03-31 22:39:18'),(39,93054,9004,2,'2026-03-31 22:39:18'),(40,93054,9011,1,'2026-03-31 22:39:18'),(41,93061,9001,2,'2026-03-31 22:39:18'),(42,93061,9010,1,'2026-03-31 22:39:18'),(43,93062,9002,2,'2026-03-31 22:39:18'),(44,93062,9006,1,'2026-03-31 22:39:18'),(45,93063,9003,2,'2026-03-31 22:39:18'),(46,93063,9008,1,'2026-03-31 22:39:18'),(47,93064,9004,2,'2026-03-31 22:39:18'),(48,93064,9005,1,'2026-03-31 22:39:18'),(49,93071,9012,2,'2026-03-31 22:39:18'),(50,93071,9007,1,'2026-03-31 22:39:18'),(51,93072,9002,2,'2026-03-31 22:39:18'),(52,93072,9006,1,'2026-03-31 22:39:18'),(53,93073,9003,2,'2026-03-31 22:39:18'),(54,93073,9005,1,'2026-03-31 22:39:18'),(55,93074,9011,2,'2026-03-31 22:39:18'),(56,93074,9004,1,'2026-03-31 22:39:18'),(57,93081,9001,2,'2026-03-31 22:39:18'),(58,93081,9007,1,'2026-03-31 22:39:18'),(59,93082,9002,2,'2026-03-31 22:39:18'),(60,93082,9010,1,'2026-03-31 22:39:18'),(61,93083,9008,2,'2026-03-31 22:39:18'),(62,93083,9003,1,'2026-03-31 22:39:18'),(63,93084,9004,2,'2026-03-31 22:39:18'),(64,93084,9005,1,'2026-03-31 22:39:18'),(65,93091,9001,2,'2026-03-31 22:39:18'),(66,93091,9007,1,'2026-03-31 22:39:18'),(67,93092,9006,2,'2026-03-31 22:39:18'),(68,93092,9009,1,'2026-03-31 22:39:18'),(69,93093,9010,2,'2026-03-31 22:39:18'),(70,93093,9007,1,'2026-03-31 22:39:18'),(71,93094,9005,2,'2026-03-31 22:39:18'),(72,93094,9008,1,'2026-03-31 22:39:18'),(73,93101,9001,2,'2026-03-31 22:39:18'),(74,93101,9009,1,'2026-03-31 22:39:18'),(75,93102,9002,2,'2026-03-31 22:39:18'),(76,93102,9012,1,'2026-03-31 22:39:18'),(77,93103,9003,2,'2026-03-31 22:39:18'),(78,93103,9006,1,'2026-03-31 22:39:18'),(79,93104,9004,2,'2026-03-31 22:39:18'),(80,93104,9011,1,'2026-03-31 22:39:18'),(81,93111,9001,2,'2026-03-31 22:39:18'),(82,93111,9009,1,'2026-03-31 22:39:18'),(83,93112,9002,2,'2026-03-31 22:39:18'),(84,93112,9006,1,'2026-03-31 22:39:18'),(85,93113,9003,2,'2026-03-31 22:39:18'),(86,93113,9005,1,'2026-03-31 22:39:18'),(87,93114,9008,2,'2026-03-31 22:39:18'),(88,93114,9011,1,'2026-03-31 22:39:18'),(89,93121,9001,2,'2026-03-31 22:39:18'),(90,93121,9008,1,'2026-03-31 22:39:18'),(91,93122,9006,2,'2026-03-31 22:39:18'),(92,93122,9002,1,'2026-03-31 22:39:18'),(93,93123,9003,2,'2026-03-31 22:39:18'),(94,93123,9005,1,'2026-03-31 22:39:18'),(95,93124,9011,2,'2026-03-31 22:39:18'),(96,93124,9004,1,'2026-03-31 22:39:18'),(97,93131,9007,2,'2026-03-31 22:39:18'),(98,93131,9001,1,'2026-03-31 22:39:18'),(99,93132,9002,2,'2026-03-31 22:39:18'),(100,93132,9010,1,'2026-03-31 22:39:18'),(101,93133,9008,2,'2026-03-31 22:39:18'),(102,93133,9005,1,'2026-03-31 22:39:18'),(103,93134,9004,2,'2026-03-31 22:39:18'),(104,93134,9011,1,'2026-03-31 22:39:18'),(105,93141,9001,2,'2026-03-31 22:39:18'),(106,93141,9007,1,'2026-03-31 22:39:18'),(107,93142,9002,2,'2026-03-31 22:39:18'),(108,93142,9006,1,'2026-03-31 22:39:18'),(109,93143,9003,2,'2026-03-31 22:39:18'),(110,93143,9005,1,'2026-03-31 22:39:18'),(111,93144,9004,2,'2026-03-31 22:39:18'),(112,93144,9011,1,'2026-03-31 22:39:18'),(113,93151,9001,2,'2026-03-31 22:39:18'),(114,93151,9009,1,'2026-03-31 22:39:18'),(115,93152,9002,2,'2026-03-31 22:39:18'),(116,93152,9012,1,'2026-03-31 22:39:18'),(117,93153,9008,2,'2026-03-31 22:39:18'),(118,93153,9005,1,'2026-03-31 22:39:18'),(119,93154,9011,2,'2026-03-31 22:39:18'),(120,93154,9004,1,'2026-03-31 22:39:18'),(121,93161,9009,2,'2026-03-31 22:39:18'),(122,93161,9001,1,'2026-03-31 22:39:18'),(123,93162,9002,2,'2026-03-31 22:39:18'),(124,93162,9006,1,'2026-03-31 22:39:18'),(125,93163,9003,2,'2026-03-31 22:39:18'),(126,93163,9008,1,'2026-03-31 22:39:18'),(127,93164,9004,2,'2026-03-31 22:39:18'),(128,93164,9011,1,'2026-03-31 22:39:18'),(129,93171,9001,2,'2026-03-31 22:39:18'),(130,93171,9007,1,'2026-03-31 22:39:18'),(131,93172,9002,2,'2026-03-31 22:39:18'),(132,93172,9012,1,'2026-03-31 22:39:18'),(133,93173,9003,2,'2026-03-31 22:39:18'),(134,93173,9008,1,'2026-03-31 22:39:18'),(135,93174,9011,2,'2026-03-31 22:39:18'),(136,93174,9004,1,'2026-03-31 22:39:18'),(137,93181,9012,2,'2026-03-31 22:39:18'),(138,93181,9007,1,'2026-03-31 22:39:18'),(139,93182,9002,2,'2026-03-31 22:39:18'),(140,93182,9010,1,'2026-03-31 22:39:18'),(141,93183,9003,2,'2026-03-31 22:39:18'),(142,93183,9006,1,'2026-03-31 22:39:18'),(143,93184,9008,2,'2026-03-31 22:39:18'),(144,93184,9005,1,'2026-03-31 22:39:18'),(145,93191,9001,2,'2026-03-31 22:39:18'),(146,93191,9012,1,'2026-03-31 22:39:18'),(147,93192,9006,2,'2026-03-31 22:39:18'),(148,93192,9002,1,'2026-03-31 22:39:18'),(149,93193,9003,2,'2026-03-31 22:39:18'),(150,93193,9008,1,'2026-03-31 22:39:18'),(151,93194,9011,2,'2026-03-31 22:39:18'),(152,93194,9004,1,'2026-03-31 22:39:18'),(153,93201,9001,2,'2026-03-31 22:39:18'),(154,93201,9008,1,'2026-03-31 22:39:18'),(155,93202,9002,2,'2026-03-31 22:39:18'),(156,93202,9007,1,'2026-03-31 22:39:18'),(157,93203,9003,2,'2026-03-31 22:39:18'),(158,93203,9005,1,'2026-03-31 22:39:18'),(159,93204,9011,2,'2026-03-31 22:39:18'),(160,93204,9004,1,'2026-03-31 22:39:18');
/*!40000 ALTER TABLE `game_poet_quiz_option_score` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_poet_quiz_question`
--

DROP TABLE IF EXISTS `game_poet_quiz_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_poet_quiz_question` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quiz_id` bigint NOT NULL,
  `question_no` int NOT NULL,
  `question_text` varchar(512) NOT NULL,
  `question_type` varchar(16) NOT NULL DEFAULT 'single',
  `status` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_quiz_no` (`quiz_id`,`question_no`),
  KEY `idx_quiz` (`quiz_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=9221 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_poet_quiz_question`
--

LOCK TABLES `game_poet_quiz_question` WRITE;
/*!40000 ALTER TABLE `game_poet_quiz_question` DISABLE KEYS */;
INSERT INTO `game_poet_quiz_question` VALUES (9201,9100,1,'周末更想怎么度过？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9202,9100,2,'遇到压力，你更常用哪种方式应对？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9203,9100,3,'你更偏好的表达风格是？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9204,9100,4,'你最看重朋友身上的哪一点？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9205,9100,5,'你对“远方”的理解更接近？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9206,9100,6,'你更容易被什么打动？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9207,9100,7,'遇到不公，你更可能？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9208,9100,8,'你更喜欢的生活节奏是？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9209,9100,9,'你更喜欢的环境氛围？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9210,9100,10,'你处理冲突时更像？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9211,9100,11,'你更愿意把时间花在？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9212,9100,12,'你对“成功”的第一反应？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9213,9100,13,'你更常见的情绪底色？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9214,9100,14,'别人评价你“最准”的一句？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9215,9100,15,'你更喜欢的旅行方式？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9216,9100,16,'你对亲密关系更在意？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9217,9100,17,'遇到低谷，你更愿意？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9218,9100,18,'你对规则与边界的态度？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9219,9100,19,'你写下文字更多是为了？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17'),(9220,9100,20,'如果只能选一个关键词代表你？','single',1,'2026-03-31 22:39:17','2026-03-31 22:39:17');
/*!40000 ALTER TABLE `game_poet_quiz_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_record`
--

DROP TABLE IF EXISTS `game_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `season_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `question` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_correct` int DEFAULT NULL,
  `score` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_record`
--

LOCK TABLES `game_record` WRITE;
/*!40000 ALTER TABLE `game_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_records`
--

DROP TABLE IF EXISTS `game_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_records` (
  `record_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) NOT NULL,
  `moment_id` int NOT NULL,
  `selected_poet_id` int NOT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`record_id`),
  KEY `moment_id` (`moment_id`),
  KEY `selected_poet_id` (`selected_poet_id`),
  CONSTRAINT `game_records_ibfk_1` FOREIGN KEY (`moment_id`) REFERENCES `poet_moments` (`moment_id`),
  CONSTRAINT `game_records_ibfk_2` FOREIGN KEY (`selected_poet_id`) REFERENCES `poet_info` (`poet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_records`
--

LOCK TABLES `game_records` WRITE;
/*!40000 ALTER TABLE `game_records` DISABLE KEYS */;
INSERT INTO `game_records` VALUES (1,'user1',1,1,1,'2026-04-04 16:49:48'),(2,'user1',4,2,1,'2026-04-04 16:49:48'),(3,'user1',7,3,1,'2026-04-04 16:49:48'),(4,'user1',10,5,0,'2026-04-04 16:49:48'),(5,'user2',2,1,1,'2026-04-04 16:49:48'),(6,'user2',5,2,1,'2026-04-04 16:49:48'),(7,'user2',8,6,0,'2026-04-04 16:49:48'),(8,'user2',11,4,1,'2026-04-04 16:49:48'),(9,'user3',3,1,1,'2026-04-04 16:49:48'),(10,'user3',6,2,1,'2026-04-04 16:49:48'),(11,'user3',9,3,1,'2026-04-04 16:49:48'),(12,'user3',12,4,1,'2026-04-04 16:49:48'),(13,'user1',3,1,1,'2026-04-04 16:50:17'),(14,'2',5,5,0,'2026-04-04 17:17:29'),(15,'2',13,5,1,'2026-04-04 17:17:31'),(16,'2',2,6,0,'2026-04-04 17:17:34'),(17,'2',22,8,1,'2026-04-05 03:06:09'),(18,'2',6,8,0,'2026-04-05 03:06:13'),(19,'2',8,6,0,'2026-04-05 03:06:15'),(20,'2',20,6,0,'2026-04-05 03:06:23'),(21,'2',5,2,1,'2026-04-05 03:06:57'),(22,'2',18,8,0,'2026-04-05 03:07:40'),(23,'2',7,3,1,'2026-04-05 03:27:27'),(24,'2',5,2,1,'2026-04-05 04:18:03'),(25,'2',16,1,0,'2026-04-05 04:18:08'),(26,'2',21,10,0,'2026-04-05 04:18:24'),(27,'2',13,5,1,'2026-04-05 05:22:57'),(28,'2',29,5,0,'2026-04-05 05:23:10'),(29,'2',25,2,0,'2026-04-05 05:48:10'),(30,'2',25,9,1,'2026-04-05 05:53:21'),(31,'2',17,6,1,'2026-04-05 05:58:42'),(32,'2',24,9,0,'2026-04-05 06:03:45'),(33,'2',25,2,0,'2026-04-05 06:03:48'),(34,'2',24,9,0,'2026-04-05 06:03:56'),(35,'2',23,8,1,'2026-04-05 06:03:59'),(36,'2',3,1,1,'2026-04-05 06:04:05'),(37,'2',1,1,1,'2026-04-05 06:07:07'),(38,'2',3,1,1,'2026-04-05 06:11:02'),(39,'2',1,1,1,'2026-04-05 06:11:30'),(40,'2',16,1,0,'2026-04-05 06:14:06'),(41,'2',25,9,1,'2026-04-05 06:18:58'),(42,'2',9,10,0,'2026-04-05 06:19:02'),(43,'2',19,2,0,'2026-04-05 06:19:07'),(44,'2',23,5,0,'2026-04-05 06:19:09'),(45,'2',5,6,0,'2026-04-05 06:24:49'),(46,'2',19,7,1,'2026-04-05 06:38:57'),(47,'2',12,4,1,'2026-04-05 06:46:56'),(48,'2',8,5,0,'2026-04-05 06:47:22'),(49,'2',23,8,1,'2026-04-05 06:52:21'),(50,'2',4,2,1,'2026-04-05 06:55:54'),(51,'2',24,8,1,'2026-04-05 06:56:34'),(52,'2',18,6,1,'2026-04-09 01:58:57'),(53,'2',3,9,0,'2026-04-09 01:59:00'),(54,'2',6,2,1,'2026-04-09 14:03:47'),(55,'2',29,10,1,'2026-04-14 03:24:05'),(56,'2',11,5,0,'2026-04-14 07:56:07');
/*!40000 ALTER TABLE `game_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_season`
--

DROP TABLE IF EXISTS `game_season`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_season` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `theme` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_season`
--

LOCK TABLES `game_season` WRITE;
/*!40000 ALTER TABLE `game_season` DISABLE KEYS */;
INSERT INTO `game_season` VALUES (1,'第1期 国风诗词挑战赛','月','2026-02-08 09:40:45','2026-02-22 09:40:45',1,'2026-02-08 09:40:45');
/*!40000 ALTER TABLE `game_season` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge`
--

DROP TABLE IF EXISTS `knowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `knowledge` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `page_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '卡片标识',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类',
  `full_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '完整介绍',
  `detail_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '详细赏析文字',
  `image_bg` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头部背景图URL',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图片URL',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_page_key` (`page_key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge`
--

LOCK TABLES `knowledge` WRITE;
/*!40000 ALTER TABLE `knowledge` DISABLE KEYS */;
/*!40000 ALTER TABLE `knowledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge_image`
--

DROP TABLE IF EXISTS `knowledge_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `knowledge_image` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `knowledge_id` int NOT NULL COMMENT '知识卡片ID',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片URL',
  `image_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图片描述',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_knowledge_id` (`knowledge_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='知识卡片图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_image`
--

LOCK TABLES `knowledge_image` WRITE;
/*!40000 ALTER TABLE `knowledge_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `knowledge_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location_poem_stats`
--

DROP TABLE IF EXISTS `location_poem_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_poem_stats` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `location_id` bigint NOT NULL COMMENT '地点ID',
  `dynasty` varchar(50) DEFAULT NULL COMMENT '朝代',
  `poem_count` int DEFAULT '0' COMMENT '诗词数量',
  `poet_count` int DEFAULT '0' COMMENT '诗人数量',
  `heat_value` decimal(5,2) DEFAULT '0.00' COMMENT '热度值(用于热力图)',
  `stat_year` int DEFAULT NULL COMMENT '统计年份',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_location_dynasty` (`location_id`,`dynasty`),
  KEY `idx_location_heat` (`location_id`,`heat_value`),
  CONSTRAINT `location_poem_stats_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='地区诗词统计表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location_poem_stats`
--

LOCK TABLES `location_poem_stats` WRITE;
/*!40000 ALTER TABLE `location_poem_stats` DISABLE KEYS */;
INSERT INTO `location_poem_stats` VALUES (1,1,'唐',1500,120,95.50,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(2,1,'宋',800,80,75.00,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(3,2,'唐',1200,100,88.50,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(4,2,'宋',600,60,65.00,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(5,3,'唐',900,70,78.50,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(6,3,'宋',1100,90,85.00,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(7,4,'唐',850,65,75.50,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(8,4,'宋',700,55,68.00,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(9,5,'唐',750,60,70.50,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(10,5,'宋',1300,110,92.00,NULL,'2026-03-16 14:39:22','2026-03-16 14:39:22'),(88,6,'唐',800,60,70.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(89,6,'宋',2500,200,99.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(90,6,'元',400,40,55.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(91,7,'唐',1200,90,85.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(92,7,'宋',1500,120,92.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(93,7,'明',800,70,75.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(94,8,'唐',1800,140,95.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(95,8,'宋',1000,80,78.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(96,8,'明',900,75,76.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(97,13,'唐',500,40,65.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(98,13,'宋',800,70,80.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(99,14,'唐',600,50,70.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(100,14,'宋',400,35,55.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(101,17,'唐',900,70,78.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(102,17,'宋',600,50,65.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(103,18,'唐',700,55,72.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(104,18,'宋',400,35,58.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(105,17,'战国',300,20,50.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(106,19,'唐',400,30,55.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(107,19,'宋',500,40,62.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(108,21,'唐',300,25,48.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(109,21,'宋',350,28,52.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(110,20,'唐',500,40,65.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(111,20,'宋',200,15,40.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(112,24,'唐',600,50,70.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(113,24,'宋',900,75,82.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(114,25,'春秋',400,30,60.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(115,25,'唐',300,25,50.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(116,15,'唐',800,60,75.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(117,15,'宋',600,50,68.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(118,16,'唐',700,55,72.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(119,16,'宋',500,40,65.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(120,16,'东晋',400,30,58.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(121,28,'宋',700,55,72.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(122,28,'唐',400,30,55.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(123,29,'宋',500,40,65.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(124,29,'唐',300,25,50.00,NULL,'2026-03-18 17:37:32','2026-03-18 17:37:32'),(125,84,'唐',600,50,72.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(126,84,'宋',400,35,62.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(127,85,'东晋',300,20,55.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(128,85,'唐',200,15,45.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(129,87,'唐',500,40,68.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(130,87,'宋',350,30,58.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(131,95,'唐',300,25,55.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(132,95,'宋',800,70,85.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(133,97,'宋',500,45,70.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(134,111,'汉',400,30,65.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(135,111,'三国',350,25,60.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(136,110,'三国',500,40,75.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(137,109,'商',200,10,50.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(138,124,'北魏',400,30,70.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(139,124,'唐',300,25,60.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(140,152,'秦',300,20,55.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(141,152,'唐',250,20,52.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(142,178,'唐',200,15,48.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(143,185,'汉',150,10,40.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(144,185,'唐',180,12,45.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(145,191,'清',400,35,68.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(146,214,'清',200,15,45.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(147,229,'明',150,10,40.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(148,230,'明',120,8,35.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(149,100,'战国',200,15,50.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(150,100,'唐',180,12,45.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32'),(151,108,'宋',300,25,60.00,NULL,'2026-03-18 18:46:32','2026-03-18 18:46:32');
/*!40000 ALTER TABLE `location_poem_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '地区名称',
  `province` varchar(100) DEFAULT NULL COMMENT '所属省份',
  `longitude` decimal(10,7) DEFAULT NULL COMMENT '经度',
  `latitude` decimal(10,7) DEFAULT NULL COMMENT '纬度',
  `description` text COMMENT '地区描述',
  `historical_name` varchar(100) DEFAULT NULL COMMENT '古称/历史名称',
  `dynasty` varchar(50) DEFAULT NULL COMMENT '所属朝代',
  `importance_score` int DEFAULT '0' COMMENT '重要程度分数(用于热力图)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_location` (`name`,`province`),
  KEY `idx_importance` (`importance_score`)
) ENGINE=InnoDB AUTO_INCREMENT=390 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='地区信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'长安','陕西',108.9401740,34.3415680,'长安是中国历史上著名的古都，位于今陕西西安，曾为多朝古都，文化底蕴深厚，李白、杜甫等诗人在此留下不朽诗篇。','长安','唐',10,'2026-03-16 14:37:43','2026-04-13 20:02:27'),(2,'洛阳','河南',112.4539260,34.6196820,'、洛阳位于河南，是中华文明重要发源地之一，曾为多朝古都，著名景点有龙门石窟、白马寺和关林，牡丹花盛开时吸引众多游客吟咏。','洛邑','唐',9,'2026-03-16 14:37:43','2026-04-13 20:02:27'),(3,'成都','四川',104.0665410,30.5722690,'成都是四川省会，以历史悠久、文化繁荣而著称，有宽窄巷子、杜甫草堂等古迹，也是蜀文化和川菜的发源地之一。','锦官城','唐',8,'2026-03-16 14:37:43','2026-04-13 20:02:27'),(4,'扬州','江苏',119.4129660,32.3942100,'扬州位于江苏，以盐商繁荣和园林文化著称，有瘦西湖、大明寺等名胜，历代诗人留下大量描写扬州的诗篇。','广陵','唐',8,'2026-03-16 14:37:43','2026-04-13 20:02:27'),(5,'杭州','浙江',120.1550700,30.2740840,'杭州位于浙江，以西湖闻名，兼具山水秀丽与历史文化，是宋代繁华之地，苏轼《饮湖上初晴后雨》曾赞美西湖美景。','临安','宋',8,'2026-03-16 14:37:43','2026-04-13 20:02:27'),(6,'长安','陕西',108.9401740,34.3415680,'长安是中国历史上著名的古都，位于今陕西西安，曾为多朝古都，文化底蕴深厚，李白、杜甫等诗人在此留下不朽诗篇。','长安、京兆','唐',10,'2026-03-16 19:33:58','2026-04-13 21:05:36'),(7,'洛阳','河南',112.4539260,34.6196820,'洛阳位于河南，是中华文明重要发源地之一，曾为多朝古都，著名景点有龙门石窟、白马寺和关林，牡丹花盛开时吸引众多游客吟咏。','洛邑、神都','唐',9,'2026-03-16 19:33:58','2026-04-13 20:02:27'),(8,'开封','河南',114.3414470,34.8014990,'开封位于河南，曾为北宋首都，以丰富的历史文化和开封府、铁塔等景观闻名，是中国古都文化的重要代表。','汴梁、东京','宋',9,'2026-03-16 19:33:58','2026-04-13 21:05:36'),(9,'北京','北京',116.4073960,39.9041990,'六朝古都，元明清都城','燕京、大都','元',8,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(10,'太原','山西',112.5488790,37.8705900,'太原为山西省省会，历史上为中原北部重要城市，晋祠、双塔寺等古建筑承载丰富文化底蕴。','晋阳','唐',7,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(11,'杭州','浙江',120.1550700,30.2740840,'杭州位于浙江，以西湖闻名，兼具山水秀丽与历史文化，是宋代繁华之地，苏轼《饮湖上初晴后雨》曾赞美西湖美景。','临安、钱塘','宋',9,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(12,'苏州','江苏',120.5853160,31.2988860,'苏州位于江苏，以江南水乡和园林闻名，拙政园、留园等古典园林体现中国传统建筑美学。','姑苏、吴郡','明',8,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(13,'扬州','江苏',119.4129660,32.3942100,'扬州再次出现，依然以瘦西湖、大明寺及盐商文化著称，诗人多在此留下吟咏之作。','广陵、江都','唐',8,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(14,'南京','江苏',118.7968770,32.0602550,'南京是江苏省会，历史悠久，曾为六朝古都，钟山风景区和明孝陵是文化与自然融合的代表。','金陵、建康','南北朝',9,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(15,'徽州','安徽',118.3375220,29.8258970,'徽州位于安徽，以徽派建筑、文化传统及徽商文化闻名，黄山、宏村是徽州著名景观。','新安','宋',7,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(16,'成都','四川',104.0665410,30.5722690,'成都再次出现，继续以川文化、美食和诗人创作的繁荣历史著称，是西南文化重镇。','锦官城、益州','唐',8,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(17,'重庆','重庆',106.5515560,29.5630090,'重庆地处长江上游，以山城特色和三峡风光闻名，历史上曾为抗战时期陪都，文化底蕴丰富。','渝州、恭州','宋',7,'2026-03-16 19:33:58','2026-04-13 20:05:40'),(18,'眉山','四川',103.8315380,30.0483390,'东坡故里，诗书之城','眉州','宋',8,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(19,'武汉','湖北',114.3054690,30.5931750,'武汉为湖北省省会，长江与汉江交汇，历史文化悠久，黄鹤楼是古代诗人常吟咏的名胜。\n','江夏、鄂州','唐',7,'2026-03-16 19:33:58','2026-04-13 20:06:39'),(20,'襄阳','湖北',112.1441640,32.0424270,'军事重镇，文化名城','襄樊','唐',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(21,'荆州','湖北',112.2418660,30.3325900,'禹划九州，楚文化中心','江陵','楚',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(22,'广州','广东',113.2643850,23.1291120,'岭南文化中心，海上丝路起点','番禺、羊城','宋',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(23,'桂林','广西',110.1798010,25.2344790,'山水甲天下，桂剧之乡','始安','唐',6,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(24,'敦煌','甘肃',94.8094950,40.1412190,'丝路明珠，佛教艺术宝库','沙州','唐',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(25,'拉萨','西藏',91.1175250,29.6469230,'雪域圣地，吐蕃都城','逻些','唐',5,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(26,'昆明','云南',102.8328900,24.8800950,'春城花都，滇文化中心','拓东','明',6,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(27,'济南','山东',117.0249670,36.6827850,'泉城济南，齐鲁文化','历下','宋',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(28,'曲阜','山东',116.9865320,35.5809960,'孔子故里，儒家圣地','鲁县','春秋',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(29,'青岛','山东',120.3826210,36.0671080,'青岛位于山东沿海，以啤酒文化和德式建筑闻名，海滨风光与文化底蕴相结合，旅游资源丰富。','胶澳','清',6,'2026-03-16 19:33:58','2026-04-13 20:07:49'),(30,'南昌','江西',115.8575670,28.6828920,'英雄城市，滕王阁所在地','洪都、豫章','唐',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(31,'九江','江西',115.9998480,29.7196400,'浔阳江头，庐山脚下','浔阳、江州','唐',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(32,'景德镇','江西',117.1865230,29.3035630,'千年瓷都，瓷器之源','昌南','宋',7,'2026-03-16 19:33:58','2026-03-16 19:33:58'),(33,'徐州','江苏',117.2010000,34.2610000,'彭城，兵家必争之地','彭城','汉',7,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(34,'湖州','浙江',120.0860000,30.8940000,'江南水乡，丝绸之府','吴兴','唐',6,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(35,'亳州','安徽',115.7790000,33.8450000,'曹魏故里，药材之都','谯郡','三国',7,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(36,'邯郸','河北',114.5390000,36.6250000,'战国赵都，成语之乡','邺城','战国',7,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(37,'常州','江苏',119.9740000,31.8110000,'龙城，季子故里','毗陵','宋',6,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(38,'上饶','江西',117.9430000,28.4540000,'信州，辛弃疾闲居地','信州','宋',7,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(39,'池州','安徽',117.4910000,30.6650000,'秋浦，杜牧任职地','秋浦','唐',6,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(40,'福州','福建',119.2960000,26.0740000,'榕城，福建提刑驻地','福州','宋',6,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(41,'绍兴','浙江',120.5800000,30.0300000,'绍兴位于浙江，以鲁迅故里及黄酒文化闻名，古桥、古街、古民居丰富文化景观。','会稽','宋',8,'2026-03-16 20:27:17','2026-04-13 20:05:40'),(42,'镇江','江苏',119.4240000,32.1880000,'京口，辛弃疾镇江知府','京口','宋',7,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(43,'金华','浙江',119.6470000,29.0790000,'婺州，李清照晚年居地','婺州','宋',7,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(44,'海南','海南',110.1990000,20.0440000,'儋州，苏轼贬谪地','儋耳','宋',5,'2026-03-16 20:27:17','2026-03-16 20:27:17'),(45,'长安','陕西',108.9401740,34.3415680,'唐朝都城，世界文化中心，丝绸之路起点','长安、京兆','唐',10,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(46,'洛阳','河南',112.4539260,34.6196820,'十三朝古都，河洛文化中心','洛邑、神都','唐',9,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(47,'开封','河南',114.3414470,34.8014990,'北宋都城，东京梦华录所在地','汴梁、东京','宋',9,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(48,'北京','北京',116.4073960,39.9041990,'六朝古都，元明清都城','燕京、大都','元',8,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(49,'太原','山西',112.5488790,37.8705900,'唐朝发源地，军事重镇','晋阳','唐',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(50,'杭州','浙江',120.1550700,30.2740840,'人间天堂，南宋都城','临安、钱塘','宋',9,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(51,'苏州','江苏',120.5853160,31.2988860,'园林之城，人间天堂','姑苏、吴郡','明',8,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(52,'扬州','江苏',119.4129660,32.3942100,'淮左名都，竹西佳处','广陵、江都','唐',8,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(53,'南京','江苏',118.7968770,32.0602550,'六朝古都，十朝都会','金陵、建康','南北朝',9,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(54,'徽州','安徽',118.3375220,29.8258970,'徽商故里，程朱阙里','新安','宋',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(55,'成都','四川',104.0665410,30.5722690,'天府之国，锦官之城','锦官城、益州','唐',8,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(56,'重庆','重庆',106.5515560,29.5630090,'山城雾都，巴渝文化','渝州、恭州','宋',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(57,'眉山','四川',103.8315380,30.0483390,'东坡故里，诗书之城','眉州','宋',8,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(58,'武汉','湖北',114.3054690,30.5931750,'九省通衢，白云黄鹤','江夏、鄂州','唐',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(59,'襄阳','湖北',112.1441640,32.0424270,'军事重镇，文化名城','襄樊','唐',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(60,'荆州','湖北',112.2418660,30.3325900,'禹划九州，楚文化中心','江陵','楚',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(61,'广州','广东',113.2643850,23.1291120,'岭南文化中心，海上丝路起点','番禺、羊城','宋',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(62,'桂林','广西',110.1798010,25.2344790,'山水甲天下，桂剧之乡','始安','唐',6,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(63,'敦煌','甘肃',94.8094950,40.1412190,'丝路明珠，佛教艺术宝库','沙州','唐',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(64,'拉萨','西藏',91.1175250,29.6469230,'雪域圣地，吐蕃都城','逻些','唐',5,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(65,'昆明','云南',102.8328900,24.8800950,'春城花都，滇文化中心','拓东','明',6,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(66,'济南','山东',117.0249670,36.6827850,'泉城济南，齐鲁文化','历下','宋',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(67,'曲阜','山东',116.9865320,35.5809960,'孔子故里，儒家圣地','鲁县','春秋',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(68,'青岛','山东',120.3826210,36.0671080,'海滨城市，道教名山崂山所在地','胶澳','清',6,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(69,'南昌','江西',115.8575670,28.6828920,'英雄城市，滕王阁所在地','洪都、豫章','唐',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(70,'九江','江西',115.9998480,29.7196400,'浔阳江头，庐山脚下','浔阳、江州','唐',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(71,'景德镇','江西',117.1865230,29.3035630,'千年瓷都，瓷器之源','昌南','宋',7,'2026-03-18 17:21:13','2026-03-18 17:21:13'),(72,'徐州','江苏',117.2010000,34.2610000,'彭城，兵家必争之地','彭城','汉',7,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(73,'湖州','浙江',120.0860000,30.8940000,'江南水乡，丝绸之府','吴兴','唐',6,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(74,'亳州','安徽',115.7790000,33.8450000,'曹魏故里，药材之都','谯郡','三国',7,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(75,'邯郸','河北',114.5390000,36.6250000,'战国赵都，成语之乡','邺城','战国',7,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(76,'常州','江苏',119.9740000,31.8110000,'龙城，季子故里','毗陵','宋',6,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(77,'上饶','江西',117.9430000,28.4540000,'信州，辛弃疾闲居地','信州','宋',7,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(78,'池州','安徽',117.4910000,30.6650000,'秋浦，杜牧任职地','秋浦','唐',6,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(79,'福州','福建',119.2960000,26.0740000,'榕城，福建提刑驻地','福州','宋',6,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(80,'绍兴','浙江',120.5800000,30.0300000,'会稽，越州治所','会稽','宋',8,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(81,'镇江','江苏',119.4240000,32.1880000,'京口，辛弃疾镇江知府','京口','宋',7,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(82,'金华','浙江',119.6470000,29.0790000,'婺州，李清照晚年居地','婺州','宋',7,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(83,'海南','海南',110.1990000,20.0440000,'儋州，苏轼贬谪地','儋耳','宋',5,'2026-03-18 17:25:58','2026-03-18 17:25:58'),(84,'岳阳','湖南',113.1328550,29.3702950,'岳阳位于湖南北部，洞庭湖畔，历史文化悠久，岳阳楼闻名，被诗人范仲淹赞为“先天下之忧而忧”，自然景观与文化结合。','巴陵','唐',7,'2026-03-18 18:46:12','2026-04-13 20:08:27'),(85,'常德','湖南',111.6985030,29.0316690,'桃花源所在地，陶渊明笔下仙境','武陵','东晋',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(86,'衡阳','湖南',112.5719970,26.8932470,'南岳衡山所在地，雁城','衡州','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(87,'长沙','湖南',112.9388140,28.2282090,'潇湘洙泗，楚汉名城','潭州','唐',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(88,'温州','浙江',120.6993620,28.0012550,'东南名邑，谢灵运曾任永嘉太守','永嘉','南北朝',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(89,'台州','浙江',121.4285990,28.6563860,'佛宗道源，天台山所在地','台州','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(90,'宁波','浙江',121.5497920,29.8683880,'海上丝路起点，天一阁所在地','明州','唐',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(91,'嘉兴','浙江',120.7508650,30.7626530,'南湖红船，江南水乡','嘉禾','宋',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(92,'衢州','浙江',118.8591660,28.9697580,'南孔圣地，围棋仙地','西安','宋',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(93,'丽水','浙江',119.9215860,28.4518370,'浙南林海，瓯江之源','处州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(94,'莆田','福建',119.0075580,25.4310110,'妈祖故里，文献名邦','兴化','宋',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(95,'泉州','福建',118.6756760,24.8741320,'海上丝路起点，东方第一大港','刺桐','宋',8,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(96,'漳州','福建',117.6474780,24.5128760,'花果之乡，闽南文化','龙溪','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(97,'南平','福建',118.1777080,26.6441500,'武夷山所在地，朱熹故里','建州','宋',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(98,'三明','福建',117.6388950,26.2636020,'客家祖地，沙县小吃发源地','沙县','宋',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(99,'龙岩','福建',117.0173170,25.0785950,'客家土楼，红色圣地','汀州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(100,'宜昌','湖北',111.2908430,30.6920770,'三峡门户，屈原故里','夷陵','唐',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(101,'十堰','湖北',110.7877680,32.6290130,'武当山所在地，道教圣地','郧阳','明',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(102,'恩施','湖北',109.4786820,30.2736170,'土家族苗族自治州，巴文化','施州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(103,'黄石','湖北',115.0385190,30.1996520,'矿冶之都，西塞山所在地','大冶','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(104,'咸宁','湖北',114.3224920,29.8414450,'桂花之乡，赤壁古战场','蒲圻','三国',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(105,'随州','湖北',113.3824580,31.6903810,'编钟之乡，神农故里','随县','战国',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(106,'孝感','湖北',113.9169030,30.9245560,'董永故里，孝文化发源地','孝昌','汉',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(107,'鄂州','湖北',114.8948520,30.3843550,'吴王古都，武昌鱼故乡','武昌','三国',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(108,'黄冈','湖北',114.8723160,30.4539320,'苏轼贬谪地，东坡赤壁','黄州','宋',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(109,'安阳','河南',114.3827810,36.1033110,'殷墟所在地，甲骨文故乡','殷都','商',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(110,'许昌','河南',113.8523940,34.0357420,'曹魏故都，三国文化中心','许都','三国',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(111,'南阳','河南',112.5283210,32.9907140,'诸葛亮躬耕地，医圣张仲景故里','宛城','汉',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(112,'信阳','河南',114.0913420,32.1469760,'茶都信阳毛尖，鸡公山','义阳','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(113,'新乡','河南',113.9268250,35.3030040,'牧野之战发生地','牧野','商',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(114,'焦作','河南',113.2418230,35.2157990,'云台山，太极拳发源地','山阳','汉',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(115,'濮阳','河南',115.0292150,35.7618890,'龙都，颛顼遗都','澶州','春秋',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(116,'商丘','河南',115.6504970,34.4370540,'商朝发源地，火神之乡','商都','商',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(117,'周口','河南',114.6969480,33.6257390,'老子故里，伏羲故都','陈州','春秋',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(118,'驻马店','河南',114.0223380,33.0115290,'梁祝故里，嵖岈山','蔡州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(119,'平顶山','河南',113.1926650,33.7662320,'观音故里，汝瓷之乡','汝州','宋',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(120,'漯河','河南',114.0160710,33.5815120,'许慎故里，《说文解字》','召陵','汉',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(121,'三门峡','河南',111.2001040,34.7733940,'函谷关所在地，老子著经处','陕州','秦',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(122,'鹤壁','河南',114.2972970,35.7472250,'诗经发源地，淇水之滨','朝歌','商',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(123,'济源','河南',112.6024490,35.0672870,'愚公移山发生地，济水之源','沁园','汉',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(124,'大同','山西',113.3000870,40.0767320,'北魏都城，云冈石窟','平城','北魏',8,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(125,'朔州','山西',112.4326680,39.3314600,'雁门关所在地，杨家将戍边','朔州','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(126,'忻州','山西',112.7335420,38.4166630,'五台山所在地，佛教圣地','忻州','唐',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(127,'吕梁','山西',111.1347660,37.5243670,'吕梁英雄传，晋绥边区','石州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(128,'晋中','山西',112.7526950,37.6874160,'晋商故里，平遥古城','榆次','清',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(129,'临汾','山西',111.5189760,36.0841570,'尧都平阳，丁村遗址','平阳','尧',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(130,'运城','山西',111.0069460,35.0264120,'关公故里，盐湖之城','河东','汉',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(131,'长治','山西',113.1162550,36.1953860,'神农尝百草，上党战役','上党','战国',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(132,'晋城','山西',112.8514930,35.4975390,'炎帝故里，皇城相府','泽州','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(133,'阳泉','山西',113.5832850,37.8615290,'百团大战主战场，娘子关','平定','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(134,'赤峰','内蒙古',118.8872770,42.2578170,'红山文化发源地，契丹故土','昭乌达','辽',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(135,'呼伦贝尔','内蒙古',119.7657440,49.2122000,'北疆明珠，草原明珠','呼伦贝尔','元',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(136,'通辽','内蒙古',122.2634600,43.6174290,'孝庄故里，科尔沁草原','哲里木','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(137,'鄂尔多斯','内蒙古',109.7813270,39.6085710,'成吉思汗陵所在地','伊克昭','元',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(138,'巴彦淖尔','内蒙古',107.3886770,40.7364760,'阴山岩画，河套平原','河套','汉',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(139,'乌兰察布','内蒙古',113.1328550,41.0000340,'辉腾锡勒草原，火山群','乌兰察布','元',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(140,'兴安盟','内蒙古',122.0376600,46.0775610,'阿尔山温泉，森林草原','兴安','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(141,'锡林郭勒','内蒙古',116.0487280,43.9334540,'锡林郭勒草原，元上都','锡林郭勒','元',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(142,'阿拉善','内蒙古',105.7289690,38.8443080,'额济纳胡杨林，沙漠绿洲','阿拉善','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(143,'延安','陕西',109.4897270,36.5854550,'革命圣地，宝塔山','延州','唐',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(144,'汉中','陕西',107.0239230,33.0674800,'汉家发祥地，张骞故里','南郑','汉',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(145,'榆林','陕西',109.7341960,38.2854290,'边塞重镇，统万城遗址','榆林','明',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(146,'安康','陕西',109.0292730,32.6848310,'秦巴明珠，汉水文化','金州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(147,'商洛','陕西',109.9404760,33.8680570,'商山四皓，贾平凹故里','商州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(148,'宝鸡','陕西',107.2379740,34.3619790,'青铜器之乡，炎帝故里','陈仓','周',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(149,'咸阳','陕西',108.7089930,34.3296050,'秦都咸阳，帝王陵寝','咸阳','秦',8,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(150,'渭南','陕西',109.5097860,34.5023580,'华山所在地，司马迁故里','华州','唐',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(151,'铜川','陕西',108.9451160,34.8967560,'药王山，孙思邈故里','耀州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(152,'天水','甘肃',105.7249470,34.5808630,'伏羲故里，麦积山石窟','秦州','秦',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(153,'酒泉','甘肃',98.4944810,39.7425430,'霍去病倾酒入泉，航天城','肃州','汉',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(154,'张掖','甘肃',100.4554720,38.9258750,'七彩丹霞，马蹄寺石窟','甘州','汉',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(155,'平凉','甘肃',106.6652400,35.5430520,'崆峒山，道教圣地','泾州','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(156,'庆阳','甘肃',107.6437310,35.7094180,'农耕文化发源地，岐黄故里','庆州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(157,'定西','甘肃',104.6262940,35.5795800,'马家窑文化，李氏故里','安定','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(158,'陇南','甘肃',104.9211650,33.4007220,'陇上江南，白马藏族','武都','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(159,'白银','甘肃',104.1385610,36.5446600,'黄河石林，会宁会师','靖远','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(160,'金昌','甘肃',102.1878880,38.5145340,'镍都，骊靬古城','永昌','汉',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(161,'嘉峪关','甘肃',98.2890970,39.7730740,'天下第一雄关，长城西端','嘉峪关','明',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(162,'临夏','甘肃',103.2105380,35.6010450,'花儿之乡，彩陶之都','河州','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(163,'甘南','甘肃',102.9110270,34.9862840,'九色香巴拉，拉卜楞寺','甘南','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(164,'西宁','青海',101.7782280,36.6171290,'夏都西宁，青藏高原门户','西平','汉',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(165,'海东','青海',102.1038460,36.5027940,'柳湾彩陶，瞿昙寺','乐都','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(166,'海北','青海',100.9010230,36.9594350,'金银滩草原，原子城','海北','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(167,'黄南','青海',102.0150500,35.5177440,'热贡艺术，唐卡之乡','黄南','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(168,'海南','青海',100.6204670,36.2804530,'青海湖，日月山','海南','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(169,'果洛','青海',100.2448080,34.4714310,'黄河源头，阿尼玛卿山','果洛','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(170,'玉树','青海',97.0085220,33.0040490,'三江之源，可可西里','玉树','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(171,'海西','青海',97.3707860,37.3746630,'茶卡盐湖，柴达木盆地','海西','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(172,'石嘴山','宁夏',106.3793370,39.0202230,'塞上煤城，沙湖','石嘴山','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(173,'吴忠','宁夏',106.1994090,37.9861650,'黄河金岸，回乡风情','吴忠','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(174,'固原','宁夏',106.2426100,36.0158190,'须弥山石窟，六盘山','原州','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(175,'中卫','宁夏',105.1895680,37.5149510,'沙坡头，黄河与沙漠交汇','中卫','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(176,'乌鲁木齐','新疆',87.6177330,43.7928180,'西域明珠，天山脚下','迪化','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(177,'克拉玛依','新疆',84.8739480,45.5794980,'石油之城，魔鬼城','克拉玛依','现代',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(178,'吐鲁番','新疆',89.1840770,42.9476130,'火洲，葡萄之乡，高昌古城','高昌','唐',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(179,'哈密','新疆',93.5133510,42.8192890,'哈密瓜故乡，东疆门户','伊州','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(180,'昌吉','新疆',87.3040120,44.0072780,'天山北麓，北庭故城','昌吉','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(181,'博尔塔拉','新疆',82.0747270,44.9058990,'赛里木湖，阿拉山口','博尔塔拉','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(182,'巴音郭楞','新疆',86.1509490,41.7640860,'巴音布鲁克草原，楼兰古城','焉耆','汉',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(183,'阿克苏','新疆',80.2605050,41.1686840,'姑墨古国，龟兹文化','姑墨','汉',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(184,'克孜勒苏','新疆',76.1684000,39.7161600,'帕米尔高原，中国最西端','疏勒','汉',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(185,'喀什','新疆',75.9891380,39.4676850,'丝路明珠，西域风情','疏勒','汉',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(186,'和田','新疆',79.9253380,37.1106320,'玉石之乡，于阗古国','于阗','汉',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(187,'伊犁','新疆',81.3241360,43.9168230,'塞外江南，薰衣草之乡','伊犁','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(188,'塔城','新疆',82.9857330,46.7453630,'塔尔巴哈台山，边境口岸','塔城','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(189,'阿勒泰','新疆',88.1396330,47.8485270,'喀纳斯湖，人类滑雪起源地','阿勒泰','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(190,'石河子','新疆',86.0804600,44.3058860,'军垦名城，兵团第一城','石河子','现代',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(191,'沈阳','辽宁',123.4290960,41.7967670,'盛京故宫，清朝发祥地','盛京','清',8,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(192,'大连','辽宁',121.6186220,38.9140030,'北方明珠，旅顺口','旅顺','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(193,'鞍山','辽宁',122.9946290,41.1088050,'钢都，千山风景区','鞍山','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(194,'抚顺','辽宁',123.9211090,41.8759560,'雷锋故乡，清前都城','抚顺','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(195,'本溪','辽宁',123.7705190,41.2979090,'枫叶之都，本溪水洞','本溪','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(196,'丹东','辽宁',124.3830440,40.1242960,'鸭绿江畔，抗美援朝','丹东','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(197,'锦州','辽宁',121.1268920,41.0955550,'辽沈战役，笔架山','锦州','明',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(198,'营口','辽宁',122.2351510,40.6676510,'渤海明珠，望儿山','营口','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(199,'阜新','辽宁',121.6703230,42.0217380,'玉龙故乡，海棠山','阜新','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(200,'辽阳','辽宁',123.1817030,41.2694020,'东北第一城，东京城','辽阳','辽',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(201,'盘锦','辽宁',122.0695710,41.1244840,'红海滩，鹤乡','盘山','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(202,'铁岭','辽宁',123.8442790,42.2906010,'小品之乡，龙首山','铁岭','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(203,'朝阳','辽宁',120.4537190,41.5765580,'红山文化，牛河梁','龙城','辽',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(204,'葫芦岛','辽宁',120.8374530,40.7110520,'兴城古城，绥中长城','锦西','明',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(205,'长春','吉林',125.3245450,43.8868410,'汽车城，伪满皇宫','长春','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(206,'吉林','吉林',126.5495720,43.8378830,'江城吉林，雾凇之都','吉林','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(207,'四平','吉林',124.3504620,43.1664200,'英雄城，四平战役','四平','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(208,'辽源','吉林',125.1453490,42.9026970,'煤城，盛京围场','辽源','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(209,'通化','吉林',125.9396970,41.7211770,'葡萄酒之乡，杨靖宇陵园','通化','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(210,'白山','吉林',126.4275550,41.9425050,'长白山脚下，人参之乡','白山','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(211,'松原','吉林',124.8236080,45.1411200,'查干湖冬捕，石油新城','松原','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(212,'白城','吉林',122.8411420,45.6196540,'向海湿地，丹顶鹤之乡','白城','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(213,'延边','吉林',129.5136920,42.9075590,'长白山天池，朝鲜族风情','延边','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(214,'哈尔滨','黑龙江',126.6424640,45.7569670,'冰城夏都，东方莫斯科','哈尔滨','清',7,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(215,'齐齐哈尔','黑龙江',123.9534890,47.3480810,'鹤城，扎龙湿地','齐齐哈尔','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(216,'鸡西','黑龙江',130.9693330,45.2950750,'煤城，兴凯湖','鸡西','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(217,'鹤岗','黑龙江',130.2976320,47.3499180,'煤城，龙江三峡','鹤岗','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(218,'双鸭山','黑龙江',131.1572910,46.6434420,'煤城，七星峰','双鸭山','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(219,'大庆','黑龙江',125.1129130,46.5901010,'油城，铁人精神','大庆','现代',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(220,'伊春','黑龙江',128.8993960,47.7247750,'林都，汤旺河石林','伊春','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(221,'佳木斯','黑龙江',130.3189170,46.7994670,'华夏东极，三江平原','佳木斯','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(222,'七台河','黑龙江',130.8261970,45.7710270,'煤城，短道速滑之乡','七台河','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(223,'牡丹江','黑龙江',129.6186020,44.5829620,'雪乡，镜泊湖','牡丹江','清',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(224,'黑河','黑龙江',127.5285600,50.2451550,'北疆重镇，五大连池','黑河','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(225,'绥化','黑龙江',126.9692930,46.6373910,'北国粮仓，寒地黑土','绥化','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(226,'大兴安岭','黑龙江',124.7115260,52.3352620,'林海雪原，北极村','大兴安岭','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(227,'贵阳','贵州',106.7134780,26.5783430,'林城贵阳，甲秀楼','贵阳','明',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(228,'六盘水','贵州',104.8304590,26.5948470,'凉都，乌蒙山','六盘水','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(229,'遵义','贵州',106.9372650,27.7066260,'遵义会议，茅台酒乡','遵义','明',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(230,'安顺','贵州',105.9321670,26.2455440,'黄果树瀑布，屯堡文化','安顺','明',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(231,'毕节','贵州',105.2849920,27.3025890,'百里杜鹃，织金洞','毕节','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(232,'铜仁','贵州',109.1915050,27.7313470,'梵净山，弥勒道场','铜仁','明',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(233,'黔西南','贵州',104.9063960,25.0880970,'马岭河峡谷，万峰林','兴义','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(234,'黔东南','贵州',107.9828590,26.5839850,'苗族侗族风情，西江千户苗寨','凯里','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(235,'黔南','贵州',107.5171560,26.2582390,'荔波小七孔，中国天眼','都匀','清',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(236,'日喀则','西藏',88.8805830,29.2675190,'后藏中心，扎什伦布寺','日喀则','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(237,'昌都','西藏',97.1784520,31.1368750,'康巴文化，茶马古道','昌都','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(238,'林芝','西藏',94.3623270,29.6491280,'西藏江南，南迦巴瓦峰','林芝','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(239,'山南','西藏',91.7664290,29.2370220,'藏文明发源地，雍布拉康','山南','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(240,'那曲','西藏',92.0535310,31.4806150,'羌塘草原，纳木错','那曲','唐',5,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(241,'阿里','西藏',80.1054980,32.5036720,'古格王朝，冈仁波齐','阿里','唐',6,'2026-03-18 18:46:12','2026-03-18 18:46:12'),(242,'龙标','湖南',109.9500000,27.4500000,'王昌龄贬谪地，有\"一片冰心在玉壶\"名句','龙标','唐',5,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(243,'永州','湖南',111.6100000,26.4200000,'柳宗元贬谪地，创作《永州八记》','零陵','唐',7,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(244,'柳州','广西',109.4200000,24.3300000,'柳宗元贬谪地，有柳侯祠','柳州','唐',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(245,'朗州','湖南',111.7000000,29.0500000,'刘禹锡贬谪地，创作《陋室铭》','常德','唐',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(246,'连州','广东',112.3800000,24.7800000,'刘禹锡任职地','连州','唐',5,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(247,'夔州','重庆',109.6500000,31.0300000,'杜甫漂泊地，刘禹锡任职地','奉节','唐',7,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(248,'阳山','广东',112.6400000,24.5700000,'韩愈贬谪地','阳山','唐',5,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(249,'潮州','广东',116.6300000,23.6800000,'韩愈贬谪地，有韩文公祠','潮州','唐',7,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(250,'夷陵','湖北',111.3000000,30.8000000,'欧阳修贬谪地','宜昌','宋',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(251,'滁州','安徽',118.3200000,32.3200000,'欧阳修任职地，创作《醉翁亭记》','滁州','宋',7,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(252,'邓州','河南',112.0800000,32.9900000,'范仲淹贬谪地，创作《岳阳楼记》','邓州','宋',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(253,'山阴','浙江',120.5800000,30.0300000,'陆游故里','绍兴','宋',8,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(254,'铅山','江西',117.7100000,28.3200000,'辛弃疾晚年居地及去世地','铅山','宋',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(255,'安西','新疆',84.1300000,39.8300000,'岑参任职地，边塞诗创作地','龟兹','唐',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(256,'北庭','新疆',89.1800000,43.9500000,'岑参任职地','庭州','唐',5,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(257,'河津','山西',110.7100000,35.5900000,'王勃故里','龙门','唐',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(258,'许昌','河南',113.8500000,34.0300000,'曹操迎献帝都于此','许都','三国',7,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(259,'鄄城','山东',115.5300000,35.5700000,'曹植封地','鄄城','三国',5,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(260,'冀州','河北',115.5800000,37.6200000,'王之涣游历地','冀州','唐',5,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(261,'蓟门','北京',116.4000000,40.0000000,'王之涣游历地，边塞','蓟州','唐',5,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(262,'嘉州','四川',103.7700000,29.5500000,'岑参任职地','乐山','唐',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(263,'临川','江西',116.3500000,28.0000000,'晏殊、王安石故里','抚州','宋',7,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(264,'鄱阳','江西',116.7000000,29.0000000,'姜夔故里','饶州','宋',6,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(265,'吉安','江西',114.9700000,27.1200000,'欧阳修、文天祥故里','庐陵','宋',7,'2026-03-24 21:31:35','2026-03-24 21:31:35'),(270,'商丘','河南',115.6504970,34.4370540,'应天府，南京留守驻地','应天','宋',7,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(271,'巩义','河南',112.9669420,34.7772220,'北宋皇陵所在地','巩县','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(272,'登封','河南',113.0547160,34.4542180,'嵩山少林寺，理学发源地','嵩阳','宋',7,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(273,'汝州','河南',112.8413080,34.1661570,'汝瓷之都','汝州','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(274,'滑县','河南',114.5237270,35.5474910,'大运河通济渠段','滑州','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(275,'邓州','河南',112.0800000,32.9900000,'范仲淹贬谪地','邓州','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(276,'唐河','河南',112.8365320,32.8419890,'唐河县，南阳盆地','唐州','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(277,'新郑','河南',113.7268710,34.3971380,'欧阳修故里','新郑','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(278,'禹州','河南',113.4669080,34.1553960,'钧瓷之都','颍昌','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(279,'辉县','河南',113.8068620,35.4598380,'百泉书院','共城','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(280,'安阳','河南',114.3827810,36.1033110,'文彦博任职地','相州','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(281,'临颍','河南',113.9364480,33.9531100,'小商桥所在地','临颍','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(282,'淮阳','河南',114.8737870,33.7278840,'包拯任职地','陈州','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(283,'太康','河南',114.8536970,34.0837400,'高适故里','太康','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(284,'鹿邑','河南',115.4836730,33.8616560,'老子故里，太清宫','真源','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(285,'浚县','河南',114.5450670,35.6742180,'大伾山摩崖石刻','黎阳','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(286,'汤阴','河南',114.3669280,35.9234370,'岳飞故里','汤阴','宋',7,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(287,'内黄','河南',114.9036560,35.9542690,'颛顼帝喾陵','内黄','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(288,'南乐','河南',115.2036590,36.0736580,'仓颉陵所在地','昌乐','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(289,'清丰','河南',115.1068650,35.8936580,'张姓起源地','清丰','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(290,'长垣','河南',114.6736560,35.1436580,'厨师之乡','蒲城','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(291,'封丘','河南',114.4236560,35.0436580,'陈桥驿兵变遗址','封丘','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(292,'原阳','河南',113.9636560,35.0536580,'张良故里','阳武','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(293,'中牟','河南',114.0236560,34.7236560,'官渡之战发生地','中牟','宋',6,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(294,'尉氏','河南',114.1936560,34.4136560,'阮籍啸台所在地','尉氏','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(295,'通许','河南',114.4636560,34.4836560,'咸平府所在地','咸平','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(296,'兰考','河南',114.8236560,34.8236560,'焦裕禄精神发源地','兰阳','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(297,'民权','河南',115.1436560,34.6436560,'江淹故里','考城','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(298,'宁陵','河南',115.3136560,34.5836560,'葛天氏故里','宁陵','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(299,'睢县','河南',115.0636560,34.4436560,'宋襄公陵墓所在地','睢州','宋',5,'2026-03-25 21:18:32','2026-03-25 21:18:32'),(300,'正定','河北',114.5756560,38.1436560,'真定府，元曲发源地','真定','元',7,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(301,'保定','河北',115.4643170,38.8738180,'直隶首府','保州','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(302,'沧州','河北',116.8386170,38.2104180,'运河重镇','沧州','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(303,'邢台','河北',114.5046170,37.0681180,'郭守敬故里','顺德','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(304,'邯郸','河北',114.5390000,36.6250000,'磁州窑所在地','磁州','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(305,'衡水','河北',115.6736560,37.7236560,'冀州所在地','冀州','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(306,'廊坊','河北',116.6836560,39.5236560,'幽州之地','安次','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(307,'张家口','河北',114.8836560,40.8236560,'张库商道起点','宣德','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(308,'承德','河北',117.9336560,40.9536560,'热河行宫','热河','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(309,'唐山','河北',118.1836560,39.6336560,'清东陵所在地','滦州','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(310,'秦皇岛','河北',119.5836560,39.8836560,'山海关所在地','临榆','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(311,'曲阜','山东',116.9865320,35.5809960,'孔子故里，衍圣公府','曲阜','元',8,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(312,'邹城','山东',116.9636560,35.4036560,'孟子故里','邹县','元',7,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(313,'泰安','山东',117.1236560,36.2036560,'泰山岱庙所在地','泰安','元',7,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(314,'济宁','山东',116.5836560,35.4236560,'运河总督衙门','济州','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(315,'聊城','山东',115.9836560,36.4536560,'东昌府所在地','东昌','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(316,'德州','山东',116.3536560,37.4536560,'九达天衢','德州','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(317,'滨州','山东',118.0236560,37.3836560,'渤海郡所在地','棣州','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(318,'菏泽','山东',115.4636560,35.2336560,'曹州牡丹园','曹州','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(319,'临沂','山东',118.3536560,35.0536560,'琅琊王氏故里','沂州','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(320,'潍坊','山东',119.1036560,36.7036560,'潍县县衙','潍州','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(321,'淄博','山东',118.0536560,36.8036560,'齐国故都','淄川','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(322,'枣庄','山东',117.5536560,34.8536560,'台儿庄古城','峄县','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(323,'日照','山东',119.5236560,35.4236560,'日出东方','日照','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(324,'莱芜','山东',117.6736560,36.2236560,'嬴牟之地','莱芜','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(325,'胶州','山东',120.0036560,36.2836560,'板桥镇所在地','胶西','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(326,'平度','山东',119.9536560,36.7836560,'即墨故城','胶东','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(327,'莱州','山东',119.9436560,37.1836560,'掖县所在地','莱州','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(328,'蓬莱','山东',120.7536560,37.8036560,'人间仙境','登州','元',6,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(329,'龙口','山东',120.5236560,37.6536560,'黄县所在地','黄县','元',5,'2026-03-25 21:19:02','2026-03-25 21:19:02'),(330,'凤阳','安徽',117.5636560,32.8636560,'明中都，朱元璋故里','濠州','明',8,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(331,'寿县','安徽',116.7836560,32.5836560,'寿春古城','寿春','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(332,'亳州','安徽',115.7790000,33.8450000,'华佗故里','亳县','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(333,'阜阳','安徽',115.8236560,32.9036560,'颍州府所在地','颍州','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(334,'蚌埠','安徽',117.3636560,32.9436560,'采珠之地','涂中','明',5,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(335,'淮南','安徽',116.9836560,32.6436560,'豆腐发源地','淮上','明',5,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(336,'滁州','安徽',118.3200000,32.3200000,'醉翁亭所在地','滁州','明',7,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(337,'巢湖','安徽',117.8836560,31.6236560,'五大淡水湖之一','居巢','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(338,'芜湖','安徽',118.3836560,31.3436560,'皖江明珠','鸠兹','明',7,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(339,'马鞍山','安徽',118.5036560,31.6836560,'李白终老地','当涂','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(340,'铜陵','安徽',117.8236560,30.8436560,'中国古铜都','铜官','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(341,'安庆','安徽',117.0536560,30.5236560,'安徽省会旧址','宜城','明',7,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(342,'黄山','安徽',118.1836560,30.1436560,'天下第一奇山','徽州','明',8,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(343,'宣城','安徽',118.7636560,30.9436560,'宣纸之乡','宣州','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(344,'池州','安徽',117.4910000,30.6650000,'九华山所在地','秋浦','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(345,'六安','安徽',116.5036560,31.7636560,'六安瓜片产地','庐州','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(346,'天长','安徽',119.0036560,32.7036560,'千秋县所在地','天长','明',5,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(347,'明光','安徽',117.9836560,32.7836560,'女山湖所在地','嘉山','明',5,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(348,'桐城','安徽',116.9536560,31.0536560,'桐城派发源地','桐城','明',7,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(349,'歙县','安徽',118.4436560,29.8636560,'徽州府治所','歙县','明',7,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(350,'黟县','安徽',117.9436560,30.0036560,'桃花源里人家','黟县','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(351,'祁门','安徽',117.7236560,29.8536560,'祁门红茶产地','祁门','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(352,'休宁','安徽',118.2036560,29.7836560,'中国第一状元县','休宁','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(353,'婺源','江西',117.8636560,29.2636560,'中国最美乡村','婺源','明',7,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(354,'绩溪','安徽',118.6036560,30.0836560,'胡适故里','绩溪','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(355,'旌德','安徽',118.5436560,30.2836560,'江村古民居','旌德','明',5,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(356,'泾县','安徽',118.4236560,30.6836560,'宣纸原产地','泾县','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(357,'广德','安徽',119.4236560,30.9036560,'太极洞所在地','广德','明',5,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(358,'宁国','安徽',118.9836560,30.6436560,'山核桃之乡','宁国','明',5,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(359,'潜山','安徽',116.5836560,30.6436560,'天柱山所在地','舒州','明',6,'2026-03-25 21:19:09','2026-03-25 21:19:09'),(360,'承德','河北',117.9336560,40.9536560,'避暑山庄，外八庙','热河','清',9,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(361,'遵化','河北',117.9636560,40.2036560,'清东陵所在地','遵化','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(362,'易县','河北',115.3836560,39.3636560,'清西陵所在地','易州','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(363,'正定','河北',114.5756560,38.1436560,'隆兴寺所在地','真定','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(364,'赵县','河北',114.7836560,37.7636560,'赵州桥所在地','赵州','清',6,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(365,'定州','河北',115.0036560,38.5236560,'定瓷之都','定州','清',6,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(366,'蔚县','河北',114.5836560,39.8436560,'剪纸艺术之乡','蔚州','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(367,'山海关','河北',119.7636560,40.0036560,'天下第一关','榆关','清',8,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(368,'北戴河','河北',119.5236560,39.8236560,'避暑胜地','临榆','清',6,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(369,'白洋淀','河北',115.9436560,38.9436560,'华北明珠','白洋淀','清',6,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(370,'曲阜','山东',116.9865320,35.5809960,'孔府孔庙孔林','曲阜','清',9,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(371,'泰山','山东',117.1236560,36.2036560,'五岳独尊','岱宗','清',9,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(372,'崂山','山东',120.4836560,36.1636560,'海上第一名山','劳山','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(373,'烟台','山东',121.4036560,37.4636560,'开埠城市','芝罘','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(374,'威海','山东',122.1236560,37.5236560,'北洋水师基地','威海卫','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(375,'青州','山东',118.4836560,36.6836560,'古九州之一','青州','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(376,'临淄','山东',118.3036560,36.8236560,'齐国故都','临淄','清',7,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(377,'章丘','山东',117.5436560,36.7236560,'李清照故里','章丘','清',6,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(378,'邹平','山东',117.7436560,36.8836560,'范仲淹读书处','邹平','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(379,'高青','山东',118.1636560,37.1836560,'陈庄遗址','高苑','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(380,'桓台','山东',118.1036560,36.9836560,'王渔洋故里','新城','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(381,'博山','山东',117.8636560,36.5036560,'鲁菜发源地','颜神','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(382,'周村','山东',117.8436560,36.8236560,'旱码头商埠','周村','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(383,'沂源','山东',118.1636560,36.1836560,'沂蒙山腹地','沂源','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(384,'沂水','山东',118.6436560,35.7836560,'地下大峡谷','沂水','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(385,'蒙阴','山东',117.9436560,35.7236560,'孟良崮战役地','蒙阴','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(386,'平邑','山东',117.6436560,35.5236560,'金银花之乡','平邑','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(387,'费县','山东',118.0436560,35.2836560,'颜真卿故里','费县','清',6,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(388,'兰陵','山东',118.0636560,34.8236560,'兰陵美酒产地','兰陵','清',6,'2026-03-25 21:19:13','2026-03-25 21:19:13'),(389,'郯城','山东',118.3636560,34.6236560,'银杏之乡','郯城','清',5,'2026-03-25 21:19:13','2026-03-25 21:19:13');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '接收通知的用户ID',
  `from_user_id` bigint NOT NULL COMMENT '触发通知的用户ID',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知类型: like/comment/mention',
  `target_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '目标类型: work/comment',
  `target_id` bigint NOT NULL COMMENT '目标ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '通知内容（评论内容等）',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '是否已读: 0未读 1已读',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`,`is_read`,`created_at`) USING BTREE,
  KEY `idx_from_user_id` (`from_user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='通知消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,1,2,'like','work',3,NULL,0,'2026-03-08 22:03:52'),(2,1,2,'comment','work',3,'123123',0,'2026-03-08 22:23:29'),(3,1,2,'comment','work',1,'111',0,'2026-03-08 22:23:34'),(4,1,2,'like','work',3,NULL,0,'2026-03-10 22:07:55'),(5,1,2,'comment','work',3,'123123123',0,'2026-03-10 22:07:58'),(6,1,2,'comment','work',1,'123123',0,'2026-03-11 22:21:01'),(7,1,2,'like','work',1,NULL,0,'2026-03-11 22:21:02'),(8,1,2,'like','work',3,NULL,0,'2026-03-13 16:31:33'),(9,2,1,'like','work',21,NULL,1,'2026-03-14 01:08:26'),(10,2,1,'comment','work',21,'很好',1,'2026-03-14 01:08:36');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poem`
--

DROP TABLE IF EXISTS `poem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `author` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `dynasty` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `genre` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '诗',
  `theme` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `difficulty` decimal(3,1) NOT NULL DEFAULT '1.0',
  `hot` int NOT NULL DEFAULT '0',
  `len` int NOT NULL DEFAULT '0',
  `quote` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `translation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `analysis` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '诗词封面图地址',
  `audio_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '朗诵音频地址',
  `audio_duration` int DEFAULT NULL COMMENT '音频时长（秒）',
  `audio_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '音频类型 mp3/wav',
  `season` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '季节: 春/夏/秋/冬',
  `emotion` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '情感: 豪迈/婉约/悲壮/闲适/忧郁/激昂',
  `scenery` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `festival` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '节日: 春节/元宵/端午/中秋/重阳',
  `historical_period` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '历史时期: 初唐/盛唐/中唐/晚唐/北宋/南宋',
  `poetic_form` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `rhetorical_device` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `famous_line_type` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=338509 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poem`
--

LOCK TABLES `poem` WRITE;
/*!40000 ALTER TABLE `poem` DISABLE KEYS */;
INSERT INTO `poem` VALUES (5,'爱莲说','周敦颐','宋','诗','悲伤',2.0,0,0,'水陆草木之花','水陆草木之花，可爱者甚蕃。晋陶渊明独爱菊。自李唐来，世人甚爱牡丹。予独爱莲之出淤泥而不染，濯清涟而不妖，中通外直，不蔓不枝，香远益清，亭亭净植，可远观而不可亵玩焉。(甚爱 一作：盛爱)\n\n　　予谓菊，花之隐逸者也；牡丹，花之富贵者也；莲，花之君子者也。噫！菊之爱，陶后鲜有闻。莲之爱，同予者何人?牡丹之爱，宜乎众矣!','　　水上、陆地上各种草本木本的花，值得喜爱的非常多。晋代的陶渊明唯独喜爱菊花。从李氏唐朝以来，世人大多喜爱牡丹。我唯独喜爱莲花从积存的淤泥中长出却不被污染，经过清水的洗涤却不显得妖艳。（它的茎）中间贯通外形挺直，不牵牵连连也不枝枝节节，香气传播更加清香，笔直洁净地竖立在水中。（人们）可以远远地观赏（莲），而不可轻易地玩弄它啊。\n　　我认为菊花，是花中的隐士；牡丹，是花中的富贵者；莲花，是花中（品德高尚）的君子。唉！（对于）菊花的喜爱，陶渊明以后就很少听到了。（对于）莲花的喜爱，像我一样的还有什么人呢？（对于）牡丹的喜爱，人数当然就很多了!\n\n','　　“说”是古代的一种议论文文体，大多是借事物或一种现象来抒发作者的感想，写法上不拘一格，行文崇尚自由活泼，波澜起伏，篇幅一般长短不定，跟现代杂文颇为相似。它可以直接说明事物，阐述事理，也可以托物寓意，借物抒情。\n\n　　《爱莲说》是我国古代散文之精品。全文119字，结构严谨，笔意超越，言简意赅，情景交融，其采用“借影”笔法，以莲自喻，有着深邃的思想内容。值得知道的是，这篇选入教材的佳作是宋代哲人周敦颐于1063年（嘉佑八年）5月在虔州（今赣州）道判署内写作的。\n\n　　正如《爱莲说》抒意，周敦颐虽身居官场，却始终未曾放弃读书治学，著书立说，教育青年提携后进。宋代著名哲学家、教育家二程——程颐、程颢，便是他在赣州一手培养出来的弟子。他做官也和别人不同，“为政精密，务尽道理”，他在1045年任南安（今大余）司理参军（一种小官）时，为了一个法不当死的囚犯，和顶头上司转运使王逵据理力争，并递上辞呈，不愿为官，终于使刚愎自用的王逵有所感悟，承认自己的错误，囚不得死。周敦颐在赣州为官多年，清廉勤勉。《爱莲说》据传系他一次游览于都罗汉岩之后所作。\n\n　　从《爱莲说》一文来看，“……予独爱莲之出淤泥而不染，濯清涟而不妖，中通外直，不蔓不枝，香远益清，亭亭净植……莲，花之君子者也。”以莲喻道德高尚的人。且正是文如其人，了专祠，并在祠后建“濂溪书院”，书院内还凿有“爱莲池”。由于几经兵燹，原来书院、祠和池均已无存。此篇文章写出了作者洁身自好、不甘屈服于世俗的高尚情操，表现了作者的“出淤泥而不染”，从而与文章中所讽刺的庸人、俗人构成了鲜明的对比。\n\n　　淳熙六年（1179年），朱熹任南康（今星子县）郡守，曾在庐山的濂溪书院中赞叹周敦颐一生不与黑暗势力同流合污；黄庭坚亦称赞他“人品甚高”，如“光风霁月”。后来，赣州人为纪念他，建立了濂溪祠，刻周敦颐的图像及一些文章于石壁。此时，周敦颐的曾孙周直卿来到九江，把他曾祖写的《爱莲说》墨本送赠，于是赣州人就在书院莲池旁壁上摹刻了此文，流传千古。\n\n','周敦颐,宋,悲伤,忧愁,月夜','/files/images/poem/5.jpg',NULL,NULL,NULL,'夏','忧愁','月夜','无','北宋','古风','设问','其他'),(8,'元日','王安石','宋','诗','离别',1.0,0,0,'爆竹声中一岁除','爆竹声中一岁除，春风送暖入屠苏。\n千门万户曈曈日，总把新桃换旧符。','阵阵轰鸣的爆竹声中，旧的一年已经过去；和暖的春风吹来了新年，人们欢乐地畅饮着新酿的屠苏酒。\n初升的太阳照耀着千家万户，他们都忙着把旧的桃符取下，换上新的桃符。\n\n','　　此诗描写春节除旧迎新的景象。一片爆竹声送走了旧的一年，饮着醇美的屠苏酒感受到了春天的气息。初升的太阳照耀着千家万户，家家门上的桃符都换成了新的。\n\n　　这是一首写古代迎接新年的即景之作，取材于民间习俗，敏感地摄取老百姓过春节时的典型素材，抓住有代表性的生活细节：点燃爆竹，饮屠苏酒，换新桃符，充分表现出年节的欢乐气氛，富有浓厚的生活气息。\n\n　　“爆竹声中一岁除，春风送暖入屠苏。”逢年遇节燃放爆竹，这种习俗古已有之，一直延续至今。古代风俗，每年正月初一，全家老小喝屠苏酒，然后用红布把渣滓包起来，挂在门框上，用来“驱邪”和躲避瘟疫。\n\n　　第三句“千门万户曈曈日”，承接前面诗意，是说家家户户都沐浴在初春朝阳的光照之中。结尾一句描述转发议论。挂桃符，这也是古代民间的一种习俗。“总把新桃换旧符”，是个压缩省略的句式，“新桃”省略了“符”字，“旧符”省略了“桃”字，交替运用，这是因为七绝每句字数限制的缘故。\n\n　　诗是人们的心声。不少论诗者注意到，这首诗表现的意境和现实，还自有它的比喻象征意义，王安石这首诗充满欢快及积极向上的奋发精神，是因为他当时正出任宰相，推行新法。王安石是北宋时期著名的改革家，他在任期间，正如眼前人们把新的桃符代替旧的一样，革除旧政，施行新政。王安石对新政充满信心，所以反映到诗中就分外开朗。这首诗，正是赞美新事物的诞生如同“春风送暖”那样充满生机；“曈曈日”照着“千门万户”，这不是平常的太阳，而是新生活的开始，变法带给百姓的是一片光明。结尾一句“总把新桃换旧符”，表现了诗人对变法胜利和人民生活改善的欣慰喜悦之情。其中含有深刻哲理，指出新生事物总是要取代没落事物的这一规律。\n\n　　这首诗虽然用的是白描手法，极力渲染喜气洋洋的节日气氛，同时又通过元日更新的习俗来寄托自己的思想，表现得含而不露。\n\n','王安石,宋,离别,惜别,花鸟','/files/images/poem/8.jpg',NULL,NULL,NULL,'春','惜别','花鸟','春节','北宋','古风','白描','其他'),(20,'春日','朱熹','宋','诗','喜悦',1.0,0,0,'胜日寻芳泗水滨','胜日寻芳泗水滨，无边光景一时新。\n等闲识得东风面，万紫千红总是春。','风和日丽游春在泗水之滨，无边无际的风光焕然一新。\n谁都可以看出春天的面貌，春风吹得百花开放、万紫千红，到处都是春天的景致。\n\n','　　人们一般都认为这是一首咏春诗。从诗中所写的景物来看，也很像是这样。首句“胜日寻芳泗水滨”，“胜日”指晴日，点明天气。“泗水滨”点明地点。“寻芳”，即是寻觅美好的春景，点明了主题。下面三句都是写“寻芳”所见所得。次句“无边光景一时新”，写观赏春景中获得的初步印象。用“无边”形容视线所及的全部风光景物。“一时新”，既写出春回大地，自然景物焕然一新，也写出了作者郊游时耳目一新的欣喜感觉。第三句“等闲识得东风面”，句中的“识”字承首句中的“寻”字。“等闲识得”是说春天的面容与特征是很容易辨认的。“东风面”借指春天。第四句“万紫千红总是春”，是说这万紫千红的景象全是由春光点染而成的，人们从这万紫千红中认识了春天。感受到了春天的美。这就具体解答了为什么能“等闲识得东风面”。而此句的“万紫千红”又照应了第二句中的“光景一时新”。第三、四句是用形象的语言具体写出光景之新，寻芳所得。\n\n　　从字面上看，这首诗好像是写游春观感，但细究寻芳的地点是泗水之滨，而此地在宋南渡时早被金人侵占。朱熹未曾北上，当然不可能在泗水之滨游春吟赏。其实诗中的的“泗水”是暗指孔门，因为春秋时孔子曾在洙、泗之间弦歌讲学，教授弟子。因此所谓“寻访”即是指求圣人之道。“万紫千红”喻孔学的丰富多彩。诗人将圣人之道比作催发生机、点燃万物的春风。这其实是一首寓理趣于形象之中的哲理诗。\n\n','朱熹,宋,喜悦,欢快,江海','/files/images/poem/20.jpg',NULL,NULL,NULL,'春','欢快','江海','无','北宋','古风','白描','其他');
/*!40000 ALTER TABLE `poem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poem_banner`
--

DROP TABLE IF EXISTS `poem_banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poem_banner` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sub` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort_no` int DEFAULT '0',
  `enabled` tinyint DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poem_banner`
--

LOCK TABLES `poem_banner` WRITE;
/*!40000 ALTER TABLE `poem_banner` DISABLE KEYS */;
/*!40000 ALTER TABLE `poem_banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poem_fav`
--

DROP TABLE IF EXISTS `poem_fav`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poem_fav` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `poem_id` bigint NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_poem` (`user_id`,`poem_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poem_fav`
--

LOCK TABLES `poem_fav` WRITE;
/*!40000 ALTER TABLE `poem_fav` DISABLE KEYS */;
/*!40000 ALTER TABLE `poem_fav` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poem_locations`
--

DROP TABLE IF EXISTS `poem_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poem_locations` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `poem_id` bigint NOT NULL COMMENT '诗词ID',
  `location_id` bigint NOT NULL COMMENT '地点ID',
  `reference_type` enum('创作地','描写地','提及地') DEFAULT '描写地' COMMENT '关联类型',
  `reference_detail` varchar(500) DEFAULT NULL COMMENT '具体描述(如诗句引用)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_poem_location` (`poem_id`,`location_id`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `poem_locations_ibfk_1` FOREIGN KEY (`poem_id`) REFERENCES `poems` (`id`),
  CONSTRAINT `poem_locations_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=563 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='诗词地点关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poem_locations`
--

LOCK TABLES `poem_locations` WRITE;
/*!40000 ALTER TABLE `poem_locations` DISABLE KEYS */;
INSERT INTO `poem_locations` VALUES (1,1,1,'创作地','李白在长安创作','2026-03-16 14:38:44'),(2,1,5,'提及地','思乡之情','2026-03-16 14:38:44'),(3,2,1,'创作地','安史之乱期间','2026-03-16 14:38:44'),(4,3,5,'描写地','描写江南风光','2026-03-16 14:38:44'),(5,4,5,'描写地','描写西湖美景','2026-03-16 14:38:44'),(344,1,2,'提及地','思乡时联想曾游洛阳','2026-03-16 19:52:35'),(345,3,1,'提及地','作诗时遥想长安','2026-03-16 19:52:35'),(346,3,22,'提及地','庐山位于九江，创作背景','2026-03-16 19:52:35'),(347,6,4,'提及地','吴越之地包括扬州','2026-03-16 19:52:35'),(348,6,29,'提及地','天姥山在越地，绍兴为越州治所','2026-03-16 19:52:35'),(349,7,1,'提及地','送别时忆长安','2026-03-16 19:52:35'),(350,7,5,'提及地','广陵邻近杭州，同为江南','2026-03-16 19:52:35'),(351,7,8,'提及地','苏州亦属江南','2026-03-16 19:52:35'),(352,8,2,'提及地','春望时忆及洛阳','2026-03-16 19:52:41'),(353,8,11,'提及地','祖籍襄阳','2026-03-16 19:52:41'),(354,9,3,'提及地','登高时联想成都','2026-03-16 19:52:41'),(355,9,11,'提及地','登高望江，武汉为长江重镇','2026-03-16 19:52:41'),(356,10,1,'提及地','茅屋被吹，思念长安','2026-03-16 19:52:41'),(357,10,2,'提及地','忆洛阳','2026-03-16 19:52:41'),(358,11,1,'提及地','喜雨时思长安','2026-03-16 19:52:41'),(359,12,1,'提及地','望岳时向往长安','2026-03-16 19:52:41'),(360,12,2,'提及地','望岳时想洛阳','2026-03-16 19:52:41'),(361,13,2,'提及地','兵车行提及洛阳','2026-03-16 19:52:41'),(362,14,2,'提及地','长恨歌中涉及洛阳','2026-03-16 19:52:46'),(363,14,3,'提及地','玄宗奔蜀，成都','2026-03-16 19:52:46'),(364,15,2,'提及地','琵琶行中联想洛阳','2026-03-16 19:52:46'),(365,16,2,'提及地','送别时联想洛阳','2026-03-16 19:52:46'),(366,17,1,'提及地','忆江南对比长安','2026-03-16 19:52:46'),(367,17,2,'提及地','忆江南对比洛阳','2026-03-16 19:52:46'),(368,17,9,'提及地','江南忆，镇江亦属江南','2026-03-16 19:52:46'),(369,17,29,'提及地','江南忆，绍兴亦越地','2026-03-16 19:52:46'),(370,18,1,'提及地','钱塘湖春行思长安','2026-03-16 19:52:46'),(371,19,1,'提及地','终南山居，近长安','2026-03-16 19:52:51'),(372,20,1,'提及地','出使前在长安','2026-03-16 19:52:51'),(373,20,20,'提及地','途径敦煌','2026-03-16 19:52:51'),(374,21,2,'提及地','忆山东，洛阳亦在华山以东','2026-03-16 19:52:51'),(375,22,2,'提及地','西行经洛阳','2026-03-16 19:52:51'),(376,22,14,'提及地','西行经凉州','2026-03-16 19:52:51'),(377,23,1,'提及地','春晓时遥想长安','2026-03-16 19:52:56'),(378,24,5,'提及地','建德江在浙江，邻近杭州','2026-03-16 19:52:56'),(379,25,1,'提及地','过故人庄时联想长安','2026-03-16 19:52:56'),(380,33,1,'提及地','饮湖上时思京城','2026-03-16 19:53:12'),(381,33,3,'提及地','联想家乡蜀地','2026-03-16 19:53:12'),(382,33,4,'提及地','江南忆，扬州','2026-03-16 19:53:12'),(383,33,8,'提及地','江南忆，南京','2026-03-16 19:53:12'),(384,34,1,'提及地','题西林壁时思长安','2026-03-16 19:53:12'),(385,34,22,'提及地','庐山位于九江','2026-03-16 19:53:12'),(386,35,1,'提及地','赤壁怀古思故都长安','2026-03-16 19:53:12'),(387,35,2,'提及地','赤壁怀古思洛阳','2026-03-16 19:53:12'),(388,35,8,'提及地','赤壁怀古思建业','2026-03-16 19:53:12'),(389,35,9,'提及地','赤壁怀古思京口','2026-03-16 19:53:12'),(390,36,1,'提及地','水调歌头思君念长安','2026-03-16 19:53:12'),(391,36,2,'提及地','水调歌头思洛阳','2026-03-16 19:53:12'),(392,36,5,'提及地','水调歌头思弟在杭州','2026-03-16 19:53:12'),(393,36,3,'提及地','水调歌头思家乡眉山，成都为蜀地中心','2026-03-16 19:53:12'),(394,37,1,'提及地','惠崇春江思长安','2026-03-16 19:53:12'),(395,37,4,'提及地','春江晚景联想扬州','2026-03-16 19:53:12'),(396,37,8,'提及地','春江晚景联想南京','2026-03-16 19:53:12'),(397,38,1,'提及地','元夕思故都长安','2026-03-16 19:53:18'),(398,38,2,'提及地','元夕思洛阳','2026-03-16 19:53:18'),(399,39,1,'提及地','京口怀古思长安','2026-03-16 19:53:18'),(400,39,2,'提及地','京口怀古思洛阳','2026-03-16 19:53:18'),(401,39,5,'提及地','京口怀古思临安','2026-03-16 19:53:18'),(402,39,6,'提及地','京口怀古思汴梁','2026-03-16 19:53:18'),(403,39,8,'提及地','京口怀古思建康','2026-03-16 19:53:18'),(404,40,1,'提及地','破阵子思长安','2026-03-16 19:53:18'),(405,40,2,'提及地','破阵子思洛阳','2026-03-16 19:53:18'),(406,40,5,'提及地','破阵子思临安','2026-03-16 19:53:18'),(407,40,6,'提及地','破阵子思汴梁','2026-03-16 19:53:18'),(408,41,1,'提及地','如梦令思故都','2026-03-16 19:53:26'),(409,41,2,'提及地','如梦令思洛阳','2026-03-16 19:53:26'),(410,41,5,'提及地','如梦令念杭州','2026-03-16 19:53:26'),(411,41,6,'提及地','如梦令忆汴京','2026-03-16 19:53:26'),(412,41,8,'提及地','如梦令忆江宁','2026-03-16 19:53:26'),(413,42,1,'提及地','一剪梅思长安','2026-03-16 19:53:26'),(414,42,2,'提及地','一剪梅思洛阳','2026-03-16 19:53:26'),(415,42,5,'提及地','一剪梅念杭州','2026-03-16 19:53:26'),(416,42,8,'提及地','一剪梅忆江宁','2026-03-16 19:53:26'),(417,43,1,'提及地','声声慢思长安','2026-03-16 19:53:26'),(418,43,2,'提及地','声声慢思洛阳','2026-03-16 19:53:26'),(419,43,5,'提及地','声声慢念杭州','2026-03-16 19:53:26'),(420,43,6,'提及地','声声慢忆汴京','2026-03-16 19:53:26'),(421,43,8,'提及地','声声慢忆江宁','2026-03-16 19:53:26'),(474,83,45,'创作地','边塞诗创作背景','2026-03-18 17:37:45'),(475,83,6,'创作地','边塞诗创作背景','2026-03-18 17:37:45'),(476,83,1,'创作地','边塞诗创作背景','2026-03-18 17:37:45'),(477,84,46,'提及地','洛阳亲友','2026-03-18 17:37:45'),(478,84,7,'提及地','洛阳亲友','2026-03-18 17:37:45'),(479,84,2,'提及地','洛阳亲友','2026-03-18 17:37:45'),(481,85,58,'创作地','登楼远眺','2026-03-18 17:37:50'),(482,85,19,'创作地','登楼远眺','2026-03-18 17:37:50'),(483,86,63,'创作地','凉州词创作','2026-03-18 17:37:50'),(484,86,24,'创作地','凉州词创作','2026-03-18 17:37:50'),(488,88,53,'创作地','南京怀古','2026-03-18 17:38:33'),(489,88,14,'创作地','南京怀古','2026-03-18 17:38:33'),(490,89,56,'创作地','竹枝词创作','2026-03-18 17:38:33'),(491,89,17,'创作地','竹枝词创作','2026-03-18 17:38:33'),(495,90,58,'创作地','永州创作','2026-03-18 17:38:33'),(496,90,19,'创作地','永州创作','2026-03-18 17:38:33'),(498,98,53,'提及地','杏花村所在地','2026-03-18 17:38:33'),(499,98,14,'提及地','杏花村所在地','2026-03-18 17:38:33'),(500,99,53,'创作地','秦淮河畔','2026-03-18 17:38:33'),(501,99,14,'创作地','秦淮河畔','2026-03-18 17:38:33'),(505,104,58,'创作地','黄州创作','2026-03-18 17:38:33'),(506,104,19,'创作地','黄州创作','2026-03-18 17:38:33'),(508,105,81,'创作地','镇江登临','2026-03-18 17:38:33'),(509,105,42,'创作地','镇江登临','2026-03-18 17:38:33'),(511,106,50,'创作地','重阳词','2026-03-18 17:38:33'),(512,106,11,'创作地','重阳词','2026-03-18 17:38:33'),(513,106,5,'创作地','重阳词','2026-03-18 17:38:33'),(514,107,82,'创作地','晚年金华','2026-03-18 17:38:33'),(515,107,43,'创作地','晚年金华','2026-03-18 17:38:33'),(518,108,80,'创作地','绍兴沈园','2026-03-18 17:38:33'),(519,108,41,'创作地','绍兴沈园','2026-03-18 17:38:33'),(521,110,53,'创作地','滁州醉翁亭','2026-03-18 17:38:33'),(522,110,14,'创作地','滁州醉翁亭','2026-03-18 17:38:33'),(524,112,81,'创作地','瓜洲渡口','2026-03-18 17:38:33'),(525,112,42,'创作地','瓜洲渡口','2026-03-18 17:38:33'),(527,114,58,'提及地','岳阳楼所在地','2026-03-18 17:38:33'),(528,114,19,'提及地','岳阳楼所在地','2026-03-18 17:38:33'),(530,117,50,'创作地','杭州繁华','2026-03-18 17:38:33'),(531,117,11,'创作地','杭州繁华','2026-03-18 17:38:33'),(532,117,5,'创作地','杭州繁华','2026-03-18 17:38:33'),(533,120,60,'创作地','楚辞创作','2026-03-18 17:38:33'),(534,120,21,'创作地','楚辞创作','2026-03-18 17:38:33'),(535,121,58,'提及地','洞庭湖','2026-03-18 17:38:33'),(536,121,19,'提及地','洞庭湖','2026-03-18 17:38:33'),(540,122,70,'创作地','归隐田园','2026-03-18 17:38:33'),(541,122,31,'创作地','归隐田园','2026-03-18 17:38:33'),(542,123,70,'创作地','田园生活','2026-03-18 17:38:33'),(543,123,31,'创作地','田园生活','2026-03-18 17:38:33'),(547,126,66,'创作地','东临碣石','2026-03-18 17:38:33'),(548,126,27,'创作地','东临碣石','2026-03-18 17:38:33'),(550,127,46,'创作地','七步成诗','2026-03-18 17:38:33'),(551,127,7,'创作地','七步成诗','2026-03-18 17:38:33'),(552,127,2,'创作地','七步成诗','2026-03-18 17:38:33'),(553,128,46,'创作地','洛神赋创作','2026-03-18 17:38:33'),(554,128,7,'创作地','洛神赋创作','2026-03-18 17:38:33'),(555,128,2,'创作地','洛神赋创作','2026-03-18 17:38:33'),(557,129,69,'创作地','滕王阁即兴','2026-03-18 17:38:33'),(558,129,30,'创作地','滕王阁即兴','2026-03-18 17:38:33'),(560,132,48,'创作地','秋思名篇','2026-03-18 17:38:33'),(561,132,9,'创作地','秋思名篇','2026-03-18 17:38:33');
/*!40000 ALTER TABLE `poem_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poems`
--

DROP TABLE IF EXISTS `poems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poems` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(200) NOT NULL COMMENT '诗词标题',
  `poet_id` bigint NOT NULL COMMENT '诗人ID',
  `content` text COMMENT '诗词内容',
  `dynasty` varchar(50) DEFAULT NULL COMMENT '朝代',
  `create_year` int DEFAULT NULL COMMENT '创作年份',
  `description` text COMMENT '诗词简介',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_poet_id` (`poet_id`),
  KEY `idx_dynasty` (`dynasty`),
  CONSTRAINT `poems_ibfk_1` FOREIGN KEY (`poet_id`) REFERENCES `poets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='诗词信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poems`
--

LOCK TABLES `poems` WRITE;
/*!40000 ALTER TABLE `poems` DISABLE KEYS */;
INSERT INTO `poems` VALUES (1,'静夜思',1,'床前明月光，疑是地上霜。举头望明月，低头思故乡。','唐',NULL,'思乡之作','2026-03-16 14:38:39','2026-03-16 14:38:39'),(2,'春望',2,'国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。','唐',NULL,'忧国忧民','2026-03-16 14:38:39','2026-03-16 14:38:39'),(3,'忆江南',3,'江南好，风景旧曾谙。日出江花红胜火，春来江水绿如蓝。能不忆江南？','唐',NULL,'赞美江南','2026-03-16 14:38:39','2026-03-16 14:38:39'),(4,'饮湖上初晴后雨',4,'水光潋滟晴方好，山色空蒙雨亦奇。欲把西湖比西子，淡妆浓抹总相宜。','宋',NULL,'赞美西湖','2026-03-16 14:38:39','2026-03-16 14:38:39'),(5,'静夜思',1,'床前明月光，疑是地上霜。举头望明月，低头思故乡。','唐',726,'思乡名作，语言简洁意境深远','2026-03-16 19:34:10','2026-03-16 19:34:10'),(6,'将进酒',1,'君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。','唐',752,'豪放派代表作，借酒抒怀','2026-03-16 19:34:10','2026-03-16 19:34:10'),(7,'望庐山瀑布',1,'日照香炉生紫烟，遥看瀑布挂前川。飞流直下三千尺，疑是银河落九天。','唐',726,'描绘庐山瀑布壮丽景色','2026-03-16 19:34:10','2026-03-16 19:34:10'),(8,'行路难',1,'金樽清酒斗十千，玉盘珍羞直万钱。停杯投箸不能食，拔剑四顾心茫然。欲渡黄河冰塞川，将登太行雪满山。闲来垂钓碧溪上，忽复乘舟梦日边。行路难，行路难，多歧路，今安在？长风破浪会有时，直挂云帆济沧海。','唐',744,'抒发怀才不遇之情','2026-03-16 19:34:10','2026-03-16 19:34:10'),(9,'蜀道难',1,'噫吁嚱，危乎高哉！蜀道之难，难于上青天！蚕丛及鱼凫，开国何茫然！尔来四万八千岁，不与秦塞通人烟。','唐',730,'描绘蜀道艰险','2026-03-16 19:34:10','2026-03-16 19:34:10'),(10,'梦游天姥吟留别',1,'海客谈瀛洲，烟涛微茫信难求。越人语天姥，云霞明灭或可睹。天姥连天向天横，势拔五岳掩赤城。天台四万八千丈，对此欲倒东南倾。','唐',745,'浪漫主义代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(11,'黄鹤楼送孟浩然之广陵',1,'故人西辞黄鹤楼，烟花三月下扬州。孤帆远影碧空尽，唯见长江天际流。','唐',730,'送别诗名作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(12,'春望',2,'国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。','唐',757,'安史之乱时期代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(13,'登高',2,'风急天高猿啸哀，渚清沙白鸟飞回。无边落木萧萧下，不尽长江滚滚来。万里悲秋常作客，百年多病独登台。艰难苦恨繁霜鬓，潦倒新停浊酒杯。','唐',767,'被称为\"七律之冠\"','2026-03-16 19:34:10','2026-03-16 19:34:10'),(14,'茅屋为秋风所破歌',2,'八月秋高风怒号，卷我屋上三重茅。茅飞渡江洒江郊，高者挂罥长林梢，下者飘转沉塘坳。南村群童欺我老无力，忍能对面为盗贼。公然抱茅入竹去，唇焦口燥呼不得，归来倚杖自叹息。','唐',761,'描写民生疾苦','2026-03-16 19:34:10','2026-03-16 19:34:10'),(15,'春夜喜雨',2,'好雨知时节，当春乃发生。随风潜入夜，润物细无声。野径云俱黑，江船火独明。晓看红湿处，花重锦官城。','唐',761,'描绘成都春夜喜雨','2026-03-16 19:34:10','2026-03-16 19:34:10'),(16,'望岳',2,'岱宗夫如何？齐鲁青未了。造化钟神秀，阴阳割昏晓。荡胸生曾云，决眦入归鸟。会当凌绝顶，一览众山小。','唐',736,'青年时期作品，气势磅礴','2026-03-16 19:34:10','2026-03-16 19:34:10'),(17,'兵车行',2,'车辚辚，马萧萧，行人弓箭各在腰。爷娘妻子走相送，尘埃不见咸阳桥。牵衣顿足拦道哭，哭声直上干云霄。','唐',750,'反战诗代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(18,'长恨歌',3,'汉皇重色思倾国，御宇多年求不得。杨家有女初长成，养在深闺人未识。天生丽质难自弃，一朝选在君王侧。回眸一笑百媚生，六宫粉黛无颜色。','唐',806,'长篇叙事诗，描写李杨爱情','2026-03-16 19:34:10','2026-03-16 19:34:10'),(19,'琵琶行',3,'浔阳江头夜送客，枫叶荻花秋瑟瑟。主人下马客在船，举酒欲饮无管弦。醉不成欢惨将别，别时茫茫江浸月。忽闻水上琵琶声，主人忘归客不发。','唐',816,'叙事长诗，抒发光彩','2026-03-16 19:34:10','2026-03-16 19:34:10'),(20,'赋得古原草送别',3,'离离原上草，一岁一枯荣。野火烧不尽，春风吹又生。远芳侵古道，晴翠接荒城。又送王孙去，萋萋满别情。','唐',788,'少年成名作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(21,'忆江南三首',3,'江南好，风景旧曾谙。日出江花红胜火，春来江水绿如蓝。能不忆江南？\n江南忆，最忆是杭州。山寺月中寻桂子，郡亭枕上看潮头。何日更重游？\n江南忆，其次忆吴宫。吴酒一杯春竹叶，吴娃双舞醉芙蓉。早晚复相逢？','唐',838,'赞美江南风光','2026-03-16 19:34:10','2026-03-16 19:34:10'),(22,'钱塘湖春行',3,'孤山寺北贾亭西，水面初平云脚低。几处早莺争暖树，谁家新燕啄春泥。乱花渐欲迷人眼，浅草才能没马蹄。最爱湖东行不足，绿杨阴里白沙堤。','唐',823,'描写西湖春景','2026-03-16 19:34:10','2026-03-16 19:34:10'),(23,'山居秋暝',4,'空山新雨后，天气晚来秋。明月松间照，清泉石上流。竹喧归浣女，莲动下渔舟。随意春芳歇，王孙自可留。','唐',740,'山水田园诗代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(24,'使至塞上',4,'单车欲问边，属国过居延。征蓬出汉塞，归雁入胡天。大漠孤烟直，长河落日圆。萧关逢候骑，都护在燕然。','唐',737,'边塞诗名篇','2026-03-16 19:34:10','2026-03-16 19:34:10'),(25,'九月九日忆山东兄弟',4,'独在异乡为异客，每逢佳节倍思亲。遥知兄弟登高处，遍插茱萸少一人。','唐',717,'思乡怀亲名作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(26,'送元二使安西',4,'渭城朝雨浥轻尘，客舍青青柳色新。劝君更尽一杯酒，西出阳关无故人。','唐',750,'送别名篇','2026-03-16 19:34:10','2026-03-16 19:34:10'),(27,'春晓',5,'春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。','唐',730,'家喻户晓的春景诗','2026-03-16 19:34:10','2026-03-16 19:34:10'),(28,'宿建德江',5,'移舟泊烟渚，日暮客愁新。野旷天低树，江清月近人。','唐',728,'羁旅诗名篇','2026-03-16 19:34:10','2026-03-16 19:34:10'),(29,'过故人庄',5,'故人具鸡黍，邀我至田家。绿树村边合，青山郭外斜。开轩面场圃，把酒话桑麻。待到重阳日，还来就菊花。','唐',735,'田园诗代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(30,'饮湖上初晴后雨',17,'水光潋滟晴方好，山色空蒙雨亦奇。欲把西湖比西子，淡妆浓抹总相宜。','宋',1073,'赞美西湖的绝唱','2026-03-16 19:34:10','2026-03-16 19:34:10'),(31,'题西林壁',17,'横看成岭侧成峰，远近高低各不同。不识庐山真面目，只缘身在此山中。','宋',1084,'哲理诗名篇','2026-03-16 19:34:10','2026-03-16 19:34:10'),(32,'念奴娇·赤壁怀古',17,'大江东去，浪淘尽，千古风流人物。故垒西边，人道是，三国周郎赤壁。乱石穿空，惊涛拍岸，卷起千堆雪。江山如画，一时多少豪杰。','宋',1082,'豪放词代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(33,'水调歌头·明月几时有',17,'明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。','宋',1076,'中秋词名篇','2026-03-16 19:34:10','2026-03-16 19:34:10'),(34,'惠崇春江晚景',17,'竹外桃花三两枝，春江水暖鸭先知。蒌蒿满地芦芽短，正是河豚欲上时。','宋',1085,'题画诗佳作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(35,'青玉案·元夕',19,'东风夜放花千树，更吹落、星如雨。宝马雕车香满路。凤箫声动，玉壶光转，一夜鱼龙舞。蛾儿雪柳黄金缕，笑语盈盈暗香去。众里寻他千百度，蓦然回首，那人却在，灯火阑珊处。','宋',1175,'婉约词代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(36,'永遇乐·京口北固亭怀古',19,'千古江山，英雄无觅，孙仲谋处。舞榭歌台，风流总被，雨打风吹去。斜阳草树，寻常巷陌，人道寄奴曾住。想当年，金戈铁马，气吞万里如虎。','宋',1205,'豪放词代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(37,'破阵子·为陈同甫赋壮词以寄之',19,'醉里挑灯看剑，梦回吹角连营。八百里分麾下炙，五十弦翻塞外声。沙场秋点兵。马作的卢飞快，弓如霹雳弦惊。了却君王天下事，赢得生前身后名。可怜白发生！','宋',1188,'爱国词代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(38,'如梦令·常记溪亭日暮',20,'常记溪亭日暮，沉醉不知归路。兴尽晚回舟，误入藕花深处。争渡，争渡，惊起一滩鸥鹭。','宋',1100,'早期代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(39,'一剪梅·红藕香残玉簟秋',20,'红藕香残玉簟秋。轻解罗裳，独上兰舟。云中谁寄锦书来？雁字回时，月满西楼。花自飘零水自流。一种相思，两处闲愁。此情无计可消除，才下眉头，却上心头。','宋',1120,'婉约词名篇','2026-03-16 19:34:10','2026-03-16 19:34:10'),(40,'声声慢·寻寻觅觅',20,'寻寻觅觅，冷冷清清，凄凄惨惨戚戚。乍暖还寒时候，最难将息。三杯两盏淡酒，怎敌他、晚来风急！雁过也，正伤心，却是旧时相识。','宋',1140,'晚期代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(41,'示儿',21,'死去元知万事空，但悲不见九州同。王师北定中原日，家祭无忘告乃翁。','宋',1210,'临终绝笔，爱国情怀','2026-03-16 19:34:10','2026-03-16 19:34:10'),(42,'游山西村',21,'莫笑农家腊酒浑，丰年留客足鸡豚。山重水复疑无路，柳暗花明又一村。箫鼓追随春社近，衣冠简朴古风存。从今若许闲乘月，拄杖无时夜叩门。','宋',1167,'哲理诗名篇','2026-03-16 19:34:10','2026-03-16 19:34:10'),(43,'十一月四日风雨大作',21,'僵卧孤村不自哀，尚思为国戍轮台。夜阑卧听风吹雨，铁马冰河入梦来。','宋',1192,'爱国诗代表作','2026-03-16 19:34:10','2026-03-16 19:34:10'),(44,'静夜思',1,'床前明月光，疑是地上霜。举头望明月，低头思故乡。','唐',726,'思乡名作，语言简洁意境深远','2026-03-18 17:21:38','2026-03-18 17:21:38'),(45,'将进酒',1,'君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。','唐',752,'豪放派代表作，借酒抒怀','2026-03-18 17:21:38','2026-03-18 17:21:38'),(46,'望庐山瀑布',1,'日照香炉生紫烟，遥看瀑布挂前川。飞流直下三千尺，疑是银河落九天。','唐',726,'描绘庐山瀑布壮丽景色','2026-03-18 17:21:38','2026-03-18 17:21:38'),(47,'行路难',1,'金樽清酒斗十千，玉盘珍羞直万钱。停杯投箸不能食，拔剑四顾心茫然。欲渡黄河冰塞川，将登太行雪满山。闲来垂钓碧溪上，忽复乘舟梦日边。行路难，行路难，多歧路，今安在？长风破浪会有时，直挂云帆济沧海。','唐',744,'抒发怀才不遇之情','2026-03-18 17:21:38','2026-03-18 17:21:38'),(48,'蜀道难',1,'噫吁嚱，危乎高哉！蜀道之难，难于上青天！蚕丛及鱼凫，开国何茫然！尔来四万八千岁，不与秦塞通人烟。','唐',730,'描绘蜀道艰险','2026-03-18 17:21:38','2026-03-18 17:21:38'),(49,'梦游天姥吟留别',1,'海客谈瀛洲，烟涛微茫信难求。越人语天姥，云霞明灭或可睹。天姥连天向天横，势拔五岳掩赤城。天台四万八千丈，对此欲倒东南倾。','唐',745,'浪漫主义代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(50,'黄鹤楼送孟浩然之广陵',1,'故人西辞黄鹤楼，烟花三月下扬州。孤帆远影碧空尽，唯见长江天际流。','唐',730,'送别诗名作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(51,'春望',2,'国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。','唐',757,'安史之乱时期代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(52,'登高',2,'风急天高猿啸哀，渚清沙白鸟飞回。无边落木萧萧下，不尽长江滚滚来。万里悲秋常作客，百年多病独登台。艰难苦恨繁霜鬓，潦倒新停浊酒杯。','唐',767,'被称为\"七律之冠\"','2026-03-18 17:21:38','2026-03-18 17:21:38'),(53,'茅屋为秋风所破歌',2,'八月秋高风怒号，卷我屋上三重茅。茅飞渡江洒江郊，高者挂罥长林梢，下者飘转沉塘坳。南村群童欺我老无力，忍能对面为盗贼。公然抱茅入竹去，唇焦口燥呼不得，归来倚杖自叹息。','唐',761,'描写民生疾苦','2026-03-18 17:21:38','2026-03-18 17:21:38'),(54,'春夜喜雨',2,'好雨知时节，当春乃发生。随风潜入夜，润物细无声。野径云俱黑，江船火独明。晓看红湿处，花重锦官城。','唐',761,'描绘成都春夜喜雨','2026-03-18 17:21:38','2026-03-18 17:21:38'),(55,'望岳',2,'岱宗夫如何？齐鲁青未了。造化钟神秀，阴阳割昏晓。荡胸生曾云，决眦入归鸟。会当凌绝顶，一览众山小。','唐',736,'青年时期作品，气势磅礴','2026-03-18 17:21:38','2026-03-18 17:21:38'),(56,'兵车行',2,'车辚辚，马萧萧，行人弓箭各在腰。爷娘妻子走相送，尘埃不见咸阳桥。牵衣顿足拦道哭，哭声直上干云霄。','唐',750,'反战诗代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(57,'长恨歌',3,'汉皇重色思倾国，御宇多年求不得。杨家有女初长成，养在深闺人未识。天生丽质难自弃，一朝选在君王侧。回眸一笑百媚生，六宫粉黛无颜色。','唐',806,'长篇叙事诗，描写李杨爱情','2026-03-18 17:21:38','2026-03-18 17:21:38'),(58,'琵琶行',3,'浔阳江头夜送客，枫叶荻花秋瑟瑟。主人下马客在船，举酒欲饮无管弦。醉不成欢惨将别，别时茫茫江浸月。忽闻水上琵琶声，主人忘归客不发。','唐',816,'叙事长诗，抒发光彩','2026-03-18 17:21:38','2026-03-18 17:21:38'),(59,'赋得古原草送别',3,'离离原上草，一岁一枯荣。野火烧不尽，春风吹又生。远芳侵古道，晴翠接荒城。又送王孙去，萋萋满别情。','唐',788,'少年成名作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(60,'忆江南三首',3,'江南好，风景旧曾谙。日出江花红胜火，春来江水绿如蓝。能不忆江南？\n江南忆，最忆是杭州。山寺月中寻桂子，郡亭枕上看潮头。何日更重游？\n江南忆，其次忆吴宫。吴酒一杯春竹叶，吴娃双舞醉芙蓉。早晚复相逢？','唐',838,'赞美江南风光','2026-03-18 17:21:38','2026-03-18 17:21:38'),(61,'钱塘湖春行',3,'孤山寺北贾亭西，水面初平云脚低。几处早莺争暖树，谁家新燕啄春泥。乱花渐欲迷人眼，浅草才能没马蹄。最爱湖东行不足，绿杨阴里白沙堤。','唐',823,'描写西湖春景','2026-03-18 17:21:38','2026-03-18 17:21:38'),(62,'山居秋暝',4,'空山新雨后，天气晚来秋。明月松间照，清泉石上流。竹喧归浣女，莲动下渔舟。随意春芳歇，王孙自可留。','唐',740,'山水田园诗代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(63,'使至塞上',4,'单车欲问边，属国过居延。征蓬出汉塞，归雁入胡天。大漠孤烟直，长河落日圆。萧关逢候骑，都护在燕然。','唐',737,'边塞诗名篇','2026-03-18 17:21:38','2026-03-18 17:21:38'),(64,'九月九日忆山东兄弟',4,'独在异乡为异客，每逢佳节倍思亲。遥知兄弟登高处，遍插茱萸少一人。','唐',717,'思乡怀亲名作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(65,'送元二使安西',4,'渭城朝雨浥轻尘，客舍青青柳色新。劝君更尽一杯酒，西出阳关无故人。','唐',750,'送别名篇','2026-03-18 17:21:38','2026-03-18 17:21:38'),(66,'春晓',5,'春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。','唐',730,'家喻户晓的春景诗','2026-03-18 17:21:38','2026-03-18 17:21:38'),(67,'宿建德江',5,'移舟泊烟渚，日暮客愁新。野旷天低树，江清月近人。','唐',728,'羁旅诗名篇','2026-03-18 17:21:38','2026-03-18 17:21:38'),(68,'过故人庄',5,'故人具鸡黍，邀我至田家。绿树村边合，青山郭外斜。开轩面场圃，把酒话桑麻。待到重阳日，还来就菊花。','唐',735,'田园诗代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(69,'饮湖上初晴后雨',17,'水光潋滟晴方好，山色空蒙雨亦奇。欲把西湖比西子，淡妆浓抹总相宜。','宋',1073,'赞美西湖的绝唱','2026-03-18 17:21:38','2026-03-18 17:21:38'),(70,'题西林壁',17,'横看成岭侧成峰，远近高低各不同。不识庐山真面目，只缘身在此山中。','宋',1084,'哲理诗名篇','2026-03-18 17:21:38','2026-03-18 17:21:38'),(71,'念奴娇·赤壁怀古',17,'大江东去，浪淘尽，千古风流人物。故垒西边，人道是，三国周郎赤壁。乱石穿空，惊涛拍岸，卷起千堆雪。江山如画，一时多少豪杰。','宋',1082,'豪放词代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(72,'水调歌头·明月几时有',17,'明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。','宋',1076,'中秋词名篇','2026-03-18 17:21:38','2026-03-18 17:21:38'),(73,'惠崇春江晚景',17,'竹外桃花三两枝，春江水暖鸭先知。蒌蒿满地芦芽短，正是河豚欲上时。','宋',1085,'题画诗佳作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(74,'青玉案·元夕',19,'东风夜放花千树，更吹落、星如雨。宝马雕车香满路。凤箫声动，玉壶光转，一夜鱼龙舞。蛾儿雪柳黄金缕，笑语盈盈暗香去。众里寻他千百度，蓦然回首，那人却在，灯火阑珊处。','宋',1175,'婉约词代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(75,'永遇乐·京口北固亭怀古',19,'千古江山，英雄无觅，孙仲谋处。舞榭歌台，风流总被，雨打风吹去。斜阳草树，寻常巷陌，人道寄奴曾住。想当年，金戈铁马，气吞万里如虎。','宋',1205,'豪放词代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(76,'破阵子·为陈同甫赋壮词以寄之',19,'醉里挑灯看剑，梦回吹角连营。八百里分麾下炙，五十弦翻塞外声。沙场秋点兵。马作的卢飞快，弓如霹雳弦惊。了却君王天下事，赢得生前身后名。可怜白发生！','宋',1188,'爱国词代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(77,'如梦令·常记溪亭日暮',20,'常记溪亭日暮，沉醉不知归路。兴尽晚回舟，误入藕花深处。争渡，争渡，惊起一滩鸥鹭。','宋',1100,'早期代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(78,'一剪梅·红藕香残玉簟秋',20,'红藕香残玉簟秋。轻解罗裳，独上兰舟。云中谁寄锦书来？雁字回时，月满西楼。花自飘零水自流。一种相思，两处闲愁。此情无计可消除，才下眉头，却上心头。','宋',1120,'婉约词名篇','2026-03-18 17:21:38','2026-03-18 17:21:38'),(79,'声声慢·寻寻觅觅',20,'寻寻觅觅，冷冷清清，凄凄惨惨戚戚。乍暖还寒时候，最难将息。三杯两盏淡酒，怎敌他、晚来风急！雁过也，正伤心，却是旧时相识。','宋',1140,'晚期代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(80,'示儿',21,'死去元知万事空，但悲不见九州同。王师北定中原日，家祭无忘告乃翁。','宋',1210,'临终绝笔，爱国情怀','2026-03-18 17:21:38','2026-03-18 17:21:38'),(81,'游山西村',21,'莫笑农家腊酒浑，丰年留客足鸡豚。山重水复疑无路，柳暗花明又一村。箫鼓追随春社近，衣冠简朴古风存。从今若许闲乘月，拄杖无时夜叩门。','宋',1167,'哲理诗名篇','2026-03-18 17:21:38','2026-03-18 17:21:38'),(82,'十一月四日风雨大作',21,'僵卧孤村不自哀，尚思为国戍轮台。夜阑卧听风吹雨，铁马冰河入梦来。','宋',1192,'爱国诗代表作','2026-03-18 17:21:38','2026-03-18 17:21:38'),(83,'出塞',8,'秦时明月汉时关，万里长征人未还。但使龙城飞将在，不教胡马度阴山。','唐',724,'边塞诗名篇，被誉为唐人七绝压卷之作','2026-03-18 17:36:56','2026-03-18 17:36:56'),(84,'芙蓉楼送辛渐',8,'寒雨连江夜入吴，平明送客楚山孤。洛阳亲友如相问，一片冰心在玉壶。','唐',748,'送别名篇，\"一片冰心在玉壶\"为千古名句','2026-03-18 17:36:56','2026-03-18 17:36:56'),(85,'登鹳雀楼',9,'白日依山尽，黄河入海流。欲穷千里目，更上一层楼。','唐',723,'哲理诗名篇，家喻户晓','2026-03-18 17:36:56','2026-03-18 17:36:56'),(86,'凉州词',9,'黄河远上白云间，一片孤城万仞山。羌笛何须怨杨柳，春风不度玉门关。','唐',726,'边塞诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(87,'陋室铭',10,'山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。','唐',824,'散文诗，表达高洁志趣','2026-03-18 17:36:56','2026-03-18 17:36:56'),(88,'乌衣巷',10,'朱雀桥边野草花，乌衣巷口夕阳斜。旧时王谢堂前燕，飞入寻常百姓家。','唐',826,'怀古诗名篇，感慨世事沧桑','2026-03-18 17:36:56','2026-03-18 17:36:56'),(89,'竹枝词',10,'杨柳青青江水平，闻郎江上唱歌声。东边日出西边雨，道是无晴却有晴。','唐',822,'民歌体诗作','2026-03-18 17:36:56','2026-03-18 17:36:56'),(90,'江雪',11,'千山鸟飞绝，万径人踪灭。孤舟蓑笠翁，独钓寒江雪。','唐',817,'山水诗名篇，意境孤寂高远','2026-03-18 17:36:56','2026-03-18 17:36:56'),(91,'白雪歌送武判官归京',12,'北风卷地白草折，胡天八月即飞雪。忽如一夜春风来，千树万树梨花开。散入珠帘湿罗幕，狐裘不暖锦衾薄。','唐',754,'边塞诗名篇，\"千树万树梨花开\"为千古名句','2026-03-18 17:36:56','2026-03-18 17:36:56'),(92,'滁州西涧',13,'独怜幽草涧边生，上有黄鹂深树鸣。春潮带雨晚来急，野渡无人舟自横。','唐',785,'山水诗名篇，意境幽静','2026-03-18 17:36:56','2026-03-18 17:36:56'),(93,'望月怀远',14,'海上生明月，天涯共此时。情人怨遥夜，竟夕起相思。灭烛怜光满，披衣觉露滋。','唐',736,'望月思远名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(94,'登幽州台歌',15,'前不见古人，后不见来者。念天地之悠悠，独怆然而涕下。','唐',696,'怀古诗名篇，意境苍凉','2026-03-18 17:36:56','2026-03-18 17:36:56'),(95,'无题',6,'相见时难别亦难，东风无力百花残。春蚕到死丝方尽，蜡炬成灰泪始干。晓镜但愁云鬓改，夜吟应觉月光寒。','唐',850,'爱情诗名篇，\"春蚕到死丝方尽\"为千古名句','2026-03-18 17:36:56','2026-03-18 17:36:56'),(96,'锦瑟',6,'锦瑟无端五十弦，一弦一柱思华年。庄生晓梦迷蝴蝶，望帝春心托杜鹃。沧海月明珠有泪，蓝田日暖玉生烟。此情可待成追忆，只是当时已惘然。','唐',858,'代表作，意境朦胧优美','2026-03-18 17:36:56','2026-03-18 17:36:56'),(97,'夜雨寄北',6,'君问归期未有期，巴山夜雨涨秋池。何当共剪西窗烛，却话巴山夜雨时。','唐',851,'思乡怀人名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(98,'清明',7,'清明时节雨纷纷，路上行人欲断魂。借问酒家何处有，牧童遥指杏花村。','唐',845,'清明节名篇，家喻户晓','2026-03-18 17:36:56','2026-03-18 17:36:56'),(99,'泊秦淮',7,'烟笼寒水月笼沙，夜泊秦淮近酒家。商女不知亡国恨，隔江犹唱后庭花。','唐',846,'咏史怀古诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(100,'山行',7,'远上寒山石径斜，白云生处有人家。停车坐爱枫林晚，霜叶红于二月花。','唐',844,'秋景诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(101,'秋夕',7,'银烛秋光冷画屏，轻罗小扇扑流萤。天阶夜色凉如水，坐看牵牛织女星。','唐',848,'七夕诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(102,'逍遥堂会宿',18,'逍遥堂后千寻木，长送中宵风雨声。误喜对床寻旧约，不知漂泊在彭城。','宋',1077,'与兄苏轼唱和之作','2026-03-18 17:36:56','2026-03-18 17:36:56'),(103,'欧阳永叔白兔',27,'飞鹰搏平原，禽兽乱衰草。孤兔未及惊，已落韩卢口。','宋',1056,'咏物诗','2026-03-18 17:36:56','2026-03-18 17:36:56'),(104,'西江月·夜行黄沙道中',19,'明月别枝惊鹊，清风半夜鸣蝉。稻花香里说丰年，听取蛙声一片。七八个星天外，两三点雨山前。旧时茅店社林边，路转溪桥忽见。','宋',1188,'田园词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(105,'南乡子·登京口北固亭有怀',19,'何处望神州？满眼风光北固楼。千古兴亡多少事？悠悠。不尽长江滚滚流。年少万兜鍪，坐断东南战未休。天下英雄谁敌手？曹刘。生子当如孙仲谋。','宋',1204,'怀古词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(106,'醉花阴',20,'薄雾浓云愁永昼，瑞脑销金兽。佳节又重阳，玉枕纱厨，半夜凉初透。东篱把酒黄昏后，有暗香盈袖。莫道不销魂，帘卷西风，人比黄花瘦。','宋',1103,'重阳词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(107,'武陵春',20,'风住尘香花已尽，日晚倦梳头。物是人非事事休，欲语泪先流。闻说双溪春尚好，也拟泛轻舟。只恐双溪舴艋舟，载不动许多愁。','宋',1134,'晚年代表作','2026-03-18 17:36:56','2026-03-18 17:36:56'),(108,'沈园二首',21,'城上斜阳画角哀，沈园非复旧池台。伤心桥下春波绿，曾是惊鸿照影来。梦断香消四十年，沈园柳老不吹绵。此身行作稽山土，犹吊遗踪一泫然。','宋',1199,'悼念唐婉之作，感人至深','2026-03-18 17:36:56','2026-03-18 17:36:56'),(109,'书愤',21,'早岁那知世事艰，中原北望气如山。楼船夜雪瓜洲渡，铁马秋风大散关。塞上长城空自许，镜中衰鬓已先斑。出师一表真名世，千载谁堪伯仲间。','宋',1186,'爱国诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(110,'醉翁亭记',22,'环滁皆山也。其西南诸峰，林壑尤美，望之蔚然而深秀者，琅琊也。山行六七里，渐闻水声潺潺，而泻出于两峰之间者，酿泉也。','宋',1046,'散文诗名篇，\"醉翁之意不在酒\"','2026-03-18 17:36:56','2026-03-18 17:36:56'),(111,'蝶恋花',22,'庭院深深深几许，杨柳堆烟，帘幕无重数。玉勒雕鞍游冶处，楼高不见章台路。雨横风狂三月暮，门掩黄昏，无计留春住。泪眼问花花不语，乱红飞过秋千去。','宋',1042,'婉约词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(112,'泊船瓜洲',23,'京口瓜洲一水间，钟山只隔数重山。春风又绿江南岸，明月何时照我还。','宋',1075,'思乡诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(113,'梅花',23,'墙角数枝梅，凌寒独自开。遥知不是雪，为有暗香来。','宋',1060,'咏梅诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(114,'岳阳楼记',24,'予观夫巴陵胜状，在洞庭一湖。衔远山，吞长江，浩浩汤汤，横无际涯。朝晖夕阴，气象万千。此则岳阳楼之大观也，前人之述备矣。','宋',1046,'散文诗名篇，\"先天下之忧而忧\"','2026-03-18 17:36:56','2026-03-18 17:36:56'),(115,'渔家傲',24,'塞下秋来风景异，衡阳雁去无留意。四面边声连角起，千嶂里，长烟落日孤城闭。浊酒一杯家万里，燕然未勒归无计。羌管悠悠霜满地，人不寐，将军白发征夫泪。','宋',1040,'边塞词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(116,'雨霖铃',25,'寒蝉凄切，对长亭晚，骤雨初歇。都门帐饮无绪，留恋处，兰舟催发。执手相看泪眼，竟无语凝噎。念去去，千里烟波，暮霭沉沉楚天阔。','宋',1037,'婉约词代表作','2026-03-18 17:36:56','2026-03-18 17:36:56'),(117,'望海潮',25,'东南形胜，三吴都会，钱塘自古繁华。烟柳画桥，风帘翠幕，参差十万人家。云树绕堤沙，怒涛卷霜雪，天堑无涯。','宋',1030,'描写杭州繁华','2026-03-18 17:36:56','2026-03-18 17:36:56'),(118,'鹊桥仙',26,'纤云弄巧，飞星传恨，银汉迢迢暗度。金风玉露一相逢，便胜却人间无数。柔情似水，佳期如梦，忍顾鹊桥归路。两情若是久长时，又岂在朝朝暮暮。','宋',1094,'七夕词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(119,'登快阁',28,'痴儿了却公家事，快阁东西倚晚晴。落木千山天远大，澄江一道月分明。朱弦已为佳人绝，青眼聊因美酒横。万里归船弄长笛，此心吾与白鸥盟。','宋',1084,'登临诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(120,'离骚',35,'帝高阳之苗裔兮，朕皇考曰伯庸。摄提贞于孟陬兮，惟庚寅吾以降。皇览揆余初度兮，肇锡余以嘉名。名余曰正则兮，字余曰灵均。','战国',-305,'楚辞代表作，中国浪漫主义诗歌源头','2026-03-18 17:36:56','2026-03-18 17:36:56'),(121,'九歌·湘夫人',35,'帝子降兮北渚，目眇眇兮愁予。袅袅兮秋风，洞庭波兮木叶下。登白薠兮骋望，与佳期兮夕张。','战国',-300,'楚辞名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(122,'归园田居',36,'少无适俗韵，性本爱丘山。误落尘网中，一去三十年。羁鸟恋旧林，池鱼思故渊。开荒南野际，守拙归园田。','东晋',406,'田园诗代表作','2026-03-18 17:36:56','2026-03-18 17:36:56'),(123,'饮酒',36,'结庐在人境，而无车马喧。问君何能尔？心远地自偏。采菊东篱下，悠然见南山。山气日夕佳，飞鸟相与还。','东晋',417,'田园诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(124,'桃花源记',36,'晋太元中，武陵人捕鱼为业。缘溪行，忘路之远近。忽逢桃花林，夹岸数百步，中无杂树，芳草鲜美，落英缤纷。','东晋',421,'散文诗名篇，描绘理想社会','2026-03-18 17:36:56','2026-03-18 17:36:56'),(125,'短歌行',33,'对酒当歌，人生几何！譬如朝露，去日苦多。慨当以慷，忧思难忘。何以解忧？唯有杜康。青青子衿，悠悠我心。但为君故，沉吟至今。','东汉',210,'乐府诗名篇，抒发壮志','2026-03-18 17:36:56','2026-03-18 17:36:56'),(126,'观沧海',33,'东临碣石，以观沧海。水何澹澹，山岛竦峙。树木丛生，百草丰茂。秋风萧瑟，洪波涌起。日月之行，若出其中；星汉灿烂，若出其里。','东汉',207,'山水诗名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(127,'七步诗',34,'煮豆燃豆萁，豆在釜中泣。本是同根生，相煎何太急？','三国',229,'七步成诗，千古名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(128,'洛神赋',34,'翩若惊鸿，婉若游龙。荣曜秋菊，华茂春松。仿佛兮若轻云之蔽月，飘摇兮若流风之回雪。','三国',222,'辞赋名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(129,'滕王阁序',29,'豫章故郡，洪都新府。星分翼轸，地接衡庐。襟三江而带五湖，控蛮荆而引瓯越。物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。','初唐',675,'骈文名篇，\"落霞与孤鹜齐飞\"','2026-03-18 17:36:56','2026-03-18 17:36:56'),(130,'送杜少府之任蜀州',29,'城阙辅三秦，风烟望五津。与君离别意，同是宦游人。海内存知己，天涯若比邻。无为在歧路，儿女共沾巾。','初唐',669,'送别名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(131,'咏鹅',32,'鹅，鹅，鹅，曲项向天歌。白毛浮绿水，红掌拨清波。','初唐',625,'少年成名作，家喻户晓','2026-03-18 17:36:56','2026-03-18 17:36:56'),(132,'天净沙·秋思',38,'枯藤老树昏鸦，小桥流水人家，古道西风瘦马。夕阳西下，断肠人在天涯。','元',1295,'元曲名篇，被誉为\"秋思之祖\"','2026-03-18 17:36:56','2026-03-18 17:36:56'),(133,'木兰花·拟古决绝词柬友',39,'人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。','清',1680,'爱情词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(134,'长相思',39,'山一程，水一程，身向榆关那畔行，夜深千帐灯。风一更，雪一更，聒碎乡心梦不成，故园无此声。','清',1682,'思乡词名篇','2026-03-18 17:36:56','2026-03-18 17:36:56'),(135,'春江花月夜',91,'春江潮水连海平，海上明月共潮生。滟滟随波千万里，何处春江无月明。江流宛转绕芳甸，月照花林皆似霰。空里流霜不觉飞，汀上白沙看不见。','唐',700,'孤篇盖全唐，千古绝唱','2026-03-18 18:46:20','2026-03-18 18:46:20'),(136,'回乡偶书',90,'少小离家老大回，乡音无改鬓毛衰。儿童相见不相识，笑问客从何处来。','唐',744,'思乡名篇，家喻户晓','2026-03-18 18:46:20','2026-03-18 18:46:20'),(137,'咏柳',90,'碧玉妆成一树高，万条垂下绿丝绦。不知细叶谁裁出，二月春风似剪刀。','唐',744,'咏物诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(138,'别董大',92,'千里黄云白日曛，北风吹雁雪纷纷。莫愁前路无知己，天下谁人不识君。','唐',749,'送别名篇，豪迈悲壮','2026-03-18 18:46:20','2026-03-18 18:46:20'),(139,'燕歌行',92,'汉家烟尘在东北，汉将辞家破残贼。男儿本自重横行，天子非常赐颜色。','唐',739,'边塞诗代表作','2026-03-18 18:46:20','2026-03-18 18:46:20'),(140,'黄鹤楼',103,'昔人已乘黄鹤去，此地空余黄鹤楼。黄鹤一去不复返，白云千载空悠悠。晴川历历汉阳树，芳草萋萋鹦鹉洲。日暮乡关何处是？烟波江上使人愁。','唐',735,'七律第一，李白搁笔','2026-03-18 18:46:20','2026-03-18 18:46:20'),(141,'枫桥夜泊',104,'月落乌啼霜满天，江枫渔火对愁眠。姑苏城外寒山寺，夜半钟声到客船。','唐',757,'羁旅诗名篇，意境深远','2026-03-18 18:46:20','2026-03-18 18:46:20'),(142,'师说',93,'古之学者必有师。师者，所以传道受业解惑也。人非生而知之者，孰能无惑？惑而不从师，其为惑也，终不解矣。','唐',802,'散文名篇，教育论说','2026-03-18 18:46:20','2026-03-18 18:46:20'),(143,'左迁至蓝关示侄孙湘',93,'一封朝奏九重天，夕贬潮州路八千。欲为圣明除弊事，肯将衰朽惜残年！云横秦岭家何在？雪拥蓝关马不前。知汝远来应有意，好收吾骨瘴江边。','唐',819,'贬谪诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(144,'离思',94,'曾经沧海难为水，除却巫山不是云。取次花丛懒回顾，半缘修道半缘君。','唐',810,'悼亡诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(145,'题李凝幽居',95,'闲居少邻并，草径入荒园。鸟宿池边树，僧敲月下门。','唐',800,'推敲典故来源','2026-03-18 18:46:20','2026-03-18 18:46:20'),(146,'寻隐者不遇',95,'松下问童子，言师采药去。只在此山中，云深不知处。','唐',810,'隐逸诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(147,'雁门太守行',96,'黑云压城城欲摧，甲光向日金鳞开。角声满天秋色里，塞上燕脂凝夜紫。','唐',813,'边塞诗名篇，诗鬼代表作','2026-03-18 18:46:20','2026-03-18 18:46:20'),(148,'李凭箜篌引',96,'吴丝蜀桐张高秋，空山凝云颓不流。江娥啼竹素女愁，李凭中国弹箜篌。','唐',811,'描写音乐名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(149,'菩萨蛮',97,'小山重叠金明灭，鬓云欲度香腮雪。懒起画蛾眉，弄妆梳洗迟。','唐',850,'花间词代表作','2026-03-18 18:46:20','2026-03-18 18:46:20'),(150,'浣溪沙',106,'一曲新词酒一杯，去年天气旧亭台。夕阳西下几时回？无可奈何花落去，似曾相识燕归来。小园香径独徘徊。','宋',1020,'婉约词名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(151,'玉楼春',107,'东城渐觉风光好，縠皱波纹迎客棹。绿杨烟外晓寒轻，红杏枝头春意闹。','宋',1030,'红杏枝头春意闹名句','2026-03-18 18:46:20','2026-03-18 18:46:20'),(152,'鲁山山行',108,'适与野情惬，千山高复低。好峰随处改，幽径独行迷。霜落熊升树，林空鹿饮溪。人家在何许？云外一声鸡。','宋',1040,'山水诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(153,'墨池记',110,'临川之城东，有地隐然而高，以临于溪，曰新城。新城之上，有池洼然而方以长，曰王羲之之墨池者。','宋',1050,'散文名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(154,'临江仙',111,'梦后楼台高锁，酒醒帘幕低垂。去年春恨却来时。落花人独立，微雨燕双飞。记得小蘋初见，两重心字罗衣。琵琶弦上说相思。当时明月在，曾照彩云归。','宋',1070,'婉约词名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(155,'天仙子',112,'水调数声持酒听，午醉醒来愁未醒。送春春去几时回？临晚镜，伤流景，往事后期空记省。沙上并禽池上暝，云破月来花弄影。','宋',1040,'云破月来花弄影名句','2026-03-18 18:46:20','2026-03-18 18:46:20'),(156,'扬州慢',113,'淮左名都，竹西佳处，解鞍少驻初程。过春风十里，尽荠麦青青。自胡马窥江去后，废池乔木，犹厌言兵。渐黄昏，清角吹寒，都在空城。','宋',1176,'婉约词名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(157,'过零丁洋',115,'辛苦遭逢起一经，干戈寥落四周星。山河破碎风飘絮，身世浮沉雨打萍。惶恐滩头说惶恐，零丁洋里叹零丁。人生自古谁无死？留取丹心照汗青。','宋',1279,'爱国诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(158,'山园小梅',118,'众芳摇落独暄妍，占尽风情向小园。疏影横斜水清浅，暗香浮动月黄昏。','宋',1010,'咏梅诗名篇，梅妻鹤子','2026-03-18 18:46:20','2026-03-18 18:46:20'),(159,'凤求凰',145,'有一美人兮，见之不忘。一日不见兮，思之如狂。凤飞翱翔兮，四海求凰。','西汉',-140,'琴曲名篇，司马相如求爱','2026-03-18 18:46:20','2026-03-18 18:46:20'),(160,'胡笳十八拍',148,'我生之初尚无为，我生之后汉祚衰。天不仁兮降乱离，地不仁兮使我逢此时。','东汉',200,'羁旅诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(161,'赠秀才入军',149,'息徒兰圃，秣马华山。流磻平皋，垂纶长川。目送归鸿，手挥五弦。','三国',250,'竹林七贤代表作','2026-03-18 18:46:20','2026-03-18 18:46:20'),(162,'咏怀',150,'夜中不能寐，起坐弹鸣琴。薄帷鉴明月，清风吹我襟。孤鸿号外野，翔鸟鸣北林。','三国',250,'咏怀诗代表作','2026-03-18 18:46:20','2026-03-18 18:46:20'),(163,'咏史',151,'郁郁涧底松，离离山上苗。以彼径寸茎，荫此百尺条。世胄蹑高位，英俊沉下僚。','西晋',280,'咏史诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(164,'晚登三山还望京邑',154,'灞涘望长安，河阳视京县。白日丽飞甍，参差皆可见。余霞散成绮，澄江静如练。','南北朝',490,'山水诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(165,'哀江南赋',155,'粤以戊辰之年，建亥之月，大盗移国，金陵瓦解。余乃窜身荒谷，公私涂炭。','南北朝',550,'赋体名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(166,'九辩',157,'悲哉，秋之为气也！萧瑟兮草木摇落而变衰。憭栗兮若在远行，登山临水兮送将归。','战国',-300,'楚辞名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(167,'登金陵雨花台望大江',125,'大江来从万山中，山势尽与江流东。钟山如龙独西上，欲破巨浪乘长风。','明',1370,'登临诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(168,'石灰吟',126,'千锤万凿出深山，烈火焚烧若等闲。粉骨碎身浑不怕，要留清白在人间。','明',1430,'咏物诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(169,'桃花庵歌',127,'桃花坞里桃花庵，桃花庵里桃花仙。桃花仙人种桃树，又摘桃花换酒钱。','明',1500,'江南才子代表作','2026-03-18 18:46:20','2026-03-18 18:46:20'),(170,'临江仙',129,'滚滚长江东逝水，浪花淘尽英雄。是非成败转头空。青山依旧在，几度夕阳红。白发渔樵江渚上，惯看秋月春风。一壶浊酒喜相逢。古今多少事，都付笑谈中。','明',1520,'《三国演义》开篇词','2026-03-18 18:46:20','2026-03-18 18:46:20'),(171,'牡丹亭·游园惊梦',131,'原来姹紫嫣红开遍，似这般都付与断井颓垣。良辰美景奈何天，赏心乐事谁家院。朝飞暮卷，云霞翠轩，雨丝风片，烟波画船。','明',1598,'戏曲名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(172,'竹石',139,'咬定青山不放松，立根原在破岩中。千磨万击还坚劲，任尔东西南北风。','清',1740,'咏物诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(173,'所见',140,'牧童骑黄牛，歌声振林樾。意欲捕鸣蝉，忽然闭口立。','清',1760,'田园诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20'),(174,'己亥杂诗',143,'九州生气恃风雷，万马齐喑究可哀。我劝天公重抖擞，不拘一格降人才。','清',1839,'爱国诗名篇','2026-03-18 18:46:20','2026-03-18 18:46:20');
/*!40000 ALTER TABLE `poems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poet_info`
--

DROP TABLE IF EXISTS `poet_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poet_info` (
  `poet_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `dynasty` varchar(20) NOT NULL,
  `birth_year` int DEFAULT NULL,
  `death_year` int DEFAULT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`poet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poet_info`
--

LOCK TABLES `poet_info` WRITE;
/*!40000 ALTER TABLE `poet_info` DISABLE KEYS */;
INSERT INTO `poet_info` VALUES (1,'李白','唐朝',701,762,'唐代伟大的浪漫主义诗人，被后人誉为\"诗仙\"，与杜甫并称为\"李杜\"。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Li%20Bai%20Tang%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(2,'杜甫','唐朝',712,770,'唐代伟大的现实主义诗人，被后人称为\"诗圣\"，他的诗被称为\"诗史\"。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Du%20Fu%20Tang%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(3,'苏轼','宋朝',1037,1101,'北宋文学家、书画家、美食家，与父亲苏洵、弟弟苏辙并称\"三苏\"。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Su%20Shi%20Song%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(4,'李清照','宋朝',1084,1155,'宋代女词人，婉约派代表，有\"千古第一才女\"之称。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Li%20Qingzhao%20Song%20Dynasty%20poetess%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(5,'王维','唐朝',701,761,'唐代诗人、画家，山水田园诗派代表，有\"诗佛\"之称。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Wang%20Wei%20Tang%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(6,'白居易','唐朝',772,846,'唐代现实主义诗人，与元稹共同倡导新乐府运动，世称\"元白\"。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Bai%20Juyi%20Tang%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(7,'辛弃疾','宋朝',1140,1207,'南宋豪放派词人，将领，有\"词中之龙\"之称。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Xin%20Qiji%20Song%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(8,'李商隐','唐朝',813,858,'晚唐著名诗人，与杜牧合称\"小李杜\"，擅长爱情诗。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Li%20Shangyin%20Tang%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(9,'孟浩然','唐朝',689,740,'唐代山水田园诗人，与王维并称\"王孟\"。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Meng%20Haoran%20Tang%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46'),(10,'杜牧','唐朝',803,852,'晚唐杰出诗人、散文家，与李商隐并称\"小李杜\"。','https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Du%20Mu%20Tang%20Dynasty%20poet%20portrait&image_size=square','2026-04-04 16:49:46','2026-04-04 16:49:46');
/*!40000 ALTER TABLE `poet_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poet_moments`
--

DROP TABLE IF EXISTS `poet_moments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poet_moments` (
  `moment_id` int NOT NULL AUTO_INCREMENT,
  `poet_id` int NOT NULL,
  `content` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `likes_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`moment_id`),
  KEY `poet_id` (`poet_id`),
  CONSTRAINT `poet_moments_ibfk_1` FOREIGN KEY (`poet_id`) REFERENCES `poet_info` (`poet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poet_moments`
--

LOCK TABLES `poet_moments` WRITE;
/*!40000 ALTER TABLE `poet_moments` DISABLE KEYS */;
INSERT INTO `poet_moments` VALUES (1,1,'今天在庐山瀑布下饮酒，看着飞流直下三千尺的壮观景象，突然诗兴大发，写下了几句，大家觉得如何？#庐山 #瀑布 #饮酒','/game/circle-friend/1.png',0,'2026-04-04 16:49:46','2026-04-05 06:21:50'),(2,1,'朋友送了我一壶好酒，今晚月色真美，准备与月亮对饮，不知天上的嫦娥是否也在看着我？#月亮 #饮酒 #孤独','/game/circle-friend/2.png',0,'2026-04-04 16:49:46','2026-04-05 06:21:50'),(3,1,'歧路漫漫，前路何从？待长风乍起，云帆直济沧溟。#励志 #行路难 #感慨','/game/circle-friend/3.png',0,'2026-04-04 16:49:46','2026-04-05 06:21:50'),(4,2,'今天看到路边有冻死的人，心中感慨万千，朱门酒肉臭，路有冻死骨，这世道何时才能改变？#社会 #感慨 #现实','/game/circle-friend/4.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(5,2,'夜里悄然而至的温柔，不声不响，却让世界慢慢变得柔软。#春雨 #喜悦 #自然','/game/circle-friend/5.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:56'),(6,2,'希望每一个努力生活的人，都能有一方安稳天地，不惧风雨，笑对生活。#理想 #关怀 #社会','/game/circle-friend/6.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(7,3,'今天发明了一道新菜，东坡肉，肥而不腻，入口即化，大家有机会一定要尝尝！#美食 #发明 #东坡肉','/game/circle-friend/7.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(8,3,'举杯望着月亮，忽然想问，这月色究竟从何而来，天上的时光，又走到了哪一年。#中秋 #月亮 #感慨','/game/circle-friend/8.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(9,3,'换个角度看，风景就不一样了。人总是困在当下，才看不清事情本来的样子。#庐山 #哲理 #观察','/game/circle-friend/9.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(10,4,'宿醉醒来，还惦记着夜里的小风小雨。还好，院里的海棠没被吹坏，依旧好好的。知否，知否？应是绿肥红瘦。#伤春 #饮酒 #海棠','/game/circle-friend/10.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(11,4,'秋风起，相思重，这般心绪，真叫人比黄花还瘦。#相思 #重阳节 #黄花','/game/circle-friend/11.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(12,4,'心里空落落的，总觉得少点什么。天气忽冷忽热，连觉都睡不踏实。#孤独 #秋意 #伤感','/game/circle-friend/12.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(13,5,'一场新雨过后，山里满是秋意。月光、松林、清泉，安静又治愈。#山水 #秋天 #自然','/game/circle-friend/13.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(14,5,'偶尔就想自己待一会儿，不用说话不用应酬，有月亮陪着，就很舒服。#独处 #弹琴 #竹林','/game/circle-friend/14.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(15,5,'临别再喝一杯，前路漫漫，各自珍重。#送别 #友情 #饮酒','/game/circle-friend/15.png',0,'2026-04-04 16:49:46','2026-04-05 06:27:57'),(16,6,'一岁一枯荣，生活嘛，总会重新发芽的。#野草 #生命力 #自然','/game/circle-friend/16.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(17,6,'就那一眼浅笑，已经胜过所有好看的风景。#杨贵妃 #美貌 #长恨歌','/game/circle-friend/17.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(18,6,'直很喜欢江南的春天，阳光、江水、繁花，怎么看都温柔，总让人念念不忘。#江南 #风景 #回忆','/game/circle-friend/18.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(19,7,'偶尔小酌，思绪翻涌，全是少年时的意气与滚烫的理想。#战争 #豪情 #壮志','/game/circle-friend/19.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(20,7,'找了那么久，原来你一直就在身后。#爱情 #元宵 #寻觅','/game/circle-friend/20.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:56'),(21,7,'年轻的时候总爱装深沉，没事就爱感慨人生，硬说自己有烦恼。#青春 #愁绪 #感慨','/game/circle-friend/21.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(22,8,'见面难，离别更难，满心的想念，一直都在。#爱情 #离别 #伤感','/game/circle-friend/22.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(23,8,'见一面不容易，分开更是舍不得。对你的心意，就像春蚕吐丝、蜡烛燃尽，一直都在。#爱情 #离别 #伤感','/game/circle-friend/23.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(24,8,'夜色渐深，烛影摇曳，星河慢慢沉向天边。忽然就觉得，人这一生，很多选择看似圆满，却往往要用无尽的孤单来偿还。大概嫦娥也会在无数个清冷的夜里后悔吧，独自守着一片碧海青天，夜夜都是无人能懂的孤寂与思念。#嫦娥 #月宫 #孤独','/game/circle-friend/24.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(25,9,'夜色渐深，烛影摇曳，星河慢慢沉向天边。忽然就觉得，人这一生，很多选择看似圆满，却往往要用无尽的孤单来偿还。大概嫦娥也会在无数个清冷的夜里后悔吧，独自守着一片碧海青天，夜夜都是无人能懂的孤寂与思念。#嫦娥 #月宫 #孤独','/game/circle-friend/25.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:56'),(26,9,'赴一场乡间邀约，有老友、有饭菜、有绿树青山，人间烟火，最是心安。#田园 #友情 #农家','/game/circle-friend/26.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(27,9,'旷野无边，江月近人。一程漂泊，一程清欢。#客愁 #江上 #夜景','/game/circle-friend/27.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(28,10,'又是一年清明，细雨绵绵。念故人，惜当下，岁岁平安。#清明 #雨 #酒家','/game/circle-friend/28.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(29,10,'误入秋日深处，看漫山红叶，胜过人间万千风景。#秋天 #枫叶 #山路','/game/circle-friend/29.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57'),(30,10,'且将旧事轻放，抬头皆是晴朗，步步皆是向上。#秦淮 #亡国 #感慨','/game/circle-friend/30.png',0,'2026-04-04 16:49:47','2026-04-05 06:27:57');
/*!40000 ALTER TABLE `poet_moments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poet_relationships`
--

DROP TABLE IF EXISTS `poet_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poet_relationships` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `poet1_id` bigint NOT NULL COMMENT '诗人A ID',
  `poet2_id` bigint NOT NULL COMMENT '诗人B ID',
  `relationship_type` enum('师徒','好友','同僚','亲威','仰慕','唱和') DEFAULT NULL COMMENT '关系类型',
  `description` text COMMENT '关系描述',
  `strength` int DEFAULT '3' COMMENT '关系强度(1-5)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_poet_relation` (`poet1_id`,`poet2_id`),
  KEY `poet2_id` (`poet2_id`),
  KEY `idx_relation_type` (`relationship_type`),
  CONSTRAINT `poet_relationships_ibfk_1` FOREIGN KEY (`poet1_id`) REFERENCES `poets` (`id`),
  CONSTRAINT `poet_relationships_ibfk_2` FOREIGN KEY (`poet2_id`) REFERENCES `poets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='诗人关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poet_relationships`
--

LOCK TABLES `poet_relationships` WRITE;
/*!40000 ALTER TABLE `poet_relationships` DISABLE KEYS */;
INSERT INTO `poet_relationships` VALUES (1,1,2,'好友','李杜友情，诗坛双璧',5,'2026-03-16 14:38:55'),(2,2,3,'仰慕','杜甫推崇白居易',3,'2026-03-16 14:38:55'),(3,4,3,'唱和','苏轼与白居易诗风相近',4,'2026-03-16 14:38:55'),(4,1,5,'好友','李白与孟浩然相交甚深，有《黄鹤楼送孟浩然之广陵》送别名篇',5,'2026-03-18 17:36:27'),(5,1,4,'好友','李白与王维同为盛唐诗人，诗风不同但相互欣赏',4,'2026-03-18 17:36:27'),(6,1,6,'仰慕','李商隐仰慕李白诗风，继承其浪漫主义传统',3,'2026-03-18 17:36:27'),(7,2,5,'好友','杜甫与孟浩然有交游，曾为其作诗',4,'2026-03-18 17:36:27'),(8,2,4,'好友','杜甫与王维同为盛唐大家，相互推崇',4,'2026-03-18 17:36:27'),(9,2,6,'仰慕','李商隐推崇杜甫，学习其律诗技巧',4,'2026-03-18 17:36:27'),(10,3,2,'仰慕','白居易推崇杜甫，学习其现实主义风格',4,'2026-03-18 17:36:27'),(11,3,4,'仰慕','白居易欣赏王维山水诗',3,'2026-03-18 17:36:27'),(12,3,7,'好友','白居易与刘禹锡并称\"刘白\"，交情深厚',5,'2026-03-18 17:36:27'),(13,4,5,'好友','王维与孟浩然并称\"王孟\"，同为山水田园派',5,'2026-03-18 17:36:27'),(14,4,6,'仰慕','李商隐学习王维诗画结合的手法',3,'2026-03-18 17:36:27'),(15,17,18,'亲威','苏轼与苏辙为兄弟，并称\"二苏\"',5,'2026-03-18 17:36:27'),(16,17,27,'亲威','苏轼之父苏洵，三人为\"三苏\"',5,'2026-03-18 17:36:27'),(17,17,22,'师徒','苏轼为欧阳修门生，深受其赏识',5,'2026-03-18 17:36:27'),(18,17,23,'同僚','苏轼与王安石政见不同，但相互尊重',3,'2026-03-18 17:36:27'),(19,17,24,'仰慕','苏轼推崇范仲淹\"先天下之忧而忧\"',4,'2026-03-18 17:36:27'),(20,17,25,'好友','苏轼与黄庭坚并称\"苏黄\"，黄为苏门四学士之一',5,'2026-03-18 17:36:27'),(21,17,26,'师徒','秦观为苏门四学士之一',5,'2026-03-18 17:36:27'),(22,17,19,'仰慕','辛弃疾推崇苏轼豪放词风',4,'2026-03-18 17:36:27'),(23,19,20,'仰慕','辛弃疾推崇李清照词作',3,'2026-03-18 17:36:27'),(24,19,21,'好友','辛弃疾与陆游同为爱国诗人，志同道合',5,'2026-03-18 17:36:27'),(25,20,21,'仰慕','李清照推崇陆游爱国诗篇',3,'2026-03-18 17:36:27'),(26,21,22,'仰慕','陆游推崇欧阳修文风',3,'2026-03-18 17:36:27'),(27,22,23,'同僚','欧阳修与王安石同朝为官，政见不同',3,'2026-03-18 17:36:27'),(28,22,24,'好友','欧阳修与范仲淹为好友，共同推动庆历新政',5,'2026-03-18 17:36:27'),(29,23,24,'同僚','王安石与范仲淹政见相近',4,'2026-03-18 17:36:27'),(30,10,11,'好友','柳宗元与刘禹锡并称\"刘柳\"，同为永贞革新成员',5,'2026-03-18 17:36:27'),(31,29,30,'好友','王勃与杨炯同为初唐四杰',5,'2026-03-18 17:36:27'),(32,29,31,'好友','王勃与卢照邻同为初唐四杰',5,'2026-03-18 17:36:27'),(33,29,32,'好友','王勃与骆宾王同为初唐四杰',5,'2026-03-18 17:36:27'),(34,30,31,'好友','杨炯与卢照邻同为初唐四杰',5,'2026-03-18 17:36:27'),(35,30,32,'好友','杨炯与骆宾王同为初唐四杰',5,'2026-03-18 17:36:27'),(36,31,32,'好友','卢照邻与骆宾王同为初唐四杰',5,'2026-03-18 17:36:27'),(37,33,34,'亲威','曹操与曹植为父子，同为建安文学代表',5,'2026-03-18 17:36:27'),(38,35,36,'仰慕','陶渊明仰慕屈原高洁品格',4,'2026-03-18 17:36:27'),(39,1,163,'好友','李白与贺知章为好友，贺称李为\"谪仙人\"',5,'2026-03-24 21:39:02'),(40,1,164,'仰慕','李白欣赏张若虚《春江花月夜》',3,'2026-03-24 21:39:02'),(41,1,13,'好友','李白与王昌龄有交游，有诗赠别',4,'2026-03-24 21:39:02'),(42,1,14,'仰慕','李白欣赏王之涣边塞诗',3,'2026-03-24 21:39:02'),(43,2,13,'好友','杜甫与王昌龄有交游，曾为其作诗',4,'2026-03-24 21:39:02'),(44,2,17,'好友','杜甫与岑参有交游，曾同游',4,'2026-03-24 21:39:02'),(45,2,165,'好友','杜甫与高适为好友，曾同游梁宋',5,'2026-03-24 21:39:02'),(46,3,179,'好友','白居易与元稹并称\"元白\"，交情深厚',5,'2026-03-24 21:39:02'),(47,3,178,'仰慕','白居易推崇韩愈古文',4,'2026-03-24 21:39:02'),(48,4,9,'好友','王维与孟浩然并称\"王孟\"，同为山水田园派',5,'2026-03-24 21:39:02'),(49,9,1,'好友','孟浩然与李白相交，李白作《黄鹤楼送孟浩然之广陵》',5,'2026-03-24 21:39:02'),(50,9,4,'好友','孟浩然与王维相交，互有赠诗',5,'2026-03-24 21:39:02'),(52,10,3,'好友','刘禹锡与白居易并称\"刘白\"，交情深厚',5,'2026-03-24 21:39:02'),(53,11,12,'好友','李商隐与杜牧并称\"小李杜\"',5,'2026-03-24 21:39:02'),(54,11,3,'仰慕','李商隐学习白居易诗风',4,'2026-03-24 21:39:02'),(55,12,3,'仰慕','杜牧推崇白居易诗风',4,'2026-03-24 21:39:02'),(56,12,179,'仰慕','杜牧与元稹有交游',3,'2026-03-24 21:39:02'),(57,13,14,'好友','王昌龄与王之涣同为边塞诗人，有交游',4,'2026-03-24 21:39:02'),(58,13,17,'好友','王昌龄与岑参同为边塞诗人',4,'2026-03-24 21:39:02'),(59,13,165,'好友','王昌龄与高适同为边塞诗人',4,'2026-03-24 21:39:02'),(60,17,165,'好友','岑参与高适并称\"高岑\"，同为边塞诗人代表',5,'2026-03-24 21:39:02'),(61,178,10,'好友','韩愈与刘禹锡有交游',4,'2026-03-24 21:39:02'),(62,178,11,'好友','韩愈与柳宗元同为古文运动倡导者',5,'2026-03-24 21:39:02'),(63,178,3,'仰慕','韩愈推崇白居易新乐府运动',4,'2026-03-24 21:39:02'),(64,63,64,'亲威','苏轼与苏辙为兄弟，并称\"二苏\"',5,'2026-03-24 21:39:02'),(65,63,65,'亲威','苏轼之父苏洵，三人为\"三苏\"',5,'2026-03-24 21:39:02'),(66,63,169,'师徒','苏轼为欧阳修门生，深受其赏识',5,'2026-03-24 21:39:02'),(67,63,170,'同僚','苏轼与王安石政见不同，但相互尊重',3,'2026-03-24 21:39:02'),(68,63,171,'仰慕','苏轼推崇范仲淹\"先天下之忧而忧\"',4,'2026-03-24 21:39:02'),(69,63,172,'好友','苏轼与柳永词风不同，但相互欣赏',3,'2026-03-24 21:39:02'),(70,63,73,'师徒','秦观为苏门四学士之一',5,'2026-03-24 21:39:02'),(71,63,74,'师徒','黄庭坚为苏门四学士之一',5,'2026-03-24 21:39:02'),(72,63,24,'仰慕','辛弃疾推崇苏轼豪放词风',4,'2026-03-24 21:39:02'),(73,24,26,'好友','辛弃疾与陆游同为爱国诗人，志同道合',5,'2026-03-24 21:39:02'),(74,24,25,'仰慕','辛弃疾推崇李清照词作',3,'2026-03-24 21:39:02'),(75,25,26,'仰慕','李清照推崇陆游爱国诗篇',3,'2026-03-24 21:39:02'),(76,26,169,'仰慕','陆游推崇欧阳修文风',3,'2026-03-24 21:39:02'),(77,169,170,'同僚','欧阳修与王安石同朝为官，政见不同',3,'2026-03-24 21:39:02'),(78,169,171,'好友','欧阳修与范仲淹为好友，共同推动庆历新政',5,'2026-03-24 21:39:02'),(79,170,171,'同僚','王安石与范仲淹政见相近',4,'2026-03-24 21:39:02'),(80,172,106,'仰慕','柳永与晏殊词风不同，但相互尊重',3,'2026-03-24 21:39:02'),(81,106,63,'仰慕','晏殊欣赏苏轼才华',4,'2026-03-24 21:39:02'),(82,113,63,'仰慕','姜夔推崇苏轼词风',4,'2026-03-24 21:39:02'),(83,113,24,'仰慕','姜夔推崇辛弃疾词作',4,'2026-03-24 21:39:02'),(84,115,26,'仰慕','文天祥推崇陆游爱国精神',4,'2026-03-24 21:39:02'),(85,36,37,'仰慕','陶渊明仰慕屈原高洁品格',4,'2026-03-24 21:39:02'),(86,37,38,'仰慕','陶渊明仰慕曹操文学才华',3,'2026-03-24 21:39:02'),(87,38,39,'亲威','曹操与曹植为父子，同为建安文学代表',5,'2026-03-24 21:39:02'),(88,41,42,'好友','王勃与杨炯同为初唐四杰',5,'2026-03-24 21:39:02'),(89,41,43,'好友','王勃与卢照邻同为初唐四杰',5,'2026-03-24 21:39:02'),(90,41,44,'好友','王勃与骆宾王同为初唐四杰',5,'2026-03-24 21:39:02'),(91,42,43,'好友','杨炯与卢照邻同为初唐四杰',5,'2026-03-24 21:39:02'),(92,42,44,'好友','杨炯与骆宾王同为初唐四杰',5,'2026-03-24 21:39:02'),(93,43,44,'好友','卢照邻与骆宾王同为初唐四杰',5,'2026-03-24 21:39:02');
/*!40000 ALTER TABLE `poet_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poet_routes`
--

DROP TABLE IF EXISTS `poet_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poet_routes` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `poet_id` bigint NOT NULL COMMENT '诗人ID',
  `location_id` bigint NOT NULL COMMENT '地点ID',
  `visit_order` int DEFAULT NULL COMMENT '访问顺序',
  `visit_year` int DEFAULT NULL COMMENT '到访年份',
  `stay_duration` varchar(50) DEFAULT NULL COMMENT '停留时长/时期',
  `event_description` text COMMENT '相关事件描述',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `location_id` (`location_id`),
  KEY `idx_poet_order` (`poet_id`,`visit_order`),
  CONSTRAINT `poet_routes_ibfk_1` FOREIGN KEY (`poet_id`) REFERENCES `poets` (`id`),
  CONSTRAINT `poet_routes_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1257 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='诗人路线表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poet_routes`
--

LOCK TABLES `poet_routes` WRITE;
/*!40000 ALTER TABLE `poet_routes` DISABLE KEYS */;
INSERT INTO `poet_routes` VALUES (1,1,5,1,724,NULL,'青年时期游历','2026-03-16 14:38:48'),(2,1,1,2,742,NULL,'入京为官','2026-03-16 14:38:48'),(3,1,3,3,755,NULL,'避乱入蜀','2026-03-16 14:38:48'),(4,1,4,4,756,NULL,'游历扬州','2026-03-16 14:38:48'),(5,2,12,1,731,'数年','青年时期游历吴越','2026-03-16 20:25:29'),(6,7,12,1,731,'数年','青年时期游历吴越','2026-03-16 20:25:29'),(7,2,5,2,732,'数月','游历杭州','2026-03-16 20:25:29'),(8,2,11,2,732,'数月','游历杭州','2026-03-16 20:25:29'),(9,7,5,2,732,'数月','游历杭州','2026-03-16 20:25:29'),(10,7,11,2,732,'数月','游历杭州','2026-03-16 20:25:29'),(11,2,14,3,733,'数月','游历金陵','2026-03-16 20:25:29'),(12,7,14,3,733,'数月','游历金陵','2026-03-16 20:25:29'),(13,2,27,4,736,'数年','游历齐赵','2026-03-16 20:25:29'),(14,7,27,4,736,'数年','游历齐赵','2026-03-16 20:25:29'),(15,2,28,5,737,'数月','游历曲阜','2026-03-16 20:25:29'),(16,7,28,5,737,'数月','游历曲阜','2026-03-16 20:25:29'),(17,2,1,6,746,'十年','困居长安','2026-03-16 20:25:29'),(18,2,6,6,746,'十年','困居长安','2026-03-16 20:25:29'),(19,7,1,6,746,'十年','困居长安','2026-03-16 20:25:29'),(20,7,6,6,746,'十年','困居长安','2026-03-16 20:25:29'),(21,2,3,7,759,'六年','避乱入蜀，筑草堂','2026-03-16 20:25:29'),(22,2,16,7,759,'六年','避乱入蜀，筑草堂','2026-03-16 20:25:29'),(23,7,3,7,759,'六年','避乱入蜀，筑草堂','2026-03-16 20:25:29'),(24,7,16,7,759,'六年','避乱入蜀，筑草堂','2026-03-16 20:25:29'),(25,2,17,8,766,'两年','移居夔州','2026-03-16 20:25:29'),(26,7,17,8,766,'两年','移居夔州','2026-03-16 20:25:29'),(27,2,21,9,768,'一年','出蜀，漂泊江陵','2026-03-16 20:25:29'),(28,7,21,9,768,'一年','出蜀，漂泊江陵','2026-03-16 20:25:29'),(36,3,1,1,800,'十五年','科举入仕，长安为官','2026-03-16 20:26:21'),(37,3,6,1,800,'十五年','科举入仕，长安为官','2026-03-16 20:26:21'),(38,8,1,1,800,'十五年','科举入仕，长安为官','2026-03-16 20:26:21'),(39,8,6,1,800,'十五年','科举入仕，长安为官','2026-03-16 20:26:21'),(40,3,31,2,815,'三年','贬为江州司马','2026-03-16 20:26:21'),(41,8,31,2,815,'三年','贬为江州司马','2026-03-16 20:26:21'),(42,3,17,3,818,'两年','移任忠州刺史','2026-03-16 20:26:21'),(43,8,17,3,818,'两年','移任忠州刺史','2026-03-16 20:26:21'),(44,3,5,4,822,'两年','任杭州刺史','2026-03-16 20:26:21'),(45,3,11,4,822,'两年','任杭州刺史','2026-03-16 20:26:21'),(46,8,5,4,822,'两年','任杭州刺史','2026-03-16 20:26:21'),(47,8,11,4,822,'两年','任杭州刺史','2026-03-16 20:26:21'),(48,3,12,5,825,'两年','任苏州刺史','2026-03-16 20:26:21'),(49,8,12,5,825,'两年','任苏州刺史','2026-03-16 20:26:21'),(50,3,2,6,829,'十七年','晚年定居洛阳','2026-03-16 20:26:21'),(51,3,7,6,829,'十七年','晚年定居洛阳','2026-03-16 20:26:21'),(52,8,2,6,829,'十七年','晚年定居洛阳','2026-03-16 20:26:21'),(53,8,7,6,829,'十七年','晚年定居洛阳','2026-03-16 20:26:21'),(67,4,18,1,1037,'十九年','出生并成长于眉山','2026-03-16 20:26:43'),(68,21,18,1,1037,'十九年','出生并成长于眉山','2026-03-16 20:26:43'),(69,4,8,2,1057,'四年','进京赶考，中进士','2026-03-16 20:26:43'),(70,21,8,2,1057,'四年','进京赶考，中进士','2026-03-16 20:26:43'),(71,4,5,4,1071,'三年','任杭州通判','2026-03-16 20:26:43'),(72,4,11,4,1071,'三年','任杭州通判','2026-03-16 20:26:43'),(73,21,5,4,1071,'三年','任杭州通判','2026-03-16 20:26:43'),(74,21,11,4,1071,'三年','任杭州通判','2026-03-16 20:26:43'),(75,4,27,5,1074,'两年','任密州知州（诸城）','2026-03-16 20:26:43'),(76,21,27,5,1074,'两年','任密州知州（诸城）','2026-03-16 20:26:43'),(77,4,19,8,1080,'四年','贬为黄州团练副使','2026-03-16 20:26:43'),(78,21,19,8,1080,'四年','贬为黄州团练副使','2026-03-16 20:26:43'),(79,4,5,9,1089,'两年','再任杭州知州','2026-03-16 20:26:43'),(80,4,11,9,1089,'两年','再任杭州知州','2026-03-16 20:26:43'),(81,21,5,9,1089,'两年','再任杭州知州','2026-03-16 20:26:43'),(82,21,11,9,1089,'两年','再任杭州知州','2026-03-16 20:26:43'),(83,4,4,10,1092,'数月','任扬州知州','2026-03-16 20:26:43'),(84,4,13,10,1092,'数月','任扬州知州','2026-03-16 20:26:43'),(85,21,4,10,1092,'数月','任扬州知州','2026-03-16 20:26:43'),(86,21,13,10,1092,'数月','任扬州知州','2026-03-16 20:26:43'),(87,4,22,11,1094,'三年','贬为惠州安置','2026-03-16 20:26:43'),(88,21,22,11,1094,'三年','贬为惠州安置','2026-03-16 20:26:43'),(99,1,11,1,724,'数年','青年时期游历','2026-03-16 20:27:45'),(100,6,5,1,724,'数年','青年时期游历','2026-03-16 20:27:45'),(101,6,11,1,724,'数年','青年时期游历','2026-03-16 20:27:45'),(103,1,6,2,742,'三年','入京为官，供奉翰林','2026-03-16 20:27:45'),(104,6,1,2,742,'三年','入京为官，供奉翰林','2026-03-16 20:27:45'),(105,6,6,2,742,'三年','入京为官，供奉翰林','2026-03-16 20:27:45'),(107,1,16,3,755,'两年','避乱入蜀','2026-03-16 20:27:45'),(108,6,3,3,755,'两年','避乱入蜀','2026-03-16 20:27:45'),(109,6,16,3,755,'两年','避乱入蜀','2026-03-16 20:27:45'),(111,1,13,4,756,'数月','游历扬州','2026-03-16 20:27:45'),(112,6,4,4,756,'数月','游历扬州','2026-03-16 20:27:45'),(113,6,13,4,756,'数月','游历扬州','2026-03-16 20:27:45'),(114,1,19,5,757,'一年','流放夜郎途中遇赦','2026-03-16 20:27:45'),(115,6,19,5,757,'一年','流放夜郎途中遇赦','2026-03-16 20:27:45'),(116,1,14,6,760,'两年','投奔族叔在当涂','2026-03-16 20:27:45'),(117,6,14,6,760,'两年','投奔族叔在当涂','2026-03-16 20:27:45'),(201,4,33,6,1077,'两年','任徐州知州','2026-03-16 20:28:00'),(202,21,33,6,1077,'两年','任徐州知州','2026-03-16 20:28:00'),(203,4,34,7,1079,'数月','任湖州知州，乌台诗案','2026-03-16 20:28:00'),(204,21,34,7,1079,'数月','任湖州知州，乌台诗案','2026-03-16 20:28:00'),(217,4,44,12,1097,'三年','贬为儋州安置','2026-03-16 20:28:00'),(218,21,44,12,1097,'三年','贬为儋州安置','2026-03-16 20:28:00'),(219,4,37,13,1101,'数月','北归途中病逝于常州','2026-03-16 20:28:00'),(220,21,37,13,1101,'数月','北归途中病逝于常州','2026-03-16 20:28:00'),(222,24,27,1,1140,'二十余年','生于济南，早年抗金','2026-03-16 20:28:05'),(223,24,14,2,1168,'两年','任建康通判','2026-03-16 20:28:05'),(224,24,30,3,1175,'六年','任江西提刑','2026-03-16 20:28:05'),(225,24,38,4,1181,'十三年','罢官闲居带湖（上饶）','2026-03-16 20:28:05'),(226,24,40,5,1192,'两年','任福建提刑','2026-03-16 20:28:05'),(227,24,38,6,1194,'十三年','再次闲居瓢泉','2026-03-16 20:28:05'),(228,24,42,7,1203,'两年','任镇江知府','2026-03-16 20:28:05'),(229,25,27,1,1084,'二十三年','生于济南，早年生活','2026-03-16 20:28:10'),(230,25,29,2,1107,'十四年','与赵明诚居青州','2026-03-16 20:28:10'),(231,25,14,3,1127,'两年','南渡后居江宁','2026-03-16 20:28:10'),(232,25,5,4,1130,'四年','居杭州','2026-03-16 20:28:10'),(233,25,11,4,1130,'四年','居杭州','2026-03-16 20:28:10'),(234,25,43,5,1134,'二十一年','晚年居金华','2026-03-16 20:28:10'),(236,5,10,1,701,'二十余年','生于太原祁县','2026-03-16 20:28:23'),(237,9,10,1,701,'二十余年','生于太原祁县','2026-03-16 20:28:23'),(238,5,1,2,721,'十六年','进士及第，长安为官','2026-03-16 20:28:23'),(239,5,6,2,721,'十六年','进士及第，长安为官','2026-03-16 20:28:23'),(240,9,1,2,721,'十六年','进士及第，长安为官','2026-03-16 20:28:23'),(241,9,6,2,721,'十六年','进士及第，长安为官','2026-03-16 20:28:23'),(242,5,1,4,739,'二十二年','回长安，半官半隐','2026-03-16 20:28:23'),(243,5,6,4,739,'二十二年','回长安，半官半隐','2026-03-16 20:28:23'),(244,9,1,4,739,'二十二年','回长安，半官半隐','2026-03-16 20:28:23'),(245,9,6,4,739,'二十二年','回长安，半官半隐','2026-03-16 20:28:23'),(246,5,2,5,740,'数次','往返洛阳','2026-03-16 20:28:23'),(247,5,7,5,740,'数次','往返洛阳','2026-03-16 20:28:23'),(248,9,2,5,740,'数次','往返洛阳','2026-03-16 20:28:23'),(249,9,7,5,740,'数次','往返洛阳','2026-03-16 20:28:23'),(251,10,20,1,689,'二十一年','生于襄阳，隐居鹿门山','2026-03-16 20:28:31'),(252,10,4,2,710,'数年','游历吴越，至扬州','2026-03-16 20:28:31'),(253,10,13,2,710,'数年','游历吴越，至扬州','2026-03-16 20:28:31'),(254,10,12,3,712,'数月','游苏州','2026-03-16 20:28:31'),(255,10,5,4,713,'数月','游杭州','2026-03-16 20:28:31'),(256,10,11,4,713,'数月','游杭州','2026-03-16 20:28:31'),(257,10,1,5,728,'一年','入长安求仕未果','2026-03-16 20:28:31'),(258,10,6,5,728,'一年','入长安求仕未果','2026-03-16 20:28:31'),(259,10,20,6,729,'十一年','归隐襄阳','2026-03-16 20:28:31'),(266,12,1,1,803,'二十五年','生于长安','2026-03-16 20:28:35'),(267,12,6,1,803,'二十五年','生于长安','2026-03-16 20:28:35'),(268,12,2,2,828,'一年','进士及第后居洛阳','2026-03-16 20:28:35'),(269,12,7,2,828,'一年','进士及第后居洛阳','2026-03-16 20:28:35'),(270,12,30,3,829,'四年','入江西观察使幕府','2026-03-16 20:28:35'),(271,12,4,4,833,'三年','任扬州节度使推官','2026-03-16 20:28:35'),(272,12,13,4,833,'三年','任扬州节度使推官','2026-03-16 20:28:35'),(273,12,1,5,836,'八年','回长安任监察御史','2026-03-16 20:28:35'),(274,12,6,5,836,'八年','回长安任监察御史','2026-03-16 20:28:35'),(275,12,19,6,844,'两年','任黄州刺史','2026-03-16 20:28:35'),(276,12,39,7,846,'两年','任池州刺史','2026-03-16 20:28:35'),(277,12,5,8,848,'两年','任睦州刺史','2026-03-16 20:28:35'),(278,12,11,8,848,'两年','任睦州刺史','2026-03-16 20:28:35'),(279,12,34,9,850,'两年','任湖州刺史','2026-03-16 20:28:35'),(280,12,1,10,852,'数月','病逝于长安','2026-03-16 20:28:35'),(281,12,6,10,852,'数月','病逝于长安','2026-03-16 20:28:35'),(297,11,2,1,813,'十六年','生于荥阳（邻近洛阳）','2026-03-16 20:28:40'),(298,11,7,1,813,'十六年','生于荥阳（邻近洛阳）','2026-03-16 20:28:40'),(299,11,1,2,829,'八年','入长安应试、任官','2026-03-16 20:28:40'),(300,11,6,2,829,'八年','入长安应试、任官','2026-03-16 20:28:40'),(301,11,23,3,847,'两年','入桂管观察使幕府','2026-03-16 20:28:40'),(302,11,33,4,849,'一年','入徐州幕府','2026-03-16 20:28:40'),(303,11,3,5,851,'四年','入东川节度使幕府','2026-03-16 20:28:40'),(304,11,16,5,851,'四年','入东川节度使幕府','2026-03-16 20:28:40'),(312,36,19,1,-340,'二十一年','生于秭归','2026-03-16 20:28:44'),(313,36,21,2,-319,'十五年','任楚怀王左徒，居郢都','2026-03-16 20:28:44'),(314,36,19,3,-304,'十八年','被流放，辗转沅湘','2026-03-16 20:28:44'),(315,37,31,1,365,'四十年','生于九江','2026-03-16 20:28:49'),(316,37,30,2,405,'数月','任江州祭酒','2026-03-16 20:28:49'),(317,37,31,3,405,'八十天','任彭泽令，辞官','2026-03-16 20:28:49'),(318,37,31,4,406,'二十二年','归隐田园','2026-03-16 20:28:49'),(322,41,10,1,650,'十六年','生于河津','2026-03-16 20:29:29'),(323,41,1,2,666,'两年','任沛王府修撰','2026-03-16 20:29:29'),(324,41,6,2,666,'两年','任沛王府修撰','2026-03-16 20:29:29'),(325,41,3,3,668,'七年','游历蜀中','2026-03-16 20:29:29'),(326,41,16,3,668,'七年','游历蜀中','2026-03-16 20:29:29'),(327,41,30,4,675,'数月','途经南昌，作《滕王阁序》','2026-03-16 20:29:29'),(328,41,22,5,676,'数月','前往交趾探父，渡海溺水','2026-03-16 20:29:29'),(329,38,35,1,155,'十九年','生于亳州','2026-03-16 20:29:33'),(330,38,2,2,174,'十年','任洛阳北部尉','2026-03-16 20:29:33'),(331,38,7,2,174,'十年','任洛阳北部尉','2026-03-16 20:29:33'),(332,38,27,3,184,'数年','任济南相','2026-03-16 20:29:33'),(333,38,8,4,196,'二十四年','迎献帝都许昌','2026-03-16 20:29:33'),(334,38,36,5,204,'十六年','平定河北，居邺城','2026-03-16 20:29:33'),(335,38,2,6,220,'数月','病逝于洛阳','2026-03-16 20:29:33'),(336,38,7,6,220,'数月','病逝于洛阳','2026-03-16 20:29:33'),(339,83,10,1,650,'十六年','生于河津','2026-03-18 17:24:34'),(403,63,19,8,1080,'四年','贬为黄州团练副使','2026-03-18 17:25:58'),(404,4,58,8,1080,'四年','贬为黄州团练副使','2026-03-18 17:25:58'),(405,21,58,8,1080,'四年','贬为黄州团练副使','2026-03-18 17:25:58'),(406,63,58,8,1080,'四年','贬为黄州团练副使','2026-03-18 17:25:58'),(555,12,58,6,844,'两年','任黄州刺史','2026-03-18 17:26:16'),(556,54,19,6,844,'两年','任黄州刺史','2026-03-18 17:26:16'),(557,54,58,6,844,'两年','任黄州刺史','2026-03-18 17:26:16'),(595,13,242,5,748,'数年','贬龙标尉','2026-03-24 21:31:59'),(597,14,260,2,720,'十年','游历冀州','2026-03-24 21:31:59'),(598,14,261,3,730,'数年','游历蓟门','2026-03-24 21:31:59'),(599,14,260,4,735,'八年','归乡','2026-03-24 21:31:59'),(602,15,245,3,805,'十年','贬朗州司马','2026-03-24 21:31:59'),(604,15,247,5,819,'三年','任夔州刺史','2026-03-24 21:31:59'),(608,16,130,1,773,'二十年','生于运城','2026-03-24 21:31:59'),(610,16,243,3,805,'十年','贬永州司马，创作《永州八记》','2026-03-24 21:31:59'),(611,16,244,4,815,'四年','贬柳州刺史','2026-03-24 21:31:59'),(612,17,111,1,715,'三十年','生于南阳','2026-03-24 21:31:59'),(614,17,255,3,749,'三年','赴安西节度使幕府','2026-03-24 21:31:59'),(616,17,256,5,755,'两年','赴北庭任职','2026-03-24 21:31:59'),(617,17,262,6,766,'五年','任嘉州刺史，后居成都','2026-03-24 21:31:59'),(618,165,260,1,704,'四十年','生于河北景县','2026-03-24 21:31:59'),(619,165,19,2,744,'数年','漫游梁宋，结识李白、杜甫','2026-03-24 21:31:59'),(621,165,255,4,753,'三年','赴河西节度使幕府','2026-03-24 21:31:59'),(625,178,248,3,803,'两年','贬阳山令','2026-03-24 21:31:59'),(627,178,249,5,819,'一年','贬潮州刺史','2026-03-24 21:31:59'),(639,179,19,6,829,'三年','任武昌军节度使','2026-03-24 21:31:59'),(640,169,265,1,1007,'二十三年','生于江西吉安','2026-03-24 21:31:59'),(642,169,250,3,1037,'三年','贬夷陵令','2026-03-24 21:31:59'),(644,169,251,5,1045,'十年','贬滁州、扬州等地','2026-03-24 21:31:59'),(646,170,263,1,1021,'二十一年','生于江西抚州','2026-03-24 21:31:59'),(653,171,252,4,1046,'三年','贬邓州，创作《岳阳楼记》','2026-03-24 21:31:59'),(657,106,263,1,991,'十四年','生于江西临川','2026-03-24 21:31:59'),(659,113,264,1,1155,'二十五年','生于江西鄱阳','2026-03-24 21:31:59'),(663,115,265,1,1236,'二十年','生于江西吉安','2026-03-24 21:31:59'),(665,115,265,3,1275,'三年','组织义军抗元','2026-03-24 21:31:59'),(667,26,253,1,1125,'二十八年','生于山阴（绍兴）','2026-03-24 21:31:59'),(671,26,253,5,1190,'二十年','归居山阴','2026-03-24 21:31:59'),(679,24,254,8,1207,'数月','病逝于铅山','2026-03-24 21:31:59'),(684,13,19,4,740,'数年','贬为龙标尉','2026-03-25 18:50:28'),(685,13,58,4,740,'数年','贬为龙标尉','2026-03-25 18:50:28'),(690,14,19,4,740,'两年','病逝于衡水','2026-03-25 18:50:34'),(696,15,17,4,815,'三年','任连州刺史','2026-03-25 18:50:38'),(697,15,19,5,820,'四年','任夔州刺史','2026-03-25 18:50:38'),(698,15,58,5,820,'四年','任夔州刺史','2026-03-25 18:50:38'),(712,16,58,4,805,'十年','贬为永州司马','2026-03-25 18:50:43'),(713,16,17,5,815,'四年','任柳州刺史','2026-03-25 18:50:43'),(714,16,59,5,815,'四年','任柳州刺史','2026-03-25 18:50:43'),(722,17,19,5,760,'四年','任虢州长史','2026-03-25 18:50:48'),(723,17,58,5,760,'四年','任虢州长史','2026-03-25 18:50:48'),(732,17,19,4,780,'三年','任滁州刺史','2026-03-25 18:50:53'),(733,18,58,4,780,'三年','任滁州刺史','2026-03-25 18:50:53'),(738,19,60,1,678,'二十年','生于韶州曲江','2026-03-25 18:50:57'),(745,19,19,5,736,'四年','贬为荆州长史','2026-03-25 18:50:57'),(746,19,58,5,736,'四年','贬为荆州长史','2026-03-25 18:50:57'),(766,22,19,7,1079,'四年','贬为黄州团练副使','2026-03-25 18:51:06'),(767,22,58,7,1079,'四年','贬为黄州团练副使','2026-03-25 18:51:06'),(827,31,19,4,1090,'五年','贬为处州酒税','2026-03-25 18:51:34'),(828,31,58,4,1090,'五年','贬为处州酒税','2026-03-25 18:51:34'),(836,32,19,3,1085,'五年','贬为涪州别驾','2026-03-25 18:51:38'),(837,32,58,3,1085,'五年','贬为涪州别驾','2026-03-25 18:51:38'),(838,32,17,4,1095,'五年','任戎州知州','2026-03-25 18:51:38'),(839,32,59,4,1095,'五年','任戎州知州','2026-03-25 18:51:38'),(857,34,19,3,1167,'五年','任零陵县丞','2026-03-25 18:51:47'),(858,34,58,3,1167,'五年','任零陵县丞','2026-03-25 18:51:47'),(870,35,19,4,1166,'五年','贬为处州知州','2026-03-25 18:51:52'),(871,35,58,4,1166,'五年','贬为处州知州','2026-03-25 18:51:52'),(1000,22,18,1,1039,'十九年','生于眉山','2026-03-25 20:46:46'),(1001,22,8,2,1057,'四年','与兄苏轼同科进士及第','2026-03-25 20:46:46'),(1002,22,8,3,1061,'八年','任制置三司条例司属官','2026-03-25 20:46:46'),(1003,22,250,4,1069,'六年','因反对新法外放','2026-03-25 20:46:46'),(1004,22,8,5,1086,'十年','旧党复用，回京任职','2026-03-25 20:46:46'),(1005,22,263,6,1097,'五年','贬居循州','2026-03-25 20:46:46'),(1006,22,18,7,1112,'数月','病逝于颍川','2026-03-25 20:46:46'),(1007,23,18,1,1009,'三十五年','生于眉山，发奋读书','2026-03-25 20:47:10'),(1008,23,8,2,1056,'二年','携二子进京，名动京师','2026-03-25 20:47:10'),(1009,23,8,3,1061,'五年','任秘书省校书郎','2026-03-25 20:47:10'),(1010,23,8,4,1066,'数月','病逝于开封','2026-03-25 20:47:10'),(1011,27,265,1,1007,'二十三年','生于绵州','2026-03-25 20:47:10'),(1012,27,8,2,1030,'七年','进士及第，任西京留守推官','2026-03-25 20:47:10'),(1013,27,250,3,1037,'三年','因支持范仲淹贬夷陵令','2026-03-25 20:47:10'),(1014,27,8,4,1040,'十五年','回京任职，参与庆历新政','2026-03-25 20:47:10'),(1015,27,251,5,1045,'十年','贬知滁州、扬州等地','2026-03-25 20:47:10'),(1016,27,8,6,1057,'十五年','任翰林学士，主考科举','2026-03-25 20:47:10'),(1017,27,265,7,1072,'数月','致仕后病逝于颍州','2026-03-25 20:47:10'),(1018,28,263,1,1021,'二十一年','生于临川','2026-03-25 20:47:10'),(1019,28,8,2,1042,'二十年','进士及第，历任地方官','2026-03-25 20:47:10'),(1020,28,8,3,1069,'七年','任参知政事，主持熙宁变法','2026-03-25 20:47:10'),(1021,28,14,4,1076,'十年','罢相后退居金陵','2026-03-25 20:47:10'),(1022,28,14,5,1086,'数月','哲宗即位后病逝','2026-03-25 20:47:10'),(1023,29,12,1,989,'二十六年','生于吴县','2026-03-25 20:47:10'),(1024,29,8,2,1015,'二十年','进士及第，任职地方','2026-03-25 20:47:10'),(1025,29,8,3,1043,'三年','任参知政事，主持庆历新政','2026-03-25 20:47:10'),(1026,29,252,4,1046,'三年','贬知邓州，作《岳阳楼记》','2026-03-25 20:47:10'),(1027,29,5,5,1049,'三年','任杭州知州','2026-03-25 20:47:10'),(1028,29,252,6,1052,'数月','赴颍州途中病逝','2026-03-25 20:47:10'),(1029,30,40,1,987,'四十七年','生于崇安','2026-03-25 20:47:10'),(1030,30,8,2,1034,'二十年','进士及第，任职地方','2026-03-25 20:47:10'),(1031,30,5,3,1053,'数年','晚年居杭州','2026-03-25 20:47:10'),(1033,31,8,2,1085,'四年','进士及第，任职京师','2026-03-25 20:47:10'),(1034,31,250,3,1094,'六年','因党争贬谪多地','2026-03-25 20:47:10'),(1037,32,8,2,1067,'十八年','进士及第，任职地方','2026-03-25 20:47:10'),(1038,32,8,3,1085,'九年','召为校书郎','2026-03-25 20:47:10'),(1041,33,5,1,1056,'二十五年','生于钱塘','2026-03-25 20:47:10'),(1042,33,8,2,1083,'十年','献赋得官，为国子主簿','2026-03-25 20:47:10'),(1043,33,8,3,1093,'十年','任大晟府提举','2026-03-25 20:47:10'),(1044,33,8,4,1121,'数月','病逝于开封','2026-03-25 20:47:10'),(1046,34,8,2,1154,'二十年','进士及第，任职地方','2026-03-25 20:47:10'),(1047,34,8,3,1174,'十年','召为国子博士','2026-03-25 20:47:10'),(1050,35,12,1,1126,'二十六年','生于吴郡','2026-03-25 20:47:10'),(1051,35,8,2,1154,'二十年','进士及第','2026-03-25 20:47:10'),(1052,35,8,3,1170,'五年','使金不辱命','2026-03-25 20:47:10'),(1053,35,3,4,1175,'五年','任四川制置使','2026-03-25 20:47:10'),(1054,35,12,5,1180,'十三年','退居石湖','2026-03-25 20:47:10'),(1055,35,12,6,1193,'数月','病逝','2026-03-25 20:47:10'),(1056,39,35,1,192,'二十四年','生于鄄城','2026-03-25 20:48:21'),(1057,39,36,2,216,'四年','随父征讨','2026-03-25 20:48:21'),(1058,39,36,3,220,'十一年','曹丕称帝后受迫害','2026-03-25 20:48:21'),(1059,39,2,4,232,'数月','忧郁而终','2026-03-25 20:48:21'),(1060,40,272,1,385,'三十八年','生于会稽','2026-03-25 19:43:27'),(1061,40,273,2,423,'五年','任永嘉太守','2026-03-25 19:43:27'),(1062,40,272,3,428,'五年','隐居会稽','2026-03-25 19:43:27'),(1063,40,274,4,433,'数月','被诬谋反遭杀害','2026-03-25 19:43:27'),(1064,42,275,1,650,'二十六年','生于华阴','2026-03-25 19:43:43'),(1065,42,1,2,676,'十年','授校书郎','2026-03-25 20:48:50'),(1066,42,276,3,686,'七年','任盈川令','2026-03-25 19:43:43'),(1067,42,276,4,693,'数月','卒于官','2026-03-25 19:43:43'),(1068,43,277,1,635,'三十年','生于涿郡','2026-03-25 19:44:12'),(1069,43,1,2,665,'十年','任邓王府典签','2026-03-25 20:48:50'),(1070,43,278,3,675,'十四年','因病投颍水而死','2026-03-25 19:44:12'),(1071,44,279,1,619,'五十年','生于义乌','2026-03-25 19:44:23'),(1072,44,1,2,669,'十年','任长安主簿','2026-03-25 20:48:50'),(1073,44,280,3,679,'八年','任临海丞','2026-03-25 19:44:23'),(1074,44,281,4,687,'数月','参加徐敬业起兵，兵败被杀','2026-03-25 19:44:23'),(1075,45,8,1,1250,'五十年','生于大都','2026-03-25 20:48:57'),(1076,45,282,2,1300,'二十年','任江浙行省务官','2026-03-25 19:44:37'),(1077,45,8,3,1321,'数月','病逝于大都','2026-03-25 20:48:57'),(1078,46,283,1,1234,'三十年','生于解州','2026-03-25 19:44:47'),(1079,46,8,2,1264,'三十六年','居大都，从事戏曲创作','2026-03-25 20:48:57'),(1080,46,8,3,1300,'数月','病逝','2026-03-25 20:48:57'),(1081,47,8,1,1655,'二十二年','生于北京','2026-03-25 20:48:57'),(1082,47,8,2,1676,'九年','中进士，授侍卫','2026-03-25 20:48:57'),(1083,47,8,3,1685,'数月','英年早逝','2026-03-25 20:48:57'),(1084,90,284,1,659,'三十七年','生于永兴','2026-03-25 19:45:23'),(1085,90,1,2,695,'五十年','进士及第，在朝为官','2026-03-25 20:49:14'),(1086,90,284,3,744,'九年','辞官归隐镜湖','2026-03-25 19:45:23'),(1087,90,284,4,744,'数月','病逝','2026-03-25 19:45:23'),(1088,91,285,1,660,'六十年','生于扬州','2026-03-25 19:45:38'),(1089,91,285,2,720,'数月','曾任兖州兵曹','2026-03-25 19:45:38'),(1090,92,286,1,704,'四十六年','生于景县','2026-03-25 19:45:49'),(1091,92,1,2,749,'十年','进士及第','2026-03-25 20:49:15'),(1092,92,255,3,753,'三年','赴河西幕府','2026-03-25 19:45:49'),(1093,92,1,4,760,'五年','任左散骑常侍','2026-03-25 20:49:15'),(1094,92,1,5,765,'数月','病逝','2026-03-25 20:49:15'),(1095,93,287,1,768,'二十四年','生于河阳','2026-03-25 19:46:00'),(1096,93,1,2,792,'十一年','进士及第','2026-03-25 20:44:47'),(1097,93,288,3,803,'两年','贬阳山令','2026-03-25 19:46:00'),(1098,93,1,4,806,'十三年','回京任职','2026-03-25 20:44:47'),(1099,93,289,5,819,'一年','贬潮州刺史','2026-03-25 19:46:00'),(1100,93,1,6,820,'五年','回京至去世','2026-03-25 20:44:47'),(1101,94,1,1,779,'十四年','生于洛阳','2026-03-25 20:46:03'),(1102,94,1,2,793,'十年','进士及第','2026-03-25 20:46:03'),(1103,94,31,3,810,'五年','任监察御史，贬江陵','2026-03-25 20:46:03'),(1104,94,1,4,820,'五年','回京任职','2026-03-25 20:46:03'),(1105,94,3,5,822,'两年','任浙东观察使','2026-03-25 20:46:03'),(1106,94,19,6,829,'三年','任武昌军节度使','2026-03-25 19:46:11'),(1107,94,19,7,831,'数月','病逝','2026-03-25 19:46:11'),(1108,95,290,1,779,'十四年','生于范阳','2026-03-25 19:46:23'),(1109,95,1,2,793,'三十年','出家为僧，后还俗','2026-03-25 20:49:15'),(1110,95,1,3,823,'二十年','任长江主簿','2026-03-25 20:49:15'),(1111,95,1,4,843,'数月','病逝','2026-03-25 20:49:15'),(1112,96,291,1,790,'二十六年','生于福昌','2026-03-25 19:46:36'),(1113,96,1,2,807,'九年','奉礼郎','2026-03-25 20:49:15'),(1114,96,291,3,816,'数月','病逝','2026-03-25 19:46:36'),(1115,97,292,1,812,'四十年','生于祁县','2026-03-25 19:46:47'),(1116,97,1,2,852,'十八年','国子助教','2026-03-25 20:49:15'),(1117,97,293,3,870,'数月','流放而死','2026-03-25 19:46:47'),(1118,98,294,1,833,'五十三年','生于新城','2026-03-25 19:47:05'),(1119,98,295,2,886,'二十三年','依吴越王钱镠','2026-03-25 19:47:05'),(1120,98,295,3,909,'数月','病逝','2026-03-25 19:47:05'),(1121,99,296,1,834,'四十九年','生于竟陵','2026-03-25 19:47:15'),(1122,99,1,2,883,'数月','参加黄巢起义，被害','2026-03-25 20:49:15'),(1123,100,12,1,836,'四十五年','生于苏州','2026-03-25 20:49:15'),(1124,100,297,2,881,'数月','隐居甫里','2026-03-25 19:47:27'),(1125,101,298,1,837,'四十六年','生于河中','2026-03-25 19:47:42'),(1126,101,1,2,883,'二十五年','任中书舍人','2026-03-25 20:49:16'),(1127,101,299,3,908,'数月','绝食而死','2026-03-25 19:47:42'),(1128,102,300,1,846,'四十六年','生于石埭','2026-03-25 19:47:54'),(1129,102,1,2,892,'十二年','进士及第','2026-03-25 20:49:16'),(1130,102,1,3,904,'数月','病逝','2026-03-25 20:49:16'),(1131,103,301,1,704,'二十六年','生于开封','2026-03-25 19:48:05'),(1132,103,1,2,723,'三十一年','进士及第','2026-03-25 20:49:16'),(1133,103,302,3,754,'数月','任河东节度使幕僚','2026-03-25 19:48:05'),(1134,104,303,1,715,'三十年','生于襄阳','2026-03-25 19:48:19'),(1135,104,1,2,744,'二十五年','进士及第','2026-03-25 20:49:16'),(1136,104,304,3,769,'数月','任洪州盐铁判官','2026-03-25 19:48:19'),(1137,106,263,1,991,'十四年','生于临川','2026-03-25 20:49:16'),(1138,106,8,2,1005,'五十年','以神童入仕','2026-03-25 20:49:16'),(1139,106,8,3,1055,'数月','病逝','2026-03-25 20:49:16'),(1140,107,305,1,998,'六十二年','生于安陆','2026-03-25 19:48:50'),(1141,107,8,2,1024,'三十七年','进士及第','2026-03-25 20:49:16'),(1142,107,8,3,1061,'数月','病逝','2026-03-25 20:49:16'),(1143,108,306,1,1002,'五十八年','生于宣城','2026-03-25 19:49:03'),(1144,108,8,2,1060,'数月','任国子监直讲','2026-03-25 20:49:16'),(1145,109,8,1,1008,'四十年','生于开封','2026-03-25 20:49:37'),(1146,109,8,2,1034,'十四年','进士及第','2026-03-25 20:49:37'),(1147,109,307,3,1048,'数月','病逝','2026-03-25 19:49:13'),(1148,110,308,1,1019,'三十九年','生于南丰','2026-03-25 19:49:25'),(1149,110,8,2,1057,'二十五年','进士及第','2026-03-25 20:49:37'),(1150,110,8,3,1083,'数月','病逝','2026-03-25 20:49:37'),(1151,111,263,1,1038,'七十二年','生于临川','2026-03-25 20:49:37'),(1152,111,8,2,1110,'数月','曾任职开封','2026-03-25 20:49:37'),(1153,112,309,1,990,'八十八年','生于乌程','2026-03-25 19:49:53'),(1154,112,8,2,1030,'四十八年','进士及第','2026-03-25 20:49:37'),(1155,112,309,3,1078,'数月','病逝','2026-03-25 19:49:53'),(1157,113,4,2,1176,'数月','游扬州','2026-03-25 20:49:37'),(1158,113,14,3,1180,'数年','居金陵','2026-03-25 20:49:37'),(1159,113,5,4,1200,'二十一年','居杭州','2026-03-25 20:49:37'),(1160,113,5,5,1221,'数月','病逝','2026-03-25 20:49:37'),(1161,114,311,1,1200,'六十年','生于四明','2026-03-25 19:50:17'),(1162,114,5,2,1260,'数月','曾为幕僚','2026-03-25 20:49:37'),(1163,115,265,1,1236,'二十年','生于吉安','2026-03-25 20:49:37'),(1164,115,8,2,1256,'二十年','状元及第','2026-03-25 20:49:37'),(1165,115,265,3,1275,'三年','组织抗元','2026-03-25 20:49:37'),(1166,115,9,4,1278,'五年','被俘囚禁','2026-03-25 20:49:37'),(1167,115,9,5,1283,'数月','从容就义','2026-03-25 20:49:37'),(1168,116,312,1,1132,'三十八年','生于历阳','2026-03-25 19:50:37'),(1169,116,8,2,1154,'十六年','状元及第','2026-03-25 20:49:37'),(1170,116,313,3,1170,'数月','病逝','2026-03-25 19:50:37'),(1171,117,314,1,1187,'八十二年','生于莆田','2026-03-25 19:50:48'),(1172,117,314,2,1269,'数月','曾任工部尚书','2026-03-25 19:50:48'),(1173,118,5,1,967,'六十一年','生于钱塘','2026-03-25 20:49:38'),(1174,118,315,2,1028,'数十年','隐居孤山，梅妻鹤子','2026-03-25 19:50:58'),(1175,119,316,1,1194,'七十五年','生于龙泉','2026-03-25 19:51:10'),(1176,119,5,2,1269,'数月','曾任处州知府','2026-03-25 20:49:38'),(1177,120,317,1,1226,'八十年','生于隩州','2026-03-25 19:51:22'),(1178,120,318,2,1306,'数月','居真定','2026-03-25 19:51:22'),(1179,121,319,1,1264,'六十年','生于平阳','2026-03-25 19:51:38'),(1180,121,320,2,1324,'数月','曾任杭州路吏','2026-03-25 19:51:38'),(1182,122,8,2,1336,'数月','创作《西厢记》','2026-03-25 20:49:54'),(1183,123,322,1,1272,'八十三年','生于代州','2026-03-25 19:52:04'),(1184,123,8,2,1355,'数月','曾任翰林学士','2026-03-25 20:49:54'),(1185,124,323,1,1296,'七十四年','生于诸暨','2026-03-25 19:52:20'),(1186,124,5,2,1370,'数月','居杭州','2026-03-25 20:49:54'),(1187,125,12,1,1336,'三十八年','生于吴县','2026-03-25 20:51:20'),(1188,125,12,2,1374,'数月','被腰斩','2026-03-25 20:51:20'),(1189,126,5,1,1398,'五十九年','生于钱塘','2026-03-25 20:51:37'),(1190,126,8,2,1457,'数月','被冤杀','2026-03-25 20:51:37'),(1191,127,12,1,1470,'五十四年','生于吴县','2026-03-25 20:52:02'),(1192,127,12,2,1524,'数月','病逝','2026-03-25 20:52:02'),(1193,128,8,1,1447,'六十九年','生于茶陵','2026-03-25 20:52:07'),(1194,128,8,2,1516,'数月','病逝','2026-03-25 20:52:07'),(1195,129,324,1,1488,'七十一年','生于新都','2026-03-25 19:53:21'),(1196,129,325,2,1524,'三十五年','状元及第，后贬云南','2026-03-25 19:53:21'),(1197,129,325,3,1559,'数月','病逝','2026-03-25 19:53:21'),(1198,130,326,1,1521,'七十二岁','生于山阴','2026-03-25 19:53:35'),(1199,130,326,2,1593,'数月','病逝','2026-03-25 19:53:35'),(1200,131,327,1,1550,'六十六年','生于临川','2026-03-25 19:53:50'),(1201,131,327,2,1616,'数月','病逝','2026-03-25 19:53:50'),(1202,132,328,1,1568,'四十二年','生于公安','2026-03-25 19:54:06'),(1203,132,8,2,1610,'数月','病逝','2026-03-25 20:52:27'),(1204,133,329,1,1582,'八十二年','生于常熟','2026-03-25 19:54:18'),(1205,133,329,2,1664,'数月','病逝','2026-03-25 19:54:18'),(1206,134,330,1,1609,'六十三年','生于太仓','2026-03-25 19:54:31'),(1207,134,330,2,1672,'数月','病逝','2026-03-25 19:54:31'),(1208,135,331,1,1613,'六十九年','生于昆山','2026-03-25 19:54:45'),(1209,135,332,2,1682,'数月','病逝于曲沃','2026-03-25 19:54:45'),(1211,136,8,2,1711,'数月','病逝','2026-03-25 20:53:49'),(1212,137,334,1,1629,'八十岁','生于秀水','2026-03-25 19:55:13'),(1213,137,8,2,1709,'数月','病逝','2026-03-25 20:53:54'),(1214,138,335,1,1650,'七十七年','生于海宁','2026-03-25 19:55:25'),(1215,138,8,2,1727,'数月','病逝','2026-03-25 20:54:06'),(1216,139,336,1,1693,'七十二年','生于兴化','2026-03-25 19:55:44'),(1217,139,337,2,1765,'数月','病逝','2026-03-25 19:55:44'),(1218,140,5,1,1716,'八十一年','生于钱塘','2026-03-25 20:54:06'),(1219,140,338,2,1797,'数月','病逝','2026-03-25 19:55:58'),(1220,141,339,1,1727,'八十七年','生于常州','2026-03-25 19:56:14'),(1221,141,339,2,1814,'数月','病逝','2026-03-25 19:56:14'),(1222,142,339,1,1749,'三十四年','生于常州','2026-03-25 19:56:37'),(1223,142,340,2,1783,'数月','病逝','2026-03-25 19:56:37'),(1224,143,5,1,1792,'四十九年','生于仁和','2026-03-25 20:54:06'),(1225,143,341,2,1841,'数月','病逝','2026-03-25 19:56:54'),(1226,144,342,1,1848,'五十七年','生于嘉应州','2026-03-25 19:57:07'),(1227,144,342,2,1905,'数月','病逝','2026-03-25 19:57:07'),(1228,145,3,1,-179,'六十一年','生于成都','2026-03-25 20:54:06'),(1229,145,8,2,-118,'数月','病逝','2026-03-25 20:54:06'),(1230,146,3,1,-53,'七十一岁','生于成都','2026-03-25 20:54:06'),(1231,146,8,2,18,'数月','病逝','2026-03-25 20:54:06'),(1232,147,343,1,32,'六十岁','生于安陵','2026-03-25 19:57:28'),(1233,147,8,2,92,'数月','死于狱中','2026-03-25 20:54:06'),(1238,149,345,1,224,'三十九年','生于铚县','2026-03-25 19:58:28'),(1239,149,346,2,263,'数月','被司马昭杀害','2026-03-25 19:58:28'),(1240,150,301,1,210,'五十三岁','生于尉氏','2026-03-25 19:58:42'),(1241,150,8,2,263,'数月','病逝','2026-03-25 20:54:17'),(1242,151,347,1,250,'五十五年','生于临淄','2026-03-25 19:59:02'),(1243,151,8,2,305,'数月','病逝','2026-03-25 20:54:17'),(1244,152,348,1,247,'五十三岁','生于中牟','2026-03-25 19:59:18'),(1245,152,8,2,300,'数月','被杀','2026-03-25 20:54:17'),(1246,153,349,1,276,'四十八年','生于闻喜','2026-03-25 19:59:33'),(1247,153,350,2,324,'数月','被王敦杀害','2026-03-25 19:59:33'),(1248,154,351,1,464,'三十六年','生于阳夏','2026-03-25 19:59:51'),(1249,154,352,2,499,'数月','被诬陷致死','2026-03-25 19:59:51'),(1252,156,355,1,540,'六十九年','生于汾阴','2026-03-25 20:00:13'),(1253,156,8,2,609,'数月','被隋炀帝杀害','2026-03-25 20:54:17'),(1254,157,356,1,-319,'五十六年','生于宜城','2026-03-25 20:00:28'),(1255,157,356,2,-263,'数月','贫困而终','2026-03-25 20:00:28'),(1256,158,345,1,221,'七十九年','生于沛国','2026-03-25 20:00:32');
/*!40000 ALTER TABLE `poet_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poets`
--

DROP TABLE IF EXISTS `poets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poets` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '诗人姓名',
  `dynasty` varchar(50) DEFAULT NULL COMMENT '朝代',
  `birth_year` int DEFAULT NULL COMMENT '出生年份',
  `death_year` int DEFAULT NULL COMMENT '去世年份',
  `birthplace` varchar(100) DEFAULT NULL COMMENT '出生地',
  `description` text COMMENT '简介',
  `image_url` varchar(500) DEFAULT NULL COMMENT '诗人画像URL',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_dynasty` (`dynasty`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='诗人信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poets`
--

LOCK TABLES `poets` WRITE;
/*!40000 ALTER TABLE `poets` DISABLE KEYS */;
INSERT INTO `poets` VALUES (1,'李白','唐',701,762,'绵州昌隆','诗仙，浪漫主义诗人',NULL,'2026-03-16 14:37:55','2026-03-16 14:37:55'),(2,'杜甫','唐',712,770,'河南巩县','诗圣，现实主义诗人',NULL,'2026-03-16 14:37:55','2026-03-16 14:37:55'),(3,'白居易','唐',772,846,'河南新郑','诗魔，新乐府运动倡导者',NULL,'2026-03-16 14:37:55','2026-03-16 14:37:55'),(4,'苏轼','宋',1037,1101,'眉州眉山','东坡居士，豪放派代表',NULL,'2026-03-16 14:37:55','2026-03-16 14:37:55'),(5,'王维','唐',701,761,'河东蒲州','诗佛，山水田园派代表',NULL,'2026-03-16 14:37:55','2026-03-16 14:37:55'),(10,'孟浩然','唐',689,740,'湖北襄阳','山水田园诗人，与王维并称\"王孟\"','/images/poets/menghaoran.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(11,'李商隐','唐',813,858,'河南荥阳','晚唐著名诗人，诗作含蓄优美，爱情诗尤为著名','/images/poets/lishangyin.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(12,'杜牧','唐',803,852,'陕西西安','晚唐杰出诗人，与李商隐并称\"小李杜\"','/images/poets/dumu.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(13,'王昌龄','唐',698,757,'山西太原','边塞诗人，擅长七绝，被称为\"七绝圣手\"','/images/poets/wangchangling.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(14,'王之涣','唐',688,742,'山西太原','边塞诗人，代表作《登鹳雀楼》','/images/poets/wangzhihuan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(15,'刘禹锡','唐',772,842,'河南洛阳','文学家、哲学家，诗风豪迈','/images/poets/liuyuxi.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(16,'柳宗元','唐',773,819,'山西运城','文学家、思想家，唐宋八大家之一','/images/poets/liuzongyuan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(17,'岑参','唐',715,770,'河南南阳','边塞诗人，善写边塞风光','/images/poets/cencan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(18,'韦应物','唐',737,792,'陕西西安','山水田园诗人，诗风恬淡','/images/poets/weiyingwu.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(19,'张九龄','唐',678,740,'广东韶关','政治家、诗人，名相张说之后','/images/poets/zhangjiuling.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(20,'陈子昂','唐',659,700,'四川射洪','文学家，开盛唐一代诗风','/images/poets/chenziang.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(22,'苏辙','宋',1039,1112,'四川眉山','苏轼之弟，散文家，唐宋八大家之一','/images/poets/suzhe.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(23,'苏洵','宋',1009,1066,'四川眉山','苏轼之父，散文家，唐宋八大家之一','/images/poets/suxun.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(24,'辛弃疾','宋',1140,1207,'山东济南','词中之龙，豪放派代表，爱国词人','/images/poets/xinqiji.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(25,'李清照','宋',1084,1155,'山东济南','千古第一才女，婉约派代表','/images/poets/liqingzhao.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(26,'陆游','宋',1125,1210,'浙江绍兴','爱国诗人，诗词文俱佳，现存诗最多','/images/poets/luyou.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(27,'欧阳修','宋',1007,1072,'江西吉安','文学家、史学家，北宋文坛领袖','/images/poets/ouyangxiu.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(28,'王安石','宋',1021,1086,'江西抚州','政治家、文学家，熙宁变法主导者','/images/poets/wanganshi.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(29,'范仲淹','宋',989,1052,'江苏苏州','政治家、文学家，\"先天下之忧而忧\"','/images/poets/fanzhongyan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(30,'柳永','宋',987,1053,'福建崇安','词人，慢词开拓者，婉约派代表','/images/poets/liuyong.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(31,'秦观','宋',1049,1100,'江苏高邮','苏门四学士之一，婉约词人','/images/poets/qinguan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(32,'黄庭坚','宋',1045,1105,'江西修水','苏门四学士之一，江西诗派开创者','/images/poets/huangtingjian.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(33,'周邦彦','宋',1056,1121,'浙江杭州','词人，格律派代表，精通音律','/images/poets/zhoubangyan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(34,'杨万里','宋',1127,1206,'江西吉水','诗人，与陆游、范成大、尤袤并称\"中兴四大诗人\"','/images/poets/yangwanli.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(35,'范成大','宋',1126,1193,'江苏苏州','诗人，中兴四大诗人之一','/images/poets/fanchengda.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(36,'屈原','战国',-340,-278,'湖北秭归','爱国诗人，楚辞开创者','/images/poets/quyuan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(37,'陶渊明','东晋',365,427,'江西九江','田园诗派创始人，隐逸诗人之宗','/images/poets/taoyuanming.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(38,'曹操','东汉',155,220,'安徽亳州','政治家、军事家、文学家，建安文学代表','/images/poets/caocao.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(39,'曹植','三国',192,232,'安徽亳州','曹魏文学家，建安文学代表，七步成诗','/images/poets/caozhi.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(40,'谢灵运','南北朝',385,433,'河南太康','山水诗派开创者','/images/poets/xielingyun.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(41,'王勃','初唐',650,676,'山西河津','初唐四杰之一，《滕王阁序》作者','/images/poets/wangbo.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(42,'杨炯','初唐',650,693,'陕西华阴','初唐四杰之一，边塞诗人','/images/poets/yangjiong.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(43,'卢照邻','初唐',635,689,'河北涿州','初唐四杰之一','/images/poets/luzhaolin.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(44,'骆宾王','初唐',619,687,'浙江义乌','初唐四杰之一，《咏鹅》作者','/images/poets/luobinwang.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(45,'马致远','元',1250,1321,'北京','元曲四大家之一，《天净沙·秋思》作者','/images/poets/mazhiyuan.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(46,'关汉卿','元',1234,1300,'山西运城','元曲四大家之首，戏剧家','/images/poets/guanhanqing.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(47,'纳兰性德','清',1655,1685,'北京','清代词人，词风清丽','/images/poets/nanlanxingde.jpg','2026-03-16 19:34:04','2026-03-16 19:34:04'),(90,'贺知章','唐',659,744,'浙江萧县','唐代诗人、书法家，自号四明狂客，与李白为好友','/images/poets/hezhizhang.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(91,'张若虚','唐',660,720,'江苏扬州','唐代诗人，《春江花月夜》被誉为\"孤篇盖全唐\"','/images/poets/zhangruoxu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(92,'高适','唐',704,765,'河北景县','边塞诗人，与岑参并称\"高岑\"，官至左散骑常侍','/images/poets/gaoshi.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(93,'韩愈','唐',768,824,'河南孟州','文学家、思想家，唐宋八大家之首，古文运动倡导者','/images/poets/hanyu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(94,'元稹','唐',779,831,'河南洛阳','诗人，与白居易并称\"元白\"，新乐府运动代表','/images/poets/yuanzhen.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(95,'贾岛','唐',779,843,'河北涿州','苦吟诗人，有\"推敲\"典故，诗风清冷','/images/poets/jiadao.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(96,'李贺','唐',790,816,'河南福昌','诗鬼，浪漫主义诗人，诗风奇诡','/images/poets/lihe.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(97,'温庭筠','唐',812,870,'山西祁县','花间派词人，词风绮丽','/images/poets/wentingyun.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(98,'罗隐','唐',833,909,'浙江富阳','晚唐诗人，诗风讽刺辛辣','/images/poets/luoyin.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(99,'皮日休','唐',834,883,'湖北天门','晚唐文学家，与陆龟蒙并称\"皮陆\"','/images/poets/pirixiu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(100,'陆龟蒙','唐',836,881,'江苏苏州','晚唐文学家，隐逸诗人','/images/poets/luguimeng.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(101,'司空图','唐',837,908,'山西永济','晚唐诗论家，《二十四诗品》作者','/images/poets/sikongtu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(102,'杜荀鹤','唐',846,904,'安徽石台','晚唐诗人，诗风朴实','/images/poets/duxunhe.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(103,'崔颢','唐',704,754,'河南开封','唐代诗人，《黄鹤楼》名动天下，李白见之搁笔','/images/poets/cuihao.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(104,'张继','唐',715,779,'湖北襄阳','唐代诗人，《枫桥夜泊》作者','/images/poets/zhangji.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(105,'金昌绪','唐',NULL,NULL,'浙江余杭','唐代诗人，《春怨》作者','/images/poets/jinchangxu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(106,'晏殊','宋',991,1055,'江西临川','宰相词人，婉约派代表，有\"无可奈何花落去\"名句','/images/poets/yanshu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(107,'宋祁','宋',998,1061,'湖北安陆','文学家，有\"红杏枝头春意闹\"名句','/images/poets/songqi.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(108,'梅尧臣','宋',1002,1060,'安徽宣城','诗人，宋诗开山祖师','/images/poets/meiyaochen.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(109,'苏舜钦','宋',1008,1048,'河南开封','诗人，与梅尧臣并称\"苏梅\"','/images/poets/sushunqin.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(110,'曾巩','宋',1019,1083,'江西南丰','散文家，唐宋八大家之一','/images/poets/zenggong.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(111,'晏几道','宋',1038,1110,'江西临川','词人，晏殊之子，婉约派代表','/images/poets/yanjidao.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(112,'张先','宋',990,1078,'浙江湖州','词人，有\"云破月来花弄影\"名句','/images/poets/zhangxian.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(113,'姜夔','宋',1155,1221,'江西鄱阳','词人、音乐家，格律派代表','/images/poets/jiangkui.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(114,'吴文英','宋',1200,1260,'浙江宁波','词人，格律派代表，词风密丽','/images/poets/wuwenying.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(115,'文天祥','宋',1236,1283,'江西吉安','民族英雄，有\"人生自古谁无死\"名句','/images/poets/wentianxiang.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(116,'张孝祥','宋',1132,1170,'安徽和县','词人，豪放派代表','/images/poets/zhangxiaoxiang.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(117,'刘克庄','宋',1187,1269,'福建莆田','诗人，江湖诗派代表','/images/poets/liukezhuang.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(118,'林逋','宋',967,1028,'浙江杭州','北宋隐士，梅妻鹤子典故','/images/poets/linbu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(119,'叶绍翁','宋',1194,1269,'浙江龙泉','南宋诗人，有\"春色满园关不住\"名句','/images/poets/yeshaoweng.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(120,'白朴','元',1226,1306,'山西永济','元曲四大家之一','/images/poets/baipu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(121,'郑光祖','元',1264,1324,'山西临汾','元曲四大家之一','/images/poets/zhengguangzu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(122,'王实甫','元',1260,1336,'河北保定','元曲作家，《西厢记》作者','/images/poets/wangshifu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(123,'萨都剌','元',1272,1355,'山西代县','元代诗人，回族','/images/poets/sadula.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(124,'杨维桢','元',1296,1370,'浙江诸暨','元末诗人，铁崖体创始人','/images/poets/yangweizhen.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(125,'高启','明',1336,1374,'江苏苏州','明初诗人，与杨基、张羽、徐贲并称\"吴中四杰\"','/images/poets/gaoqi.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(126,'于谦','明',1398,1457,'浙江杭州','明代名臣，有《石灰吟》名篇','/images/poets/yuqian.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(127,'唐寅','明',1470,1524,'江苏苏州','江南才子，画家、诗人','/images/poets/tangyin.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(128,'李东阳','明',1447,1516,'北京','明代诗人，茶陵诗派创始人','/images/poets/lidongyang.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(129,'杨慎','明',1488,1559,'四川成都','明代文学家，有\"滚滚长江东逝水\"名句','/images/poets/yangshen.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(130,'徐渭','明',1521,1593,'浙江绍兴','明代文学家、书画家','/images/poets/xuwei.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(131,'汤显祖','明',1550,1616,'江西临川','明代戏曲家，《牡丹亭》作者','/images/poets/tangxianzu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(132,'袁宏道','明',1568,1610,'湖北公安','公安派代表，提倡性灵说','/images/poets/yuanhongdao.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(133,'钱谦益','明',1582,1664,'江苏常熟','明末清初诗人，虞山诗派创始人','/images/poets/qianqianyi.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(134,'吴伟业','明',1609,1672,'江苏太仓','明末清初诗人，娄东诗派代表','/images/poets/wuweiye.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(135,'顾炎武','明',1613,1682,'江苏昆山','明末清初思想家、诗人','/images/poets/guyanwu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(136,'王士禛','清',1634,1711,'山东桓台','清代诗人，神韵说倡导者','/images/poets/wangshizhen.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(137,'朱彝尊','清',1629,1709,'浙江嘉兴','清代词人，浙西词派创始人','/images/poets/zhuyizun.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(138,'查慎行','清',1650,1727,'浙江海宁','清代诗人，诗风清新','/images/poets/zhashenxing.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(139,'郑燮','清',1693,1765,'江苏兴化','扬州八怪之一，号板桥','/images/poets/zhengxie.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(140,'袁枚','清',1716,1797,'浙江杭州','清代诗人，性灵派代表','/images/poets/yuanmei.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(141,'赵翼','清',1727,1814,'江苏常州','清代诗人、史学家','/images/poets/zhaoyi.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(142,'黄景仁','清',1749,1783,'江苏常州','清代诗人，诗风哀婉','/images/poets/huangjingren.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(143,'龚自珍','清',1792,1841,'浙江杭州','清代思想家、诗人，有\"落红不是无情物\"名句','/images/poets/gongzizhen.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(144,'黄遵宪','清',1848,1905,'广东梅州','晚清诗人，诗界革命代表','/images/poets/huangzunxian.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(145,'司马相如','西汉',-179,-118,'四川成都','汉赋代表作家，与卓文君爱情故事传世','/images/poets/simaxiangru.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(146,'扬雄','西汉',-53,18,'四川成都','西汉学者、辞赋家','/images/poets/yangxiong.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(147,'班固','东汉',32,92,'陕西咸阳','史学家、文学家，《汉书》作者','/images/poets/bangu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(148,'蔡文姬','东汉',177,249,'河南开封','女诗人，有《胡笳十八拍》传世','/images/poets/caiwenji.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(149,'嵇康','三国',224,263,'安徽宿州','竹林七贤之一，音乐家、诗人','/images/poets/jikang.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(150,'阮籍','三国',210,263,'河南开封','竹林七贤之一，咏怀诗代表','/images/poets/ruanji.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(151,'左思','西晋',250,305,'山东淄博','西晋诗人，《三都赋》作者，洛阳纸贵典故','/images/poets/zuosi.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(152,'潘岳','西晋',247,300,'河南巩义','西晋诗人，美男子，有\"潘安之貌\"典故','/images/poets/panyue.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(153,'郭璞','东晋',276,324,'山西闻喜','东晋学者、诗人，游仙诗代表','/images/poets/guopu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(154,'谢朓','南北朝',464,499,'河南太康','山水诗人，与谢灵运并称\"大小谢\"','/images/poets/xietiao.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(155,'庾信','南北朝',513,581,'河南新野','北周诗人，集六朝诗赋之大成','/images/poets/yuxin.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(156,'薛道衡','隋',540,609,'山西万荣','隋代诗人，有\"人日思归\"名篇','/images/poets/xuedaoheng.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(157,'宋玉','战国',-319,-263,'湖北宜城','楚辞作家，屈原弟子','/images/poets/songyu.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19'),(158,'刘伶','西晋',221,300,'安徽宿州','竹林七贤之一，以嗜酒著称','/images/poets/liuling.jpg','2026-03-18 17:57:19','2026-03-18 17:57:19');
/*!40000 ALTER TABLE `poets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provinces`
--

DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provinces` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '省份ID',
  `name` varchar(50) NOT NULL COMMENT '省份名称（如：陕西）',
  `historical_name` varchar(100) DEFAULT NULL COMMENT '历史名称',
  `description` text COMMENT '省份诗词历史介绍',
  `poem_count` int DEFAULT '0' COMMENT '相关诗词数量',
  `poet_count` int DEFAULT '0' COMMENT '相关诗人数量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='省份信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provinces`
--

LOCK TABLES `provinces` WRITE;
/*!40000 ALTER TABLE `provinces` DISABLE KEYS */;
INSERT INTO `provinces` VALUES (1,'北京','燕京、大都、北平','北京建城历史悠久，前11世纪蓟国即建都于此，秦汉为蓟县，隋唐称幽州，辽代为陪都南京，金朝始为正式国都中都，元朝建大都，明清称京师，民国改称北平，1949年后复为北京。三千年城址不移，数朝积淀使这里成为全国诗词文化重镇。先秦荆轲刺秦前作“风萧萧兮易水寒”的易水便近京畿；东汉卢植等经学大师注经讲学，诗教相承。唐代幽州诗人贾岛“鸟宿池边树，僧敲月下门”锤炼字句，开苦吟一派。金元之际，元好问被羁管中都，哀叹“渺渺西风去翼轻”；马致远《天净沙·秋思》“枯藤老树昏鸦，小桥流水人家，古道西风瘦马”写尽元大都羁旅苍凉。明代于谦在北京写下《石灰吟》“粉骨碎身浑不怕，要留清白在人间”；杨慎谪戍云南之际，曾与京师诗友唱和不绝。清代纳兰性德生于京师明珠府，以其沉挚清婉的小令誉满词坛，“人生若只如初见，何事秋风悲画扇”唱绝京华；曹雪芹在黄叶村著《红楼梦》，书中诗社唱和实为北京园林诗生活写照。乾嘉年间翁方纲等创肌理说，推动诗学精进。近现代胡适、鲁迅、老舍、冰心等长期居京，新诗运动由此辐射全国，《新青年》首发胡适《鸽子》、郭沫若《炉中煤》，百年新诗从北京起步。当代北岛、食指等朦胧诗人亦以北京为重要据点。',12500,3800),(2,'天津','津沽、天津卫','天津古为退海之地，金代称直沽，元设海津镇，明永乐二年设卫筑城，始名天津，意为“天子渡口”。因河海交汇，漕运繁华，南北文人多会于此，形成开放包容的津门诗风。清代天津诗坛兴盛，查慎行多次途经天津，有“潞河浊浪高于屋，直放扁舟过海门”之句；梅成栋编《津门诗钞》三十卷，录元明以来四百余家诗，是天津第一部大型诗歌总集。水西庄是清代三大私家园林之一，查为仁等主持风雅，乾隆时厉鹗、杭世骏等名流雅集于此，联句酬唱，留下大量佳作。晚清李叔同生于天津，早年诗酒风流，后出家为弘一法师，所作《送别》“长亭外，古道边，芳草碧连天”堪称现代经典。近现代都市诗兴起，曹禺早期诗歌充满海河气息，穆旦、辛笛等诗人也曾在此活动，九叶诗派与天津渊源深厚。杨柳青年画题跋诗词相得益彰，鼓曲、时调中的唱词也富有诗韵。',3200,780),(3,'河北','冀州、幽州、直隶','河北省古称冀州，京津外围，燕赵故地，自古多慷慨悲歌之士，亦不乏清丽婉约之章。战国时荆轲赴秦，“风萧萧兮易水寒，壮士一去兮不复还”的易水便在今易县境，开燕赵悲壮诗风先河。汉末曹操北征乌桓，过碣石山作《观沧海》“东临碣石，以观沧海。水何澹澹，山岛竦峙”，气魄沉雄。唐代河北道文风极盛：高适为渤海蓨人（今景县），与岑参并称边塞诗双璧，“汉家烟尘在东北，汉将辞家破残贼”笔力千钧；刘长卿河间人，五言长城，“柴门闻犬吠，风雪夜归人”意境悠远；还有“大历十才子”中的卢纶、司空曙等籍贯河北。宋代磁州窑瓷器题诗具民间风味；元代刘秉忠邢台人，助忽必烈定国号元，诗亦清疏。清代纪昀（纪晓岚）献县人，虽以《四库全书》总纂闻名，其《阅微草堂笔记》中论诗亦多真见；张之洞南皮人，诗开河北近代新风。现代诗人田间、郭小川、孙犁（白洋淀派代表）等或以战鼓诗催人奋进，或以清新质朴写冀中平原，尤其孙犁《荷花淀》如诗体小说深入人心。',9800,2100),(4,'山西','晋、河东、三晋','山西古称河东，表里山河，是华夏文明发源地之一，诗脉悠长。尧舜禹故地，舜作《南风歌》“南风之薰兮，可以解吾民之愠兮”流传至今；《诗经·魏风》《唐风》皆采自山西，如《伐檀》《硕鼠》反映先民心声。汉魏时期，卫觊、卫瓘等才俊辈出；郭璞为河东闻喜人，以《游仙诗》著称，“京华游侠窟，山林隐遁栖”格调高奇。唐代是山西诗文高峰：王勃绛州龙门人（今河津），“海内存知己，天涯若比邻”千古传唱，其《滕王阁序》更是骈赋绝唱；王之涣并州人，旗亭画壁故事广传，《登鹳雀楼》“欲穷千里目，更上一层楼”写于永济；王昌龄亦籍太原，七绝圣手，“秦时明月汉时关”雄浑苍凉；柳宗元河东人，与韩愈共倡古文运动，山水诗清峭孤迥，“千山鸟飞绝，万径人踪灭”可称绝唱；白居易祖籍太原，倡导新乐府，诗传天下。宋代司马光夏县人，虽以史著《资治通鉴》闻名，其诗亦典雅；金元之际元好问忻州人，丧乱诗沉郁苍凉，“问世间情为何物，直教生死相许”开词境新域。明代罗贯中太原人，其小说中诗词亦多佳构。现代山药蛋派赵树理以小说名世，但其唱词、诗词亦带泥土芬芳。',8700,1900),(5,'内蒙古','塞北、漠南、绥远','内蒙古自治区横亘北方，自古为游牧文明与农耕文明交融之地，诗词文化既具草原豪情，又融边塞悲壮。北朝民歌《敕勒歌》“敕勒川，阴山下，天似穹庐，笼盖四野。天苍苍，野茫茫，风吹草低见牛羊”原为鲜卑语，译为汉语后成为草原诗魂的永恒图腾。汉唐以来，内蒙古地域多属边塞，王维《使至塞上》“大漠孤烟直，长河落日圆”写萧关，边塞诸家多有吟及阴山、河套。王昭君出塞和亲，青冢在今呼和浩特南，历代诗人白居易、杜甫、欧阳修、王安石等皆有题咏，杜甫“千载琵琶作胡语，分明怨恨曲中论”，王安石“汉恩自浅胡自深，人生乐在相知心”议论各异。唐代边塞诗人李益曾游历云中，高适、岑参等多涉今内蒙古南境。蒙元时期，史诗《蒙古秘史》韵散结合，气势恢弘。清代蒙古族诗人法式善为乾隆朝著名诗论家，编《同馆赋钞》，提倡诗歌风雅；尹湛纳希以蒙文创作，兼通韵文。近现代诗人纳·赛音朝克图作为蒙古族新文学奠基人，以蒙汉双语书写草原新章；当代白涛、阿尔泰等诗人延续边塞诗情。',4500,620),(6,'辽宁','辽东、奉天、盛京','辽宁古称辽东，清初设盛京，后称奉天，为关外文化首善之区。其诗词发展深受流人文化和满族文化双重影响。明末清初，大批文士流放辽东，结成“冰天诗社”等，苦寒中相濡以诗。吴兆骞因科场案流放宁古塔（今黑龙江境内），途经辽东，所作《辽东行》《出关》苍凉沉郁；函可和尚流放沈阳，创“冰天诗社”，开东北诗社先河。满族诗人纳兰性德虽生于京师，但扈从康熙东巡盛京、吉林等地，所作《长相思》“山一程，水一程，身向榆关那畔行，夜深千帐灯”脍炙人口。清代奉天地区涌现缪公恩、戴亨、陈景元等“辽东三老”，诗宗汉魏，格调高迈。近现代辽宁诗人辈出：萧军以小说《八月的乡村》名世，亦有诗作；郭小川、公刘、邵燕祥等皆曾旅居或创作于辽宁，写下歌颂工业与海港的诗篇。大连海滨更吸引众多现代诗人流连，留下海韵华章。',5200,980),(7,'吉林','吉林乌拉、船厂','吉林满语原称“吉林乌拉”，意为沿江，清初设船厂。长白山为满族发祥圣地，被尊为龙兴之地。清代帝王多次东巡至此，康熙、乾隆俱有诗咏长白山、松花江，如康熙《松花江放船歌》，乾隆“滚滚遥源出不咸”追溯江源。流人文化同样深刻影响吉林诗坛：吴兆骞居宁古塔（今黑龙江省境内，清时属吉林将军辖区），与张缙彦、姚琢之等结“七子诗社”，吟哦不绝，其《秋笳集》多写塞外奇寒与故园之思。近代诗人成多禄为“吉林三杰”之一，诗风雄健苍凉，被誉为“北地骚人”。现当代诗人公木（张松如）为河北人,却长期在吉林大学工作，创作《八路军进行曲》歌词，诗歌理论建树颇丰；胡昭、丁耶等本土诗人扎根关东黑土，以新诗描绘林海雪原、松花江畔的壮美与朴厚。',2800,450),(8,'黑龙江','龙江、黑水','黑龙江古称黑水，地处极北，清初宁古塔是主要流放地，流人诗歌成为黑龙江古代文学最重要的一脉。顺治、康熙年间，方拱乾、方孝标、张贲、张缙彦等大批文人因科场或政治案流放宁古塔，他们在冰雪绝域结社吟诗，张缙彦辑《域外集》，方拱乾有《何陋居集》，为中国第一部东北流人诗集。他们用诗歌记录边塞风光、物产风俗及流放悲欢，风格凄怆深厚。清中后期，黑龙江本土文士渐起，如崔珽等以诗名。近代中东铁路修建，哈尔滨成为国际都市，现代诗潮随之涌入。女作家萧红虽以小说《呼兰河传》闻名，其文笔诗意盎然；乌·白辛、巴彦布等少数民族诗人带来异质文化色泽。当代迟子建的写作充满北国灵性诗性，李琦等诗人以细腻之笔写冰雪中的温暖。',3100,520),(9,'上海','沪、申城、松江府','上海古为松江府华亭县，南宋建镇，元设县，近代开埠后迅速崛起，成为现代都市诗与文学的重镇。西晋陆机、陆云为华亭人，陆机《文赋》为重要文论，诗亦典雅；唐代天宝十年置华亭县，皮日休、陆龟蒙等曾在此游历。明代董其昌以书画名世，题画诗清逸；陈继儒隐居佘山，诗词小品闲适。清初陈子龙、夏完淳等云间派诗人抗清殉国，诗风悲慨，陈子龙“不信有天常似醉，最怜无地可埋忧”催人泪下。近代开埠后，上海迅速成为新文化运动与诗歌现代化的策源地。鲁迅、郭沫若、茅盾、巴金等长期居沪，大量新诗发表于此。任钧、蒲风等发起中国诗歌会，倡导现实主义；辛笛、陈敬容、唐祈等“九叶诗人”在上海形成现代诗浪潮；张爱玲的散文亦富诗意。改革开放后，上海是新潮诗实验场，城市诗、口语诗、先锋诗探索活跃。',7600,2100),(10,'江苏','吴、金陵、江南东道','江苏跨江滨海，钟灵毓秀，自古为诗词圣地。春秋吴国季札观乐评诗，开审美批评先河。汉代枚乘、枚皋父子为淮阴人，创汉赋七发等体。六朝时期，建康（南京）为都城，谢灵运、谢朓、鲍照等山水诗派萌生，谢朓“余霞散成绮，澄江静如练”被李白倾慕。唐代江苏诗人璀璨：扬州张若虚以孤篇《春江花月夜》盖全唐；刘慎虚、储光羲润州延陵人，山水田园诗清丽；张继《枫桥夜泊》“姑苏城外寒山寺，夜半钟声到客船”让苏州诗意永恒；白居易、刘禹锡任苏州刺史，白“扬州驿里梦苏州”，刘“苏州刺史例能诗”。南唐建都金陵，李璟、李煜父子词开一代新风，后主“问君能有几多愁，恰似一江春水向东流”冠绝千古。宋代范成大苏州人，田园诗与杨万里齐名；秦观高邮人，婉约词宗，“两情若是久长时，又岂在朝朝暮暮”。明代高启为明初诗人之冠，苏州北郭诗社活跃；唐寅等吴中四才子诗书画酒，狂放不羁。清代钱谦益、吴伟业为江左三大家，梅村体叙事长诗“恸哭六军俱缟素，冲冠一怒为红颜”史笔诗心；袁枚南京随园倡导性灵说。现代卞之琳、朱自清等皆为江苏籍，卞诗“你在桥上看风景，看风景人在楼上看你”哲理绵长。',32500,7800),(11,'浙江','越、会稽、两浙路','浙江山灵水秀，诗脉浩荡。先秦越歌《越人歌》“山有木兮木有枝，心悦君兮君不知”婉转动人。东晋王羲之兰亭雅集，“群贤毕至，少长咸集”，流觞赋诗成千古佳话；谢灵运任永嘉太守，创山水诗派，“池塘生春草，园柳变鸣禽”清新可爱。唐代浙江诗人辈出：骆宾王义乌人，七岁咏鹅；贺知章越州永兴人，“少小离家老大回”；孟郊湖州武康人，“慈母手中线，游子身上衣”；钱起吴兴人，大历十才子之一；张志和婺州人，《渔歌子》“西塞山前白鹭飞”开文人词先河。宋代苏轼两任杭州，与白居易同筑苏堤白堤，“欲把西湖比西子，淡妆浓抹总相宜”使湖山诗化；陆游越州山阴人，爱国诗词惊天地，“王师北定中原日，家祭无忘告乃翁”至死不渝；李清照避乱金华登八咏楼，“水通南国三千里，气压江城十四州”；永嘉四灵、江湖诗派等活跃。元末杨维桢诸暨人，铁崖体瑰奇。明代于谦钱塘人，《石灰吟》清白传世；张岱《湖心亭看雪》文如诗。清代朱彝尊秀水人，浙西词派宗主；袁枚侨寓杭州。近现代新诗星群闪耀：徐志摩海宁人，“轻轻的我走了”；戴望舒杭州人，“撑着油纸伞”；艾青金华人，“为什么我的眼里常含泪水”；穆旦、冯至等皆与浙江渊源深厚。',29800,6900),(12,'安徽','皖、徽州、江南省','安徽南北分属江淮，文化兼具中原厚重与江南清绮。先秦《诗经》中“关雎”诗篇可能采自皖地。汉魏时期，曹操、曹丕、曹植父子谯郡人（今亳州），建安风骨慷慨悲凉，“对酒当歌，人生几何”雄视千古；嵇康铚城人（今濉溪），竹林名士，其四言诗清峻。唐代池州杜牧任刺史，“清明时节雨纷纷，路上行人欲断魂”即写贵池杏花村；李白五游安徽，在宣城敬亭山“相看两不厌”，在马鞍山捉月升天；刘长卿、韦应物等宦游皖南，留下无数佳咏。南唐亡国，徽州崛起文教。宋代梅尧臣宣城人，开宋诗平淡先河；欧阳修守滁州，作《醉翁亭记》并诗，环滁皆山也，林壑尤美；王安石含山人，诗风遒劲；宋代徽商兴盛，程朱理学发端，朱熹虽籍江西，但祖籍徽州婺源，常返歙县等地讲学赋诗。明代桐城派方苞、刘大櫆、姚鼐等提倡古文义法，诗亦雅正；新安画派渐江等诗画禅意。清代徽州“一生痴绝处，无梦到徽州”，汤显祖此诗句令皖南诗意扬名。现代胡适绩溪人，新诗开山，“两个黄蝴蝶，双双飞上天”；汪静之湖畔诗人，“我冒犯了人们的指摘”。',11600,2800),(13,'福建','闽、八闽、福州路','福建山海环抱，自唐五代以来文教渐兴，宋代以后诗家迭出。唐末五代，王审知治闽，折节下士，中原诗人如韩偓等入闽，播下诗种。宋代成为福建文学黄金期：柳永崇安人，婉约派大宗，“今宵酒醒何处？杨柳岸、晓风残月”凡有井水处即能歌柳词；杨亿浦城人，西昆体领袖；李纲邵武人，抗金名臣，诗词慷慨；朱熹虽生于尤溪，长于建阳，理学诗“问渠那得清如许，为有源头活水来”寓理于景；刘克庄莆田人，江湖诗派巨擘，“男儿西北有神州，莫滴水西桥畔泪”呼吁恢复。元代杨载为元诗四大家之一。明代闽中十子复兴唐音，林鸿、高棅等倡导盛唐诗风，高棅《唐诗品汇》影响深远；李贽泉州人，其诗反传统，极具个性。清代黄任永福人，诗名台湾海峡两岸。近现代福建诗人影响全国：林徽因福州人，新诗《你是人间的四月天》灵动隽永；冰心长乐人，《繁星》《春水》开小诗哲理一派；郑敏为九叶派女诗人；舒婷世居厦门鼓浪屿，“我如果爱你——绝不像攀援的凌霄花”是新时期朦胧诗代表作。',7600,2100),(14,'江西','豫章、江右','江西古称豫章，素有“物华天宝，人杰地灵”之誉，诗词文脉极度昌盛。东晋陶渊明柴桑人（今九江），弃官归隐，“采菊东篱下，悠然见南山”，开创田园诗派，其《桃花源记》亦为诗序。唐代江西诗人初盛：綦毋潜虔州人，与王维唱和；刘昚虚新吴人，诗境清幽；王昌龄被誉为“七绝圣手”，虽籍江宁，但曾在龙标贬所，其心系江右；郑谷宜春人，以鹧鸪诗得名郑鹧鸪。宋代江西文学达到全盛：晏殊、晏几道父子临川人，婉约大家，“无可奈何花落去，似曾相识燕归来”；欧阳修庐陵人，一代文宗，诗文革新的领袖，“月上柳梢头，人约黄昏后”亦为欧词名句；王安石临川人，诗风遒劲，“春风又绿江南岸”锤炼精工；曾巩南丰人，散文名家，诗亦清健；黄庭坚分宁人，开创江西诗派，影响波及整个南宋，“桃李春风一杯酒，江湖夜雨十年灯”深挚感人；杨万里吉水人，创诚斋体，“小荷才露尖尖角，早有蜻蜓立上头”清新活泼；文天祥吉安人，“人生自古谁无死，留取丹心照汗青”光照千古。元代揭傒斯、虞集等延祐大家多出江西。明代汤显祖临川人，戏曲诗中“情不知所起，一往而深”极富诗意；解缙吉水人，主持编纂《永乐大典》。清代蒋士铨铅山人，与袁枚、赵翼并称乾隆三大家。现代陈寅恪修水人，诗史互证。',14200,3400),(15,'山东','齐鲁、东鲁','山东齐鲁大地，是儒家诗教发源地，《诗经》即由孔子最后编定，“《诗》三百，一言以蔽之，曰：思无邪”，诗学传统贯穿古今。先秦《齐风》《鲁风》皆山东之诗。西汉韦孟、韦玄成父子为邹人，作四言诗延续风雅；东方朔厌次人，滑稽善赋。东汉末孔融鲁人，建安七子之一。魏晋左思临淄人，构思十年成《三都赋》，洛阳纸贵，其咏史诗“振衣千仞冈，濯足万里流”格局宏阔。南北朝鲍照东海人，七言歌行壮丽，开李白之先河。唐代储光羲兖州人，山水田园诗清丽；段成式临淄人，诗奇丽。宋代山东籍大词人、诗人极多：王禹偁巨野人，宋初诗文革新先驱；李之仪无棣人，“我住长江头，君住长江尾”朴素动人；李清照济南人，婉约词宗，“寻寻觅觅，冷冷清清，凄凄惨惨戚戚”更是绝唱；辛弃疾济南人，词坛飞将，“醉里挑灯看剑，梦回吹角连营”豪壮悲凉。金元之际，杜仁杰等山东曲家亦多诗词。明代李开先章丘人，边贡历城人，前七子之一；谢榛临清人，后七子首领，诗论《四溟诗话》影响深远；清代王士禛新城人，创“神韵说”，主盟康熙诗坛四十余年；蒲松龄淄川人，聊斋诗亦清丽；赵执信博山人，诗主峻刻。现代诗人臧克家诸城人，“有的人活着，他已经死了”入骨三分；贺敬之峄县人，《回延安》激情澎湃。',16800,3900),(16,'河南','中原、豫州、河洛','\'河南古称中州，地处天下之中，是华夏文明核心发祥地，历代诗词巨星灿若星辰。先秦《诗经·国风》中的《郑风》《卫风》《王风》产生于河南，如“关关雎鸠”的周南也涉此地。东汉张衡南阳人，《四愁诗》创七言雏形；蔡邕、蔡琰父女陈留人，《悲愤诗》字字血泪。魏晋“建安七子”中阮瑀、徐干等，竹林七贤中阮籍、阮咸、向秀等多为河南籍，阮籍《咏怀》诗“忧思独伤心”开创正始玄言诗风。唐代更是河南诗人的天下：杜甫巩义人（祖籍襄阳），“朱门酒肉臭，路有冻死骨”诗史铸就；白居易新郑人，《长恨歌》《琵琶行》妇孺皆知；李商隐怀州河内人（今沁阳），无题诗深婉绮丽；韩愈河阳人，以文为诗，奇崛雄放；岑参南阳人（一说江陵），“忽如一夜春风来”奇丽边塞；元稹洛阳人，与白居易齐名；李贺福昌人（今宜阳），诗称鬼才，“天若有情天亦老”；刘禹锡洛阳人，诗豪旷达，“沉舟侧畔千帆过”。北宋建都开封，西京洛阳，文人云集：程颢、程颐理学亦寓于诗；贺铸卫州人，“一川烟草，满城风絮，梅子黄时雨”得号贺梅子。明代何景明信阳人，前七子领袖；清初侯方域商丘人，诗文名世。现代徐玉诺、苏金伞等新诗质朴有力。',21500,5000),(17,'湖北','荆楚、鄂州','湖北古称荆楚，瑰丽浪漫的楚辞在此诞生。屈原秭归人，行吟沅湘，作《离骚》《九歌》《天问》，开中国个人诗歌创作先河，“路漫漫其修远兮，吾将上下而求索”百代传响；宋玉继之，《九辩》悲秋之祖。汉代王昭君秭归人，出塞和亲，历代诗人多有吟咏。唐代湖北诗人群星耀目：孟浩然襄州襄阳人，山水田园诗巨匠，“春眠不觉晓，处处闻啼鸟”自然天成；皮日休襄阳人，与陆龟蒙齐名，散文与诗兼善；岑参江陵人（一说南阳），边塞诗雄；张继籍襄州，《枫桥夜泊》名篇。宋代米芾襄阳人，书画大家，诗亦豪放；公安三袁：袁宗道、袁宏道、袁中道，创公安派，主张“性灵”，影响晚明诗风。最煊赫者为苏轼贬谪黄州（今黄冈）期间，写下前后《赤壁赋》与《念奴娇·赤壁怀古》“大江东去，浪淘尽，千古风流人物”，此外在黄州还作有《定风波》“莫听穿林打叶声”，实现人生与诗境的双重升华。近现代诗人闻一多浠水人，致力于新诗格律化，《红烛》《死水》堪称经典；胡风蕲春人，七月诗派的理论导师；曹禺虽为剧作家，其剧作亦充满诗性。',13800,3300),(18,'湖南','湘、潇湘、楚南','湖南地处洞庭之南，潇湘山水滋养了斑斓诗章。战国屈原流放沅湘之间，作《九歌·湘君》《湘夫人》，湘水女神飘渺含情，“袅袅兮秋风，洞庭波兮木叶下”。西汉贾谊谪居长沙，作《吊屈原赋》《鵩鸟赋》，开骚体流变。唐代李群玉澧州人，诗笔清丽，令狐楚荐之；齐己益阳人，诗僧，“前村深雪里，昨夜一枝开”传为炼字典范；刘禹锡贬朗州司马，居常德十年，学巴渝民歌为新词，“东边日出西边雨，道是无晴还有晴”。宋代周敦颐道州人，理学开山，《爱莲说》以花喻人，“出淤泥而不染”兼有诗境；王以宁等湘籍词人活跃。明末清初，衡阳王夫之（船山）抗清隐居，诗词深寄故国之思，著述等身。近代湘军人物曾国藩、左宗棠等皆工诗，曾氏“倚天照海花无数，流水高山心自知”颇具哲思。维新变法中谭嗣同浏阳人，“我自横刀向天笑，去留肝胆两昆仑”慷慨就义。现代毛泽东出自湘潭韶山，其诗词气吞山河，“数风流人物，还看今朝”壮阔雄浑；沈从文凤凰人，虽以小说名世，其文字如水般流淌诗意。',12300,2900),(19,'广东','岭南、粤','广东古为百越之地，秦汉以后中原文化南渐，唐宋以降诗词渐兴。唐代曲江张九龄开岭南诗派先河，“海上生明月，天涯共此时”情韵兼胜，又有“草木有本心，何求美人折”标格高洁；韩愈贬潮州，“一封朝奏九重天，夕贬潮州路八千”，在潮期间兴学化民，诗亦沉郁。宋代余靖韶州人，与欧阳修等为“庆历四谏”，诗风刚健；刘昉等亦以诗名。明代广东诗坛大振：明初“南园五子”孙蕡、王佐等结社唱酬，称雄岭表；陈白沙新会人，创江门学派，诗主自然，涵养性灵。清初“岭南三大家”屈大均、陈恭尹、梁佩兰鼎立，屈诗词气雄深，“悲歌慷慨临风立，莫道无人识姓名”气节凛然；清中叶黎简、宋湘等学宋人，锐意创新。晚清至近代，广东成为诗界革命策源地：黄遵宪嘉应州人（今梅州），提出“我手写我口”，《人境庐诗草》实践新意境；康有为南海人，梁启超新会人，以诗推动维新变革，梁氏“世界无穷愿无尽，海天寥廓立多时”豪迈深远；苏曼殊香山人，诗僧情怀，“芒鞋破钵无人识，踏过樱花第几桥”。现代李金发梅县人，中国象征派诗歌先驱。',7600,2100),(20,'广西','八桂、广南西路','广西地处岭南西道，桂林山水甲天下，奇峰秀水引来无数文人题咏。南朝颜延之被贬始安郡守，常于独秀峰下读书赋诗，开桂林文风。唐初褚遂良贬桂州，留下《桂州诗》。韩愈未亲至桂林，却以“江作青罗带，山如碧玉簪”生动摹写。柳宗元任柳州刺史四年，释放奴婢、兴办学堂、开凿水井，政余吟哦，“岭树重遮千里目，江流曲似九回肠”写尽贬谪情思，临终前嘱建柳侯祠，至今享祀。晚唐曹邺阳朔人，为广西首位著名进士诗人，“官仓老鼠大如斗，见人开仓亦不走”讽喻深刻；曹唐临桂人，游仙诗奇丽。宋代王正功咏出“桂林山水甲天下”千古名句；范成大、张孝祥等宦游广西，皆有诗章。明代解缙贬广西，有诗抒怀。清代广西诗坛蓬勃发展，“临桂词派”与浙西、常州词派鼎足而三：王鹏运、况周颐为晚清四大词人，况氏《蕙风词话》影响巨大；此外张鹏展、朱琦等亦以诗鸣。抗战时期，桂林成为文化城，郭沫若、茅盾、巴金、艾青等大批文化人汇聚，艾青在此创作《北方》等诗篇。',4100,780),(21,'海南','琼州、儋耳','海南古称儋耳、珠崖，孤悬海外，诗脉因贬谪文人而兴盛。唐宰相李德裕贬崖州，“崖州何处在，生度鬼门关”悲凉无限。对海南诗教影响最深远的是苏东坡，晚年贬谪儋州三年，虽已高龄，仍办学堂、传教化，与黎民交往，诗作丰硕，“我本儋耳人，寄生西蜀州”“他年谁作舆地志，海南万里真吾乡”等体现出随遇而安的旷达。苏过随侍，亦多诗篇。宋代白玉蟾为道教南宗五祖，琼州人，诗书画俱佳，飘逸出尘。明代海南人文蔚起：丘濬琼山人，官至大学士，有“琼台先生”之称，诗以说理为主，亦不乏性情；海瑞琼山人，刚直不阿，其诗如其人，“干戈此日犹未定，何日中原一扫平”关心民瘼。清代张岳崧为探花，诗学昌黎。近现代冯白驹等革命者亦有诗词留世。黎族创世史诗色调古朴，与汉诗交融共美。',1900,320),(22,'重庆','渝州、巴郡、恭州','重庆古称巴郡，山川险峻，云雾缭绕，诗风奇崛。先秦《巴渝舞》歌辞刚健。唐代重庆为夔州、渝州、涪州等地，李白“夜发清溪向三峡，思君不见下渝州”轻舟飞渡；李商隐《夜雨寄北》“君问归期未有期，巴山夜雨涨秋池”缠绵切切。而杜甫在夔州（今奉节、巫山一带）寓居近两年，成诗四百三十余首，《秋兴八首》《咏怀古迹五首》《登高》等千古名篇均诞生于此，“无边落木萧萧下，不尽长江滚滚来”沉郁顿挫，是其诗艺巅峰。宋代陆游入蜀任夔州通判，有《入蜀记》，作“细雨骑驴入剑门”等名句；王十朋知夔州，诗碑至今。明代杨慎贬滇往来，有诗咏巴渝。清代张问陶船山遂宁人（当时属四川），性灵诗风，写三峡诗极多。现代诗人何其芳重庆万州人，从早期《预言》的柔美到延安后《夜歌》的写实，在中国新诗史占有重要地位；方敬、梁上泉等亦活跃于重庆诗坛。',7800,1600),(23,'四川','蜀、益州、剑南','四川素称“天府之国”，物阜文丰，历代诗文巨匠大量出自巴蜀或在此成就。西汉司马相如成都人，汉赋四大家之首，其赋中亦多诗化语句；扬雄成都人，《方言》《太玄》等著作外，有《酒箴》等韵文；王褒资阳人，《僮约》等虽为赋，亦富诗趣。唐代李白生于绵州昌隆（今江油青莲乡），出川后纵横天下，“峨眉山月半轮秋，影入平羌江水流”起步不凡；陈子昂射洪人，高举汉魏风骨，“前不见古人，后不见来者”振聋发聩；薛涛居成都浣花溪，“花开不同赏，花落不同悲”细腻动人，创制薛涛笺；雍陶成都人，诗亦隽永。五代前蜀、后蜀词客云集，《花间集》编纂于成都，温庭筠、韦庄等开倚声填词先河，韦庄“人人尽说江南好，游人只合江南老”实寓蜀乡之恋；女诗人花蕊夫人以“十四万人齐解甲，更无一个是男儿”传世。宋代苏洵、苏轼、苏辙父子出眉山，三苏文名动天下，东坡“大江东去……”“但愿人长久，千里共婵娟”等豪放清雄，开词体新境界。明代杨慎新都人，发配云南三十余年，“滚滚长江东逝水”一词传为《三国演义》开篇。清代李调元罗江人，辑《函海》，诗主性灵。近现代郭沫若乐山人，新诗集《女神》开浪漫主义先河；“五四”之后，四川诗人流沙河、周啸天等影响深远。',22400,5100),(24,'贵州','黔、夜郎','贵州古为夜郎地，山重水复，明代建省后文教渐兴，诗词发展虽晚而潜力深厚。汉代唐蒙通夜郎，李白闻王昌龄左迁龙标，有“我寄愁心与明月，随风直到夜郎西”之句，虽非实指贵州，却令贵州与诗结缘。明代大儒王阳明因忤刘瑾谪为贵州龙场驿丞，居黔三年，龙场悟道，心境豁然开朗，作《瘗旅文》等名篇，诗作如“天下之山萃于云贵”等纪游山水，理趣并蓄，广授生徒，黔中诗教由此肇兴。杨慎谪戍云南永昌期间多次过黔，“肠断滇南与黔北”悲慨万端。明中后期贵州本土文人孙应鳌、谢三秀等崭露头角。清代黔诗迎来高潮：“沙滩文化”代表人物郑珍、莫友芝、黎庶昌均为贵州遵义人，郑珍被尊为“西南巨儒”，其《巢经巢诗》深得韩黄神髓，莫友芝精金石小学，诗亦渊雅；周起渭贵阳人，康熙进士，诗名动京师。近现代蹇先艾、廖公弦等新诗写黔山黔水，充满乡土气息。',3100,580),(25,'云南','滇、南诏、大理','云南古称滇，西汉置郡，地处西南边陲，诗文化融合汉、白、彝、纳西等多民族特质。汉有一首《渡兰沧歌》载于《华阳国志》，开云南诗歌记录之先。唐代南诏王异牟寻与唐和好，南诏德化碑文采斐然；南北相接，多有使节唱酬。宋代大理国与中原交往亦留诗迹。明代杨慎贬戍云南永昌卫（今保山）三十余年，虽身处天涯，仍孜孜不倦著述、授徒、吟诗，“天气常如二三月，花枝不断四时春”歌咏云南气候，与丽江土司木公、木增等唱和，带动滇云诗风；担当和尚（唐泰）诗书画禅兼绝，气格超逸。明末清初，孙髯翁贫困中作昆明大观楼长联，上下联各九十言，被誉为“天下第一长联”，气势磅礴，一扫俗尘。清代钱沣昆明人，诗书画三绝，诗格刚正。近现代云南诗坛因西南联大而璀璨：1938年后，北大、清华、南开迁昆组成西南联大，冯至在昆明写出巅峰之作《十四行集》，穆旦（查良铮）在此写下《赞美》《春》等现代诗经典，朱自清、闻一多、沈从文等一大批文人共同营造出战时昆明浓厚的诗歌氛围。少数民族史诗《阿诗玛》《创世纪》等亦被整理为叙事长诗。',4900,890),(26,'西藏','吐蕃、乌斯藏','西藏古为吐蕃，雪域高原宗教氛围浓厚，诗歌传统以藏族典籍与民歌为主。吐蕃时期松赞干布创制文字，敦煌及新疆出土古藏文写卷中已有赞普传记诗与卜辞。12世纪噶举派尊者米拉日巴《十万道歌》以通俗犀利的诗歌弘法，成为藏族诗教早期典范。后世达赖、班禅等高僧亦多诗作。17世纪仓央嘉措以其道歌独步雪域，其汉译本“住进布达拉宫，我是雪域最大的王。流浪在拉萨街头，我是世间最美的情郎”“世间安得双全法，不负如来不负卿”触动世人，融宗教、爱情与民俗为一体。清代驻藏大臣和琳、松筠等亦有诗记藏地风物。现代藏族诗人伊丹才让、饶阶巴桑、唯色等以藏汉双语创作，将传统与现代交织，题材从草原到城市，拓宽了西藏诗歌版图。长篇英雄史诗《格萨尔王传》被誉为东方荷马史诗，韵散结合，传唱千年不绝。',1500,200),(27,'陕西','秦、三秦、关中','陕西是周秦汉唐等十三个王朝建都之地，中国诗歌发展的核心舞台。《诗经》“秦风”“豳风”等采集于此，如“岂曰无衣？与子同袍”激昂慷慨。西汉司马迁韩城人，《史记》被鲁迅誉为“无韵之离骚”。长安作为汉唐帝都，吸引天下诗人。汉代班固、张衡等大赋家均在此活动。唐代为诗歌巅峰时期的中心：王勃、杨炯、卢照邻、骆宾王“初唐四杰”入长安受激赏；陈子昂长安碎琴献诗；李白奉诏入京，“长安一片月，万户捣衣声”，又“仰天大笑出门去”；杜甫困居长安十年，“朱门酒肉臭，路有冻死骨”；王维在终南山下辋川别业诗画禅修，“行到水穷处，坐看云起时”；白居易长期在长安为官，新乐府运动影响巨大；杜牧为长安人，《阿房宫赋》开篇雄奇。长安籍诗人韦应物、薛涛（游宦）、鱼玄机等各具面目。宋代寇准下邽人，有“只有天在上，更无山与齐”的《华山》诗。金元时期关中亦多诗人。明代康海、王九思等前七子籍贯陕籍，力振诗风。近代陕西有于右任，诗沉雄壮阔，《望大陆》凄楚苍凉；延安时期，艾青、何其芳、萧三、郭小川等汇聚，创作《给战斗者》《延安与中国青年》等革命战歌。当代路遥虽以小说名世，其文字中也渗透着黄土地的诗魂。',18800,4300),(28,'甘肃','陇、凉州、河陇','甘肃古为雍凉之地，丝绸之路贯穿全境，诗词以边塞、行旅题材为主，风格雄浑苍凉。汉代张骞通西域，乐府诗《陇头歌》“陇头流水，流离山下”悲慨动人。魏晋傅玄泥阳人（今宁县），诗颇多风骨。唐代边塞诗大量取材甘肃：王翰“葡萄美酒夜光杯，欲饮琵琶马上催”苍凉豪纵；王昌龄“秦时明月汉时关，万里长征人未还”；高适、岑参多次出塞赴河西、安西，高适《别董大》“莫愁前路无知己，天下谁人不识君”，岑参《白雪歌送武判官归京》“北风卷地白草折……千树万树梨花开”皆作于今甘肃一带；李白《关山月》“长风几万里，吹度玉门关”气魄宏大。中唐李贺籍属福昌，但其“大漠沙如雪，燕山月似钩”亦有边塞魂魄。宋代金国统治期间，邓千江作《望海潮·上兰州守》被誉为金人乐府第一。明代李梦阳庆阳人，为前七子领袖，主张“文必秦汉，诗必盛唐”。清代吴镇狄道人，有“关西四杰”之称。当代叶舟《大敦煌》等组诗重铸河西走廊诗魂。',5400,1200),(29,'青海','西海、河源','青海地处江河之源，古为羌戎地，王莽设西海郡，是中原与边塞文化交汇处，诗词多具高原荒寒与民族色彩。唐代边塞诗屡涉青海，哥舒翰曾与吐蕃战于青海，李白《关山月》“汉下白登道，胡窥青海湾”；杜甫《兵车行》“君不见青海头，古来白骨无人收”；王昌龄“青海长云暗雪山，孤城遥望玉门关”等名句均以青海为背景，表达对征夫的同情。宋代熙河开边，诗文亦有波及。明清两代西宁卫设儒学，地方文人渐多：明代张问仁等有诗名；清代杨应琚任西宁道，纂修《西宁府新志》，诗纪边陲风物。汉族、藏族、回族、土族、蒙古族等多民族文学交融，民歌“花儿”广为传唱，词浅情深。现代“西部歌王”王洛宾采集创作的《在那遥远的地方》《半个月亮爬上来》等均汲取青海民族音乐营养，诗乐合一。当代诗人昌耀1950年代因诗罹祸流放青海，在此生活创作数十年，以高原为稿纸，写《慈航》《划呀，划呀，父亲们！》等扛鼎之作，成为中国新诗的高峰。',2100,280),(30,'宁夏','西夏、兴庆','宁夏古为塞上江南，东依黄河，西屏贺兰，唐宋边塞诗重镇。唐代王维奉命出使凉州，途经萧关（今固原一带），写下“大漠孤烟直，长河落日圆”的千古名句；韦蟾《送卢潘尚书之灵武》“贺兰山下果园成，塞北江南旧有名”。宋代西夏立国，创制西夏文，翻译《诗经》《论语》等典籍，亦有西夏文诗歌、谚语集《新集锦合辞》等遗存，风格质朴诙谐。岳飞《满江红》“驾长车，踏破贺兰山缺”虽系泛指，却令贺兰山与英雄气概紧密相联。元代西夏遗民有诗人如王翰（非唐王翰）、余阙等，其诗词中仍见故园记忆。明代宁夏巡抚崔景荣、杨应聘等皆有诗咏边关防御与河渠水利。清代宁夏府出现赵良栋等能诗武将。现代诗人李季、闻捷等曾在宁夏体验生活，创作以信天游等民歌为形式的新诗。',1600,280),(31,'新疆','西域、安西','新疆古称西域，是丝绸之路核心区，多元文明交融，诗歌以边塞征战、丝路风情为主。汉乐府《战城南》已涉西域征战，《李陵歌》见于西域文献。唐代经营安西、北庭，大量诗人从军或出使西域。骆宾王随军到天山，有《晚度天山有怀京邑》；李白《关山月》《塞下曲》等亦寄西域；岑参曾两次出塞，在北庭、轮台生活多年，写下《白雪歌》《走马川行》《轮台歌》等边塞诗顶峰之作，“轮台九月风夜吼，一川碎石大如斗”惊心动魄。高适亦有西域之作。宋元回鹘诗人尤素甫·哈斯·哈吉甫在喀喇汗王朝时期创作长篇劝喻诗《福乐智慧》，哲理深邃，韵律严整。清代统一西域后，流放文人纪昀、洪亮吉等皆有西域诗，纪昀《乌鲁木齐杂诗》一百六十首描绘风俗物产；林则徐遣戍伊犁，作“苟利国家生死以，岂因祸福避趋之”明志。维吾尔族诗人铁依甫江·艾里耶夫等在现代以新诗讴歌绿洲新貌；《十二木卡姆》唱词集古典诗之大成，充满音乐性。',2800,510),(32,'台湾','夷洲、琉球、东宁','台湾诗史自明郑时期正式开启。1661年郑成功收复台湾，沈光文等明末遗老随至，播下诗种，其结“东吟社”，为台湾第一个诗社。清统一后，大量大陆文人宦游或流寓台湾，诗社林立，击钵吟盛行。清康熙间郁永河采硫磺，作《裨海纪游》诗。雍乾年间台湾本土出身的诗人开始崭露，如陈鹏南等。光绪年间，丘逢甲甲午后内渡，写《离台诗》“四百万人同一哭，去年今日割台湾”悲愤交迸，后迭有抗日诗篇。连横博通文史，辑《台湾诗乘》，保存大量台湾诗作。日据时期，传统诗社如台中栎社、台北瀛社等延续诗脉，同时新诗萌芽。赖和、杨华、龙瑛宗等在殖民压迫下用中文、日文创作，抵抗书写极为动人。1949年后，大批迁台诗人如覃子豪、郑愁予、余光中、杨牧等持续创作，余光中《乡愁》“而现在，乡愁是一湾浅浅的海峡”牵动两岸，郑愁予“我达达的马蹄是美丽的错误”成为新诗经典。席慕蓉、罗智成、陈黎等当代诗人丰富台湾诗坛。',5800,1300);
/*!40000 ALTER TABLE `provinces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_favorite`
--

DROP TABLE IF EXISTS `recite_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `target_id` bigint NOT NULL COMMENT '收藏目标ID',
  `favorite_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收藏类型：playlist/video',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_target_type` (`user_id`,`target_id`,`favorite_type`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_target_id` (`target_id`) USING BTREE,
  KEY `idx_favorite_type` (`favorite_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='朗诵收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_favorite`
--

LOCK TABLES `recite_favorite` WRITE;
/*!40000 ALTER TABLE `recite_favorite` DISABLE KEYS */;
INSERT INTO `recite_favorite` VALUES (1,1,1,'playlist','2026-03-18 16:55:59'),(2,1,2,'playlist','2026-03-18 16:55:59'),(4,2,3,'playlist','2026-03-18 16:55:59'),(5,3,2,'playlist','2026-03-18 16:55:59'),(6,4,4,'playlist','2026-03-18 16:55:59'),(10,1,1,'audio','2026-03-20 23:12:33'),(11,1,2,'audio','2026-03-20 23:12:33'),(12,1,4,'audio','2026-03-20 23:12:33'),(13,2,3,'audio','2026-03-20 23:12:33'),(14,2,5,'audio','2026-03-20 23:12:33'),(15,2,1,'audio','2026-03-20 23:41:42'),(18,2,1,'playlist','2026-03-21 00:19:13'),(20,2,4,'playlist','2026-03-21 13:23:28'),(21,8,1,'playlist','2026-03-21 13:23:44'),(22,8,1,'audio','2026-03-21 13:23:46'),(23,8,2,'audio','2026-03-21 13:23:47'),(24,8,2,'playlist','2026-03-27 11:35:39'),(25,8,5,'playlist','2026-03-27 11:35:41'),(26,8,3,'audio','2026-03-27 11:35:50'),(27,8,9,'playlist','2026-03-27 11:36:00');
/*!40000 ALTER TABLE `recite_favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_playlist`
--

DROP TABLE IF EXISTS `recite_playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_playlist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '诗单名称',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'album音频集 / taste鉴赏',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '简介',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '1启用 0停用',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='朗诵诗单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_playlist`
--

LOCK TABLES `recite_playlist` WRITE;
/*!40000 ALTER TABLE `recite_playlist` DISABLE KEYS */;
INSERT INTO `recite_playlist` VALUES (1,'千古家国志','album','/files/langsongtupian/1.jpg','爱国诗、边塞诗、咏史怀古、壮志豪情',1,1,'2026-03-21 00:12:33','2026-03-21 14:48:19'),(2,'山水田园心','album','/files/langsongtupian/2.jpg','山水诗、田园诗、写景咏物、自然禅意',2,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(3,'人间风月情','album','/files/langsongtupian/3.jpg','爱情诗、闺怨、相思、离别、悼亡',3,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(4,'岁月浮生记','album','/files/langsongtupian/4.jpg','人生感慨、时光、岁月、暮年、境遇',4,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(5,'风物节气吟','album','/files/langsongtupian/5.jpg','节气、节日、民俗、四季、时令',5,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(6,'江湖行旅歌','album','/files/langsongtupian/6.jpg','羁旅、行舟、远游、乡愁、怀古行吟',6,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(7,'风骨咏物篇','album','/files/langsongtupian/7.jpg','咏物言志、托物寄情、品格气节',7,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(8,'文心哲思录','album','/files/langsongtupian/8.jpg','哲理诗、禅诗、悟道、人生智慧',8,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(9,'诗中典故','taste','/files/langsongtupian/9.jpg','那些藏在诗句里的历史故事；解读诗词背后的历史、典故、人物，听懂一句诗，读懂一段往事。',1,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(10,'诗人心事','taste','/files/langsongtupian/10.jpg','读懂诗词背后的人生；从生平经历解读作品，看李白、杜甫、苏轼、李清照等为何写下那些句子。',2,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(11,'一字见心','taste','/files/langsongtupian/11.jpg','古诗词中的炼字艺术；赏析关键用字，讲清楚为什么这个字用得妙、意境全出。',3,1,'2026-03-21 00:12:33','2026-03-21 00:12:33'),(12,'同题不同情','taste','/files/langsongtupian/12.jpg','同一题材的千种诗意；对比同类诗词如送别、咏春、登高、思乡，体会不同诗人的心境与风格。',4,1,'2026-03-21 00:12:33','2026-03-21 00:12:33');
/*!40000 ALTER TABLE `recite_playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_playlist_item`
--

DROP TABLE IF EXISTS `recite_playlist_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_playlist_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `playlist_id` bigint NOT NULL COMMENT '诗单ID',
  `poem_id` bigint DEFAULT NULL COMMENT '诗词ID',
  `media_id` bigint DEFAULT NULL COMMENT '音频媒体ID',
  `item_title` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '音频标题',
  `item_subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '音频副标题',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图',
  `audio_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '音频地址',
  `is_hot` tinyint DEFAULT '0' COMMENT '是否热门',
  `is_pick` tinyint DEFAULT '0' COMMENT '是否精选',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_playlist_id` (`playlist_id`) USING BTREE,
  KEY `idx_poem_id` (`poem_id`) USING BTREE,
  KEY `idx_media_id` (`media_id`) USING BTREE,
  KEY `idx_is_hot` (`is_hot`) USING BTREE,
  KEY `idx_is_pick` (`is_pick`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='朗诵诗单关联作品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_playlist_item`
--

LOCK TABLES `recite_playlist_item` WRITE;
/*!40000 ALTER TABLE `recite_playlist_item` DISABLE KEYS */;
INSERT INTO `recite_playlist_item` VALUES (1,1,101,NULL,'关雎','佚名[先秦]','/files/images/default.jpg','/files/audio/poem/静夜思.mp3',1,0,1,'2026-03-18 18:23:21'),(2,1,102,NULL,'桃花源记','陶渊明[晋代]','/files/images/default.jpg','/files/audio/taohuayuanji.mp3',1,0,2,'2026-03-18 18:23:21'),(3,1,103,NULL,'杞人忧天','列子[先秦]','/files/images/default.jpg','/files/audio/qirenyoutian.mp3',1,0,3,'2026-03-18 18:23:21'),(4,2,104,NULL,'江城子·乙卯正月二十日夜记梦','苏轼[宋代]','/files/images/default.jpg','/files/audio/jiangchengzi.mp3',0,1,1,'2026-03-18 18:23:21'),(5,2,105,NULL,'念奴娇·赤壁怀古','苏轼[宋代]','/files/images/default.jpg','/files/audio/niannujiao.mp3',0,1,2,'2026-03-18 18:23:21'),(6,2,106,NULL,'浣溪沙','苏轼[宋代]','/files/images/default.jpg','/files/audio/huanxisha.mp3',0,1,3,'2026-03-18 18:23:21'),(7,3,107,NULL,'水调歌头','苏轼[宋代]','/files/images/default.jpg','/files/audio/shuidiaogetou.mp3',0,1,1,'2026-03-18 18:23:21'),(8,3,108,NULL,'题西林壁','苏轼[宋代]','/files/images/default.jpg','/files/audio/tixilinbi.mp3',0,1,2,'2026-03-18 18:23:21'),(9,2,NULL,NULL,'东郊','','/files/images/default.jpg','/files/audio/poem/东郊.mp3',0,0,1,'2026-03-28 22:25:18'),(10,3,NULL,NULL,'送杨氏女','','/files/images/default.jpg','/files/audio/poem/送杨氏女.mp3',0,0,2,'2026-03-28 22:25:18'),(11,1,NULL,NULL,'晨诣超师院读禅经','','/files/images/default.jpg','/files/audio/poem/晨诣超师院读禅经.mp3',0,0,3,'2026-03-28 22:25:18'),(12,4,NULL,NULL,'溪居','','/files/images/default.jpg','/files/audio/poem/溪居.mp3',0,0,4,'2026-03-28 22:25:18'),(13,2,NULL,NULL,'登幽州台歌','','/files/images/default.jpg','/files/audio/poem/登幽州台歌.mp3',0,0,5,'2026-03-28 22:25:18'),(14,3,NULL,NULL,'古意','','/files/images/default.jpg','/files/audio/poem/古意.mp3',0,0,6,'2026-03-28 22:25:18'),(15,1,NULL,NULL,'送陈章甫','','/files/images/default.jpg','/files/audio/poem/送陈章甫.mp3',0,0,7,'2026-03-28 22:25:18'),(16,4,NULL,NULL,'琴歌','','/files/images/default.jpg','/files/audio/poem/琴歌.mp3',0,0,8,'2026-03-28 22:25:18'),(17,2,NULL,NULL,'听安万善吹笛歌','','/files/images/default.jpg','/files/audio/poem/听安万善吹笛歌.mp3',0,0,9,'2026-03-28 22:25:18'),(18,3,NULL,NULL,'夜归鹿门歌','','/files/images/default.jpg','/files/audio/poem/夜归鹿门歌.mp3',0,0,10,'2026-03-28 22:25:18'),(19,1,NULL,NULL,'庐山谣寄卢侍御虚舟','','/files/images/default.jpg','/files/audio/poem/庐山谣寄卢侍御虚舟.mp3',0,0,11,'2026-03-28 22:25:18'),(20,4,NULL,NULL,'宣州谢朓楼','','/files/images/default.jpg','/files/audio/poem/宣州谢朓楼.mp3',0,0,12,'2026-03-28 22:25:18'),(21,2,NULL,NULL,'初发扬子寄元大校书','','/files/images/default.jpg','/files/audio/poem/初发扬子寄元大校书.mp3',0,0,13,'2026-03-28 22:25:18'),(22,3,NULL,NULL,'春泛若耶溪','','/files/images/default.jpg','/files/audio/poem/春泛若耶溪.mp3',0,0,14,'2026-03-28 22:25:18'),(23,1,NULL,NULL,'春思','','/files/images/default.jpg','/files/audio/poem/春思.mp3',0,0,15,'2026-03-28 22:25:18'),(24,4,NULL,NULL,'感遇其二','','/files/images/default.jpg','/files/audio/poem/感遇其二.mp3',0,0,16,'2026-03-28 22:25:18'),(25,2,NULL,NULL,'感遇其三','','/files/images/default.jpg','/files/audio/poem/感遇其三.mp3',0,0,17,'2026-03-28 22:25:18'),(26,3,NULL,NULL,'感遇其四','','/files/images/default.jpg','/files/audio/poem/感遇其四.mp3',0,0,18,'2026-03-28 22:25:18'),(27,1,NULL,NULL,'感遇其一','','/files/images/default.jpg','/files/audio/poem/感遇其一.mp3',0,0,19,'2026-03-28 22:25:18'),(28,4,NULL,NULL,'寄全椒山中道士','','/files/images/default.jpg','/files/audio/poem/寄全椒山中道士.mp3',0,0,20,'2026-03-28 22:25:18'),(29,2,NULL,NULL,'佳人','','/files/images/default.jpg','/files/audio/poem/佳人.mp3',0,0,21,'2026-03-28 22:25:18'),(30,3,NULL,NULL,'静夜思','','/files/images/default.jpg','/files/audio/poem/静夜思.mp3',0,0,22,'2026-03-28 22:25:18'),(31,1,NULL,NULL,'郡斋雨中与诸文士燕集','','/files/images/default.jpg','/files/audio/poem/郡斋雨中与诸文士燕集.mp3',0,0,23,'2026-03-28 22:25:18'),(32,4,NULL,NULL,'梦李白','','/files/images/default.jpg','/files/audio/poem/梦李白.mp3',0,0,24,'2026-03-28 22:25:18'),(33,2,NULL,NULL,'梦李白（杜甫）','','/files/images/default.jpg','/files/audio/poem/梦李白（杜甫）.mp3',0,0,25,'2026-03-28 22:25:18'),(34,3,NULL,NULL,'青溪','','/files/images/default.jpg','/files/audio/poem/青溪.mp3',0,0,26,'2026-03-28 22:25:18'),(35,1,NULL,NULL,'秋登兰山寄张五','','/files/images/default.jpg','/files/audio/poem/秋登兰山寄张五.mp3',0,0,27,'2026-03-28 22:25:18'),(36,4,NULL,NULL,'送别','','/files/images/default.jpg','/files/audio/poem/送别.mp3',0,0,28,'2026-03-28 22:25:18'),(37,2,NULL,NULL,'送綦毋潜落第还乡','','/files/images/default.jpg','/files/audio/poem/送綦毋潜落第还乡.mp3',0,0,29,'2026-03-28 22:25:18'),(38,3,NULL,NULL,'宿王昌龄隐居','','/files/images/default.jpg','/files/audio/poem/宿王昌龄隐居.mp3',0,0,30,'2026-03-28 22:25:18'),(39,1,NULL,NULL,'宿业师山房待丁大不至','','/files/images/default.jpg','/files/audio/poem/宿业师山房待丁大不至.mp3',0,0,31,'2026-03-28 22:25:18'),(40,4,NULL,NULL,'同从弟南斋玩月','','/files/images/default.jpg','/files/audio/poem/同从弟南斋玩月.mp3',0,0,32,'2026-03-28 22:25:18'),(41,2,NULL,NULL,'望岳','','/files/images/default.jpg','/files/audio/poem/望岳.mp3',0,0,33,'2026-03-28 22:25:18'),(42,3,NULL,NULL,'渭川田家','','/files/images/default.jpg','/files/audio/poem/渭川田家.mp3',0,0,34,'2026-03-28 22:25:18'),(43,1,NULL,NULL,'夕次盱眙县','','/files/images/default.jpg','/files/audio/poem/夕次盱眙县.mp3',0,0,35,'2026-03-28 22:25:18'),(44,4,NULL,NULL,'西施咏','','/files/images/default.jpg','/files/audio/poem/西施咏.mp3',0,0,36,'2026-03-28 22:25:18'),(45,2,NULL,NULL,'下终南山过斛斯山人宿置酒','','/files/images/default.jpg','/files/audio/poem/下终南山过斛斯山人宿置酒.mp3',0,0,37,'2026-03-28 22:25:18'),(46,3,NULL,NULL,'夏日南亭怀辛大','','/files/images/default.jpg','/files/audio/poem/夏日南亭怀辛大.mp3',0,0,38,'2026-03-28 22:25:18'),(47,1,NULL,NULL,'寻西山隐者不遇','','/files/images/default.jpg','/files/audio/poem/寻西山隐者不遇.mp3',0,0,39,'2026-03-28 22:25:18'),(48,4,NULL,NULL,'与高适薛据登慈恩寺浮图','','/files/images/default.jpg','/files/audio/poem/与高适薛据登慈恩寺浮图.mp3',0,0,40,'2026-03-28 22:25:18'),(49,2,NULL,NULL,'月下独酌','','/files/images/default.jpg','/files/audio/poem/月下独酌.mp3',0,0,41,'2026-03-28 22:25:18'),(50,3,NULL,NULL,'贼退示官吏并序','','/files/images/default.jpg','/files/audio/poem/贼退示官吏并序.mp3',0,0,42,'2026-03-28 22:25:18'),(51,1,NULL,NULL,'赠卫八处士','','/files/images/default.jpg','/files/audio/poem/赠卫八处士.mp3',0,0,43,'2026-03-28 22:25:18'),(52,4,NULL,NULL,'长安遇冯著','','/files/images/default.jpg','/files/audio/poem/长安遇冯著.mp3',0,0,44,'2026-03-28 22:25:18');
/*!40000 ALTER TABLE `recite_playlist_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_playlist_video`
--

DROP TABLE IF EXISTS `recite_playlist_video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_playlist_video` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `playlist_id` bigint NOT NULL COMMENT '专题ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '视频标题',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '作者',
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面',
  `video_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '视频地址',
  `duration` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '时长',
  `quality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '清晰度',
  `views` bigint DEFAULT '0' COMMENT '观看量',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '描述',
  `upload_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '上传时间',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_playlist_id` (`playlist_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_playlist_video`
--

LOCK TABLES `recite_playlist_video` WRITE;
/*!40000 ALTER TABLE `recite_playlist_video` DISABLE KEYS */;
INSERT INTO `recite_playlist_video` VALUES (1,11,'诗中典故·屈原','诗词讲堂','/files/images/default.jpg','/files/shouye/videos/爱过诗人屈原.mp4','08:12','1080P',120,'典故','爱国诗人屈原生平事迹','2026-03-22',1,'2026-03-22 19:05:54'),(2,11,'诗中典故·李白','古诗课堂','/files/images/default.jpg','/files/shouye/videos/李白诗歌赏析.mp4','06:45','1080P',98,'李白','李白诗歌典故赏析','2026-03-22',2,'2026-03-22 19:05:54'),(3,11,'诗人心事·苏轼','诗词社','/files/images/default.jpg','/files/shouye/videos/苏轼的人生智慧.mp4','10:05','720P',150,'苏轼','苏轼人生智慧解析','2026-03-22',1,'2026-03-22 19:05:54');
/*!40000 ALTER TABLE `recite_playlist_video` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_poem_selection`
--

DROP TABLE IF EXISTS `recite_poem_selection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_poem_selection` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `poem_id` bigint NOT NULL COMMENT '诗词 ID(关联 poems 表)',
  `title` varchar(200) NOT NULL COMMENT '诗词标题',
  `poet_name` varchar(100) DEFAULT NULL COMMENT '诗人姓名',
  `dynasty` varchar(50) DEFAULT NULL COMMENT '朝代',
  `content` text NOT NULL COMMENT '诗词内容',
  `difficulty_level` int DEFAULT '1' COMMENT '难度等级 (1-5,1 最简单，5 最难)',
  `recommended_duration` int DEFAULT '60' COMMENT '推荐朗诵时长 (秒)',
  `emotion_type` varchar(50) DEFAULT NULL COMMENT '情感类型 (思乡/爱国/山水/送别等)',
  `is_featured` tinyint(1) DEFAULT '0' COMMENT '是否推荐 (1-推荐，0-普通)',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_poem_id` (`poem_id`),
  KEY `idx_dynasty` (`dynasty`),
  KEY `idx_difficulty` (`difficulty_level`),
  KEY `idx_featured` (`is_featured`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='朗诵诗词选择表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_poem_selection`
--

LOCK TABLES `recite_poem_selection` WRITE;
/*!40000 ALTER TABLE `recite_poem_selection` DISABLE KEYS */;
INSERT INTO `recite_poem_selection` VALUES (1,1,'静夜思','李白','唐','床前明月光，疑是地上霜。举头望明月，低头思故乡。',1,30,'思乡',1,1,'2026-03-29 17:36:21'),(2,27,'春晓','孟浩然','唐','春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。',1,30,'春景',1,2,'2026-03-29 17:36:21'),(3,85,'登鹳雀楼','王之涣','唐','白日依山尽，黄河入海流。欲穷千里目，更上一层楼。',1,30,'哲理',1,3,'2026-03-29 17:36:21'),(4,98,'清明','杜牧','唐','清明时节雨纷纷，路上行人欲断魂。借问酒家何处有，牧童遥指杏花村。',1,40,'清明',1,4,'2026-03-29 17:36:21'),(5,100,'山行','杜牧','唐','远上寒山石径斜，白云生处有人家。停车坐爱枫林晚，霜叶红于二月花。',1,40,'秋景',1,5,'2026-03-29 17:36:21'),(6,113,'梅花','王安石','宋','墙角数枝梅，凌寒独自开。遥知不是雪，为有暗香来。',1,30,'咏物',1,6,'2026-03-29 17:36:21'),(7,131,'咏鹅','骆宾王','初唐','鹅，鹅，鹅，曲项向天歌。白毛浮绿水，红掌拨清波。',1,30,'咏物',1,7,'2026-03-29 17:36:21'),(8,136,'回乡偶书','贺知章','唐','少小离家老大回，乡音无改鬓毛衰。儿童相见不相识，笑问客从何处来。',2,40,'思乡',1,8,'2026-03-29 17:36:21'),(9,137,'咏柳','贺知章','唐','碧玉妆成一树高，万条垂下绿丝绦。不知细叶谁裁出，二月春风似剪刀。',1,30,'春景',1,9,'2026-03-29 17:36:21'),(10,7,'望庐山瀑布','李白','唐','日照香炉生紫烟，遥看瀑布挂前川。飞流直下三千尺，疑是银河落九天。',2,40,'山水',1,10,'2026-03-29 17:36:21'),(11,11,'黄鹤楼送孟浩然之广陵','李白','唐','故人西辞黄鹤楼，烟花三月下扬州。孤帆远影碧空尽，唯见长江天际流。',2,40,'送别',1,11,'2026-03-29 17:36:21'),(12,25,'九月九日忆山东兄弟','王维','唐','独在异乡为异客，每逢佳节倍思亲。遥知兄弟登高处，遍插茱萸少一人。',2,40,'思乡',1,12,'2026-03-29 17:36:21'),(13,26,'送元二使安西','王维','唐','渭城朝雨浥轻尘，客舍青青柳色新。劝君更尽一杯酒，西出阳关无故人。',2,40,'送别',1,13,'2026-03-29 17:36:21'),(14,83,'出塞','王昌龄','唐','秦时明月汉时关，万里长征人未还。但使龙城飞将在，不教胡马度阴山。',2,40,'边塞',1,14,'2026-03-29 17:36:21'),(15,84,'芙蓉楼送辛渐','王昌龄','唐','寒雨连江夜入吴，平明送客楚山孤。洛阳亲友如相问，一片冰心在玉壶。',2,40,'送别',1,15,'2026-03-29 17:36:21'),(16,86,'凉州词','王之涣','唐','黄河远上白云间，一片孤城万仞山。羌笛何须怨杨柳，春风不度玉门关。',2,40,'边塞',1,16,'2026-03-29 17:36:21'),(17,90,'江雪','柳宗元','唐','千山鸟飞绝，万径人踪灭。孤舟蓑笠翁，独钓寒江雪。',2,40,'山水',1,17,'2026-03-29 17:36:21'),(18,138,'别董大','高适','唐','千里黄云白日曛，北风吹雁雪纷纷。莫愁前路无知己，天下谁人不识君。',2,40,'送别',1,18,'2026-03-29 17:36:21'),(19,141,'枫桥夜泊','张继','唐','月落乌啼霜满天，江枫渔火对愁眠。姑苏城外寒山寺，夜半钟声到客船。',2,50,'羁旅',1,19,'2026-03-29 17:36:21'),(20,146,'寻隐者不遇','贾岛','唐','松下问童子，言师采药去。只在此山中，云深不知处。',1,30,'隐逸',1,20,'2026-03-29 17:36:21'),(21,6,'将进酒','李白','唐','君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。',4,120,'豪放',1,21,'2026-03-29 17:36:21'),(22,12,'春望','杜甫','唐','国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。',3,80,'爱国',1,22,'2026-03-29 17:36:21'),(23,13,'登高','杜甫','唐','风急天高猿啸哀，渚清沙白鸟飞回。无边落木萧萧下，不尽长江滚滚来。万里悲秋常作客，百年多病独登台。艰难苦恨繁霜鬓，潦倒新停浊酒杯。',4,90,'悲秋',1,23,'2026-03-29 17:36:21'),(24,15,'春夜喜雨','杜甫','唐','好雨知时节，当春乃发生。随风潜入夜，润物细无声。野径云俱黑，江船火独明。晓看红湿处，花重锦官城。',2,60,'春景',1,24,'2026-03-29 17:36:21'),(25,16,'望岳','杜甫','唐','岱宗夫如何？齐鲁青未了。造化钟神秀，阴阳割昏晓。荡胸生曾云，决眦入归鸟。会当凌绝顶，一览众山小。',3,70,'山水',1,25,'2026-03-29 17:36:21'),(26,30,'饮湖上初晴后雨','苏轼','宋','水光潋滟晴方好，山色空蒙雨亦奇。欲把西湖比西子，淡妆浓抹总相宜。',2,50,'山水',1,26,'2026-03-29 17:36:21'),(27,33,'水调歌头·明月几时有','苏轼','宋','明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。转朱阁，低绮户，照无眠。不应有恨，何事长向别时圆？人有悲欢离合，月有阴晴圆缺，此事古难全。但愿人长久，千里共婵娟。',4,150,'思亲',1,27,'2026-03-29 17:36:21'),(28,151,'滁州西涧','韦应物','唐','独怜幽草涧边生，上有黄鹂深树鸣。春潮带雨晚来急，野渡无人舟自横。',2,45,'山水',1,31,'2026-03-29 17:38:10'),(29,152,'乌衣巷','刘禹锡','唐','朱雀桥边野草花，乌衣巷口夕阳斜。旧时王谢堂前燕，飞入寻常百姓家。',2,45,'怀古',1,32,'2026-03-29 17:38:10'),(30,153,'望洞庭','刘禹锡','唐','湖光秋月两相和，潭面无风镜未磨。遥望洞庭山水翠，白银盘里一青螺。',2,45,'山水',1,33,'2026-03-29 17:38:10'),(31,154,'浪淘沙','刘禹锡','唐','九曲黄河万里沙，浪淘风簸自天涯。如今直上银河去，同到牵牛织女家。',2,45,'豪放',1,34,'2026-03-29 17:38:10'),(32,155,'赋得古原草送别','白居易','唐','离离原上草，一岁一枯荣。野火烧不尽，春风吹又生。远芳侵古道，晴翠接荒城。又送王孙去，萋萋满别情。',3,70,'送别',1,35,'2026-03-29 17:38:10'),(33,156,'暮江吟','白居易','唐','一道残阳铺水中，半江瑟瑟半江红。可怜九月初三夜，露似真珠月似弓。',2,45,'秋景',1,36,'2026-03-29 17:38:10'),(34,157,'悯农·其一','李绅','唐','锄禾日当午，汗滴禾下土。谁知盘中餐，粒粒皆辛苦。',1,30,'哲理',1,37,'2026-03-29 17:38:10'),(35,158,'悯农·其二','李绅','唐','春种一粒粟，秋收万颗子。四海无闲田，农夫犹饿死。',1,30,'悯民',1,38,'2026-03-29 17:38:10'),(36,159,'江南春','杜牧','唐','千里莺啼绿映红，水村山郭酒旗风。南朝四百八十寺，多少楼台烟雨中。',2,50,'怀古',1,39,'2026-03-29 17:38:10'),(37,160,'泊秦淮','杜牧','唐','烟笼寒水月笼沙，夜泊秦淮近酒家。商女不知亡国恨，隔江犹唱后庭花。',3,55,'怀古',1,40,'2026-03-29 17:38:10'),(38,161,'夏日绝句','李清照','宋','生当作人杰，死亦为鬼雄。至今思项羽，不肯过江东。',2,40,'爱国',1,41,'2026-03-29 17:38:10'),(39,162,'题西林壁','苏轼','宋','横看成岭侧成峰，远近高低各不同。不识庐山真面目，只缘身在此山中。',2,45,'哲理',1,42,'2026-03-29 17:38:10'),(40,163,'赠刘景文','苏轼','宋','荷尽已无擎雨盖，菊残犹有傲霜枝。一年好景君须记，最是橙黄橘绿时。',2,45,'秋景',1,43,'2026-03-29 17:38:10'),(41,164,'惠崇春江晚景','苏轼','宋','竹外桃花三两枝，春江水暖鸭先知。蒌蒿满地芦芽短，正是河豚欲上时。',1,40,'春景',1,44,'2026-03-29 17:38:10'),(42,165,'小池','杨万里','宋','泉眼无声惜细流，树阴照水爱晴柔。小荷才露尖尖角，早有蜻蜓立上头。',1,35,'夏景',1,45,'2026-03-29 17:38:10'),(43,166,'宿新市徐公店','杨万里','宋','篱落疏疏一径深，树头新绿未成阴。儿童急走追黄蝶，飞入菜花无处寻。',1,40,'童趣',1,46,'2026-03-29 17:38:10'),(44,167,'四时田园杂兴','范成大','宋','梅子金黄杏子肥，麦花雪白菜花稀。日长篱落无人过，惟有蜻蜓蛱蝶飞。',1,40,'田园',1,47,'2026-03-29 17:38:10'),(45,168,'乡村四月','翁卷','宋','绿遍山原白满川，子规声里雨如烟。乡村四月闲人少，才了蚕桑又插田。',1,40,'田园',1,48,'2026-03-29 17:38:10'),(46,169,'游园不值','叶绍翁','宋','应怜屐齿印苍苔，小扣柴扉久不开。春色满园关不住，一枝红杏出墙来。',1,40,'春景',1,49,'2026-03-29 17:38:10'),(47,170,'竹石','郑燮','清','咬定青山不放松，立根原在破岩中。千磨万击还坚劲，任尔东西南北风。',2,45,'咏物',1,50,'2026-03-29 17:38:10');
/*!40000 ALTER TABLE `recite_poem_selection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_recent_play`
--

DROP TABLE IF EXISTS `recite_recent_play`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_recent_play` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `playlist_id` bigint DEFAULT NULL COMMENT '诗单ID',
  `poem_id` bigint DEFAULT NULL COMMENT '诗词ID',
  `media_id` bigint DEFAULT NULL COMMENT '媒体ID',
  `play_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '播放类型：playlist/song',
  `play_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '最近播放时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_playlist_id` (`playlist_id`) USING BTREE,
  KEY `idx_poem_id` (`poem_id`) USING BTREE,
  KEY `idx_media_id` (`media_id`) USING BTREE,
  KEY `idx_play_time` (`play_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='朗诵最近播放表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_recent_play`
--

LOCK TABLES `recite_recent_play` WRITE;
/*!40000 ALTER TABLE `recite_recent_play` DISABLE KEYS */;
INSERT INTO `recite_recent_play` VALUES (1,1,2,NULL,NULL,'playlist','2026-03-18 17:43:32'),(2,1,4,NULL,NULL,'playlist','2026-03-17 17:43:32'),(3,2,1,NULL,NULL,'playlist','2026-03-18 17:57:29'),(4,2,1,NULL,NULL,'playlist','2026-03-18 18:02:27'),(5,2,1,NULL,NULL,'playlist','2026-03-18 18:23:34'),(6,2,1,NULL,NULL,'playlist','2026-03-18 18:41:55'),(7,2,1,NULL,NULL,'playlist','2026-03-18 18:43:44'),(8,2,1,101,NULL,'song','2026-03-18 18:59:43'),(9,2,1,101,NULL,'song','2026-03-18 18:59:43'),(10,2,3,107,NULL,'song','2026-03-18 18:59:45'),(11,2,3,107,NULL,'song','2026-03-18 18:59:46'),(12,2,3,107,NULL,'song','2026-03-18 18:59:46'),(13,2,3,107,NULL,'song','2026-03-18 18:59:47'),(14,2,3,107,NULL,'song','2026-03-18 18:59:47'),(15,2,1,101,NULL,'song','2026-03-18 18:59:48'),(16,2,3,107,NULL,'song','2026-03-18 18:59:50'),(17,2,3,107,NULL,'song','2026-03-18 19:00:05'),(18,2,3,107,NULL,'song','2026-03-18 19:00:05'),(19,2,1,NULL,NULL,'playlist','2026-03-18 19:00:08'),(20,2,1,NULL,NULL,'playlist','2026-03-18 19:01:46'),(21,2,1,NULL,NULL,'playlist','2026-03-18 19:21:24'),(22,2,1,101,NULL,'playlist','2026-03-18 20:03:36'),(23,2,1,101,NULL,'playlist','2026-03-18 20:03:43'),(24,2,1,101,NULL,'playlist','2026-03-18 20:03:43'),(25,2,1,101,NULL,'playlist','2026-03-18 20:27:11'),(26,2,1,101,NULL,'playlist','2026-03-18 20:31:07'),(27,2,1,101,NULL,'playlist','2026-03-18 20:47:06'),(28,2,1,101,NULL,'playlist','2026-03-20 22:48:43'),(29,2,1,101,NULL,'playlist','2026-03-20 22:52:48'),(30,2,1,101,NULL,'playlist','2026-03-20 22:52:49'),(31,2,2,104,NULL,'playlist','2026-03-20 22:52:54'),(32,2,1,101,1,'song','2026-03-20 23:41:40'),(33,2,1,101,1,'playlist','2026-03-20 23:41:40'),(34,2,3,107,7,'song','2026-03-20 23:42:00'),(35,2,1,101,1,'song','2026-03-20 23:43:33'),(36,2,1,101,1,'song','2026-03-21 00:18:29'),(37,2,1,101,1,'song','2026-03-21 00:18:49'),(38,2,1,102,2,'song','2026-03-21 00:18:51'),(39,2,1,101,1,'song','2026-03-21 00:18:53'),(40,2,3,107,7,'song','2026-03-21 00:19:02'),(41,2,1,101,1,'song','2026-03-21 00:19:03'),(42,2,2,105,5,'song','2026-03-21 00:19:36'),(43,2,1,101,1,'song','2026-03-21 00:19:42'),(44,2,1,101,1,'song','2026-03-21 00:19:43'),(45,2,1,101,1,'song','2026-03-21 00:19:45'),(46,2,1,101,1,'song','2026-03-21 00:23:07'),(47,2,2,105,5,'song','2026-03-21 00:23:35'),(48,2,3,107,7,'song','2026-03-21 00:29:10'),(49,2,1,101,1,'song','2026-03-21 00:31:00'),(50,2,1,101,1,'playlist','2026-03-21 00:31:00'),(51,2,1,101,1,'song','2026-03-21 11:21:02'),(52,2,1,102,2,'song','2026-03-21 11:21:03'),(53,2,1,103,3,'song','2026-03-21 11:21:04'),(54,2,1,101,1,'song','2026-03-21 11:40:34'),(55,2,1,101,1,'song','2026-03-21 11:40:38'),(56,2,1,101,1,'song','2026-03-21 11:40:40'),(57,2,1,102,2,'song','2026-03-21 11:40:41'),(58,2,1,103,3,'song','2026-03-21 11:40:43'),(59,2,1,102,2,'song','2026-03-21 11:40:44'),(60,2,1,101,1,'song','2026-03-21 11:40:46'),(61,2,1,101,1,'song','2026-03-21 11:40:48'),(62,2,1,101,1,'song','2026-03-21 11:40:57'),(63,2,1,102,2,'song','2026-03-21 11:40:58'),(64,2,1,103,3,'song','2026-03-21 11:41:00'),(65,2,1,101,1,'song','2026-03-21 11:41:24'),(66,2,1,102,2,'song','2026-03-21 11:41:41'),(67,2,1,101,1,'song','2026-03-21 11:41:42'),(68,2,1,101,1,'song','2026-03-21 11:41:53'),(69,2,1,101,1,'song','2026-03-21 11:46:58'),(70,2,1,101,1,'playlist','2026-03-21 11:46:58'),(71,8,1,101,1,'song','2026-03-21 13:23:57'),(72,8,1,101,1,'playlist','2026-03-21 13:23:57'),(73,8,1,101,1,'song','2026-03-21 14:31:31'),(74,8,1,101,1,'song','2026-03-21 14:31:46'),(75,8,1,101,1,'song','2026-03-21 15:08:57'),(76,8,1,101,1,'playlist','2026-03-21 15:08:58'),(77,8,1,102,2,'song','2026-03-21 15:09:24'),(78,8,1,101,1,'song','2026-03-21 15:13:33'),(79,8,1,101,1,'song','2026-03-21 15:13:39'),(80,8,1,101,1,'playlist','2026-03-21 15:13:39'),(81,8,1,102,2,'song','2026-03-21 15:14:03'),(82,2,1,101,1,'song','2026-03-21 21:18:08'),(83,2,1,101,1,'song','2026-03-22 00:06:04'),(84,2,1,101,1,'song','2026-03-22 11:32:34'),(85,2,1,101,1,'song','2026-03-22 11:32:36'),(86,8,11,NULL,NULL,'taste','2026-03-27 11:35:24'),(87,8,9,NULL,NULL,'taste','2026-03-27 11:36:12'),(88,8,10,NULL,NULL,'taste','2026-03-27 11:36:15'),(89,8,9,NULL,NULL,'taste','2026-03-27 11:57:44'),(90,8,9,NULL,NULL,'taste','2026-03-27 12:38:33'),(91,8,9,NULL,NULL,'taste','2026-03-27 12:38:46'),(92,8,9,NULL,NULL,'taste','2026-03-27 12:38:46'),(93,8,9,NULL,NULL,'taste','2026-03-27 18:45:26'),(94,8,1,101,1,'song','2026-03-27 18:48:50'),(95,8,1,101,1,'song','2026-03-27 18:49:02'),(96,8,9,NULL,NULL,'taste','2026-03-27 18:49:05'),(97,8,10,NULL,NULL,'taste','2026-03-27 18:49:08'),(98,8,1,102,2,'song','2026-03-27 18:49:13'),(99,8,1,101,1,'song','2026-03-28 11:38:38'),(100,8,1,101,1,'song','2026-03-28 11:38:43'),(101,8,9,NULL,NULL,'taste','2026-03-28 11:38:53'),(102,2,1,101,1,'song','2026-03-29 12:34:38'),(103,2,2,104,4,'song','2026-03-29 13:11:57'),(104,2,2,104,4,'song','2026-03-29 13:12:01'),(105,2,2,104,4,'song','2026-03-29 13:12:01'),(106,2,3,107,7,'song','2026-03-29 13:12:02'),(107,2,1,103,3,'song','2026-03-29 13:12:08'),(108,2,1,101,1,'song','2026-03-29 13:12:10'),(109,2,1,NULL,31,'song','2026-03-29 15:15:14'),(110,2,1,103,3,'song','2026-03-29 15:15:20'),(111,2,1,101,1,'song','2026-03-29 15:15:22'),(112,2,3,107,7,'song','2026-03-29 15:15:33'),(113,2,1,101,1,'song','2026-03-29 15:15:36'),(114,2,1,101,1,'playlist','2026-03-29 15:15:36'),(115,2,3,108,8,'song','2026-03-29 15:15:44'),(116,2,1,101,1,'song','2026-04-06 21:07:20'),(117,2,1,101,1,'song','2026-04-09 22:57:25'),(118,2,1,101,1,'song','2026-04-09 22:57:28'),(119,2,1,NULL,11,'song','2026-04-09 22:57:33'),(120,2,1,NULL,39,'song','2026-04-09 22:57:38'),(121,2,4,NULL,40,'song','2026-04-15 19:43:20'),(122,2,1,101,1,'song','2026-04-15 19:58:04'),(123,2,1,101,1,'song','2026-04-15 19:58:09'),(124,2,1,102,2,'song','2026-04-15 19:58:24'),(125,2,1,102,2,'song','2026-04-15 19:58:26'),(126,2,1,101,1,'song','2026-04-15 19:58:28');
/*!40000 ALTER TABLE `recite_recent_play` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_record`
--

DROP TABLE IF EXISTS `recite_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `poem_id` bigint DEFAULT NULL COMMENT '诗词ID',
  `playlist_id` bigint DEFAULT NULL COMMENT '诗单ID',
  `media_id` bigint DEFAULT NULL COMMENT '媒体ID',
  `play_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'playlist/song/task',
  `play_seconds` int DEFAULT '0' COMMENT '播放秒数',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_poem_id` (`poem_id`) USING BTREE,
  KEY `idx_playlist_id` (`playlist_id`) USING BTREE,
  KEY `idx_media_id` (`media_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='朗诵播放记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_record`
--

LOCK TABLES `recite_record` WRITE;
/*!40000 ALTER TABLE `recite_record` DISABLE KEYS */;
INSERT INTO `recite_record` VALUES (1,2,NULL,1,NULL,'playlist',0,'2026-03-18 17:57:29'),(2,2,NULL,1,NULL,'playlist',0,'2026-03-18 18:02:27'),(3,2,NULL,1,NULL,'playlist',0,'2026-03-18 18:23:34'),(4,2,NULL,1,NULL,'playlist',0,'2026-03-18 18:41:55'),(5,2,NULL,1,NULL,'playlist',0,'2026-03-18 18:43:44'),(6,2,101,1,NULL,'song',0,'2026-03-18 18:59:43'),(7,2,101,1,NULL,'song',0,'2026-03-18 18:59:43'),(8,2,107,3,NULL,'song',0,'2026-03-18 18:59:45'),(9,2,107,3,NULL,'song',0,'2026-03-18 18:59:46'),(10,2,107,3,NULL,'song',0,'2026-03-18 18:59:46'),(11,2,107,3,NULL,'song',0,'2026-03-18 18:59:47'),(12,2,107,3,NULL,'song',0,'2026-03-18 18:59:47'),(13,2,101,1,NULL,'song',0,'2026-03-18 18:59:48'),(14,2,107,3,NULL,'song',0,'2026-03-18 18:59:50'),(15,2,107,3,NULL,'song',0,'2026-03-18 19:00:05'),(16,2,107,3,NULL,'song',0,'2026-03-18 19:00:05'),(17,2,NULL,1,NULL,'playlist',0,'2026-03-18 19:00:08'),(18,2,NULL,1,NULL,'playlist',0,'2026-03-18 19:01:46'),(19,2,NULL,1,NULL,'playlist',0,'2026-03-18 19:21:24'),(20,2,101,1,NULL,'playlist',0,'2026-03-18 20:03:36'),(21,2,101,1,NULL,'playlist',0,'2026-03-18 20:03:43'),(22,2,101,1,NULL,'playlist',0,'2026-03-18 20:03:43'),(23,2,101,1,NULL,'playlist',0,'2026-03-18 20:27:11'),(24,2,101,1,NULL,'playlist',0,'2026-03-18 20:31:07'),(25,2,101,1,NULL,'playlist',0,'2026-03-18 20:47:06'),(26,2,101,1,NULL,'playlist',0,'2026-03-20 22:48:43'),(27,2,101,1,NULL,'playlist',0,'2026-03-20 22:52:48'),(28,2,101,1,NULL,'playlist',0,'2026-03-20 22:52:49'),(29,2,104,2,NULL,'playlist',0,'2026-03-20 22:52:54'),(30,2,101,1,1,'song',0,'2026-03-20 23:41:40'),(31,2,101,1,1,'playlist',0,'2026-03-20 23:41:40'),(32,2,107,3,7,'song',0,'2026-03-20 23:42:00'),(33,2,101,1,1,'song',0,'2026-03-20 23:43:33'),(34,2,101,1,1,'song',0,'2026-03-21 00:18:29'),(35,2,101,1,1,'song',0,'2026-03-21 00:18:49'),(36,2,102,1,2,'song',0,'2026-03-21 00:18:51'),(37,2,101,1,1,'song',0,'2026-03-21 00:18:53'),(38,2,107,3,7,'song',0,'2026-03-21 00:19:02'),(39,2,101,1,1,'song',0,'2026-03-21 00:19:03'),(40,2,105,2,5,'song',0,'2026-03-21 00:19:36'),(41,2,101,1,1,'song',0,'2026-03-21 00:19:42'),(42,2,101,1,1,'song',0,'2026-03-21 00:19:43'),(43,2,101,1,1,'song',0,'2026-03-21 00:19:45'),(44,2,101,1,1,'song',0,'2026-03-21 00:23:07'),(45,2,105,2,5,'song',0,'2026-03-21 00:23:35'),(46,2,107,3,7,'song',0,'2026-03-21 00:29:10'),(47,2,101,1,1,'song',0,'2026-03-21 00:31:00'),(48,2,101,1,1,'playlist',0,'2026-03-21 00:31:00'),(49,2,101,1,1,'song',0,'2026-03-21 11:21:02'),(50,2,102,1,2,'song',0,'2026-03-21 11:21:03'),(51,2,103,1,3,'song',0,'2026-03-21 11:21:04'),(52,2,101,1,1,'song',0,'2026-03-21 11:40:34'),(53,2,101,1,1,'song',0,'2026-03-21 11:40:38'),(54,2,101,1,1,'song',0,'2026-03-21 11:40:40'),(55,2,102,1,2,'song',0,'2026-03-21 11:40:41'),(56,2,103,1,3,'song',0,'2026-03-21 11:40:43'),(57,2,102,1,2,'song',0,'2026-03-21 11:40:44'),(58,2,101,1,1,'song',0,'2026-03-21 11:40:46'),(59,2,101,1,1,'song',0,'2026-03-21 11:40:48'),(60,2,101,1,1,'song',0,'2026-03-21 11:40:57'),(61,2,102,1,2,'song',0,'2026-03-21 11:40:58'),(62,2,103,1,3,'song',0,'2026-03-21 11:41:00'),(63,2,101,1,1,'song',0,'2026-03-21 11:41:24'),(64,2,102,1,2,'song',0,'2026-03-21 11:41:40'),(65,2,101,1,1,'song',0,'2026-03-21 11:41:42'),(66,2,101,1,1,'song',0,'2026-03-21 11:41:52'),(67,2,101,1,1,'song',0,'2026-03-21 11:46:58'),(68,2,101,1,1,'playlist',0,'2026-03-21 11:46:58'),(69,8,101,1,1,'song',0,'2026-03-21 13:23:57'),(70,8,101,1,1,'playlist',0,'2026-03-21 13:23:57'),(71,8,101,1,1,'song',0,'2026-03-21 14:31:31'),(72,8,101,1,1,'song',0,'2026-03-21 14:31:46'),(73,8,101,1,1,'song',0,'2026-03-21 15:08:57'),(74,8,101,1,1,'playlist',0,'2026-03-21 15:08:57'),(75,8,102,1,2,'song',0,'2026-03-21 15:09:24'),(76,8,101,1,1,'song',0,'2026-03-21 15:13:32'),(77,8,101,1,1,'song',0,'2026-03-21 15:13:39'),(78,8,101,1,1,'playlist',0,'2026-03-21 15:13:39'),(79,8,102,1,2,'song',0,'2026-03-21 15:14:03'),(80,2,101,1,1,'song',0,'2026-03-21 21:18:08'),(81,2,101,1,1,'song',0,'2026-03-22 00:06:04'),(82,2,101,1,1,'song',0,'2026-03-22 11:32:34'),(83,2,101,1,1,'song',0,'2026-03-22 11:32:36'),(84,2,101,1,101,'song',0,'2026-03-23 21:01:31'),(85,8,106,2,106,'song',0,'2026-03-26 18:35:02'),(86,8,NULL,11,NULL,'taste',0,'2026-03-27 11:35:24'),(87,8,NULL,9,NULL,'taste',0,'2026-03-27 11:36:12'),(88,8,NULL,10,NULL,'taste',0,'2026-03-27 11:36:15'),(89,8,NULL,9,NULL,'taste',0,'2026-03-27 11:57:44'),(90,8,NULL,9,NULL,'taste',0,'2026-03-27 12:38:33'),(91,8,NULL,9,NULL,'taste',0,'2026-03-27 12:38:46'),(92,8,NULL,9,NULL,'taste',0,'2026-03-27 12:38:46'),(93,8,NULL,9,NULL,'taste',0,'2026-03-27 18:45:26'),(94,8,101,1,1,'song',0,'2026-03-27 18:48:50'),(95,8,101,1,1,'song',0,'2026-03-27 18:49:02'),(96,8,NULL,9,NULL,'taste',0,'2026-03-27 18:49:05'),(97,8,NULL,10,NULL,'taste',0,'2026-03-27 18:49:08'),(98,8,102,1,2,'song',0,'2026-03-27 18:49:13'),(99,8,101,1,1,'song',0,'2026-03-28 11:38:38'),(100,8,101,1,1,'song',0,'2026-03-28 11:38:43'),(101,8,NULL,9,NULL,'taste',0,'2026-03-28 11:38:53'),(102,2,101,1,1,'song',0,'2026-03-29 12:34:38'),(103,2,104,2,4,'song',0,'2026-03-29 13:11:57'),(104,2,104,2,4,'song',0,'2026-03-29 13:12:01'),(105,2,104,2,4,'song',0,'2026-03-29 13:12:01'),(106,2,107,3,7,'song',0,'2026-03-29 13:12:02'),(107,2,103,1,3,'song',0,'2026-03-29 13:12:08'),(108,2,101,1,1,'song',0,'2026-03-29 13:12:10'),(109,2,NULL,1,31,'song',0,'2026-03-29 15:15:14'),(110,2,103,1,3,'song',0,'2026-03-29 15:15:20'),(111,2,101,1,1,'song',0,'2026-03-29 15:15:22'),(112,2,107,3,7,'song',0,'2026-03-29 15:15:33'),(113,2,101,1,1,'song',0,'2026-03-29 15:15:36'),(114,2,101,1,1,'playlist',0,'2026-03-29 15:15:36'),(115,2,108,3,8,'song',0,'2026-03-29 15:15:44'),(116,2,101,1,1,'song',0,'2026-04-06 21:07:20'),(117,2,101,1,1,'song',0,'2026-04-09 22:57:25'),(118,2,101,1,1,'song',0,'2026-04-09 22:57:28'),(119,2,NULL,1,11,'song',0,'2026-04-09 22:57:33'),(120,2,NULL,1,39,'song',0,'2026-04-09 22:57:38'),(121,2,NULL,4,40,'song',0,'2026-04-15 19:43:20'),(122,2,101,1,1,'song',0,'2026-04-15 19:58:04'),(123,2,101,1,1,'song',0,'2026-04-15 19:58:09'),(124,2,102,1,2,'song',0,'2026-04-15 19:58:24'),(125,2,102,1,2,'song',0,'2026-04-15 19:58:26'),(126,2,101,1,1,'song',0,'2026-04-15 19:58:28');
/*!40000 ALTER TABLE `recite_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_recording`
--

DROP TABLE IF EXISTS `recite_recording`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_recording` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `poem_id` bigint NOT NULL COMMENT '诗词ID',
  `poem_title` varchar(200) DEFAULT NULL COMMENT '诗词标题（冗余存储）',
  `poem_content` text COMMENT '诗词原文（冗余存储）',
  `audio_url` varchar(500) DEFAULT NULL COMMENT '录音文件URL',
  `audio_duration` int DEFAULT '0' COMMENT '录音时长（秒）',
  `transcribed_text` text COMMENT '语音识别转写的文本',
  `clarity_score` int DEFAULT '0' COMMENT '清晰度评分(0-100)',
  `rhythm_score` int DEFAULT '0' COMMENT '节奏感评分(0-100)',
  `emotion_score` int DEFAULT '0' COMMENT '情感表达评分(0-100)',
  `overall_score` int DEFAULT '0' COMMENT '综合评分(0-100)',
  `ai_evaluation` text COMMENT 'AI评价内容（JSON格式）',
  `ai_suggestion` text COMMENT 'AI改进建议',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_poem_id` (`poem_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='朗诵录音评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_recording`
--

LOCK TABLES `recite_recording` WRITE;
/*!40000 ALTER TABLE `recite_recording` DISABLE KEYS */;
INSERT INTO `recite_recording` VALUES (1,1,1,'静夜思','床前明月光，疑是地上霜。举头望明月，低头思故乡。','/files/recordings/1_1774712428994.wav',0,'',70,75,65,70,'由于无法获取实际的朗诵录音，本次评价基于《静夜思》这首经典诗作的通用朗诵要求进行。通常，朗诵此诗时，清晰度方面需注意‘明’、‘霜’、‘望’等字的归音；节奏上，五言绝句应有平稳的‘二二一’或‘二一二’节拍，并处理好句末的停顿；情感上，应传达出由静夜观月引发的淡淡乡愁，而非强烈的悲伤。','1. 清晰度：重点练习平翘舌音（如‘床’、‘是’、‘思’）和前后鼻音（如‘明’、‘光’、‘霜’、‘乡’），确保字正腔圆。\n2. 节奏感：遵循五言诗的韵律，在‘床前/明月光’、‘疑是/地上霜’等处做自然停顿，整体节奏舒缓平稳。\n3. 情感表达：理解诗人李白在静谧夜晚的思绪流动，朗诵时语调可先平缓描述（前两句），后略带深沉与悠远（后两句），‘思故乡’三字可适当放缓，留有余韵。建议先理解诗意，再进行有感情的慢速跟读练习。','2026-03-28 23:40:42'),(2,1,1,'静夜思','床前明月光疑是地上霜举头望明月低头思故乡','/files/recordings/1_1774715248133.wav',0,'',70,65,60,65,'由于无法获取您的具体朗诵录音，本次评价基于《静夜思》的通用朗诵要点进行。这是一首语言质朴、情感深沉的思乡诗。在缺乏具体录音的情况下，我们假设朗诵可能存在一些常见问题，例如：吐字可能不够清晰有力，导致‘光’、‘霜’、‘乡’等韵脚不够突出；节奏可能过于平均，未能充分体现五言诗的韵律和诗人望月、低头的动作与情感变化；情感表达可能较为平淡，未能深入传达出夜深人静时那份悠远而含蓄的思乡之情。','1. 清晰度练习：重点练习‘明（míng）’、‘光（guāng）’、‘霜（shuāng）’、‘望（wàng）’、‘乡（xiāng）’等字的发音，确保字头清晰，韵母饱满，特别是ang韵母要打开口腔。\n2. 节奏感练习：理解诗句的意群。建议的停顿为：‘床前/明月光，疑是/地上霜。举头/望明月，低头/思故乡。’‘举头’与‘低头’之间可有一个稍长的停顿，以体现动作的转换和情感的深化。\n3. 情感表达练习：朗诵前深入理解诗意。前两句写景，语调可平缓、略带疑惑（‘疑’字）；后两句抒情，‘举头’时语调可微微扬起，带着遥望的期盼，‘低头’时语调下沉，语速放缓，读出沉思与怀念的厚重感。建议多听名家朗诵，模仿并体会其中的韵味。','2026-03-29 00:27:42'),(3,1,1,'静夜思','床前明月光疑是地上霜举头望明月低头思故乡','/files/recordings/1_1774715399193.wav',0,'',0,0,0,0,'由于语音识别失败，本次无法对您的朗诵进行具体的技术性评价。这通常意味着录音质量不佳（如环境噪音过大、音量过小、语速过快或吐字不清），导致系统无法有效识别语音内容。因此，无法评估您在清晰度、节奏感和情感表达方面的具体表现。','1. 录音环境：请确保在安静的环境下录音，远离背景噪音。\n2. 录音设备：使用质量较好的麦克风，并确保嘴巴与麦克风保持适当距离（约10-15厘米），避免喷麦或声音过小。\n3. 朗诵准备：朗诵前先熟悉《静夜思》的原文，理解其描绘的月夜思乡之情。注意每个字的发音，特别是“疑”、“霜”、“举”、“低”等字要清晰饱满。\n4. 节奏控制：这是一首五言绝句，建议采用“二/三”或“二/二/一”的停顿节奏，如“床前/明月光，疑是/地上霜”。语速应舒缓，以贴合静谧的意境。\n5. 情感基调：整体情感应是宁静中带着淡淡的思乡愁绪，语调不宜过高亢，在“望明月”和“思故乡”处可稍作强调和情感深化。\n请调整后重新录制，期待听到您清晰的朗诵。','2026-03-29 00:30:12'),(4,1,1,'静夜思','床前明月光疑是地上霜举头望明月低头思故乡','/files/recordings/1_1774715513107.wav',0,'',70,65,60,65,'由于语音识别失败，无法对您本次朗诵的具体表现进行精确评估。这是一个常见的技术问题，但我们可以基于《静夜思》这首经典作品的一般朗诵要求，进行通用性的分析和指导。通常，朗诵这首诗的难点在于用简洁的语言传达深沉的思乡之情。如果未能识别，可能意味着朗诵时音量、语速或清晰度存在较大波动，影响了录音质量。','1. **提升录音清晰度**：朗诵时请确保环境安静，口齿清晰，音量稳定，话筒距离适中。\n2. **把握诗歌节奏**：《静夜思》四句均为五言，应有自然的停顿（如“床前/明月光，疑是/地上霜”），避免语速过快或过慢，保持平稳流畅。\n3. **注入情感层次**：前两句可带有些许疑惑、观察的语调，后两句“望明月”“思故乡”应放缓语速，声音下沉，流露出深沉、含蓄的思索与怀念之情。\n4. **建议练习方法**：先缓慢朗读，确保每个字音准确；再跟随名家朗诵音频模仿节奏与情感；最后尝试融入自己的理解进行演绎，并重新录制检查效果。','2026-03-29 00:32:05'),(23,2,7,'咏鹅','鹅，鹅，鹅，曲项向天歌。白毛浮绿水，红掌拨清波。','/files/recordings/2_1774869624261.wav',9,'',70,75,65,70,'由于语音识别失败，无法对本次朗诵的发音准确性进行精确评估。基于《咏鹅》这首经典诗篇的通用朗诵要求，本次评价将侧重于朗诵的节奏感和情感表达的潜在框架。通常，初学者在朗诵此类明快活泼的童趣诗时，容易把握其基本的节奏，但可能在情感层次和细节处理上有所欠缺。','1. 清晰度：请确保每个字都发音饱满，特别是‘鹅’、‘曲’、‘浮’、‘拨’等关键字，要念得清晰有力。可以对着镜子练习口型。\n2. 节奏感：注意诗句内部的停顿，如‘鹅，鹅，鹅’之间应有短暂而清晰的间隔，后两句的‘白毛/浮绿水，红掌/拨清波’也要根据意群合理断句，让节奏轻快有弹性。\n3. 情感表达：想象鹅在水中悠然自得的画面，用声音表现出童趣和欣赏之情。前两句的‘向天歌’可以带点昂扬感，后两句的‘浮绿水’、‘拨清波’则可以更轻柔、愉悦，展现生动的画面感。建议多听名家朗诵，模仿其语气变化。','2026-03-30 19:20:39'),(28,2,1,'静夜思','床前明月光，疑是地上霜。举头望明月，低头思故乡。','/files/recordings/2_1774874451643.wav',12,'',70,75,65,70,'由于无法获取具体的朗诵录音，本次评价基于《静夜思》的通用朗诵要求进行。假设这是一次常规的朗诵练习。在节奏感方面，五言绝句的停顿（如“床前/明月光”）通常能基本把握。情感上可能对思乡之情的含蓄深沉表达尚有提升空间，未能完全传递出诗中由“疑”到“望”再到“思”的细腻情感变化。','1. 清晰度：请确保每个字发音饱满，特别是韵脚“光、霜、乡”要清晰圆润。可对着镜子练习口型。\n2. 节奏感：注意“举头—望明月”与“低头—思故乡”中的逻辑停顿，前句稍扬，后句渐缓下沉，以体现动作与思绪的转折。\n3. 情感表达：朗诵前可默想漂泊在外的场景，将“疑”字读出恍惚感，“思故乡”三字音量渐弱，语速放慢，以表现悠长的思念。建议多听名家朗诵版本进行模仿。','2026-03-30 20:41:05'),(41,2,1,'静夜思','床前明月光，疑是地上霜。举头望明月，低头思故乡。','/files/recordings/2_1774968368251.wav',7,'床前明月光，疑是地上霜，举头望明月，低头思故乡。',85,75,70,77,'整体朗诵清晰流畅，吐字基本准确，语音识别文本与原文完全一致，说明发音清晰度良好。节奏平稳，但略显平均，四句之间的停顿处理较为一致，缺乏变化。情感表达上，能够听出思乡的主题，但整体情绪较为平铺直叙，对‘疑’字的疑惑感、‘望’字的凝望感以及‘思’字的深沉眷恋感，表现力可以进一步加强。','1. 清晰度方面：继续保持清晰的吐字，可以尝试在‘霜’、‘乡’等押韵字上稍微延长归韵，让音色更圆润。2. 节奏感方面：建议打破四句完全均衡的节奏。例如，第一、二句可稍快，体现观察与疑惑的过程；第三句‘举头望明月’的‘望’字后可有一个小小的、充满想象的停顿；第四句‘低头思故乡’整体放慢，尤其是‘思故乡’三字，语速放缓，音量减弱，以营造悠远、深沉的意境。3. 情感表达方面：深入理解诗句。‘疑’字可带一丝不确定的轻声；‘望明月’时，声音可略微扬起，眼神仿佛看向远方；‘思故乡’时，声音下沉，气息绵长，注入更多的内在情感。可以多听名家朗诵，体会他们如何处理细节。','2026-03-31 22:46:18'),(42,2,1,'静夜思','床前明月光，疑是地上霜。举头望明月，低头思故乡。','/files/recordings/2_1774968458794.wav',8,'床前明月光，疑是地上霜，举头望明月，低头思故乡。',85,70,65,73,'本次朗诵整体完成度较好。在清晰度方面，吐字基本清晰，每个字的发音都比较准确，没有明显的含糊或错误，这是值得肯定的基础。在节奏感方面，四句诗的停顿位置基本正确，但整体节奏略显平均和急促，缺乏古诗应有的韵律感和从容感，尤其是“举头望明月”与“低头思故乡”之间的停顿不够充分，削弱了诗句间的转折与递进关系。在情感表达方面，能够听出朗诵者试图传达一种思乡的情绪，但表达较为平直，对“疑”、“望”、“思”这几个关键动词所蕴含的微妙情感和动作画面感表现不足，未能充分营造出静谧月夜下孤独沉思的深远意境。','1. 节奏练习：尝试放慢整体语速，在每句诗的句末（“光”、“霜”、“月”、“乡”）适当延长并轻收，营造悠远感。特别注意在第三句后做一个稍长的停顿，为最后一句的情感爆发做铺垫。\n2. 情感注入：深入理解诗句。朗诵“疑是地上霜”时，可带有一丝恍惚和不确定的轻声；朗诵“举头望明月”时，想象仰头的动作，声音可略微扬起，眼神仿佛看向远方；朗诵“低头思故乡”时，语速放至最慢，声音下沉，注入深沉、绵长的思念之情。\n3. 跟读模仿：多听名家朗诵（如孙道临、濮存昕等艺术家的版本），注意模仿其气息运用、轻重缓急和情感层次的处理，先模仿再形成自己的风格。','2026-03-31 22:47:51'),(43,2,2,'春晓','春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。','/files/recordings/2_1775140437092.wav',6,'春眠不觉晓，处处闻啼鸟，夜来风雨声，花落知多少。',85,75,70,77,'本次朗诵整体完成度较好。优点在于：1. 吐字清晰，发音基本准确，尤其是“春”、“晓”、“鸟”、“声”等关键字发音到位，清晰度较高。2. 诗句完整，没有遗漏或错读。不足之处在于：1. 节奏处理较为平直，四句之间的停顿感不够明显，尤其是第三句“夜来风雨声”与第四句“花落知多少”之间缺乏必要的语气转换和停顿，使得全诗的韵律感稍显不足。2. 情感表达上，对诗中蕴含的惜春、爱春的淡淡惆怅与宁静的春日晨起之感捕捉不够深入，语调偏于平稳，未能充分展现“闻啼鸟”的生机与“花落知多少”的感慨之间的意境对比。','1. 节奏练习：建议在“处处闻啼鸟”后做一个稍长的、意味深长的停顿，想象清晨被鸟鸣唤醒的情境；在“夜来风雨声”后，语气可稍转低沉、缓慢，为最后一句的感慨做铺垫。可以尝试用手打拍子或标记停顿符号来辅助练习。2. 情感投入：朗诵前深入理解诗意。前两句可带着初醒的慵懒与发现春意的细微喜悦，语调可轻快些；后两句则转入回忆与沉思，语调放缓，在“知多少”三字上可加入一丝轻柔的叹息感，以体现对春光易逝的怜惜。多听名家朗诵，模仿其语气起伏。','2026-04-02 22:34:14'),(44,2,11,'黄鹤楼送孟浩然之广陵','故人西辞黄鹤楼，烟花三月下扬州。孤帆远影碧空尽，唯见长江天际流。','/files/recordings/2_1775271433546.wav',3,'故人西辞黄鹤楼，烟花三月下扬州。',85,80,75,80,'同学你好！你朗诵了《黄鹤楼送孟浩然之广陵》的前两句。从清晰度来看，你的发音总体是清晰的，吐字也比较准确，这是很好的基础。节奏感方面，两句之间的停顿基本合理，保持了诗句原有的韵律感。在情感表达上，你尝试为诗句注入了一些送别友人时的情绪，这是一个很好的开端。','你的朗诵目前只完成了前两句，建议将后两句‘孤帆远影碧空尽，唯见长江天际流’也完整地练习和朗诵出来，这样才能完整地体会和表达整首诗的意境。在情感上，可以进一步揣摩诗人目送友人远去时，那种由近及远、由实入虚的怅惘与深情，试着在‘远影’、‘尽’、‘天际流’等关键词上通过语速和音调的变化来加强画面感和悠远感。节奏上，注意四句诗是一个整体，情感是逐步推进和升华的，要把握好这个内在的脉络。多听一些优秀的朗诵范本进行模仿，会有很大帮助。','2026-04-04 10:57:23'),(45,2,1,'静夜思','床前明月光，疑是地上霜。举头望明月，低头思故乡。','/files/recordings/2_1775273184704.wav',5,'床前明月光，疑是地上霜。',85,70,65,73,'同学你好！你的朗诵在清晰度方面表现不错，吐字较为清晰，尤其是‘床前明月光’一句，发音准确。然而，本次朗诵只完成了前两句，未能完整呈现整首《静夜思》。在已朗诵的部分，节奏较为平直，缺少诗句间应有的停顿与起伏变化，例如‘疑是地上霜’后的句号停顿感不足。情感表达上，能听出一定的平静感，但未能充分传达出诗人从‘望月’到‘思乡’的细腻情感转折和深沉的思乡之情。','1. 请务必练习并朗诵完整首诗，体会四句诗之间情感的递进与完整意境。2. 节奏练习：在‘光’、‘霜’、‘月’、‘乡’这些韵脚字后，可以适当延长并做轻微停顿，以增强诗歌的韵律感。‘举头’与‘低头’两个动作之间，应有明显的节奏变化和情感对比。3. 情感投入：尝试在朗诵前默读几遍，想象自己身处异乡、夜深人静时望见明月的场景，将‘疑’（疑惑）、‘望’（仰望）、‘思’（深沉思念）这些关键字的情感通过语气和语调的变化表现出来。可以先放慢语速，着重练习后两句的情感表达。','2026-04-04 11:26:35'),(46,2,1,'静夜思','床前明月光，疑是地上霜。举头望明月，低头思故乡。','/files/recordings/2_1775275118599.wav',1,'减少。',20,10,10,13,'本次朗诵未能有效完成。从提供的识别文本来看，仅识别出“减少”二字，与《静夜思》原文完全不符。这表明录音可能存在严重问题，如环境噪音过大、学生未清晰朗诵、或语音识别系统故障。因此，无法对发音清晰度、节奏把握和情感表达进行有效评估。本次朗诵未达到基本要求。','1. 请确认录音设备正常工作，并在安静环境下重新录制。\n2. 朗诵前，请学生先默读或朗读几遍原诗，确保熟悉内容。\n3. 录制时，请吐字清晰，音量适中，语速平缓，确保每个字都能被准确识别。\n4. 完成录制后，建议先回听确认录音质量，再提交作业。','2026-04-04 11:58:46'),(47,2,2,'春晓','春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。','/files/recordings/2_1775280503211.wav',2,'',0,0,0,0,'由于语音识别失败，无法对本次朗诵的具体表现进行客观评价。本次评价将基于《春晓》这首诗的朗诵要点，提供通用性的指导。','1. 清晰度练习：重点练习“晓（xiǎo）”、“闻（wén）”、“声（shēng）”等字的发音，确保字正腔圆，尤其是前后鼻音和声调要准确。\n2. 节奏感练习：这首诗为五言绝句，每句的停顿应为“春眠/不觉晓，处处/闻啼鸟。夜来/风雨声，花落/知多少。”注意第二句与第四句末尾的“鸟”和“少”押韵，应适当拖长，营造悠远之感。\n3. 情感表达练习：前两句可带着春日初醒的慵懒与欣喜，语调轻快；后两句转入对昨夜风雨的回想与淡淡惋惜，语调应稍缓、略沉，体现“惜春”的意境。建议先理解诗意，再进行有感情的朗诵。','2026-04-04 13:28:32'),(48,2,3,'登鹳雀楼','白日依山尽，黄河入海流。欲穷千里目，更上一层楼。','/files/recordings/2_1775280608249.wav',4,'白日依山尽，黄河入海流。',85,70,65,73,'同学你好！你的朗诵在清晰度方面表现不错，吐字较为清晰，基本能听清每个字的发音。然而，本次朗诵只完成了前两句“白日依山尽，黄河入海流”，未能完整呈现全诗。从已朗诵的部分来看，节奏较为平直，缺乏诗句内在的起伏变化，情感表达也略显平淡，未能充分展现诗人登高望远时那种开阔的胸襟和积极向上的哲思。','1. 请务必练习并朗诵完整首诗，体会四句诗之间由景入理、层层递进的关系。2. 在节奏上，可以尝试在“依山尽”和“入海流”后做适当的、有意识的停顿，以营造画面感和空间感。3. 在情感上，前两句可想象壮阔的自然景象，语气沉稳开阔；后两句“欲穷”、“更上”可注入一种探索和向上的劲头，语调可略微扬起。建议先放慢速度，逐句揣摩意境，再进行连贯的、有感情的朗诵练习。','2026-04-04 13:30:17');
/*!40000 ALTER TABLE `recite_recording` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_submit`
--

DROP TABLE IF EXISTS `recite_submit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_submit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户id',
  `task_id` bigint NOT NULL COMMENT '任务id',
  `audio_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '用户录音地址',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '备注',
  `source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'record' COMMENT 'record/text',
  `score` int DEFAULT '0' COMMENT '评分',
  `accuracy` decimal(5,2) DEFAULT '0.00' COMMENT '准确率',
  `speed` decimal(4,2) DEFAULT '1.00' COMMENT '语速',
  `duration_ms` int DEFAULT '0' COMMENT '录音时长',
  `teacher_comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '老师点评',
  `submit_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_task` (`user_id`,`task_id`) USING BTREE,
  KEY `idx_submit_time` (`submit_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='朗诵提交记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_submit`
--

LOCK TABLES `recite_submit` WRITE;
/*!40000 ALTER TABLE `recite_submit` DISABLE KEYS */;
/*!40000 ALTER TABLE `recite_submit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recite_video`
--

DROP TABLE IF EXISTS `recite_video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recite_video` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '视频标题',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'master名师示范/student学生作品/tutorial技巧讲解',
  `author_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '作者/发布者',
  `thumbnail_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '缩略图',
  `video_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '视频地址',
  `duration_sec` int DEFAULT '0' COMMENT '时长秒',
  `quality` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '清晰度',
  `views` bigint DEFAULT '0' COMMENT '播放量',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签，逗号分隔',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '描述',
  `upload_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '1启用 0停用',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='朗诵视频推荐表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recite_video`
--

LOCK TABLES `recite_video` WRITE;
/*!40000 ALTER TABLE `recite_video` DISABLE KEYS */;
INSERT INTO `recite_video` VALUES (1,'静夜思朗诵示范','master','王老师','/files/images/default.jpg','/files/videos/1.mp4',180,NULL,12000,'名师,唐诗',NULL,'2026-03-18 17:43:50',0,1,'2026-03-18 17:43:50','2026-04-15 19:52:35'),(2,'春望朗诵示范','master','陈老师','/files/images/default.jpg','/files/videos/2.mp4',200,NULL,9000,'杜甫,情感',NULL,'2026-03-18 17:43:50',0,1,'2026-03-18 17:43:50','2026-04-15 19:53:19'),(3,'学生朗诵展示','student','高一1班','/files/images/default.jpg','https://www.w3schools.com/html/mov_bbb.mp4',150,NULL,5000,'学生作品',NULL,'2026-03-18 17:43:50',0,1,'2026-03-18 17:43:50','2026-03-18 17:43:50'),(4,'朗诵技巧讲解','tutorial','教研组','/files/images/default.jpg','https://www.w3schools.com/html/mov_bbb.mp4',220,NULL,15000,'技巧',NULL,'2026-03-18 17:43:50',0,1,'2026-03-18 17:43:50','2026-03-18 17:43:50');
/*!40000 ALTER TABLE `recite_video` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relay_answer_record`
--

DROP TABLE IF EXISTS `relay_answer_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relay_answer_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `session_id` bigint DEFAULT NULL COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `question_id` bigint DEFAULT NULL COMMENT '题目ID',
  `poem_sentence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '题面诗句',
  `expected_word` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '要求接的字',
  `user_answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户答案',
  `correct_answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '正确答案',
  `is_correct` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否答对：0否1是',
  `score_delta` int NOT NULL DEFAULT '0' COMMENT '本次加分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_session_id` (`session_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_question_id` (`question_id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='词语接龙答题记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relay_answer_record`
--

LOCK TABLES `relay_answer_record` WRITE;
/*!40000 ALTER TABLE `relay_answer_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `relay_answer_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relay_game_session`
--

DROP TABLE IF EXISTS `relay_game_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relay_game_session` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `current_question_id` bigint DEFAULT NULL COMMENT '当前题目ID',
  `current_poem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '当前题面诗句',
  `expected_word` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '当前要求接的字',
  `current_streak` int NOT NULL DEFAULT '0' COMMENT '当前连续答对次数',
  `total_correct` int NOT NULL DEFAULT '0' COMMENT '本局累计答对数',
  `dragon_light_count` int NOT NULL DEFAULT '0' COMMENT '龙鳞点亮数',
  `total_target_count` int NOT NULL DEFAULT '12' COMMENT '总目标数，默认12',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ONGOING' COMMENT '状态：ONGOING进行中，FINISHED已完成',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='词语接龙会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relay_game_session`
--

LOCK TABLES `relay_game_session` WRITE;
/*!40000 ALTER TABLE `relay_game_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `relay_game_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relay_question_bank`
--

DROP TABLE IF EXISTS `relay_question_bank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relay_question_bank` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '题目标题',
  `poem_sentence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题面诗句',
  `answer_sentence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '正确接龙诗句',
  `expected_word` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '期望接龙字',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '作者',
  `dynasty` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '朝代',
  `difficulty` int NOT NULL DEFAULT '1' COMMENT '难度，1-5',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态：0启用1停用',
  `sort_num` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_expected_word` (`expected_word`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_difficulty` (`difficulty`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='词语接龙题库表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relay_question_bank`
--

LOCK TABLES `relay_question_bank` WRITE;
/*!40000 ALTER TABLE `relay_question_bank` DISABLE KEYS */;
/*!40000 ALTER TABLE `relay_question_bank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `season_player_stat`
--

DROP TABLE IF EXISTS `season_player_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `season_player_stat` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `season_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `score` int DEFAULT '0',
  `correct_count` int DEFAULT '0',
  `wrong_count` int DEFAULT '0',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `season_player_stat`
--

LOCK TABLES `season_player_stat` WRITE;
/*!40000 ALTER TABLE `season_player_stat` DISABLE KEYS */;
INSERT INTO `season_player_stat` VALUES (1,1,1,0,0,16,'2026-03-08 20:25:49');
/*!40000 ALTER TABLE `season_player_stat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shici_user`
--

DROP TABLE IF EXISTS `shici_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shici_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'student',
  `grade` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shici_user`
--

LOCK TABLES `shici_user` WRITE;
/*!40000 ALTER TABLE `shici_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `shici_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story`
--

DROP TABLE IF EXISTS `story`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '典故ID',
  `category_id` bigint NOT NULL COMMENT '分类ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '典故名称',
  `dynasty` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '朝代',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关键词',
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '典故简介',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '完整典故内容',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '出处',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图片',
  `heat` int DEFAULT '0' COMMENT '热度',
  `status` tinyint DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_category_id` (`category_id`) USING BTREE,
  KEY `idx_title` (`title`) USING BTREE,
  KEY `idx_heat` (`heat`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story`
--

LOCK TABLES `story` WRITE;
/*!40000 ALTER TABLE `story` DISABLE KEYS */;
INSERT INTO `story` VALUES (1,2,'伯牙绝弦','春秋','知音,高山流水,友情','伯牙善鼓琴，钟子期善听，二人因琴结为知音。','伯牙鼓琴，志在高山，子期曰：“善哉，峨峨兮若泰山！”志在流水，子期曰：“善哉，洋洋兮若江河！”子期死，伯牙破琴绝弦，终身不复鼓琴。','《列子·汤问》','/images/story/boya.jpg',398,1,'2026-04-29 01:19:42','2026-05-12 20:44:19'),(2,3,'项庄舞剑','秦末','鸿门宴,暗藏杀机','项庄舞剑，意在沛公。','鸿门宴上，项庄舞剑，意在刺杀刘邦，但被项伯阻拦。','《史记》','/images/story/xiangzhuang.jpg',196,1,'2026-04-29 01:19:42','2026-05-04 15:29:40'),(3,3,'卧薪尝胆','春秋','忍辱负重,复仇','越王勾践卧薪尝胆，励精图治。','勾践战败后卧薪尝胆，最终灭吴复国。','《史记》','/images/story/goujian.jpg',166,1,'2026-04-29 01:19:42','2026-05-06 17:33:51'),(4,6,'乌衣巷','东晋','旧时王谢,兴衰','昔日繁华地，如今荒凉。','王谢堂前燕，飞入寻常百姓家。','《乌衣巷》','/images/story/wuyi.jpg',121,1,'2026-04-29 01:19:42','2026-05-01 14:17:13'),(5,4,'赤壁之战','三国','火攻,以少胜多','周瑜火攻曹操，大败其军。','赤壁之战奠定三国鼎立格局。','《三国志》','/images/story/chibi.jpg',95,1,'2026-04-29 01:19:42','2026-05-01 14:26:34'),(6,2,'负荆请罪','战国','廉颇,蔺相如,将相和','廉颇知错后背负荆条向蔺相如请罪，二人和好。','赵国名将廉颇因不满蔺相如位居其上，屡次相逼。蔺相如以国家大局为重处处退让，廉颇得知后惭愧不已，背负荆条上门请罪，成就将相和的佳话。','《史记·廉颇蔺相如列传》','/images/story/fujingqingzui.jpg',292,1,'2026-05-01 10:00:00','2026-05-06 17:37:55'),(7,3,'完璧归赵','战国','和氏璧,蔺相如,智勇','蔺相如凭胆识使和氏璧完整归还赵国。','秦王想以城池换取赵国和氏璧，蔺相如奉命出使秦国。他看出秦王无意守约，机智周旋，最终派人将璧送回赵国，维护了赵国尊严。','《史记·廉颇蔺相如列传》','/images/story/wanbiguiZhao.jpg',276,1,'2026-05-01 10:00:00','2026-05-13 18:24:00'),(8,3,'纸上谈兵','战国','赵括,长平之战,空谈','赵括只会照书本谈兵，最终导致赵军惨败。','赵括熟读兵书却缺少实战经验，接替廉颇统军后轻敌冒进，在长平之战中被秦军围困，赵军大败。后人用纸上谈兵比喻空谈理论而不能解决实际问题。','《史记·廉颇蔺相如列传》','/images/story/zhishangtanbing.jpg',247,1,'2026-05-01 10:00:00','2026-05-01 15:55:11'),(9,3,'破釜沉舟','秦末','项羽,巨鹿之战,决心','项羽砸锅沉船，激励士兵决一死战。','项羽率军渡河救赵后，下令破釜沉舟，只带三日粮草，表示不胜不归。士卒因此奋勇作战，在巨鹿之战中大败秦军。','《史记·项羽本纪》','/images/story/pofuchenzhou.jpg',360,1,'2026-05-01 10:00:00','2026-05-12 20:45:07'),(10,3,'四面楚歌','秦末','项羽,垓下,失败','项羽被围垓下，四周响起楚歌，军心瓦解。','楚汉相争末期，项羽被刘邦军队围困于垓下。夜间汉军四面唱起楚地歌谣，项羽以为楚地尽失，悲叹大势已去。','《史记·项羽本纪》','/images/story/simianchuge.jpg',308,1,'2026-05-01 10:00:00','2026-05-06 18:21:30'),(11,2,'退避三舍','春秋','晋文公,诚信,报恩','晋文公遵守旧诺，在交战时主动后退三舍。','晋文公重耳流亡楚国时曾受礼遇，并许诺若两国交战愿退避三舍。后来晋楚交战，他依约后退，既守信义，也赢得军心。','《左传》','/images/story/tuibisanshe.jpg',221,1,'2026-05-01 10:00:00','2026-05-01 15:15:23'),(12,2,'管鲍之交','春秋','管仲,鲍叔牙,友情','管仲与鲍叔牙相知相敬，是知己之交的典范。','鲍叔牙深知管仲才能，处处理解并举荐他。齐桓公任用管仲为相后，成就霸业。管鲍之交后常用来形容朋友之间真诚相知。','《史记·管晏列传》','/images/story/guanbaozhijiao.jpg',279,1,'2026-05-01 10:00:00','2026-05-12 20:42:22'),(13,4,'三顾茅庐','三国','刘备,诸葛亮,求贤','刘备三次拜访诸葛亮，诚心请其出山辅佐。','刘备听闻诸葛亮才略过人，三次前往隆中拜访。诸葛亮被其诚意打动，提出隆中对，后来辅佐刘备建立蜀汉。','《三国志》','/images/story/sangumaolu.jpg',379,1,'2026-05-01 10:00:00','2026-05-06 18:24:42'),(14,4,'草船借箭','三国','诸葛亮,周瑜,智谋','诸葛亮借大雾用草船从曹军处取得箭支。','周瑜要求诸葛亮限期造箭，诸葛亮利用江上大雾，命草船靠近曹营诱敌放箭，轻松取得十万支箭，展现过人谋略。','《三国演义》','/images/story/caochuanjiejian.jpg',594,1,'2026-05-01 10:00:00','2026-05-20 08:55:44'),(15,4,'七步成诗','三国','曹植,曹丕,才思','曹植七步之内作诗，表现敏捷才华。','曹丕命曹植七步内作诗，否则加罪。曹植以豆萁相煎为喻写成诗句，委婉表达兄弟相逼之痛。','《世说新语》','/images/story/qibuchengshi.jpg',235,1,'2026-05-01 10:00:00','2026-05-01 15:16:17'),(16,4,'乐不思蜀','三国','刘禅,安乐,亡国','刘禅沉迷安逸，说出不再思念蜀国之语。','蜀汉灭亡后，刘禅被迁至洛阳。司马昭试探他是否思念故国，刘禅回答此间乐不思蜀，后世用来形容安于现状而忘本。','《三国志》','/images/story/lebushishu.jpg',187,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(17,4,'闻鸡起舞','东晋','祖逖,刘琨,勤奋','祖逖和刘琨听到鸡叫便起身练剑。','祖逖与刘琨胸怀报国之志，夜间听到鸡鸣就起床舞剑，刻苦磨炼本领。后用闻鸡起舞形容有志之士奋发勤勉。','《晋书·祖逖传》','/images/story/wenjiqiwu.jpg',266,1,'2026-05-01 10:00:00','2026-05-06 18:21:23'),(18,4,'东山再起','东晋','谢安,隐居,复出','谢安隐居东山后再次出仕，成就大业。','谢安早年隐居东山，后来应召出仕，在淝水之战中主持大局，帮助东晋转危为安。东山再起指失势后重新恢复地位。','《晋书·谢安传》','/images/story/dongshanzaiqi.jpg',245,1,'2026-05-01 10:00:00','2026-05-02 15:29:27'),(19,4,'淝水之战','东晋','谢安,以少胜多,前秦','东晋在淝水之战中以少胜多，击败前秦。','前秦苻坚率大军南下，东晋谢安等人沉着应对。晋军抓住战机，使前秦军队溃败，成为中国历史上著名的以少胜多战例。','《晋书》','/images/story/feishuizhizhan.jpg',304,1,'2026-05-01 10:00:00','2026-05-12 20:42:08'),(20,9,'洛阳纸贵','西晋','左思,三都赋,文学','左思作品广受欢迎，导致洛阳纸价上涨。','左思写成《三都赋》后，士人竞相传抄，一时洛阳纸张供不应求，价格上涨。后用洛阳纸贵形容著作风行一时。','《晋书·左思传》','/images/story/luoyangzhigui.jpg',227,1,'2026-05-01 10:00:00','2026-05-01 15:01:39'),(21,6,'程门立雪','北宋','杨时,程颐,尊师','杨时为求教在程颐门前冒雪等待。','杨时与游酢去拜见程颐，见老师正在静坐，便在门外恭敬等候。程颐醒来时，门外积雪已深，体现尊师重道。','《宋史·杨时传》','/images/story/chengmenlixue.jpg',255,1,'2026-05-01 10:00:00','2026-05-06 18:21:20'),(22,6,'凿壁偷光','西汉','匡衡,读书,勤学','匡衡家贫无灯，凿开墙壁借邻家灯光读书。','匡衡小时候家境贫寒，夜间无钱点灯，便在墙上凿出小孔，借邻居家的灯光读书。后人用此典鼓励勤学苦读。','《西京杂记》','/images/story/zaobitouguang.jpg',338,1,'2026-05-01 10:00:00','2026-05-06 18:21:11'),(23,6,'囊萤映雪','晋代','车胤,孙康,勤学','车胤囊萤照书，孙康映雪读书。','车胤家贫，以纱囊装萤火虫照明读书；孙康冬夜借雪光读书。两事合称囊萤映雪，象征勤奋求学。','《晋书》《孙氏世录》','/images/story/nangyingyingxue.jpg',311,1,'2026-05-01 10:00:00','2026-05-06 18:29:31'),(24,6,'画龙点睛','南北朝','张僧繇,绘画,神妙','张僧繇为龙点上眼睛后，画龙仿佛飞去。','传说画家张僧繇在寺壁画龙，却迟迟不点眼睛。点睛之后，龙破壁飞去。后用画龙点睛比喻关键处一笔使整体生动。','《历代名画记》','/images/story/hualongdianjing.jpg',272,1,'2026-05-01 10:00:00','2026-05-12 20:42:24'),(25,6,'江郎才尽','南朝','江淹,才华,衰退','江淹晚年文才衰退，被称为江郎才尽。','南朝文学家江淹少年成名，文章华美。传说晚年梦中归还彩笔，从此才思减退。后用江郎才尽比喻才华衰退。','《南史·江淹传》','/images/story/jianglangcaijin.jpg',201,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(26,2,'滥竽充数','战国','南郭先生,齐宣王,冒充','南郭先生不会吹竽，却混在乐队中充数。','齐宣王喜欢听多人合奏，南郭先生便混入乐队冒充乐师。齐湣王继位后要求独奏，南郭先生只好逃走。','《韩非子》','/images/story/lanyuchongshu.jpg',291,1,'2026-05-01 10:00:00','2026-05-06 18:21:27'),(27,2,'守株待兔','战国','农夫,偶然,懒惰','农夫偶然捡到撞树而死的兔子，便天天守着树等待。','宋国有农夫见兔子撞树而死，便放下农具守在树旁，希望再有兔子送上门。后用来讽刺不劳而获和死守经验。','《韩非子》','/images/story/shouzhudaitu.jpg',280,1,'2026-05-01 10:00:00','2026-05-06 18:21:26'),(28,2,'刻舟求剑','战国','楚人,求剑,拘泥','楚人剑落水后在船上刻记号寻找。','楚人渡江时剑掉入水中，他在船边刻下记号，等船靠岸才从刻痕处下水找剑。后用刻舟求剑比喻拘泥成法。','《吕氏春秋》','/images/story/kezhouqiujian.jpg',264,1,'2026-05-01 10:00:00','2026-05-06 18:21:21'),(29,2,'掩耳盗铃','春秋','盗铃,自欺欺人','盗铃人捂住自己的耳朵，以为别人也听不到铃声。','有人想偷铃铛，担心铃声被人听见，便捂住自己的耳朵去盗铃。后用掩耳盗铃比喻自欺欺人。','《吕氏春秋》','/images/story/yanerdaoling.jpg',256,1,'2026-05-01 10:00:00','2026-05-06 18:21:21'),(30,2,'鹬蚌相争','战国','渔翁得利,争斗','鹬和蚌互不相让，最后被渔翁一起捉住。','鹬鸟啄蚌，蚌夹住鹬嘴，双方争执不下，渔翁经过将它们一并捕获。后用来比喻双方相争，使第三者得利。','《战国策》','/images/story/yubangxiangzheng.jpg',292,1,'2026-05-01 10:00:00','2026-05-06 18:05:41'),(31,2,'塞翁失马','西汉','祸福相依,边塞老人','塞翁失马后反而带来转机，说明祸福难料。','边塞老人丢失马匹，邻人安慰，他却认为未必是坏事。后来马带回胡马，其子骑马摔伤，又因此免于征战。后用来说明祸福相依。','《淮南子》','/images/story/saiwengshima.jpg',314,1,'2026-05-01 10:00:00','2026-05-12 20:41:42'),(32,2,'庖丁解牛','战国','庄子,技艺,游刃有余','庖丁解牛技艺高超，动作合乎规律。','庖丁为文惠君解牛，顺着骨节空隙下刀，十九年刀刃仍如新发。后用庖丁解牛比喻技艺纯熟，做事游刃有余。','《庄子·养生主》','/images/story/paodingjieniu.jpg',291,1,'2026-05-01 10:00:00','2026-05-04 16:36:23'),(33,2,'叶公好龙','汉代','叶公,好龙,表里不一','叶公表面喜欢龙，真龙出现却吓得逃走。','叶公声称自己最爱龙，屋中器物都刻画龙。真龙听说后前来拜访，他却惊慌逃走。后用来讽刺表面爱好而实际害怕。','《新序》','/images/story/yegonghaolong.jpg',246,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(34,2,'买椟还珠','战国','楚人,珍珠,舍本逐末','买珠人只留下漂亮盒子，却退还珍珠。','楚国商人把珍珠装在精美木匣中出售。买者看中匣子，买下后把珍珠还给商人。后用买椟还珠比喻舍本逐末。','《韩非子》','/images/story/maiduhuanzhu.jpg',238,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(35,4,'望梅止渴','三国','曹操,行军,机智','曹操用前方有梅林的话激励士兵忍受口渴。','曹操行军途中士兵口渴难耐，他说前面有大片梅林，酸梅可解渴。士兵听后口中生津，坚持前进。','《世说新语》','/images/story/wangmeizhike.jpg',268,1,'2026-05-01 10:00:00','2026-05-02 16:42:38'),(36,4,'煮豆燃萁','三国','曹植,兄弟,相煎','曹植以煮豆燃萁比喻兄弟相逼。','曹丕逼曹植七步成诗，曹植写下豆在釜中泣的诗句，以同根相煎表现兄弟之间不该互相残害。','《世说新语》','/images/story/zhudouranqi.jpg',242,1,'2026-05-01 10:00:00','2026-05-04 16:36:49'),(37,4,'桃园结义','东汉末','刘备,关羽,张飞','刘备、关羽、张飞在桃园结为兄弟。','传说刘备、关羽、张飞志同道合，在桃园焚香结义，誓言同心协力扶危济困，后来成为忠义象征。','《三国演义》','/images/story/taoyuanjieyi.jpg',341,1,'2026-05-01 10:00:00','2026-05-06 18:21:34'),(38,4,'刮目相看','三国','吕蒙,孙权,读书','吕蒙勤学后大有长进，令人刮目相看。','孙权劝吕蒙读书，吕蒙接受劝告后学识大增。鲁肃再见吕蒙时发现他已非昔日吴下阿蒙，于是称赞不已。','《三国志》','/images/story/guamuxiangkan.jpg',260,1,'2026-05-01 10:00:00','2026-05-01 16:39:22'),(39,4,'单刀赴会','三国','关羽,鲁肃,胆略','关羽只带少数随从赴鲁肃之会，表现胆识。','鲁肃约关羽商议荆州之事，关羽带刀赴会，从容应对，体现胆略和气度。后用单刀赴会形容勇敢赴约。','《三国演义》','/images/story/dandaofuhui.jpg',281,1,'2026-05-01 10:00:00','2026-05-12 20:42:12'),(40,4,'万事俱备只欠东风','三国','赤壁,诸葛亮,东风','赤壁火攻一切准备就绪，只缺东风。','赤壁大战前，周瑜准备火攻曹军，但风向不利。诸葛亮借天时之变，助东风吹起，促成赤壁之胜。','《三国演义》','/images/story/dongfeng.jpg',333,1,'2026-05-01 10:00:00','2026-05-12 20:41:57'),(41,3,'司马昭之心','三国','司马昭,野心,路人皆知','司马昭篡权之心明显，人人都看得出来。','魏帝曹髦不满司马昭专权，说司马昭之心路人皆知，随后率人讨伐失败。后用来形容野心非常明显。','《三国志》','/images/story/simazhaozhixin.jpg',232,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(42,6,'一字千金','战国','吕不韦,吕氏春秋,文章','吕不韦悬赏改一字千金，显示文章严密。','吕不韦组织门客编成《吕氏春秋》，公布于咸阳城门，宣称能增删一字者赏千金。后用来形容文章价值极高。','《史记·吕不韦列传》','/images/story/yiziqianjin.jpg',275,1,'2026-05-01 10:00:00','2026-05-06 17:37:52'),(43,6,'青梅竹马','唐代','李白,童年,两小无猜','青梅竹马形容男女儿童天真亲近。','李白诗中写郎骑竹马来，绕床弄青梅，描绘儿童时代亲密玩耍的情景。后用青梅竹马形容自幼相识的纯真情谊。','李白《长干行》','/images/story/qingmeizhuma.jpg',221,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(44,6,'人面桃花','唐代','崔护,桃花,相思','崔护重访旧地，只见桃花依旧而人已不在。','崔护清明郊游时遇见一位女子，次年再访只见门户紧闭，于是题诗人面不知何处去，桃花依旧笑春风。','《本事诗》','/images/story/renmiantaohua.jpg',265,1,'2026-05-01 10:00:00','2026-05-06 18:21:22'),(45,6,'红叶题诗','唐代','宫女,红叶,姻缘','宫女在红叶上题诗，随水流出宫外。','传说宫女将题诗红叶投入御沟，书生拾得后也题诗相和，后来二人结成姻缘。红叶题诗常象征美好情缘。','《云溪友议》','/images/story/hongyeteshi.jpg',250,1,'2026-05-01 10:00:00','2026-05-06 18:21:19'),(46,6,'金榜题名','唐代','科举,功名,登第','科举中榜后姓名写在榜上，称金榜题名。','古代科举放榜时，考中者姓名列于榜上，被视为人生荣耀。后用金榜题名祝贺考试成功。','《唐摭言》','/images/story/jinbangtiming.jpg',291,1,'2026-05-01 10:00:00','2026-05-12 20:19:50'),(47,6,'蟾宫折桂','晋代','科举,桂枝,登科','蟾宫折桂比喻科举及第或取得优异成绩。','传说月宫中有桂树，折桂象征获得高第。后来人们用蟾宫折桂祝愿学子考试成功、名列前茅。','《晋书·郤诜传》','/images/story/changongzhegui.jpg',235,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(48,6,'梦笔生花','唐代','李白,才华,文思','梦见笔头生花，象征文才出众。','传说李白少年时梦见所用之笔开花，从此才思大进。后用梦笔生花形容文章优美、才华横溢。','《开元天宝遗事》','/images/story/mengbishenghua.jpg',270,1,'2026-05-01 10:00:00','2026-05-13 18:35:27'),(49,6,'铁杵成针','唐代','李白,坚持,勤奋','李白见老妇磨铁杵成针，受到坚持不懈的启发。','传说李白少年读书不耐烦，途中见老妇磨铁杵想做针，受到触动后发奋学习。后用来说明只要有恒心，难事也能成功。','《方舆胜览》','/images/story/tiechuchengzhen.jpg',319,1,'2026-05-01 10:00:00','2026-05-12 20:41:44'),(50,2,'画蛇添足','战国','楚人,多此一举','有人画蛇后又添脚，反而失去酒。','几个人比赛画蛇，先画成者本可得酒，却自作聪明给蛇添脚，结果被别人夺去。后用画蛇添足比喻多此一举。','《战国策》','/images/story/huashetianzu.jpg',289,1,'2026-05-01 10:00:00','2026-05-12 20:42:10'),(51,2,'狐假虎威','战国','狐狸,老虎,借势','狐狸借老虎威势吓退百兽。','狐狸被老虎捉住后谎称自己受天命为百兽之长，让老虎跟在身后验证。百兽见老虎而逃，老虎却以为怕的是狐狸。','《战国策》','/images/story/hujiahuwei.jpg',289,1,'2026-05-01 10:00:00','2026-05-13 18:20:21'),(52,2,'黔驴技穷','唐代','柳宗元,驴,本领有限','黔地老虎发现驴不过只有几样本领，最终吃掉了它。','柳宗元寓言中，黔地无驴，有人运来一头驴。老虎起初惧怕，后来发现驴只会鸣叫和踢腿，便将其吃掉。','柳宗元《黔之驴》','/images/story/qianlvjiqiong.jpg',243,1,'2026-05-01 10:00:00','2026-05-01 10:00:00'),(53,2,'愚公移山','战国','愚公,坚持,信念','愚公坚持移山，感动天帝。','愚公家门前有太行、王屋二山阻路，他率子孙日日挖山不止。其坚定信念感动天帝，最终移走大山。','《列子·汤问》','/images/story/yugongyishan.jpg',338,1,'2026-05-01 10:00:00','2026-05-12 20:41:59'),(54,3,'围魏救赵','战国','孙膑,田忌,兵法','孙膑不直接救赵，而攻魏都迫使魏军回援。','魏军围攻赵国邯郸，赵国求救于齐。孙膑建议攻打魏国都城大梁，迫使魏军撤围回救，从而解赵之危。','《史记·孙子吴起列传》','/images/story/weiweijiuzhao.jpg',303,1,'2026-05-01 10:00:00','2026-05-06 18:21:30'),(55,3,'指鹿为马','秦代','赵高,权谋,颠倒黑白','赵高把鹿说成马，试探群臣是否顺从。','赵高在秦二世面前献鹿，却称其为马，并观察群臣反应。敢说真话者后来多遭迫害，后用指鹿为马形容颠倒是非。','《史记·秦始皇本纪》','/images/story/zhiluweima.jpg',326,1,'2026-05-01 10:00:00','2026-05-12 20:41:46'),(56,5,'嫦娥奔月','上古神话','嫦娥,后羿,月宫,神话','嫦娥服下仙药后飞升月宫，成为月中仙子。','相传后羿射下九日后，得到西王母赐予的不死仙药。嫦娥因故服下仙药，身体轻盈飞向月亮，从此居于广寒宫。嫦娥奔月成为中国古代关于月亮最著名的神话典故之一。','《淮南子》','/images/story/changebenyue.jpg',347,1,'2026-05-01 10:00:00','2026-05-06 18:21:35'),(57,5,'精卫填海','上古神话','精卫,填海,坚持,神话','炎帝之女化为精卫鸟，衔石填海。','相传炎帝的小女儿女娃在东海溺亡，死后化为精卫鸟。她常常衔来西山的木石，投入东海，想要把大海填平。后人用精卫填海比喻意志坚定、不畏艰难。','《山海经·北山经》','/images/story/jingweitianhai.jpg',323,1,'2026-05-01 10:00:00','2026-05-12 20:19:47'),(58,5,'女娲补天','上古神话','女娲,补天,救世,神话','女娲炼五色石修补破裂的天空。','传说远古时期天柱折断，天穹破裂，洪水猛兽危害人间。女娲炼五色石补天，又斩巨鳌之足支撑四极，使天地重新安定。女娲补天表现了古人对创世与救世神力的想象。','《淮南子·览冥训》','/images/story/nvwabutian.jpg',421,1,'2026-05-01 10:00:00','2026-05-13 18:20:36'),(59,7,'南柯一梦','唐代','梦境,人生,虚幻,其他典故','淳于棼梦入槐安国，醒后方知荣华如梦。','唐人传奇中，淳于棼醉卧槐树下，梦中进入槐安国，娶公主、任太守，享尽荣华。醒来后发现所谓槐安国不过是槐树下的蚁穴。后用南柯一梦比喻人生富贵虚幻如梦。','李公佐《南柯太守传》','/images/story/nankeyimeng.jpg',279,1,'2026-05-01 10:00:00','2026-05-06 17:37:49'),(60,7,'黄粱一梦','唐代','卢生,梦境,富贵,其他典故','卢生梦中经历一生富贵，醒来黄粱饭还未熟。','卢生在旅店中遇到吕翁，枕着瓷枕入梦，梦中历尽功名富贵，醒来时店家的黄粱饭尚未煮熟。后人用黄粱一梦比喻荣华富贵转瞬成空。','沈既济《枕中记》','/images/story/huangliangyimeng.jpg',303,1,'2026-05-01 10:00:00','2026-05-06 18:05:40'),(61,7,'邯郸学步','战国','燕人,学步,盲目模仿,其他典故','燕国人到邯郸学习走路，结果连原来的走法也忘了。','相传燕国有个年轻人听说赵国邯郸人走路姿态优美，便前去模仿。结果不但没有学会，反而忘了自己原来的走路方式，只好爬着回去。后用邯郸学步比喻盲目模仿反而失去本来能力。','《庄子·秋水》','/images/story/handanxuebu.jpg',266,1,'2026-05-01 10:00:00','2026-05-12 20:44:33'),(62,6,'折柳送别','汉唐','柳树,离别,送行,物象典故','古人送别时常折柳相赠，寄托依依惜别之情。','古代柳与留谐音，折柳赠别成为送行时表达挽留和惜别的习俗。诗词中常以柳枝、杨柳、柳色写离情，如灞桥折柳便成为送别意象的重要典故。','古代送别习俗及诗词传统','/images/story/zheliusongbie.jpg',289,1,'2026-05-01 10:00:00','2026-05-12 20:42:19'),(63,6,'青鸟传书','先秦神话','青鸟,传信,相思,物象典故','青鸟常被视为传递消息的神鸟。','传说青鸟是西王母的使者，能够往来传递消息。后来诗词中常用青鸟象征信使，也寄托相思、盼信与远方消息之意。','《山海经》及后世诗词','/images/story/qingniaochuanshu.jpg',277,1,'2026-05-01 10:00:00','2026-05-06 18:21:25'),(64,6,'杜鹃啼血','古蜀传说','杜鹃,望帝,哀思,物象典故','杜鹃鸟啼声悲切，常被用来寄托哀怨思归之情。','相传蜀王杜宇死后化为杜鹃鸟，暮春啼叫，声声凄切，甚至啼至出血。后世诗词常以杜鹃啼血表达亡国之痛、离别之悲和思乡之情。','古蜀传说及诗词典故','/images/story/dujuantixue.jpg',305,1,'2026-05-01 10:00:00','2026-05-06 18:29:17'),(65,6,'鸿雁传书','汉代','鸿雁,书信,思念,物象典故','鸿雁被视为传递书信和思念的象征。','汉代苏武被困匈奴，传说汉使借鸿雁足系书信之说探得其下落。后世诗词中常以鸿雁代表书信、音讯和游子思乡之情。','《汉书·苏武传》','/images/story/hongyanchuanshu.jpg',328,1,'2026-05-01 10:00:00','2026-05-12 20:41:50'),(66,8,'封狼居胥','西汉','霍去病,将军,功业,官职典故','霍去病北击匈奴，登狼居胥山祭天，象征武将最高功业。','西汉名将霍去病率军远征匈奴，深入漠北，大获全胜，并在狼居胥山举行祭天封礼。后世常用封狼居胥形容将帅建功边塞、功业卓著。','《史记·卫将军骠骑列传》','/images/story/fenglangjuxu.jpg',353,1,'2026-05-01 10:00:00','2026-05-12 20:20:15'),(67,8,'拜相封侯','古代','宰相,侯爵,功名,官职典故','拜为宰相、封为侯爵，象征古代士人功名显达。','古代读书人或功臣若能拜相封侯，便意味着位极人臣、功成名就。后世诗文中常用拜相封侯表达对仕途成功、功名富贵的追求或感慨。','古代官制典故','/images/story/baixiangfenghou.jpg',285,1,'2026-05-01 10:00:00','2026-05-04 16:36:25'),(68,8,'青云直上','战国','仕途,高升,官职典故','青云直上比喻仕途顺利，职位迅速升高。','青云原指高空云天，后常用来比喻高官显位。古代文人常以青云直上形容进入仕途后步步高升，也可表达对功名事业的向往。','《史记》及后世诗文','/images/story/qingyunzhishang.jpg',270,1,'2026-05-01 10:00:00','2026-05-06 18:21:23'),(69,7,'悬梁刺股','战国','苏秦,孙敬,勤学,其他典故','孙敬悬梁、苏秦刺股，都是刻苦学习的典故。','孙敬读书时怕自己困倦，便用绳子把头发系在房梁上；苏秦读书困乏时用锥子刺大腿提醒自己。后世用悬梁刺股形容发奋苦读、刻苦自励。','《太平御览》《战国策》','/images/story/xuanliangcigu.jpg',319,1,'2026-05-01 10:00:00','2026-05-06 18:21:12'),(70,7,'毛遂自荐','战国','毛遂,自荐,胆识,其他典故','毛遂主动推荐自己随平原君出使楚国，最终立下功劳。','赵国危急时，平原君准备出使楚国求援，门客毛遂主动请求同行。到楚国后，他凭借胆识和口才促成合纵抗秦。后用毛遂自荐比喻主动推荐自己承担任务。','《史记·平原君虞卿列传》','/images/story/maosuizijian.jpg',298,1,'2026-05-01 10:00:00','2026-05-12 20:42:04'),(71,9,'班门弄斧','唐代','鲁班,技艺,自不量力,其他典故','在鲁班门前摆弄斧头，比喻在行家面前卖弄本领。','鲁班是古代著名巧匠，若在鲁班门前炫耀斧工，便显得自不量力。后世用班门弄斧形容在高手或专家面前卖弄本领。','柳宗元诗文及后世典故','/images/story/banmennongfu.jpg',252,1,'2026-05-01 10:00:00','2026-05-06 18:21:20'),(72,7,'高山流水','春秋','伯牙,子期,知音,其他典故','伯牙善弹琴，钟子期能听懂琴中志趣，成为知音典范。','伯牙弹琴时志在高山，钟子期便说巍巍乎若泰山；志在流水，子期又说洋洋乎若江河。子期死后，伯牙摔琴绝弦。后用高山流水比喻知音难得。','《列子·汤问》','/images/story/gaoshanliushui.jpg',358,1,'2026-05-01 10:00:00','2026-05-12 20:44:22');
/*!40000 ALTER TABLE `story` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story_category`
--

DROP TABLE IF EXISTS `story_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类图标',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story_category`
--

LOCK TABLES `story_category` WRITE;
/*!40000 ALTER TABLE `story_category` DISABLE KEYS */;
INSERT INTO `story_category` VALUES (1,'全部典故','all',1,'2026-04-29 01:18:02'),(2,'人物典故','person',2,'2026-04-29 01:18:02'),(3,'历史事件','history',3,'2026-04-29 01:18:02'),(4,'战争典故','war',4,'2026-04-29 01:18:02'),(5,'神话传说','myth',5,'2026-04-29 01:18:02'),(6,'地名典故','place',6,'2026-04-29 01:18:02'),(7,'物象典故','object',7,'2026-04-29 01:18:02'),(8,'官职典故','official',8,'2026-04-29 01:18:02'),(9,'其他典故','other',9,'2026-04-29 01:18:02');
/*!40000 ALTER TABLE `story_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story_poem_relation`
--

DROP TABLE IF EXISTS `story_poem_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story_poem_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `story_id` bigint NOT NULL COMMENT '典故ID',
  `poem_id` bigint NOT NULL COMMENT '诗词ID',
  `relation_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联说明',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_story_id` (`story_id`) USING BTREE,
  KEY `idx_poem_id` (`poem_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story_poem_relation`
--

LOCK TABLES `story_poem_relation` WRITE;
/*!40000 ALTER TABLE `story_poem_relation` DISABLE KEYS */;
INSERT INTO `story_poem_relation` VALUES (1,1,5,'表现知音与豪情','2026-04-29 01:21:09'),(2,1,8,'体现情感共鸣','2026-04-29 01:21:09'),(3,2,20,'表达忠义与志向','2026-04-29 01:21:09'),(4,3,5,'隐逸理想与桃源意境','2026-04-29 01:21:09'),(5,4,8,'旧地兴衰对比','2026-04-29 01:21:09'),(6,5,20,'战争背景下的诗歌表达','2026-04-29 01:21:09'),(7,6,1,'体现知错改过与将相和精神','2026-05-02 14:00:00'),(8,7,8,'表现智勇周旋与家国尊严','2026-05-02 14:00:00'),(9,8,7,'表现空谈误国与历史警示','2026-05-02 14:00:00'),(10,9,7,'表现决绝奋战与英雄气概','2026-05-02 14:00:00'),(11,10,7,'表现失败悲歌与英雄末路','2026-05-02 14:00:00'),(12,11,1,'体现守信重义与报恩精神','2026-05-02 14:00:00'),(13,12,1,'表现真诚相知的友情主题','2026-05-02 14:00:00'),(14,13,8,'表现求贤若渴与历史风云','2026-05-02 14:00:00'),(15,14,20,'表现智谋筹划与战争情境','2026-05-02 14:00:00'),(16,15,3,'表现才思敏捷与文学意象','2026-05-02 14:00:00'),(17,16,10,'表现安逸忘本与兴亡感慨','2026-05-02 14:00:00'),(18,17,3,'表现勤奋自励与报国志向','2026-05-02 14:00:00'),(19,18,3,'表现隐居复出与人生转折','2026-05-02 14:00:00'),(20,19,10,'表现以少胜多与历史战事','2026-05-02 14:00:00'),(21,20,3,'表现文章风行与文学盛名','2026-05-02 14:00:00'),(22,21,3,'表现尊师重道与求学精神','2026-05-02 14:00:00'),(23,22,3,'表现勤学苦读与逆境自强','2026-05-02 14:00:00'),(24,23,3,'表现刻苦求学与清贫志向','2026-05-02 14:00:00'),(25,24,3,'表现关键点化与艺术神韵','2026-05-02 14:00:00'),(26,25,3,'表现才华衰退与人生感慨','2026-05-02 14:00:00'),(27,26,1,'表现滥竽充数与自省警示','2026-05-02 14:00:00'),(28,27,1,'表现守旧侥幸与人生警示','2026-05-02 14:00:00'),(29,28,1,'表现拘泥成法与处事警示','2026-05-02 14:00:00'),(30,29,1,'表现自欺欺人与讽喻意味','2026-05-02 14:00:00'),(31,30,7,'表现争斗相持与渔翁得利','2026-05-02 14:00:00'),(32,31,1,'表现祸福相依的人生哲理','2026-05-02 14:00:00'),(33,32,5,'表现技艺精熟与顺势而为','2026-05-02 14:00:00'),(34,33,1,'表现表里不一的讽刺意味','2026-05-02 14:00:00'),(35,34,1,'表现舍本逐末的处事警示','2026-05-02 14:00:00'),(36,35,10,'表现机智应变与军旅情境','2026-05-02 14:00:00'),(37,36,3,'表现兄弟相逼与才情悲慨','2026-05-02 14:00:00'),(38,37,1,'表现结义情谊与忠义精神','2026-05-02 14:00:00'),(39,38,3,'表现勤学成长与刮目相看','2026-05-02 14:00:00'),(40,39,10,'表现胆略气魄与历史风云','2026-05-02 14:00:00'),(41,40,10,'表现东风火攻与赤壁意象','2026-05-02 14:00:00'),(42,41,7,'表现权谋野心与时代动荡','2026-05-02 14:00:00'),(43,42,3,'表现文章价值与文采声名','2026-05-02 14:00:00'),(44,43,2,'表现两小无猜与青春情意','2026-05-02 14:00:00'),(45,44,2,'表现桃花相思与物是人非','2026-05-02 14:00:00'),(46,45,2,'表现红叶传情与姻缘意象','2026-05-02 14:00:00'),(47,46,3,'表现科举登第与功名理想','2026-05-02 14:00:00'),(48,47,3,'表现折桂登科与仕途愿望','2026-05-02 14:00:00'),(49,48,3,'表现文思才华与诗意想象','2026-05-02 14:00:00'),(50,49,3,'表现坚持不懈与勤学精神','2026-05-02 14:00:00'),(51,50,1,'表现多此一举的讽喻警示','2026-05-02 14:00:00'),(52,51,1,'表现借势欺人的寓言意味','2026-05-02 14:00:00'),(53,52,1,'表现本领有限与自知之明','2026-05-02 14:00:00'),(54,53,1,'表现坚定信念与不懈追求','2026-05-02 14:00:00'),(55,54,7,'表现兵法谋略与救危智慧','2026-05-02 14:00:00'),(56,55,7,'表现颠倒黑白与权力讽刺','2026-05-02 14:00:00'),(57,56,2,'表现月宫神话与浪漫想象','2026-05-02 14:00:00'),(58,57,5,'表现执着坚韧与神话精神','2026-05-02 14:00:00'),(59,58,5,'表现救世补天与神话想象','2026-05-02 14:00:00'),(60,59,3,'表现梦境虚幻与人生无常','2026-05-02 14:00:00'),(61,60,3,'表现富贵如梦与人生感慨','2026-05-02 14:00:00'),(62,61,1,'表现盲目模仿与失本警示','2026-05-02 14:00:00'),(63,62,2,'表现折柳送别与离情别绪','2026-05-02 14:00:00'),(64,63,2,'表现青鸟传信与相思意象','2026-05-02 14:00:00'),(65,64,2,'表现杜鹃啼血与哀思乡愁','2026-05-02 14:00:00'),(66,65,2,'表现鸿雁传书与思乡怀人','2026-05-02 14:00:00'),(67,66,7,'表现边塞功业与英雄气概','2026-05-02 14:00:00'),(68,67,3,'表现功名富贵与仕途理想','2026-05-02 14:00:00'),(69,68,3,'表现仕途高升与人生志向','2026-05-02 14:00:00'),(70,69,3,'表现刻苦自励与求学精神','2026-05-02 14:00:00'),(71,70,7,'表现主动担当与胆识口才','2026-05-02 14:00:00'),(72,71,3,'表现自不量力与谦逊警示','2026-05-02 14:00:00'),(73,72,1,'表现知音难得与山水琴心','2026-05-02 14:00:00');
/*!40000 ALTER TABLE `story_poem_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `story_user_action`
--

DROP TABLE IF EXISTS `story_user_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `story_user_action` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `story_id` bigint NOT NULL COMMENT '典故ID',
  `action_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '行为类型：like收藏/点赞/view浏览',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_story` (`user_id`,`story_id`) USING BTREE,
  KEY `idx_story_action` (`story_id`,`action_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=796 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `story_user_action`
--

LOCK TABLES `story_user_action` WRITE;
/*!40000 ALTER TABLE `story_user_action` DISABLE KEYS */;
INSERT INTO `story_user_action` VALUES (1,2,14,'view','2026-05-02 15:17:58'),(2,2,14,'view','2026-05-02 15:17:58'),(3,2,58,'view','2026-05-02 15:18:10'),(4,2,58,'view','2026-05-02 15:18:10'),(5,2,1,'view','2026-05-02 15:18:10'),(6,2,1,'view','2026-05-02 15:18:10'),(7,2,9,'view','2026-05-02 15:18:12'),(8,2,9,'view','2026-05-02 15:18:12'),(9,2,9,'like','2026-05-02 15:18:13'),(10,2,13,'view','2026-05-02 15:18:24'),(11,2,13,'view','2026-05-02 15:18:24'),(12,2,72,'view','2026-05-02 15:20:05'),(13,2,72,'view','2026-05-02 15:20:05'),(14,2,58,'view','2026-05-02 15:20:07'),(15,2,58,'view','2026-05-02 15:20:07'),(16,2,58,'like','2026-05-02 15:20:08'),(17,2,58,'fav','2026-05-02 15:20:09'),(18,2,14,'view','2026-05-02 15:20:39'),(19,2,14,'view','2026-05-02 15:20:39'),(20,2,1,'view','2026-05-02 15:27:25'),(21,2,66,'view','2026-05-02 15:27:30'),(22,2,66,'view','2026-05-02 15:27:30'),(23,2,56,'view','2026-05-02 15:28:08'),(24,2,56,'view','2026-05-02 15:28:08'),(25,2,14,'view','2026-05-02 15:28:11'),(26,2,14,'view','2026-05-02 15:28:11'),(27,2,58,'view','2026-05-02 15:28:12'),(28,2,58,'view','2026-05-02 15:28:12'),(29,2,14,'view','2026-05-02 15:28:13'),(30,2,14,'view','2026-05-02 15:28:13'),(31,2,39,'view','2026-05-02 15:28:14'),(32,2,39,'view','2026-05-02 15:28:14'),(33,2,39,'like','2026-05-02 15:28:15'),(34,2,39,'fav','2026-05-02 15:28:16'),(35,2,18,'view','2026-05-02 15:29:27'),(36,2,18,'view','2026-05-02 15:29:27'),(37,2,13,'view','2026-05-02 15:29:34'),(38,2,13,'view','2026-05-02 15:29:34'),(39,2,19,'view','2026-05-02 15:29:38'),(40,2,19,'view','2026-05-02 15:29:38'),(41,2,1,'view','2026-05-02 15:29:40'),(42,2,1,'view','2026-05-02 15:29:40'),(43,2,14,'view','2026-05-02 15:29:56'),(44,2,14,'view','2026-05-02 15:29:56'),(45,2,39,'view','2026-05-02 15:29:59'),(46,2,39,'view','2026-05-02 15:29:59'),(47,2,14,'view','2026-05-02 15:35:33'),(48,2,14,'view','2026-05-02 15:35:33'),(49,2,56,'view','2026-05-02 15:36:40'),(50,2,56,'view','2026-05-02 15:36:40'),(51,2,14,'view','2026-05-02 15:40:34'),(52,2,14,'view','2026-05-02 15:40:34'),(53,2,14,'view','2026-05-02 15:41:18'),(54,2,14,'view','2026-05-02 15:41:18'),(55,2,58,'view','2026-05-02 15:44:04'),(56,2,58,'view','2026-05-02 15:44:04'),(57,2,14,'view','2026-05-02 15:44:56'),(58,2,14,'view','2026-05-02 15:44:56'),(59,2,14,'view','2026-05-02 15:45:14'),(60,2,14,'view','2026-05-02 15:45:14'),(61,2,14,'view','2026-05-02 15:47:26'),(62,2,14,'view','2026-05-02 15:47:26'),(63,2,14,'view','2026-05-02 15:48:08'),(64,2,14,'view','2026-05-02 15:48:08'),(65,2,14,'view','2026-05-02 15:48:46'),(66,2,14,'view','2026-05-02 15:48:46'),(67,2,40,'view','2026-05-02 15:48:48'),(68,2,40,'view','2026-05-02 15:48:48'),(69,2,14,'view','2026-05-02 15:48:58'),(70,2,14,'view','2026-05-02 15:48:58'),(71,2,58,'view','2026-05-02 15:48:59'),(72,2,58,'view','2026-05-02 15:48:59'),(73,2,1,'view','2026-05-02 15:49:00'),(74,2,1,'view','2026-05-02 15:49:00'),(75,2,13,'view','2026-05-02 15:49:01'),(76,2,13,'view','2026-05-02 15:49:01'),(77,2,66,'view','2026-05-02 15:49:02'),(78,2,66,'view','2026-05-02 15:49:02'),(79,2,66,'fav','2026-05-02 15:49:03'),(80,2,14,'view','2026-05-02 16:16:23'),(81,2,14,'view','2026-05-02 16:16:23'),(82,2,58,'view','2026-05-02 16:16:39'),(83,2,58,'view','2026-05-02 16:16:39'),(84,2,1,'view','2026-05-02 16:17:03'),(85,2,1,'view','2026-05-02 16:17:03'),(86,2,14,'view','2026-05-02 16:17:11'),(87,2,14,'view','2026-05-02 16:17:11'),(88,2,58,'view','2026-05-02 16:17:12'),(89,2,58,'view','2026-05-02 16:17:12'),(90,2,14,'view','2026-05-02 16:21:59'),(91,2,14,'view','2026-05-02 16:22:00'),(92,2,14,'fav','2026-05-02 16:22:12'),(93,2,14,'view','2026-05-02 16:29:01'),(94,2,14,'view','2026-05-02 16:29:02'),(95,2,1,'view','2026-05-02 16:29:19'),(96,2,1,'view','2026-05-02 16:29:19'),(97,2,31,'view','2026-05-02 16:29:21'),(98,2,31,'view','2026-05-02 16:29:21'),(99,2,14,'view','2026-05-02 16:31:18'),(100,2,14,'view','2026-05-02 16:31:18'),(101,2,14,'view','2026-05-02 16:35:00'),(102,2,14,'view','2026-05-02 16:35:00'),(103,2,14,'view','2026-05-02 16:39:32'),(104,2,14,'view','2026-05-02 16:39:32'),(105,2,35,'view','2026-05-02 16:42:38'),(106,2,35,'view','2026-05-02 16:42:38'),(107,2,14,'view','2026-05-02 16:42:50'),(108,2,14,'view','2026-05-02 16:42:50'),(109,2,14,'fav','2026-05-02 16:42:55'),(110,2,58,'view','2026-05-02 16:42:56'),(111,2,58,'view','2026-05-02 16:42:56'),(112,2,14,'view','2026-05-02 16:42:57'),(113,2,14,'view','2026-05-02 16:42:57'),(114,2,14,'view','2026-05-02 23:55:10'),(115,2,14,'view','2026-05-02 23:55:11'),(116,2,14,'view','2026-05-02 23:55:40'),(117,2,14,'view','2026-05-02 23:55:40'),(118,2,14,'view','2026-05-03 00:01:13'),(119,2,14,'view','2026-05-03 00:01:14'),(120,2,58,'view','2026-05-03 00:17:26'),(121,2,58,'view','2026-05-03 00:17:26'),(122,2,1,'view','2026-05-03 00:19:20'),(123,2,1,'view','2026-05-03 00:19:20'),(124,2,14,'view','2026-05-03 00:19:22'),(125,2,14,'view','2026-05-03 00:19:22'),(126,2,58,'view','2026-05-03 00:19:23'),(127,2,58,'view','2026-05-03 00:19:23'),(128,2,1,'view','2026-05-03 00:19:24'),(129,2,1,'view','2026-05-03 00:19:24'),(130,2,13,'view','2026-05-03 00:19:25'),(131,2,13,'view','2026-05-03 00:19:25'),(132,2,72,'view','2026-05-03 00:19:25'),(133,2,72,'view','2026-05-03 00:19:25'),(134,2,14,'view','2026-05-03 00:19:26'),(135,2,14,'view','2026-05-03 00:19:26'),(136,2,53,'view','2026-05-03 00:19:28'),(137,2,53,'view','2026-05-03 00:19:28'),(138,2,53,'like','2026-05-03 00:19:30'),(139,2,53,'fav','2026-05-03 00:19:31'),(140,2,14,'view','2026-05-03 00:19:44'),(141,2,14,'view','2026-05-03 00:19:44'),(142,2,58,'view','2026-05-03 00:19:44'),(143,2,58,'view','2026-05-03 00:19:44'),(144,2,14,'view','2026-05-03 00:19:47'),(145,2,14,'view','2026-05-03 00:19:47'),(146,2,58,'view','2026-05-03 00:19:49'),(147,2,58,'view','2026-05-03 00:19:49'),(148,2,13,'view','2026-05-03 00:19:58'),(149,2,13,'view','2026-05-03 00:19:58'),(150,2,14,'view','2026-05-04 13:26:00'),(151,2,14,'view','2026-05-04 13:26:01'),(152,2,1,'view','2026-05-04 13:26:29'),(153,2,1,'view','2026-05-04 13:26:29'),(154,2,58,'view','2026-05-04 13:26:30'),(155,2,58,'view','2026-05-04 13:26:30'),(156,2,14,'view','2026-05-04 13:26:31'),(157,2,14,'view','2026-05-04 13:26:31'),(158,2,58,'view','2026-05-04 13:26:36'),(159,2,58,'view','2026-05-04 13:26:36'),(160,2,58,'like','2026-05-04 13:26:38'),(161,2,58,'fav','2026-05-04 13:26:38'),(162,2,1,'view','2026-05-04 13:26:44'),(163,2,1,'view','2026-05-04 13:26:44'),(164,2,1,'fav','2026-05-04 13:26:45'),(165,2,14,'view','2026-05-04 13:27:14'),(166,2,14,'view','2026-05-04 13:27:14'),(167,2,14,'view','2026-05-04 13:38:28'),(168,2,14,'view','2026-05-04 13:38:28'),(169,2,14,'view','2026-05-04 13:44:37'),(170,2,14,'view','2026-05-04 13:44:37'),(171,2,14,'view','2026-05-04 13:50:58'),(172,2,14,'view','2026-05-04 13:50:58'),(173,2,58,'view','2026-05-04 14:20:42'),(174,2,58,'view','2026-05-04 14:20:42'),(175,2,1,'view','2026-05-04 14:20:44'),(176,2,1,'view','2026-05-04 14:20:44'),(177,2,13,'view','2026-05-04 14:20:45'),(178,2,13,'view','2026-05-04 14:20:45'),(179,2,13,'like','2026-05-04 14:20:48'),(180,2,13,'fav','2026-05-04 14:20:53'),(181,2,14,'view','2026-05-04 14:20:58'),(182,2,14,'view','2026-05-04 14:20:58'),(183,2,14,'view','2026-05-04 14:21:02'),(184,2,14,'view','2026-05-04 14:21:02'),(185,2,56,'view','2026-05-04 14:21:04'),(186,2,56,'view','2026-05-04 14:21:04'),(187,2,66,'view','2026-05-04 14:21:07'),(188,2,66,'view','2026-05-04 14:21:07'),(189,2,56,'view','2026-05-04 14:21:10'),(190,2,56,'view','2026-05-04 14:21:10'),(191,2,13,'view','2026-05-04 14:21:11'),(192,2,13,'view','2026-05-04 14:21:11'),(193,2,65,'view','2026-05-04 14:21:12'),(194,2,65,'view','2026-05-04 14:21:12'),(195,2,1,'view','2026-05-04 14:21:14'),(196,2,1,'view','2026-05-04 14:21:14'),(197,2,9,'view','2026-05-04 14:21:15'),(198,2,9,'view','2026-05-04 14:21:15'),(199,2,58,'view','2026-05-04 14:21:17'),(200,2,58,'view','2026-05-04 14:21:17'),(201,2,56,'view','2026-05-04 14:21:18'),(202,2,56,'view','2026-05-04 14:21:18'),(203,2,57,'view','2026-05-04 14:21:20'),(204,2,57,'view','2026-05-04 14:21:20'),(205,2,14,'view','2026-05-04 14:21:26'),(206,2,14,'view','2026-05-04 14:21:26'),(207,2,58,'view','2026-05-04 14:50:23'),(208,2,58,'view','2026-05-04 14:50:24'),(209,2,58,'like','2026-05-04 14:50:26'),(210,2,58,'fav','2026-05-04 14:50:26'),(211,2,13,'view','2026-05-04 14:50:31'),(212,2,13,'view','2026-05-04 14:50:31'),(213,2,14,'view','2026-05-04 14:52:44'),(214,2,14,'view','2026-05-04 14:52:45'),(215,2,14,'view','2026-05-04 14:54:00'),(216,2,14,'view','2026-05-04 14:54:00'),(217,2,14,'view','2026-05-04 14:58:53'),(218,2,14,'view','2026-05-04 14:58:54'),(219,2,14,'view','2026-05-04 14:59:17'),(220,2,14,'view','2026-05-04 14:59:17'),(221,2,14,'view','2026-05-04 15:02:11'),(222,2,14,'view','2026-05-04 15:02:11'),(223,2,58,'view','2026-05-04 15:03:47'),(224,2,58,'view','2026-05-04 15:03:47'),(225,2,1,'view','2026-05-04 15:03:48'),(226,2,1,'view','2026-05-04 15:03:48'),(227,2,13,'view','2026-05-04 15:03:49'),(228,2,13,'view','2026-05-04 15:03:49'),(229,2,72,'view','2026-05-04 15:03:49'),(230,2,72,'view','2026-05-04 15:03:49'),(231,2,9,'view','2026-05-04 15:03:50'),(232,2,9,'view','2026-05-04 15:03:50'),(233,2,14,'view','2026-05-04 15:03:51'),(234,2,14,'view','2026-05-04 15:03:51'),(235,2,32,'view','2026-05-04 15:28:48'),(236,2,32,'view','2026-05-04 15:28:48'),(237,2,14,'view','2026-05-04 15:29:34'),(238,2,14,'view','2026-05-04 15:29:34'),(239,2,32,'view','2026-05-04 15:29:38'),(240,2,32,'view','2026-05-04 15:29:38'),(241,2,2,'view','2026-05-04 15:29:40'),(242,2,2,'view','2026-05-04 15:29:40'),(243,2,14,'view','2026-05-04 15:30:31'),(244,2,14,'view','2026-05-04 15:30:31'),(245,2,32,'view','2026-05-04 15:30:34'),(246,2,32,'view','2026-05-04 15:30:34'),(247,2,1,'view','2026-05-04 15:30:40'),(248,2,1,'view','2026-05-04 15:30:40'),(249,2,14,'view','2026-05-04 15:30:40'),(250,2,14,'view','2026-05-04 15:30:40'),(251,2,14,'view','2026-05-04 15:46:47'),(252,2,14,'view','2026-05-04 15:46:47'),(253,2,14,'view','2026-05-04 15:47:39'),(254,2,14,'view','2026-05-04 15:47:39'),(255,2,14,'view','2026-05-04 15:47:57'),(256,2,14,'view','2026-05-04 15:47:57'),(257,2,14,'view','2026-05-04 15:48:33'),(258,2,14,'view','2026-05-04 15:48:33'),(259,2,14,'view','2026-05-04 15:48:59'),(260,2,14,'view','2026-05-04 15:48:59'),(261,2,14,'view','2026-05-04 15:49:27'),(262,2,14,'view','2026-05-04 15:49:27'),(263,2,14,'view','2026-05-04 15:49:29'),(264,2,14,'view','2026-05-04 15:49:29'),(265,2,14,'view','2026-05-04 15:49:45'),(266,2,14,'view','2026-05-04 15:49:45'),(267,2,49,'view','2026-05-04 15:49:49'),(268,2,49,'view','2026-05-04 15:49:49'),(269,2,58,'view','2026-05-04 15:49:51'),(270,2,58,'view','2026-05-04 15:49:51'),(271,2,1,'view','2026-05-04 15:49:53'),(272,2,1,'view','2026-05-04 15:49:53'),(273,2,13,'view','2026-05-04 15:49:54'),(274,2,13,'view','2026-05-04 15:49:54'),(275,2,37,'view','2026-05-04 15:49:56'),(276,2,37,'view','2026-05-04 15:49:56'),(277,2,66,'view','2026-05-04 15:49:57'),(278,2,66,'view','2026-05-04 15:49:57'),(279,2,14,'view','2026-05-04 15:49:58'),(280,2,14,'view','2026-05-04 15:49:58'),(281,2,13,'view','2026-05-04 15:49:58'),(282,2,13,'view','2026-05-04 15:49:58'),(283,2,14,'view','2026-05-04 15:50:04'),(284,2,14,'view','2026-05-04 15:50:04'),(285,2,14,'view','2026-05-04 16:02:05'),(286,2,14,'view','2026-05-04 16:02:05'),(287,2,23,'view','2026-05-04 16:29:45'),(288,2,23,'view','2026-05-04 16:29:45'),(289,2,14,'view','2026-05-04 16:30:26'),(290,2,14,'view','2026-05-04 16:30:26'),(291,2,23,'view','2026-05-04 16:30:29'),(292,2,23,'view','2026-05-04 16:30:29'),(293,2,14,'view','2026-05-04 16:30:35'),(294,2,14,'view','2026-05-04 16:30:35'),(295,2,40,'view','2026-05-04 16:31:50'),(296,2,40,'view','2026-05-04 16:31:50'),(297,2,53,'view','2026-05-04 16:36:00'),(298,2,53,'view','2026-05-04 16:36:00'),(299,2,40,'view','2026-05-04 16:36:01'),(300,2,40,'view','2026-05-04 16:36:01'),(301,2,65,'view','2026-05-04 16:36:02'),(302,2,65,'view','2026-05-04 16:36:02'),(303,2,40,'view','2026-05-04 16:36:02'),(304,2,40,'view','2026-05-04 16:36:02'),(305,2,14,'view','2026-05-04 16:36:04'),(306,2,14,'view','2026-05-04 16:36:04'),(307,2,40,'view','2026-05-04 16:36:08'),(308,2,40,'view','2026-05-04 16:36:08'),(309,2,66,'view','2026-05-04 16:36:20'),(310,2,66,'view','2026-05-04 16:36:20'),(311,2,32,'view','2026-05-04 16:36:23'),(312,2,32,'view','2026-05-04 16:36:23'),(313,2,67,'view','2026-05-04 16:36:25'),(314,2,67,'view','2026-05-04 16:36:25'),(315,2,14,'view','2026-05-04 16:36:33'),(316,2,14,'view','2026-05-04 16:36:33'),(317,2,40,'view','2026-05-04 16:36:36'),(318,2,40,'view','2026-05-04 16:36:36'),(319,2,14,'view','2026-05-04 16:36:43'),(320,2,14,'view','2026-05-04 16:36:43'),(321,2,13,'view','2026-05-04 16:36:44'),(322,2,13,'view','2026-05-04 16:36:44'),(323,2,40,'view','2026-05-04 16:36:46'),(324,2,40,'view','2026-05-04 16:36:46'),(325,2,36,'view','2026-05-04 16:36:49'),(326,2,36,'view','2026-05-04 16:36:49'),(327,2,14,'view','2026-05-04 16:36:52'),(328,2,14,'view','2026-05-04 16:36:52'),(329,2,9,'view','2026-05-04 16:36:52'),(330,2,9,'view','2026-05-04 16:36:52'),(331,2,14,'view','2026-05-04 16:36:53'),(332,2,14,'view','2026-05-04 16:36:53'),(333,2,58,'view','2026-05-04 16:36:53'),(334,2,58,'view','2026-05-04 16:36:53'),(335,2,22,'view','2026-05-04 16:36:54'),(336,2,22,'view','2026-05-04 16:36:54'),(337,2,72,'view','2026-05-04 16:36:54'),(338,2,72,'view','2026-05-04 16:36:54'),(339,2,66,'view','2026-05-04 16:36:55'),(340,2,66,'view','2026-05-04 16:36:55'),(341,2,71,'view','2026-05-04 16:36:56'),(342,2,71,'view','2026-05-04 16:36:56'),(343,2,58,'view','2026-05-04 16:36:58'),(344,2,58,'view','2026-05-04 16:36:58'),(345,2,14,'view','2026-05-04 16:36:58'),(346,2,14,'view','2026-05-04 16:36:58'),(347,2,9,'view','2026-05-04 16:36:58'),(348,2,9,'view','2026-05-04 16:36:58'),(349,2,1,'view','2026-05-04 16:36:59'),(350,2,1,'view','2026-05-04 16:36:59'),(351,2,14,'view','2026-05-04 16:36:59'),(352,2,14,'view','2026-05-04 16:36:59'),(353,2,9,'view','2026-05-04 16:40:25'),(354,2,9,'view','2026-05-04 16:40:25'),(355,2,58,'view','2026-05-04 16:40:27'),(356,2,58,'view','2026-05-04 16:40:27'),(357,2,14,'view','2026-05-04 16:40:27'),(358,2,14,'view','2026-05-04 16:40:27'),(359,2,9,'view','2026-05-04 16:40:30'),(360,2,9,'view','2026-05-04 16:40:30'),(361,2,58,'view','2026-05-04 16:40:31'),(362,2,58,'view','2026-05-04 16:40:31'),(363,2,9,'view','2026-05-04 16:40:32'),(364,2,9,'view','2026-05-04 16:40:32'),(365,2,1,'view','2026-05-04 16:40:32'),(366,2,1,'view','2026-05-04 16:40:32'),(367,2,14,'view','2026-05-04 16:40:32'),(368,2,14,'view','2026-05-04 16:40:32'),(369,2,65,'view','2026-05-04 16:40:35'),(370,2,65,'view','2026-05-04 16:40:35'),(371,2,65,'like','2026-05-04 16:40:38'),(372,2,14,'view','2026-05-04 16:40:41'),(373,2,14,'view','2026-05-04 16:40:41'),(374,2,22,'view','2026-05-04 16:40:43'),(375,2,22,'view','2026-05-04 16:40:43'),(376,2,53,'view','2026-05-04 16:40:45'),(377,2,53,'view','2026-05-04 16:40:45'),(378,2,21,'view','2026-05-04 17:34:21'),(379,2,21,'view','2026-05-04 17:34:21'),(380,2,14,'view','2026-05-04 17:34:27'),(381,2,14,'view','2026-05-04 17:34:27'),(382,2,22,'view','2026-05-04 17:53:59'),(383,2,22,'view','2026-05-04 17:53:59'),(384,2,14,'view','2026-05-04 17:55:09'),(385,2,14,'view','2026-05-04 17:55:09'),(386,2,45,'view','2026-05-04 17:55:45'),(387,2,45,'view','2026-05-04 17:55:45'),(388,2,14,'view','2026-05-04 18:16:03'),(389,2,14,'view','2026-05-04 18:16:03'),(390,2,14,'view','2026-05-04 18:49:57'),(391,2,14,'view','2026-05-04 18:49:58'),(392,2,58,'view','2026-05-04 19:16:01'),(393,2,58,'view','2026-05-04 19:16:01'),(394,2,9,'view','2026-05-04 19:16:03'),(395,2,9,'view','2026-05-04 19:16:03'),(396,2,14,'view','2026-05-04 19:16:09'),(397,2,14,'view','2026-05-04 19:16:09'),(398,2,14,'view','2026-05-04 19:16:15'),(399,2,14,'view','2026-05-04 19:16:15'),(400,2,1,'view','2026-05-04 19:16:16'),(401,2,1,'view','2026-05-04 19:16:16'),(402,2,14,'view','2026-05-04 19:17:59'),(403,2,14,'view','2026-05-04 19:17:59'),(404,2,1,'view','2026-05-04 19:18:00'),(405,2,1,'view','2026-05-04 19:18:00'),(406,2,14,'view','2026-05-06 14:59:39'),(407,2,14,'view','2026-05-06 14:59:40'),(408,2,14,'view','2026-05-06 15:37:18'),(409,2,14,'view','2026-05-06 15:37:18'),(410,2,58,'view','2026-05-06 15:37:45'),(411,2,58,'view','2026-05-06 15:37:45'),(412,2,40,'view','2026-05-06 15:37:47'),(413,2,40,'view','2026-05-06 15:37:47'),(414,2,40,'like','2026-05-06 15:37:48'),(415,2,31,'view','2026-05-06 15:37:51'),(416,2,31,'view','2026-05-06 15:37:51'),(417,2,14,'view','2026-05-06 15:38:59'),(418,2,14,'view','2026-05-06 15:39:00'),(419,2,54,'view','2026-05-06 15:39:18'),(420,2,54,'view','2026-05-06 15:39:18'),(421,2,70,'view','2026-05-06 15:39:19'),(422,2,70,'view','2026-05-06 15:39:19'),(423,2,58,'view','2026-05-06 15:43:59'),(424,2,58,'view','2026-05-06 15:43:59'),(425,2,14,'view','2026-05-06 15:50:09'),(426,2,14,'view','2026-05-06 15:50:09'),(427,2,14,'view','2026-05-06 15:50:12'),(428,2,14,'view','2026-05-06 15:50:12'),(429,2,56,'view','2026-05-06 15:56:37'),(430,2,56,'view','2026-05-06 15:56:37'),(431,2,71,'view','2026-05-06 15:56:39'),(432,2,71,'view','2026-05-06 15:56:39'),(433,2,14,'view','2026-05-06 15:56:43'),(434,2,14,'view','2026-05-06 15:56:43'),(435,2,1,'view','2026-05-06 15:57:30'),(436,2,1,'view','2026-05-06 15:57:31'),(437,2,66,'view','2026-05-06 15:57:32'),(438,2,66,'view','2026-05-06 15:57:32'),(439,2,9,'view','2026-05-06 15:57:33'),(440,2,9,'view','2026-05-06 15:57:33'),(441,2,14,'view','2026-05-06 15:57:34'),(442,2,14,'view','2026-05-06 15:57:34'),(443,2,65,'view','2026-05-06 15:57:40'),(444,2,65,'view','2026-05-06 15:57:40'),(445,2,55,'view','2026-05-06 15:57:43'),(446,2,55,'view','2026-05-06 15:57:43'),(447,2,14,'view','2026-05-06 16:55:44'),(448,2,14,'view','2026-05-06 16:55:44'),(449,2,14,'view','2026-05-06 17:27:19'),(450,2,14,'view','2026-05-06 17:27:19'),(451,2,58,'view','2026-05-06 17:29:03'),(452,2,58,'view','2026-05-06 17:29:03'),(453,2,66,'view','2026-05-06 17:29:13'),(454,2,66,'view','2026-05-06 17:29:13'),(455,2,14,'view','2026-05-06 17:29:17'),(456,2,14,'view','2026-05-06 17:29:17'),(457,2,3,'view','2026-05-06 17:33:51'),(458,2,3,'view','2026-05-06 17:33:51'),(459,2,14,'view','2026-05-06 17:34:26'),(460,2,14,'view','2026-05-06 17:34:27'),(461,2,55,'view','2026-05-06 17:37:42'),(462,2,55,'view','2026-05-06 17:37:42'),(463,2,49,'view','2026-05-06 17:37:44'),(464,2,49,'view','2026-05-06 17:37:44'),(465,2,10,'view','2026-05-06 17:37:45'),(466,2,10,'view','2026-05-06 17:37:45'),(467,2,60,'view','2026-05-06 17:37:46'),(468,2,60,'view','2026-05-06 17:37:46'),(469,2,6,'view','2026-05-06 17:37:47'),(470,2,6,'view','2026-05-06 17:37:47'),(471,2,26,'view','2026-05-06 17:37:48'),(472,2,26,'view','2026-05-06 17:37:48'),(473,2,59,'view','2026-05-06 17:37:49'),(474,2,59,'view','2026-05-06 17:37:49'),(475,2,63,'view','2026-05-06 17:37:50'),(476,2,63,'view','2026-05-06 17:37:50'),(477,2,42,'view','2026-05-06 17:37:52'),(478,2,42,'view','2026-05-06 17:37:52'),(479,2,50,'view','2026-05-06 17:37:54'),(480,2,50,'view','2026-05-06 17:37:54'),(481,2,6,'view','2026-05-06 17:37:55'),(482,2,6,'view','2026-05-06 17:37:55'),(483,2,9,'view','2026-05-06 17:37:58'),(484,2,9,'view','2026-05-06 17:37:58'),(485,2,14,'view','2026-05-06 17:38:00'),(486,2,14,'view','2026-05-06 17:38:00'),(487,2,14,'view','2026-05-06 18:03:44'),(488,2,14,'view','2026-05-06 18:03:44'),(489,2,14,'view','2026-05-06 18:04:10'),(490,2,14,'view','2026-05-06 18:04:10'),(491,2,13,'view','2026-05-06 18:04:47'),(492,2,13,'view','2026-05-06 18:04:47'),(493,2,14,'view','2026-05-06 18:04:50'),(494,2,14,'view','2026-05-06 18:04:50'),(495,2,56,'view','2026-05-06 18:04:51'),(496,2,56,'view','2026-05-06 18:04:51'),(497,2,40,'view','2026-05-06 18:04:53'),(498,2,40,'view','2026-05-06 18:04:53'),(499,2,56,'view','2026-05-06 18:04:54'),(500,2,56,'view','2026-05-06 18:04:54'),(501,2,1,'view','2026-05-06 18:05:32'),(502,2,1,'view','2026-05-06 18:05:32'),(503,2,14,'view','2026-05-06 18:05:33'),(504,2,14,'view','2026-05-06 18:05:33'),(505,2,37,'view','2026-05-06 18:05:36'),(506,2,37,'view','2026-05-06 18:05:36'),(507,2,40,'view','2026-05-06 18:05:37'),(508,2,40,'view','2026-05-06 18:05:37'),(509,2,57,'view','2026-05-06 18:05:38'),(510,2,57,'view','2026-05-06 18:05:38'),(511,2,49,'view','2026-05-06 18:05:39'),(512,2,49,'view','2026-05-06 18:05:39'),(513,2,31,'view','2026-05-06 18:05:39'),(514,2,31,'view','2026-05-06 18:05:39'),(515,2,60,'view','2026-05-06 18:05:40'),(516,2,60,'view','2026-05-06 18:05:40'),(517,2,30,'view','2026-05-06 18:05:41'),(518,2,30,'view','2026-05-06 18:05:41'),(519,2,26,'view','2026-05-06 18:05:42'),(520,2,26,'view','2026-05-06 18:05:42'),(521,2,54,'view','2026-05-06 18:05:43'),(522,2,54,'view','2026-05-06 18:05:43'),(523,2,10,'view','2026-05-06 18:05:44'),(524,2,10,'view','2026-05-06 18:05:44'),(525,2,69,'view','2026-05-06 18:05:45'),(526,2,69,'view','2026-05-06 18:05:45'),(527,2,40,'view','2026-05-06 18:05:45'),(528,2,40,'view','2026-05-06 18:05:45'),(529,2,72,'view','2026-05-06 18:05:47'),(530,2,72,'view','2026-05-06 18:05:47'),(531,2,13,'view','2026-05-06 18:05:48'),(532,2,13,'view','2026-05-06 18:05:48'),(533,2,14,'view','2026-05-06 18:06:10'),(534,2,14,'view','2026-05-06 18:06:10'),(535,2,14,'view','2026-05-06 18:10:52'),(536,2,14,'view','2026-05-06 18:10:53'),(537,2,14,'view','2026-05-06 18:11:02'),(538,2,14,'view','2026-05-06 18:11:03'),(539,2,14,'view','2026-05-06 18:11:35'),(540,2,14,'view','2026-05-06 18:11:35'),(541,2,56,'view','2026-05-06 18:11:37'),(542,2,56,'view','2026-05-06 18:11:37'),(543,2,37,'view','2026-05-06 18:11:37'),(544,2,37,'view','2026-05-06 18:11:37'),(545,2,14,'view','2026-05-06 18:18:41'),(546,2,14,'view','2026-05-06 18:18:41'),(547,2,72,'view','2026-05-06 18:19:33'),(548,2,72,'view','2026-05-06 18:19:33'),(549,2,14,'view','2026-05-06 18:19:35'),(550,2,14,'view','2026-05-06 18:19:35'),(551,2,14,'view','2026-05-06 18:20:28'),(552,2,14,'view','2026-05-06 18:20:28'),(553,2,72,'view','2026-05-06 18:21:04'),(554,2,72,'view','2026-05-06 18:21:04'),(555,2,49,'view','2026-05-06 18:21:06'),(556,2,49,'view','2026-05-06 18:21:06'),(557,2,37,'view','2026-05-06 18:21:09'),(558,2,37,'view','2026-05-06 18:21:10'),(559,2,22,'view','2026-05-06 18:21:11'),(560,2,22,'view','2026-05-06 18:21:11'),(561,2,69,'view','2026-05-06 18:21:12'),(562,2,69,'view','2026-05-06 18:21:12'),(563,2,10,'view','2026-05-06 18:21:12'),(564,2,10,'view','2026-05-06 18:21:12'),(565,2,19,'view','2026-05-06 18:21:13'),(566,2,19,'view','2026-05-06 18:21:13'),(567,2,26,'view','2026-05-06 18:21:14'),(568,2,26,'view','2026-05-06 18:21:14'),(569,2,50,'view','2026-05-06 18:21:15'),(570,2,50,'view','2026-05-06 18:21:15'),(571,2,39,'view','2026-05-06 18:21:16'),(572,2,39,'view','2026-05-06 18:21:16'),(573,2,63,'view','2026-05-06 18:21:17'),(574,2,63,'view','2026-05-06 18:21:17'),(575,2,68,'view','2026-05-06 18:21:17'),(576,2,68,'view','2026-05-06 18:21:17'),(577,2,28,'view','2026-05-06 18:21:18'),(578,2,28,'view','2026-05-06 18:21:18'),(579,2,45,'view','2026-05-06 18:21:19'),(580,2,45,'view','2026-05-06 18:21:19'),(581,2,71,'view','2026-05-06 18:21:20'),(582,2,71,'view','2026-05-06 18:21:20'),(583,2,21,'view','2026-05-06 18:21:20'),(584,2,21,'view','2026-05-06 18:21:20'),(585,2,29,'view','2026-05-06 18:21:21'),(586,2,29,'view','2026-05-06 18:21:21'),(587,2,28,'view','2026-05-06 18:21:21'),(588,2,28,'view','2026-05-06 18:21:21'),(589,2,44,'view','2026-05-06 18:21:22'),(590,2,44,'view','2026-05-06 18:21:22'),(591,2,17,'view','2026-05-06 18:21:23'),(592,2,17,'view','2026-05-06 18:21:23'),(593,2,68,'view','2026-05-06 18:21:23'),(594,2,68,'view','2026-05-06 18:21:23'),(595,2,7,'view','2026-05-06 18:21:24'),(596,2,7,'view','2026-05-06 18:21:24'),(597,2,63,'view','2026-05-06 18:21:25'),(598,2,63,'view','2026-05-06 18:21:25'),(599,2,12,'view','2026-05-06 18:21:25'),(600,2,12,'view','2026-05-06 18:21:26'),(601,2,27,'view','2026-05-06 18:21:26'),(602,2,27,'view','2026-05-06 18:21:26'),(603,2,50,'view','2026-05-06 18:21:27'),(604,2,50,'view','2026-05-06 18:21:27'),(605,2,26,'view','2026-05-06 18:21:27'),(606,2,26,'view','2026-05-06 18:21:27'),(607,2,19,'view','2026-05-06 18:21:29'),(608,2,19,'view','2026-05-06 18:21:29'),(609,2,54,'view','2026-05-06 18:21:30'),(610,2,54,'view','2026-05-06 18:21:30'),(611,2,10,'view','2026-05-06 18:21:30'),(612,2,10,'view','2026-05-06 18:21:30'),(613,2,49,'view','2026-05-06 18:21:31'),(614,2,49,'view','2026-05-06 18:21:31'),(615,2,57,'view','2026-05-06 18:21:32'),(616,2,57,'view','2026-05-06 18:21:32'),(617,2,65,'view','2026-05-06 18:21:33'),(618,2,65,'view','2026-05-06 18:21:33'),(619,2,53,'view','2026-05-06 18:21:33'),(620,2,53,'view','2026-05-06 18:21:34'),(621,2,37,'view','2026-05-06 18:21:34'),(622,2,37,'view','2026-05-06 18:21:34'),(623,2,56,'view','2026-05-06 18:21:35'),(624,2,56,'view','2026-05-06 18:21:35'),(625,2,13,'view','2026-05-06 18:21:36'),(626,2,13,'view','2026-05-06 18:21:36'),(627,2,1,'view','2026-05-06 18:21:37'),(628,2,1,'view','2026-05-06 18:21:37'),(629,2,58,'view','2026-05-06 18:21:38'),(630,2,58,'view','2026-05-06 18:21:38'),(631,2,14,'view','2026-05-06 18:21:42'),(632,2,14,'view','2026-05-06 18:21:43'),(633,2,14,'view','2026-05-06 18:22:25'),(634,2,14,'view','2026-05-06 18:22:25'),(635,2,66,'view','2026-05-06 18:23:20'),(636,2,66,'view','2026-05-06 18:23:20'),(637,2,58,'view','2026-05-06 18:23:22'),(638,2,58,'view','2026-05-06 18:23:22'),(639,2,1,'view','2026-05-06 18:23:23'),(640,2,1,'view','2026-05-06 18:23:23'),(641,2,13,'view','2026-05-06 18:23:29'),(642,2,13,'view','2026-05-06 18:23:29'),(643,2,58,'view','2026-05-06 18:23:31'),(644,2,58,'view','2026-05-06 18:23:31'),(645,2,14,'view','2026-05-06 18:24:05'),(646,2,14,'view','2026-05-06 18:24:05'),(647,2,58,'view','2026-05-06 18:24:07'),(648,2,58,'view','2026-05-06 18:24:07'),(649,2,1,'view','2026-05-06 18:24:29'),(650,2,1,'view','2026-05-06 18:24:29'),(651,2,58,'view','2026-05-06 18:24:30'),(652,2,58,'view','2026-05-06 18:24:30'),(653,2,14,'view','2026-05-06 18:24:32'),(654,2,14,'view','2026-05-06 18:24:32'),(655,2,9,'view','2026-05-06 18:24:38'),(656,2,9,'view','2026-05-06 18:24:38'),(657,2,66,'view','2026-05-06 18:24:40'),(658,2,66,'view','2026-05-06 18:24:40'),(659,2,13,'view','2026-05-06 18:24:42'),(660,2,13,'view','2026-05-06 18:24:42'),(661,2,58,'view','2026-05-06 18:24:44'),(662,2,58,'view','2026-05-06 18:24:44'),(663,2,14,'view','2026-05-06 18:24:46'),(664,2,14,'view','2026-05-06 18:24:46'),(665,2,14,'view','2026-05-06 18:27:12'),(666,2,14,'view','2026-05-06 18:27:12'),(667,2,14,'view','2026-05-06 18:27:22'),(668,2,14,'view','2026-05-06 18:27:22'),(669,2,58,'view','2026-05-06 18:29:06'),(670,2,58,'view','2026-05-06 18:29:06'),(671,2,1,'view','2026-05-06 18:29:07'),(672,2,1,'view','2026-05-06 18:29:07'),(673,2,58,'view','2026-05-06 18:29:16'),(674,2,58,'view','2026-05-06 18:29:16'),(675,2,64,'view','2026-05-06 18:29:17'),(676,2,64,'view','2026-05-06 18:29:17'),(677,2,23,'view','2026-05-06 18:29:18'),(678,2,23,'view','2026-05-06 18:29:18'),(679,2,58,'view','2026-05-06 18:29:23'),(680,2,58,'view','2026-05-06 18:29:23'),(681,2,23,'view','2026-05-06 18:29:31'),(682,2,23,'view','2026-05-06 18:29:31'),(683,2,55,'view','2026-05-06 18:29:33'),(684,2,55,'view','2026-05-06 18:29:33'),(685,2,49,'view','2026-05-06 18:29:38'),(686,2,49,'view','2026-05-06 18:29:38'),(687,2,14,'view','2026-05-06 18:29:45'),(688,2,14,'view','2026-05-06 18:29:45'),(689,2,14,'like','2026-05-06 18:30:10'),(690,2,14,'fav','2026-05-06 18:30:10'),(691,2,53,'view','2026-05-06 18:30:11'),(692,2,53,'view','2026-05-06 18:30:11'),(693,2,14,'view','2026-05-12 20:19:30'),(694,2,14,'view','2026-05-12 20:19:31'),(695,2,55,'view','2026-05-12 20:19:36'),(696,2,55,'view','2026-05-12 20:19:36'),(697,2,9,'view','2026-05-12 20:19:42'),(698,2,9,'view','2026-05-12 20:19:42'),(699,2,9,'like','2026-05-12 20:19:45'),(700,2,9,'fav','2026-05-12 20:19:45'),(701,2,57,'view','2026-05-12 20:19:47'),(702,2,57,'view','2026-05-12 20:19:48'),(703,2,46,'view','2026-05-12 20:19:50'),(704,2,46,'view','2026-05-12 20:19:50'),(705,2,14,'view','2026-05-12 20:41:34'),(706,2,14,'view','2026-05-12 20:41:35'),(707,2,31,'view','2026-05-12 20:41:42'),(708,2,31,'view','2026-05-12 20:41:42'),(709,2,49,'view','2026-05-12 20:41:44'),(710,2,49,'view','2026-05-12 20:41:44'),(711,2,55,'view','2026-05-12 20:41:46'),(712,2,55,'view','2026-05-12 20:41:47'),(713,2,65,'view','2026-05-12 20:41:50'),(714,2,65,'view','2026-05-12 20:41:50'),(715,2,40,'view','2026-05-12 20:41:57'),(716,2,40,'view','2026-05-12 20:41:57'),(717,2,53,'view','2026-05-12 20:41:59'),(718,2,53,'view','2026-05-12 20:41:59'),(719,2,19,'view','2026-05-12 20:42:02'),(720,2,19,'view','2026-05-12 20:42:02'),(721,2,70,'view','2026-05-12 20:42:04'),(722,2,70,'view','2026-05-12 20:42:04'),(723,2,19,'view','2026-05-12 20:42:08'),(724,2,19,'view','2026-05-12 20:42:08'),(725,2,50,'view','2026-05-12 20:42:10'),(726,2,50,'view','2026-05-12 20:42:10'),(727,2,39,'view','2026-05-12 20:42:12'),(728,2,39,'view','2026-05-12 20:42:12'),(729,2,62,'view','2026-05-12 20:42:19'),(730,2,62,'view','2026-05-12 20:42:19'),(731,2,12,'view','2026-05-12 20:42:22'),(732,2,12,'view','2026-05-12 20:42:22'),(733,2,24,'view','2026-05-12 20:42:24'),(734,2,24,'view','2026-05-12 20:42:24'),(735,2,7,'view','2026-05-12 20:42:25'),(736,2,7,'view','2026-05-12 20:42:25'),(737,2,9,'view','2026-05-12 20:42:37'),(738,2,9,'view','2026-05-12 20:42:37'),(739,2,14,'view','2026-05-12 20:42:40'),(740,2,14,'view','2026-05-12 20:42:40'),(741,2,7,'view','2026-05-12 20:42:48'),(742,2,7,'view','2026-05-12 20:42:48'),(743,2,7,'like','2026-05-12 20:42:50'),(744,2,7,'like','2026-05-12 20:43:29'),(745,2,7,'view','2026-05-12 20:43:48'),(746,2,7,'view','2026-05-12 20:43:48'),(747,2,14,'view','2026-05-12 20:43:53'),(748,2,14,'view','2026-05-12 20:43:53'),(749,2,1,'view','2026-05-12 20:44:20'),(750,2,1,'view','2026-05-12 20:44:20'),(751,2,72,'view','2026-05-12 20:44:22'),(752,2,72,'view','2026-05-12 20:44:22'),(753,2,58,'view','2026-05-12 20:44:23'),(754,2,58,'view','2026-05-12 20:44:23'),(755,2,58,'like','2026-05-12 20:44:27'),(756,2,58,'fav','2026-05-12 20:44:28'),(757,2,61,'view','2026-05-12 20:44:33'),(758,2,61,'view','2026-05-12 20:44:33'),(759,2,61,'like','2026-05-12 20:44:36'),(760,2,61,'fav','2026-05-12 20:44:37'),(761,2,7,'view','2026-05-12 20:44:57'),(762,2,7,'view','2026-05-12 20:44:57'),(763,2,7,'like','2026-05-12 20:44:59'),(764,2,9,'view','2026-05-12 20:45:07'),(765,2,9,'view','2026-05-12 20:45:07'),(766,2,14,'view','2026-05-13 08:52:00'),(767,2,14,'view','2026-05-13 08:52:00'),(768,2,14,'view','2026-05-13 17:37:00'),(769,2,14,'view','2026-05-13 17:37:00'),(770,2,14,'view','2026-05-13 18:19:26'),(771,2,14,'view','2026-05-13 18:19:26'),(772,2,14,'like','2026-05-13 18:20:18'),(773,2,14,'fav','2026-05-13 18:20:18'),(774,2,51,'view','2026-05-13 18:20:21'),(775,2,51,'view','2026-05-13 18:20:21'),(776,2,7,'view','2026-05-13 18:20:28'),(777,2,7,'view','2026-05-13 18:20:29'),(778,2,58,'view','2026-05-13 18:20:36'),(779,2,58,'view','2026-05-13 18:20:36'),(780,2,7,'view','2026-05-13 18:24:00'),(781,2,7,'view','2026-05-13 18:24:00'),(782,2,14,'view','2026-05-13 18:24:03'),(783,2,14,'view','2026-05-13 18:24:03'),(784,2,14,'view','2026-05-13 18:33:51'),(785,2,14,'view','2026-05-13 18:33:51'),(786,2,14,'like','2026-05-13 18:35:24'),(787,2,14,'fav','2026-05-13 18:35:25'),(788,2,48,'view','2026-05-13 18:35:27'),(789,2,48,'view','2026-05-13 18:35:27'),(790,2,14,'view','2026-05-13 18:35:32'),(791,2,14,'view','2026-05-13 18:35:32'),(792,2,14,'like','2026-05-13 18:35:33'),(793,2,14,'fav','2026-05-13 18:35:33'),(794,2,14,'view','2026-05-20 08:55:44'),(795,2,14,'view','2026-05-20 08:55:44');
/*!40000 ALTER TABLE `story_user_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_token`
--

DROP TABLE IF EXISTS `sys_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_token` (
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  `expire_at` datetime DEFAULT NULL,
  PRIMARY KEY (`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_token`
--

LOCK TABLES `sys_token` WRITE;
/*!40000 ALTER TABLE `sys_token` DISABLE KEYS */;
INSERT INTO `sys_token` VALUES ('12a56d009a214edb8eeb58270562cc18',2,'2026-03-13 23:34:09',NULL);
/*!40000 ALTER TABLE `sys_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'student',
  `grade` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '明文密码(临时测试)',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `bio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `like_count` int NOT NULL DEFAULT '0' COMMENT '获赞数',
  `following_count` int NOT NULL DEFAULT '0' COMMENT '关注数',
  `follower_count` int NOT NULL DEFAULT '0' COMMENT '粉丝数',
  `ff_score` int NOT NULL DEFAULT '0' COMMENT '飞花令积分',
  `relay_score` int NOT NULL DEFAULT '0' COMMENT '词语接龙积分',
  `poem_match_score` int NOT NULL DEFAULT '0' COMMENT '诗词趣消消积分',
  `poem_match_pass_count` int NOT NULL DEFAULT '0' COMMENT '诗词趣消消通关次数',
  `poem_match_correct_count` int NOT NULL DEFAULT '0' COMMENT '诗词趣消消成功配对次数',
  `game_total_score` int NOT NULL DEFAULT '0' COMMENT '游戏总积分',
  `ff_correct_count` int NOT NULL DEFAULT '0' COMMENT '飞花令答对次数',
  `relay_correct_count` int NOT NULL DEFAULT '0' COMMENT '词语接龙答对次数',
  `game_updated_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '游戏积分更新时间',
  `maze_score` int NOT NULL DEFAULT '0' COMMENT '迷宫累计总分',
  `maze_pass_count` int NOT NULL DEFAULT '0' COMMENT '迷宫累计通关次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'demo','依依','student',NULL,'2026-02-03 03:42:24','123456','/files/avatar/cae0a148b22f4d2a992ccfa5c27f83c7.jpg','/uploads/14d705590052498f8dbad0d19fbf7418.jpg','没有',0,1,0,0,0,0,0,0,0,0,0,'2026-03-15 16:45:12',0,0),(2,'123456','小时','student',8,'2026-02-21 23:57:51','123456','/files/avatar/1e6480d3d201436c8cf71b2cf5e133ac.jpg','/files/cover/7e8dedd20f8141c594d2789741789a0c.gif','我是一名诗词爱好者，请大家关注我的作品',0,2,2,14,350,10,0,10,188,22,35,'2026-03-26 14:49:47',0,0),(3,'166666','雨天','student',NULL,'2026-03-12 22:46:58','123456','/files/avatar/87cfbb58da544ae895eafe46661456eb.gif','/files/cover/7bb4fe6545024f8e8ce2c1d6c1c6eb0f.jpg','',0,0,0,2,10,0,0,0,0,2,1,'2026-03-16 12:47:57',0,0),(4,'232323','物语','student',NULL,'2026-03-14 20:23:25','666666','/files/avatar/d3b24e4517c64a90ac1e2ebdbaf35830.jpg','/files/cover/2fa84a10c5674688ae94bc561478f6f6.jpg','不知道',0,0,2,0,0,0,0,0,0,0,0,'2026-03-15 16:45:12',0,0),(5,'616161','新心','student',NULL,'2026-03-14 21:24:05','111111','/files/avatar/83acdd1abe5744a595cfd90d2967110e.gif','/files/cover/114ffcfb717146f3a181d6075c817643.jpg','不知道说什么',0,0,0,1,0,0,0,0,0,4,0,'2026-03-16 12:42:26',0,0),(6,'060601','新用户','student',NULL,'2026-03-16 12:59:37','060601',NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,'2026-03-16 12:59:37',0,0),(7,'100001','夏夏','student',NULL,'2026-03-16 13:00:23','100001','/files/avatar/cbf502b7a0694e4a8e74caf65294d14e.jpg','/files/cover/99849a6ce674481e8a33a60f3640be7d.gif','11122',0,0,0,1,10,0,0,0,0,1,1,'2026-03-16 14:17:10',0,0),(8,'1222221','李圈圈','student',NULL,'2026-03-18 11:04:21','1222221','/files/avatar/cc44748a1f79421da4c45617e9795189.jpg','/files/cover/de9323327b9e4f1781b75595050798b9.jpg','',0,2,1,3,40,1,0,1,33,3,4,'2026-03-29 10:09:12',600,6);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_follow`
--

DROP TABLE IF EXISTS `sys_user_follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_follow` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '发起关注的人',
  `follow_user_id` bigint NOT NULL COMMENT '被关注的人',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_follow` (`user_id`,`follow_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户关注关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_follow`
--

LOCK TABLES `sys_user_follow` WRITE;
/*!40000 ALTER TABLE `sys_user_follow` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_user_follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_token`
--

DROP TABLE IF EXISTS `sys_user_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_token` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expired_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `token` (`token`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_token`
--

LOCK TABLES `sys_user_token` WRITE;
/*!40000 ALTER TABLE `sys_user_token` DISABLE KEYS */;
INSERT INTO `sys_user_token` VALUES (1,1,'7fff5bb03db7483a91d876e1567c878b','2026-02-22 03:19:28',NULL),(2,2,'db413a2e269b43d1bd8dde703971ffcd','2026-03-08 21:17:04',NULL),(3,2,'e38b173fafee465fafb347c99b540d83','2026-03-08 21:35:49',NULL),(4,2,'33765ec881784972ae369d5a8ae8478c','2026-03-10 21:28:27',NULL),(5,2,'33ae618c60cb4ccc80f3c2e985ac1a5a','2026-03-10 21:30:50',NULL),(6,2,'f30de888e3c3425db4693750c9b5d3d2','2026-03-10 21:33:49',NULL),(7,2,'1f6f3f8bfea5416bb92cde34ab6fcfea','2026-03-10 22:04:21',NULL),(8,2,'455622c2cbaf4b569d64bc4276e68cc8','2026-03-11 22:20:51',NULL),(9,2,'58d823eff9004ebb8fbfd86181639ffc','2026-03-12 22:41:24',NULL),(10,3,'a8c3bafbf2124603930c1a3b48faba1a','2026-03-12 22:47:09',NULL),(11,1,'10204114dc714af68d8e963f9e285ae8','2026-03-13 11:47:46',NULL),(12,2,'38f7f413037e482aa1b3d843d2e1e052','2026-03-13 12:17:24',NULL),(13,2,'72ac58034f98478a8ec9f8463ad6b2c6','2026-03-13 22:23:12',NULL),(14,2,'12a56d009a214edb8eeb58270562cc18','2026-03-13 23:05:58',NULL),(15,2,'e22c5dd085ad4d3f9c2a9c4f195ba0e6','2026-03-13 23:35:24',NULL),(16,1,'b42e9b59afae436b8da2bcac17a5e562','2026-03-14 00:47:50',NULL),(17,2,'fa76ded01adc46efbccf68cf1cc3fd65','2026-03-14 01:08:56',NULL),(18,2,'7a0d16c31e634246b671b86de699a6cc','2026-03-14 18:15:21',NULL),(19,2,'228e245095384b058e077bc16b48890a','2026-03-23 15:09:20',NULL),(20,2,'0458e55e3f984882bef607ef529ed2cf','2026-03-28 17:43:58',NULL),(21,2,'410af76535ea46a590e00636b2ce940f','2026-03-29 12:20:55',NULL),(22,2,'117349afd50e44bc916e75ed6a6282b3','2026-03-29 15:12:07',NULL),(23,2,'c0c9ecf0bffe4c64a671045e2218ef2d','2026-03-31 22:55:02',NULL),(24,2,'e4b1f8efdf794c24bd73b7be8e549a6c','2026-03-31 23:00:48',NULL),(25,2,'fd9596ff601a4ab9915990e3f421d1ec','2026-03-31 23:12:11',NULL),(26,2,'7a70471485c64cd197812354e6d97325','2026-04-01 11:04:47',NULL),(27,2,'520b871809324fd3ab3b504620222840','2026-04-06 21:06:37',NULL),(28,2,'876556f9f3c5443f821a8985c291e1cb','2026-04-07 11:11:10',NULL),(29,2,'a040efadc0954f8db15ff3b0aec39648','2026-04-08 11:22:49',NULL),(30,2,'9d08f91bf7d849d8bf5712fd179c0d96','2026-04-08 11:28:03',NULL),(31,2,'6073341ec90f4d359a3101edeb32e818','2026-04-08 11:40:11',NULL),(32,2,'d786166e37744fbb9524c497d01e9d23','2026-04-13 10:06:32',NULL),(33,2,'a3d79efa390040f5a7791d8eb9c8bc53','2026-04-27 17:05:30',NULL),(34,2,'dbe3c9b1291241738a03d8707258c31e','2026-04-27 20:18:01',NULL),(35,2,'8cb2231a6fc04fb4a6317bc1618bb424','2026-05-02 15:20:36',NULL),(36,2,'f16ebf652abd4b28a6a7b00e458ba442','2026-05-02 15:27:08',NULL),(37,2,'062dc71f4221428daaa4da8b8afae16c','2026-05-12 10:46:41',NULL),(38,2,'2bd8cc2360e347559a6c4804c5bfa580','2026-05-12 10:49:58',NULL),(39,2,'66bb95459be0414988869ebe873a66a9','2026-05-12 14:50:44',NULL),(40,2,'7195b6e9622345089b7baf4fdcacc4cd','2026-05-12 18:36:14',NULL);
/*!40000 ALTER TABLE `sys_user_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timeline_events`
--

DROP TABLE IF EXISTS `timeline_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timeline_events` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `poet_id` bigint NOT NULL COMMENT '诗人ID',
  `event_type` enum('出生','入仕','贬谪','游历','创作','交游','去世') DEFAULT NULL COMMENT '事件类型',
  `event_name` varchar(200) DEFAULT NULL COMMENT '事件名称',
  `event_description` text COMMENT '事件描述',
  `event_year` int DEFAULT NULL COMMENT '事件年份',
  `location_id` bigint DEFAULT NULL COMMENT '相关地点ID',
  `related_poem_id` bigint DEFAULT NULL COMMENT '相关诗词ID',
  `importance` int DEFAULT '3' COMMENT '重要性(1-5)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `location_id` (`location_id`),
  KEY `related_poem_id` (`related_poem_id`),
  KEY `idx_poet_year` (`poet_id`,`event_year`),
  CONSTRAINT `timeline_events_ibfk_1` FOREIGN KEY (`poet_id`) REFERENCES `poets` (`id`),
  CONSTRAINT `timeline_events_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  CONSTRAINT `timeline_events_ibfk_3` FOREIGN KEY (`related_poem_id`) REFERENCES `poems` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=220 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='时间轴事件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timeline_events`
--

LOCK TABLES `timeline_events` WRITE;
/*!40000 ALTER TABLE `timeline_events` DISABLE KEYS */;
INSERT INTO `timeline_events` VALUES (1,1,'出生','李白诞生','诗仙诞生于碎叶城',701,5,NULL,3,'2026-03-16 14:39:06'),(2,1,'入仕','供奉翰林','入京为官，供奉翰林',742,1,NULL,3,'2026-03-16 14:39:06'),(3,1,'游历','游历江南','游历江南各地，创作大量诗篇',756,5,NULL,3,'2026-03-16 14:39:06'),(4,2,'出生','杜甫诞生','诗圣诞生',712,2,NULL,3,'2026-03-16 14:39:06'),(5,2,'创作','春望创作','在长安创作春望',757,1,NULL,3,'2026-03-16 14:39:06'),(6,1,'出生','李白诞生','诗仙李白诞生于碎叶城（今吉尔吉斯斯坦）',701,NULL,NULL,5,'2026-03-18 17:36:38'),(7,1,'游历','出蜀漫游','青年时期离开四川，开始漫游天下',725,3,NULL,4,'2026-03-18 17:36:38'),(8,1,'入仕','供奉翰林','经贺知章推荐，入京供奉翰林',742,1,NULL,5,'2026-03-18 17:36:38'),(9,1,'贬谪','赐金放还','因得罪权贵，被赐金放还',744,1,NULL,4,'2026-03-18 17:36:38'),(10,1,'游历','游历江南','漫游江南各地，创作大量诗篇',745,5,NULL,4,'2026-03-18 17:36:38'),(11,1,'贬谪','流放夜郎','因永王李璘案被流放夜郎',757,NULL,NULL,4,'2026-03-18 17:36:38'),(12,1,'游历','遇赦东归','途中遇赦，东归至当涂',759,NULL,NULL,3,'2026-03-18 17:36:38'),(13,1,'去世','李白病逝','病逝于安徽当涂，终年62岁',762,NULL,NULL,5,'2026-03-18 17:36:38'),(14,2,'出生','杜甫诞生','诗圣杜甫诞生于河南巩县',712,2,NULL,5,'2026-03-18 17:36:38'),(15,2,'游历','漫游吴越','青年时期漫游吴越，开阔眼界',731,7,NULL,3,'2026-03-18 17:36:38'),(16,2,'入仕','献赋入仕','向玄宗献《三大礼赋》，获右卫率府胄曹参军',751,1,NULL,4,'2026-03-18 17:36:38'),(17,2,'贬谪','安史之乱','安史之乱爆发，携家逃难',755,NULL,NULL,5,'2026-03-18 17:36:38'),(18,2,'贬谪','陷贼脱险','被叛军俘获，后脱险投奔凤翔',756,1,NULL,4,'2026-03-18 17:36:38'),(19,2,'贬谪','贬华州','因直言进谏被贬华州司功参军',758,NULL,NULL,3,'2026-03-18 17:36:38'),(20,2,'游历','入蜀避乱','携家入蜀，在成都建草堂',759,3,NULL,5,'2026-03-18 17:36:38'),(21,2,'创作','创作高峰','在成都草堂创作240余首诗',760,3,NULL,5,'2026-03-18 17:36:38'),(22,2,'游历','漂泊夔州','移居夔州，创作《登高》等名篇',766,14,NULL,4,'2026-03-18 17:36:38'),(23,2,'去世','杜甫病逝','漂泊途中病逝于湘江舟中，终年59岁',770,NULL,NULL,5,'2026-03-18 17:36:38'),(24,3,'出生','白居易诞生','诗魔白居易诞生于河南新郑',772,2,NULL,5,'2026-03-18 17:36:38'),(25,3,'入仕','进士及第','考中进士，开始仕途',800,1,NULL,5,'2026-03-18 17:36:38'),(26,3,'入仕','任左拾遗','任左拾遗，敢于直谏',807,1,NULL,4,'2026-03-18 17:36:38'),(27,3,'贬谪','贬江州司马','因越职言事被贬江州司马',815,16,NULL,5,'2026-03-18 17:36:38'),(28,3,'创作','创作《琵琶行》','在江州创作《琵琶行》',816,16,NULL,5,'2026-03-18 17:36:38'),(29,3,'入仕','任杭州刺史','任杭州刺史，疏浚西湖筑白堤',822,5,NULL,5,'2026-03-18 17:36:38'),(30,3,'入仕','任苏州刺史','任苏州刺史',825,7,NULL,3,'2026-03-18 17:36:38'),(31,3,'入仕','定居洛阳','晚年定居洛阳，过着闲适生活',829,2,NULL,4,'2026-03-18 17:36:38'),(32,3,'去世','白居易去世','病逝于洛阳，终年75岁',846,2,NULL,5,'2026-03-18 17:36:38'),(33,17,'出生','苏轼诞生','东坡居士苏轼诞生于四川眉山',1037,13,NULL,5,'2026-03-18 17:36:38'),(34,17,'入仕','进士及第','与弟苏辙同科进士及第，名动京师',1057,6,NULL,5,'2026-03-18 17:36:38'),(35,17,'贬谪','乌台诗案','因诗获罪入狱，险遭不测',1079,NULL,NULL,5,'2026-03-18 17:36:38'),(36,17,'贬谪','贬黄州','被贬为黄州团练副使，创作《赤壁赋》',1080,17,NULL,5,'2026-03-18 17:36:38'),(37,17,'入仕','任杭州知州','再任杭州知州，疏浚西湖筑苏堤',1089,5,NULL,5,'2026-03-18 17:36:38'),(38,17,'贬谪','贬惠州','被贬惠州安置',1094,19,NULL,4,'2026-03-18 17:36:38'),(39,17,'贬谪','贬儋州','被贬海南儋州，极为偏远',1097,32,NULL,4,'2026-03-18 17:36:38'),(40,17,'去世','苏轼病逝','北归途中病逝于常州，终年65岁',1101,NULL,NULL,5,'2026-03-18 17:36:38'),(41,19,'出生','辛弃疾诞生','词中之龙辛弃疾诞生于山东济南',1140,24,NULL,5,'2026-03-18 17:36:38'),(42,19,'入仕','起义抗金','组织义军抗金，后归南宋',1161,NULL,NULL,5,'2026-03-18 17:36:38'),(43,19,'入仕','任建康通判','任建康府通判',1168,8,NULL,3,'2026-03-18 17:36:38'),(44,19,'贬谪','罢官闲居','被弹劾罢官，闲居上饶',1181,27,NULL,4,'2026-03-18 17:36:38'),(45,19,'入仕','任镇江知府','任镇江知府，准备北伐',1203,29,NULL,4,'2026-03-18 17:36:38'),(46,19,'去世','辛弃疾病逝','壮志未酬，病逝于铅山，终年68岁',1207,NULL,NULL,5,'2026-03-18 17:36:38'),(47,20,'出生','李清照诞生','千古第一才女李清照诞生于济南',1084,24,NULL,5,'2026-03-18 17:36:38'),(48,20,'创作','词名远播','早期词作名动京师',1100,NULL,NULL,4,'2026-03-18 17:36:38'),(49,20,'贬谪','南渡避乱','金兵南下，南渡避乱',1127,NULL,NULL,5,'2026-03-18 17:36:38'),(50,20,'贬谪','夫亡独居','丈夫赵明诚病逝，独居杭州',1129,5,NULL,4,'2026-03-18 17:36:38'),(51,20,'去世','李清照去世','晚年孤寂，约于1155年去世',1155,NULL,NULL,5,'2026-03-18 17:36:38'),(52,21,'出生','陆游诞生','爱国诗人陆游诞生于越州山阴',1125,28,NULL,5,'2026-03-18 17:36:38'),(53,21,'入仕','进士及第','考中进士，但因秦桧阻挠未得官',1153,5,NULL,4,'2026-03-18 17:36:38'),(54,21,'入仕','入蜀任职','入蜀任职，与范成大交好',1172,3,NULL,4,'2026-03-18 17:36:38'),(55,21,'创作','创作高峰','在蜀期间创作大量爱国诗篇',1175,3,NULL,5,'2026-03-18 17:36:38'),(56,21,'去世','陆游病逝','临终作《示儿》，终年86岁',1210,28,NULL,5,'2026-03-18 17:36:38'),(57,4,'出生','王维诞生','诗佛王维诞生于太原祁县',701,5,NULL,5,'2026-03-18 17:36:38'),(58,4,'入仕','进士及第','考中进士，任太乐丞',721,1,NULL,4,'2026-03-18 17:36:38'),(59,4,'贬谪','贬济州','因伶人舞黄狮子事被贬济州',723,NULL,NULL,3,'2026-03-18 17:36:38'),(60,4,'入仕','回长安任职','回长安任职，半官半隐',739,1,NULL,4,'2026-03-18 17:36:38'),(61,4,'贬谪','安史之乱','安史之乱中被俘，被迫任职',756,1,NULL,4,'2026-03-18 17:36:38'),(62,4,'去世','王维去世','病逝于长安，终年61岁',761,1,NULL,5,'2026-03-18 17:36:38'),(63,5,'出生','孟浩然诞生','山水田园诗人孟浩然诞生于襄阳',689,18,NULL,5,'2026-03-18 17:36:38'),(64,5,'入仕','求仕未果','入长安求仕，不第而归',728,1,NULL,4,'2026-03-18 17:36:38'),(65,5,'交游','与李白交游','与李白相交，李白作诗送别',730,NULL,NULL,4,'2026-03-18 17:36:38'),(66,5,'去世','孟浩然去世','因背疽发作去世，终年52岁',740,18,NULL,5,'2026-03-18 17:36:38'),(67,35,'出生','屈原诞生','爱国诗人屈原诞生于楚国秭归',-340,NULL,NULL,5,'2026-03-18 17:36:38'),(68,35,'入仕','任左徒','任楚怀王左徒，参与国政',-319,17,NULL,5,'2026-03-18 17:36:38'),(69,35,'贬谪','被谗放逐','被谗言所害，遭放逐',-304,NULL,NULL,5,'2026-03-18 17:36:38'),(70,35,'创作','创作《离骚》','创作不朽名篇《离骚》',-300,NULL,NULL,5,'2026-03-18 17:36:38'),(71,35,'去世','投江殉国','投汨罗江殉国，端午节由此而来',-278,NULL,NULL,5,'2026-03-18 17:36:38'),(72,36,'出生','陶渊明诞生','田园诗派创始人陶渊明诞生',365,16,NULL,5,'2026-03-18 17:36:38'),(73,36,'入仕','任江州祭酒','任江州祭酒，不久辞官',393,NULL,NULL,3,'2026-03-18 17:36:38'),(74,36,'入仕','任彭泽令','任彭泽令，八十日后辞官',405,16,NULL,5,'2026-03-18 17:36:38'),(75,36,'创作','创作《归去来兮辞》','辞官后创作《归去来兮辞》',405,NULL,NULL,5,'2026-03-18 17:36:38'),(76,36,'创作','创作《桃花源记》','创作《桃花源记》，描绘理想社会',421,NULL,NULL,5,'2026-03-18 17:36:38'),(77,36,'去世','陶渊明去世','病逝于家中，终年63岁',427,16,NULL,5,'2026-03-18 17:36:38'),(78,10,'出生','孟浩然诞生','山水田园诗人孟浩然诞生于襄阳',689,20,NULL,5,'2026-03-24 21:31:51'),(79,10,'游历','隐居鹿门山','隐居鹿门山，专心读书创作',710,20,NULL,4,'2026-03-24 21:31:51'),(80,10,'游历','游历吴越','漫游吴越各地，开阔眼界',712,4,NULL,4,'2026-03-24 21:31:51'),(81,10,'入仕','求仕长安','入长安求仕，不第而归',728,1,NULL,4,'2026-03-24 21:31:51'),(82,10,'交游','结识王维','与王维相交，互有赠诗',730,NULL,NULL,4,'2026-03-24 21:31:51'),(83,10,'去世','孟浩然去世','因背疽发作去世，终年52岁',740,20,NULL,5,'2026-03-24 21:31:51'),(84,11,'出生','李商隐诞生','晚唐诗人李商隐诞生于河南荥阳',813,2,NULL,5,'2026-03-24 21:31:51'),(85,11,'入仕','进士及第','考中进士，开始仕途',837,1,NULL,4,'2026-03-24 21:31:51'),(86,11,'贬谪','陷入牛李党争','因牛李党争，仕途坎坷',840,NULL,NULL,4,'2026-03-24 21:31:51'),(87,11,'入仕','入桂管幕府','入桂管观察使幕府',847,23,NULL,3,'2026-03-24 21:31:51'),(88,11,'创作','创作《无题》','创作大量《无题》诗，表达爱情与身世之感',850,NULL,NULL,5,'2026-03-24 21:31:51'),(89,11,'去世','李商隐去世','病逝于郑州，终年46岁',858,NULL,NULL,5,'2026-03-24 21:31:51'),(90,12,'出生','杜牧诞生','晚唐诗人杜牧诞生于长安',803,1,NULL,5,'2026-03-24 21:31:51'),(91,12,'入仕','进士及第','考中进士，名动京师',828,1,NULL,4,'2026-03-24 21:31:51'),(92,12,'创作','创作《阿房宫赋》','创作名篇《阿房宫赋》',825,NULL,NULL,5,'2026-03-24 21:31:51'),(93,12,'入仕','任黄州刺史','任黄州刺史，创作《赤壁》',842,108,NULL,4,'2026-03-24 21:31:51'),(94,12,'入仕','任池州刺史','任池州刺史，创作《清明》',845,78,NULL,4,'2026-03-24 21:31:51'),(95,12,'去世','杜牧去世','病逝于长安，终年50岁',852,1,NULL,5,'2026-03-24 21:31:51'),(96,13,'出生','王昌龄诞生','边塞诗人王昌龄诞生于太原',698,10,NULL,5,'2026-03-24 21:31:51'),(97,13,'入仕','进士及第','考中进士，开始仕途',727,1,NULL,4,'2026-03-24 21:31:51'),(98,13,'贬谪','贬龙标尉','被贬为龙标尉，有\"一片冰心在玉壶\"名句',748,242,NULL,4,'2026-03-24 21:31:51'),(99,13,'创作','创作边塞诗','创作大量边塞诗，被称为\"七绝圣手\"',730,NULL,NULL,5,'2026-03-24 21:31:51'),(100,13,'去世','王昌龄遇害','在安史之乱中被刺史闾丘晓所杀',757,NULL,NULL,5,'2026-03-24 21:31:51'),(101,14,'出生','王之涣诞生','边塞诗人王之涣诞生于太原',688,10,NULL,5,'2026-03-24 21:31:51'),(102,14,'创作','创作《登鹳雀楼》','创作千古名篇《登鹳雀楼》',720,NULL,NULL,5,'2026-03-24 21:31:51'),(103,14,'创作','创作《凉州词》','创作边塞名篇《凉州词》',725,NULL,NULL,5,'2026-03-24 21:31:51'),(104,14,'去世','王之涣去世','病逝于家中，终年55岁',742,NULL,NULL,5,'2026-03-24 21:31:51'),(105,15,'出生','刘禹锡诞生','文学家刘禹锡诞生于洛阳',772,2,NULL,5,'2026-03-24 21:31:51'),(106,15,'入仕','进士及第','考中进士，与柳宗元同榜',793,1,NULL,4,'2026-03-24 21:31:51'),(107,15,'贬谪','参与永贞革新','参与永贞革新，失败后被贬',805,NULL,NULL,5,'2026-03-24 21:31:51'),(108,15,'贬谪','贬朗州司马','被贬为朗州司马，创作《陋室铭》',805,245,NULL,5,'2026-03-24 21:31:51'),(109,15,'创作','创作《竹枝词》','创作大量《竹枝词》，开创民歌新境界',815,NULL,NULL,5,'2026-03-24 21:31:51'),(110,15,'入仕','回京任职','被召回京城，任主客郎中',828,1,NULL,4,'2026-03-24 21:31:51'),(111,15,'去世','刘禹锡去世','病逝于洛阳，终年70岁',842,2,NULL,5,'2026-03-24 21:31:51'),(112,16,'出生','柳宗元诞生','文学家柳宗元诞生于运城',773,130,NULL,5,'2026-03-24 21:31:51'),(113,16,'入仕','进士及第','考中进士，与刘禹锡同榜',793,1,NULL,4,'2026-03-24 21:31:51'),(114,16,'贬谪','参与永贞革新','参与永贞革新，失败后被贬',805,NULL,NULL,5,'2026-03-24 21:31:51'),(115,16,'贬谪','贬永州司马','被贬为永州司马，创作《永州八记》',805,243,NULL,5,'2026-03-24 21:31:51'),(116,16,'贬谪','贬柳州刺史','被贬为柳州刺史',815,244,NULL,4,'2026-03-24 21:31:51'),(117,16,'创作','创作《江雪》','创作千古名篇《江雪》',805,NULL,NULL,5,'2026-03-24 21:31:51'),(118,16,'去世','柳宗元去世','病逝于柳州任上，终年47岁',819,244,NULL,5,'2026-03-24 21:31:51'),(119,17,'出生','岑参诞生','边塞诗人岑参诞生于南阳',715,111,NULL,5,'2026-03-24 21:31:51'),(120,17,'入仕','进士及第','考中进士，开始仕途',744,1,NULL,4,'2026-03-24 21:31:51'),(121,17,'入仕','赴安西任职','赴安西节度使幕府任职',749,24,NULL,4,'2026-03-24 21:31:51'),(122,17,'创作','创作边塞诗','在边塞创作大量边塞诗，与高适并称\"高岑\"',750,NULL,NULL,5,'2026-03-24 21:31:51'),(123,17,'入仕','任嘉州刺史','任嘉州刺史',766,262,NULL,3,'2026-03-24 21:31:51'),(124,17,'去世','岑参去世','病逝于成都，终年56岁',770,3,NULL,5,'2026-03-24 21:31:51'),(125,25,'出生','李清照诞生','千古第一才女李清照诞生于济南',1084,27,NULL,5,'2026-03-24 21:31:51'),(126,25,'创作','词名远播','早期词作名动京师',1100,NULL,NULL,4,'2026-03-24 21:31:51'),(127,25,'贬谪','南渡避乱','金兵南下，南渡避乱',1127,NULL,NULL,5,'2026-03-24 21:31:51'),(128,25,'贬谪','夫亡独居','丈夫赵明诚病逝，独居杭州',1129,5,NULL,4,'2026-03-24 21:31:51'),(129,25,'创作','创作《声声慢》','创作名篇《声声慢》',1130,NULL,NULL,5,'2026-03-24 21:31:51'),(130,25,'去世','李清照去世','晚年孤寂，约于1155年去世',1155,NULL,NULL,5,'2026-03-24 21:31:51'),(131,26,'出生','陆游诞生','爱国诗人陆游诞生于越州山阴',1125,253,NULL,5,'2026-03-24 21:31:51'),(132,26,'入仕','进士及第','考中进士，但因秦桧阻挠未得官',1153,5,NULL,4,'2026-03-24 21:31:51'),(133,26,'入仕','入蜀任职','入蜀任职，与范成大交好',1172,3,NULL,4,'2026-03-24 21:31:51'),(134,26,'创作','创作高峰','在蜀期间创作大量爱国诗篇',1175,3,NULL,5,'2026-03-24 21:31:51'),(135,26,'创作','创作《钗头凤》','创作爱情名篇《钗头凤》',1155,NULL,NULL,5,'2026-03-24 21:31:51'),(136,26,'去世','陆游病逝','临终作《示儿》，终年86岁',1210,253,NULL,5,'2026-03-24 21:31:51'),(137,24,'出生','辛弃疾诞生','词中之龙辛弃疾诞生于山东济南',1140,27,NULL,5,'2026-03-24 21:31:51'),(138,24,'入仕','起义抗金','组织义军抗金，后归南宋',1161,NULL,NULL,5,'2026-03-24 21:31:51'),(139,24,'入仕','任建康通判','任建康府通判',1168,14,NULL,3,'2026-03-24 21:31:51'),(140,24,'贬谪','罢官闲居','被弹劾罢官，闲居上饶',1181,38,NULL,4,'2026-03-24 21:31:51'),(141,24,'创作','创作《破阵子》','创作名篇《破阵子·为陈同甫赋壮词以寄之》',1188,NULL,NULL,5,'2026-03-24 21:31:51'),(142,24,'入仕','任镇江知府','任镇江知府，准备北伐',1203,42,NULL,4,'2026-03-24 21:31:51'),(143,24,'去世','辛弃疾病逝','壮志未酬，病逝于铅山，终年68岁',1207,254,NULL,5,'2026-03-24 21:31:51'),(144,41,'出生','王勃诞生','初唐四杰之一王勃诞生于河津',650,257,NULL,5,'2026-03-24 21:31:51'),(145,41,'入仕','任沛王府修撰','任沛王府修撰',666,1,NULL,4,'2026-03-24 21:31:51'),(146,41,'贬谪','被逐出王府','因作《檄英王鸡》被逐出王府',668,NULL,NULL,4,'2026-03-24 21:31:51'),(147,41,'游历','游历蜀中','游历蜀中各地',669,3,NULL,3,'2026-03-24 21:31:51'),(148,41,'创作','创作《滕王阁序》','途经南昌，创作千古名篇《滕王阁序》',675,30,NULL,5,'2026-03-24 21:31:51'),(149,41,'去世','王勃溺水身亡','前往交趾探父，渡海溺水身亡，年仅27岁',676,NULL,NULL,5,'2026-03-24 21:31:51'),(150,38,'出生','曹操诞生','政治家、文学家曹操诞生于亳州',155,35,NULL,5,'2026-03-24 21:31:51'),(151,38,'入仕','任洛阳北部尉','任洛阳北部尉',174,2,NULL,3,'2026-03-24 21:31:51'),(152,38,'入仕','迎献帝都许','迎献帝都许昌，挟天子以令诸侯',196,258,NULL,5,'2026-03-24 21:31:51'),(153,38,'创作','创作《短歌行》','创作名篇《短歌行》',208,NULL,NULL,5,'2026-03-24 21:31:51'),(154,38,'创作','创作《观沧海》','创作名篇《观沧海》',207,NULL,NULL,5,'2026-03-24 21:31:51'),(155,38,'去世','曹操病逝','病逝于洛阳，终年66岁',220,2,NULL,5,'2026-03-24 21:31:51'),(156,165,'出生','高适诞生','边塞诗人高适诞生于河北景县',704,NULL,NULL,5,'2026-03-24 21:31:51'),(157,165,'游历','漫游梁宋','漫游梁宋各地，结识李白、杜甫',744,NULL,NULL,4,'2026-03-24 21:31:51'),(158,165,'入仕','进士及第','考中进士，开始仕途',749,1,NULL,4,'2026-03-24 21:31:51'),(159,165,'入仕','任左散骑常侍','任左散骑常侍，封渤海县侯',760,1,NULL,4,'2026-03-24 21:31:51'),(160,165,'创作','创作《燕歌行》','创作边塞名篇《燕歌行》',745,NULL,NULL,5,'2026-03-24 21:31:51'),(161,165,'去世','高适去世','病逝于长安，终年62岁',765,1,NULL,5,'2026-03-24 21:31:51'),(162,178,'出生','韩愈诞生','文学家韩愈诞生于河南孟州',768,2,NULL,5,'2026-03-24 21:31:51'),(163,178,'入仕','进士及第','考中进士，开始仕途',792,1,NULL,4,'2026-03-24 21:31:51'),(164,178,'贬谪','贬阳山令','因上书论事被贬阳山令',803,248,NULL,4,'2026-03-24 21:31:51'),(165,178,'贬谪','贬潮州刺史','因谏迎佛骨被贬潮州刺史',819,249,NULL,5,'2026-03-24 21:31:51'),(166,178,'创作','倡导古文运动','倡导古文运动，被尊为\"唐宋八大家之首\"',800,NULL,NULL,5,'2026-03-24 21:31:51'),(167,178,'去世','韩愈去世','病逝于长安，终年57岁',824,1,NULL,5,'2026-03-24 21:31:51'),(168,163,'出生','贺知章诞生','唐代诗人、书法家贺知章诞生',659,NULL,NULL,5,'2026-03-24 21:31:51'),(169,163,'入仕','进士及第','考中进士，开始仕途',695,1,NULL,4,'2026-03-24 21:31:51'),(170,163,'入仕','任秘书监','任秘书监，与李白为好友',725,1,NULL,4,'2026-03-24 21:31:51'),(171,163,'交游','推荐李白','推荐李白入京，称其为\"谪仙人\"',742,1,NULL,5,'2026-03-24 21:31:51'),(172,163,'创作','创作《回乡偶书》','创作名篇《回乡偶书》',744,NULL,NULL,5,'2026-03-24 21:31:51'),(173,163,'去世','贺知章去世','病逝于家乡，终年86岁',744,NULL,NULL,5,'2026-03-24 21:31:51'),(174,164,'出生','张若虚诞生','唐代诗人张若虚诞生于扬州',660,4,NULL,5,'2026-03-24 21:31:51'),(175,164,'创作','创作《春江花月夜》','创作《春江花月夜》，被誉为\"孤篇盖全唐\"',710,NULL,NULL,5,'2026-03-24 21:31:51'),(176,164,'去世','张若虚去世','约于720年去世',720,NULL,NULL,5,'2026-03-24 21:31:51'),(177,179,'出生','元稹诞生','诗人元稹诞生于洛阳',779,2,NULL,5,'2026-03-24 21:31:51'),(178,179,'入仕','进士及第','考中进士，与白居易并称\"元白\"',793,1,NULL,4,'2026-03-24 21:31:51'),(179,179,'交游','与白居易交好','与白居易交好，共同倡导新乐府运动',800,NULL,NULL,5,'2026-03-24 21:31:51'),(180,179,'创作','创作《莺莺传》','创作传奇小说《莺莺传》',804,NULL,NULL,5,'2026-03-24 21:31:51'),(181,179,'去世','元稹去世','病逝于武昌军节度使任上，终年53岁',831,NULL,NULL,5,'2026-03-24 21:31:51'),(182,169,'出生','欧阳修诞生','文学家欧阳修诞生于江西吉安',1007,265,NULL,5,'2026-03-24 21:31:51'),(183,169,'入仕','进士及第','考中进士，开始仕途',1030,8,NULL,4,'2026-03-24 21:31:51'),(184,169,'贬谪','贬夷陵令','因支持范仲淹被贬夷陵令',1037,250,NULL,4,'2026-03-24 21:31:51'),(185,169,'创作','创作《醉翁亭记》','创作名篇《醉翁亭记》',1046,251,NULL,5,'2026-03-24 21:31:51'),(186,169,'入仕','任参知政事','任参知政事，参与庆历新政',1043,8,NULL,4,'2026-03-24 21:31:51'),(187,169,'去世','欧阳修去世','病逝于家中，终年66岁',1072,NULL,NULL,5,'2026-03-24 21:31:51'),(188,170,'出生','王安石诞生','政治家、文学家王安石诞生于江西抚州',1021,263,NULL,5,'2026-03-24 21:31:51'),(189,170,'入仕','进士及第','考中进士，开始仕途',1042,8,NULL,4,'2026-03-24 21:31:51'),(190,170,'入仕','任参知政事','任参知政事，主持熙宁变法',1069,8,NULL,5,'2026-03-24 21:31:51'),(191,170,'贬谪','罢相闲居','变法失败后罢相，闲居金陵',1076,14,NULL,4,'2026-03-24 21:31:51'),(192,170,'创作','创作《泊船瓜洲》','创作名篇《泊船瓜洲》',1070,NULL,NULL,5,'2026-03-24 21:31:51'),(193,170,'去世','王安石去世','病逝于金陵，终年66岁',1086,14,NULL,5,'2026-03-24 21:31:51'),(194,171,'出生','范仲淹诞生','政治家、文学家范仲淹诞生于江苏苏州',989,NULL,NULL,5,'2026-03-24 21:31:51'),(195,171,'入仕','进士及第','考中进士，开始仕途',1015,8,NULL,4,'2026-03-24 21:31:51'),(196,171,'入仕','主持庆历新政','主持庆历新政，推行改革',1043,8,NULL,5,'2026-03-24 21:31:51'),(197,171,'贬谪','贬饶州知州','因直言进谏被贬饶州知州',1034,NULL,NULL,4,'2026-03-24 21:31:51'),(198,171,'创作','创作《岳阳楼记》','创作名篇《岳阳楼记》，有\"先天下之忧而忧\"名句',1046,84,NULL,5,'2026-03-24 21:31:51'),(199,171,'去世','范仲淹去世','病逝于徐州，终年64岁',1052,NULL,NULL,5,'2026-03-24 21:31:51'),(200,172,'出生','柳永诞生','词人柳永诞生于福建崇安',987,NULL,NULL,5,'2026-03-24 21:31:51'),(201,172,'入仕','进士及第','考中进士，开始仕途',1034,8,NULL,4,'2026-03-24 21:31:51'),(202,172,'创作','创作《雨霖铃》','创作名篇《雨霖铃》',1010,NULL,NULL,5,'2026-03-24 21:31:51'),(203,172,'创作','开创慢词','开创慢词，拓展词的表现力',1020,NULL,NULL,5,'2026-03-24 21:31:51'),(204,172,'去世','柳永去世','病逝于润州，终年67岁',1053,NULL,NULL,5,'2026-03-24 21:31:51'),(205,106,'出生','晏殊诞生','宰相词人晏殊诞生于江西临川',991,263,NULL,5,'2026-03-24 21:31:51'),(206,106,'入仕','神童入仕','以神童身份入仕，赐进士出身',1005,8,NULL,5,'2026-03-24 21:31:51'),(207,106,'入仕','任宰相','任宰相，为北宋名臣',1042,8,NULL,4,'2026-03-24 21:31:51'),(208,106,'创作','创作《浣溪沙》','创作名篇《浣溪沙》，有\"无可奈何花落去\"名句',1020,NULL,NULL,5,'2026-03-24 21:31:51'),(209,106,'去世','晏殊去世','病逝于家中，终年65岁',1055,NULL,NULL,5,'2026-03-24 21:31:51'),(210,113,'出生','姜夔诞生','词人、音乐家姜夔诞生于江西鄱阳',1155,264,NULL,5,'2026-03-24 21:31:51'),(211,113,'游历','漫游江南','漫游江南各地，以词名世',1180,NULL,NULL,4,'2026-03-24 21:31:51'),(212,113,'创作','创作《扬州慢》','创作名篇《扬州慢》',1176,4,NULL,5,'2026-03-24 21:31:51'),(213,113,'去世','姜夔去世','病逝于杭州，终年67岁',1221,5,NULL,5,'2026-03-24 21:31:51'),(214,115,'出生','文天祥诞生','民族英雄文天祥诞生于江西吉安',1236,265,NULL,5,'2026-03-24 21:31:51'),(215,115,'入仕','状元及第','考中状元，开始仕途',1256,8,NULL,5,'2026-03-24 21:31:51'),(216,115,'入仕','抗元救国','组织义军抗元，保家卫国',1275,NULL,NULL,5,'2026-03-24 21:31:51'),(217,115,'贬谪','被俘囚禁','抗元失败被俘，囚禁于大都',1278,9,NULL,5,'2026-03-24 21:31:51'),(218,115,'创作','创作《过零丁洋》','创作名篇《过零丁洋》，有\"人生自古谁无死\"名句',1279,NULL,NULL,5,'2026-03-24 21:31:51'),(219,115,'去世','文天祥就义','就义于大都，终年47岁',1283,9,NULL,5,'2026-03-24 21:31:51');
/*!40000 ALTER TABLE `timeline_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topic` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,'山水意境','清远空灵、意象丰富','🏞️','2026-02-04 22:54:19'),(2,'友情名句','送别、相知、共鸣','🧑‍🤝‍🧑','2026-02-04 22:54:19'),(3,'思乡明月','乡愁与月色常相伴','🌙','2026-02-04 22:54:19'),(4,'边塞雄风','豪迈壮阔、家国情怀','⚔️','2026-02-04 22:54:19'),(5,'节令四时','春夏秋冬与物候','🍃','2026-02-04 22:54:19'),(6,'田园闲适','归隐生活与农桑','🌾','2026-02-04 22:54:19');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic_poem`
--

DROP TABLE IF EXISTS `topic_poem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topic_poem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `topic_id` bigint NOT NULL,
  `poem_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_tp_topic` (`topic_id`) USING BTREE,
  KEY `fk_tp_poem` (`poem_id`) USING BTREE,
  CONSTRAINT `fk_tp_poem` FOREIGN KEY (`poem_id`) REFERENCES `poem` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_tp_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic_poem`
--

LOCK TABLES `topic_poem` WRITE;
/*!40000 ALTER TABLE `topic_poem` DISABLE KEYS */;
/*!40000 ALTER TABLE `topic_poem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_favorite`
--

DROP TABLE IF EXISTS `user_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `target_id` bigint NOT NULL COMMENT '被收藏对象ID，例如诗词ID/作品ID',
  `target_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'poem' COMMENT 'poem/post',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_target` (`user_id`,`target_id`,`target_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_favorite`
--

LOCK TABLES `user_favorite` WRITE;
/*!40000 ALTER TABLE `user_favorite` DISABLE KEYS */;
INSERT INTO `user_favorite` VALUES (1,2,3,'work','2026-03-13 16:31:34'),(2,2,21,'work','2026-03-14 00:05:59'),(3,2,31,'creation_work','2026-05-12 16:00:08');
/*!40000 ALTER TABLE `user_favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_feedback`
--

DROP TABLE IF EXISTS `user_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contact` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` tinyint DEFAULT '0' COMMENT '0待处理 1已处理',
  `reply_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户反馈表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_feedback`
--

LOCK TABLES `user_feedback` WRITE;
/*!40000 ALTER TABLE `user_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_follow`
--

DROP TABLE IF EXISTS `user_follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_follow` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '发起关注的人',
  `follow_user_id` bigint NOT NULL COMMENT '被关注的人',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_follow` (`user_id`,`follow_user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='关注关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_follow`
--

LOCK TABLES `user_follow` WRITE;
/*!40000 ALTER TABLE `user_follow` DISABLE KEYS */;
INSERT INTO `user_follow` VALUES (1,1,2,'2026-03-14 01:08:14'),(2,2,1,'2026-03-14 01:09:50');
/*!40000 ALTER TABLE `user_follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_history`
--

DROP TABLE IF EXISTS `user_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `target_id` bigint NOT NULL,
  `target_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'poem',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `viewed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户浏览历史';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_history`
--

LOCK TABLES `user_history` WRITE;
/*!40000 ALTER TABLE `user_history` DISABLE KEYS */;
INSERT INTO `user_history` VALUES (1,2,24,'creation_work','未命名作品',NULL,'2026-04-09 09:28:44'),(2,2,22,'creation_work','未命名作品',NULL,'2026-04-09 09:28:50'),(3,2,23,'creation_work','111',NULL,'2026-04-09 09:29:05'),(4,2,29,'creation_work','111','/uploads/images/2026/05/12/e8de52b1-35c0-4398-b2a8-54612725ebc5.png','2026-05-12 10:48:38'),(5,2,29,'creation_work','111','/uploads/images/2026/05/12/e8de52b1-35c0-4398-b2a8-54612725ebc5.png','2026-05-12 10:48:53'),(6,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 15:59:25'),(7,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 15:59:31'),(8,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 15:59:57'),(9,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 16:05:54'),(10,2,2,'creation_work','水调歌头·明月几时有',NULL,'2026-05-12 16:06:19'),(11,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 16:06:24'),(12,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 16:09:12'),(13,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 16:18:09'),(14,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 18:31:00'),(15,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 18:33:59'),(16,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 18:41:52'),(17,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 18:42:17'),(18,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 20:18:20'),(19,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 20:49:33'),(20,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 20:53:03'),(21,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-12 20:56:00'),(22,2,31,'creation_work','111','/uploads/images/2026/05/12/ce05c2cd-df16-4d44-a3a5-558bbd84a255.jpg','2026-05-13 08:43:38'),(23,2,32,'creation_work','无题','/uploads/images/2026/05/13/ab9017db-e45e-4378-8ccb-c7d2b66fc9f6.jpg','2026-05-13 08:59:43'),(24,2,33,'creation_work','满江红','/uploads/images/2026/05/13/bc8109e0-fd89-4259-a06a-bac89774b70b.jpg','2026-05-13 09:06:40'),(25,2,34,'creation_work','满江红','/uploads/images/2026/05/13/fa1a992a-e25c-49d8-8103-fb8fac60ca1a.jpg','2026-05-13 09:25:49');
/*!40000 ALTER TABLE `user_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录账号',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '昵称',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像地址',
  `bg_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '个人主页背景图',
  `bio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '个人简介',
  `gender` tinyint DEFAULT '0' COMMENT '0未知 1男 2女',
  `role_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '学生' COMMENT '身份标签',
  `theme_color` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'light' COMMENT '主题颜色',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `status` tinyint DEFAULT '1' COMMENT '1正常 0禁用',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_info`
--

LOCK TABLES `user_info` WRITE;
/*!40000 ALTER TABLE `user_info` DISABLE KEYS */;
INSERT INTO `user_info` VALUES (1,'test','123456','1111','/uploads/afe4ad430aba40e4a6838964e6936998.jpg','','热爱古诗词学习与创作1',0,'学生','light','13800000000','test@qq.com',1,'2026-03-12 14:13:17','2026-03-13 11:47:30');
/*!40000 ALTER TABLE `user_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_like`
--

DROP TABLE IF EXISTS `user_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_like` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `target_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `target_id` bigint NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_like` (`user_id`,`target_type`,`target_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_target` (`target_type`,`target_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_like`
--

LOCK TABLES `user_like` WRITE;
/*!40000 ALTER TABLE `user_like` DISABLE KEYS */;
INSERT INTO `user_like` VALUES (1,2,'work',5,'2026-03-08 21:39:47'),(4,2,'work',1,'2026-03-11 22:21:02'),(7,2,'work',3,'2026-03-13 16:31:33'),(8,2,'work',19,'2026-03-13 16:36:01'),(10,2,'work',21,'2026-03-14 00:05:49'),(11,2,'work',23,'2026-03-14 00:07:10'),(12,1,'work',21,'2026-03-14 01:08:26'),(13,2,'work',29,'2026-05-12 10:49:12'),(14,2,'work',22,'2026-05-12 10:49:14'),(15,2,'work',31,'2026-05-12 16:09:19'),(16,2,'work',32,'2026-05-13 08:59:51'),(17,2,'work',33,'2026-05-13 09:06:46');
/*!40000 ALTER TABLE `user_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_like_record`
--

DROP TABLE IF EXISTS `user_like_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_like_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `owner_user_id` bigint NOT NULL COMMENT '被点赞作品所属用户',
  `from_user_id` bigint NOT NULL COMMENT '点赞人',
  `target_id` bigint NOT NULL COMMENT '作品或帖子ID',
  `target_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'post',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户获赞记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_like_record`
--

LOCK TABLES `user_like_record` WRITE;
/*!40000 ALTER TABLE `user_like_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_like_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_note`
--

DROP TABLE IF EXISTS `user_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_note` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `related_id` bigint DEFAULT NULL COMMENT '关联诗词或文章ID',
  `related_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'poem/post',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户笔记表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_note`
--

LOCK TABLES `user_note` WRITE;
/*!40000 ALTER TABLE `user_note` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_note` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-15 23:21:26
