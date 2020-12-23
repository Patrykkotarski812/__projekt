CREATE TABLE `adres` (
  `id_adresu` int NOT NULL AUTO_INCREMENT,
  `miejscowosc` varchar(45) DEFAULT NULL,
  `nr_domu` varchar(45) DEFAULT NULL,
  `nr_mieszkania` varchar(45) DEFAULT NULL,
  `kod_pocztowy` varchar(45) DEFAULT NULL,
  `ulica` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_adresu`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `kategoria` (
  `id_kategorii` int NOT NULL AUTO_INCREMENT,
  `nazwa_kategorii` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_kategorii`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci



CREATE TABLE `klient` (
  `id_klienta` int NOT NULL AUTO_INCREMENT,
  `imie_klienta` varchar(45) DEFAULT NULL,
  `nazwisko_klienta` varchar(45) DEFAULT NULL,
  `adres_id_adresu` int NOT NULL,
  PRIMARY KEY (`id_klienta`,`adres_id_adresu`),
  KEY `fk_klient_adres1_idx` (`adres_id_adresu`),
  CONSTRAINT `fk_klient_adres1` FOREIGN KEY (`adres_id_adresu`) REFERENCES `adres` (`id_adresu`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

CREATE TABLE `towar` (
  `id_towar` int NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(255) DEFAULT NULL,
  `rodzaj` varchar(255) DEFAULT NULL,
  `cena` decimal(10,2) DEFAULT NULL,
  `kategoria_id_kategorii` int NOT NULL,
  PRIMARY KEY (`id_towar`,`kategoria_id_kategorii`),
  KEY `fk_towar_kategoria1_idx` (`kategoria_id_kategorii`),
  CONSTRAINT `fk_towar_kategoria1` FOREIGN KEY (`kategoria_id_kategorii`) REFERENCES `kategoria` (`id_kategorii`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

CREATE TABLE `zamowienie` (
  `id_zamowienia` int NOT NULL AUTO_INCREMENT,
  `data_zamowienia` date DEFAULT NULL,
  `metoda_platnosci` enum('gotowka','karta') DEFAULT NULL,
  `czy_oplacone` tinyint DEFAULT NULL,
  `klient_id_klienta` int NOT NULL,
  PRIMARY KEY (`id_zamowienia`,`klient_id_klienta`),
  KEY `fk_zamowienie_klient` (`klient_id_klienta`),
  CONSTRAINT `fk_zamowienie_klient` FOREIGN KEY (`klient_id_klienta`) REFERENCES `klient` (`id_klienta`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

CREATE TABLE `zamowienie_has_towar` (
  `zamowienie_id_zamowienia` int NOT NULL,
  `zamowienie_klient_id_klienta` int NOT NULL,
  `towar_id_towar` int NOT NULL,
  `towar_kategoria_id_kategorii` int NOT NULL,
  PRIMARY KEY (`zamowienie_id_zamowienia`,`zamowienie_klient_id_klienta`,`towar_id_towar`,`towar_kategoria_id_kategorii`),
  KEY `fk_zamowienie_has_towar_towar1_idx` (`towar_id_towar`,`towar_kategoria_id_kategorii`),
  KEY `fk_zamowienie_has_towar_zamowienie1_idx` (`zamowienie_id_zamowienia`,`zamowienie_klient_id_klienta`),
  CONSTRAINT `fk_zamowienie_has_towar_towar1` FOREIGN KEY (`towar_id_towar`, `towar_kategoria_id_kategorii`) REFERENCES `towar` (`id_towar`, `kategoria_id_kategorii`),
  CONSTRAINT `fk_zamowienie_has_towar_zamowienie1` FOREIGN KEY (`zamowienie_id_zamowienia`, `zamowienie_klient_id_klienta`) REFERENCES `zamowienie` (`id_zamowienia`, `klient_id_klienta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci




USE `kotarskip`;
DROP procedure IF EXISTS `promocja`;

DELIMITER $$
USE `kotarskip`$$
CREATE PROCEDURE `promocja` (IN id int)
BEGIN
update towar set cena = 0.8 * cena where id_towar=id;
END$$

DELIMITER ;






USE `kotarskip`;
DROP function IF EXISTS `count_klient`;

DELIMITER $$
USE `kotarskip`$$
CREATE FUNCTION `count_klient` ()
RETURNS INTEGER
BEGIN
DECLARE ilosc INT;
SELECT COUNT(*) INTO @ilosc FROM klient;
 
RETURN @ilosc;
END$$

DELIMITER ;







DELIMITER $$
USE `kotarskip`$$
CREATE DEFINER = CURRENT_USER TRIGGER `kotarskip`.`towar_BEFORE_INSERT` BEFORE INSERT ON `towar` FOR EACH ROW
BEGIN
IF NEW.cena <0 THEN 
SET NEW.cena = 0;
 END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`kotarskip`@`localhost` TRIGGER `zamowienie_BEFORE_INSERT` BEFORE INSERT ON `zamowienie` FOR EACH ROW BEGIN
SET NEW.data_zamowienia=now();
END$$ 
DELIMITER ;
