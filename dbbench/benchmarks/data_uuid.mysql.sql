CREATE TABLE `data_uuid` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `a` char(36) NOT NULL,
  `b` char(36) NOT NULL,
  `c` char(36) NOT NULL,
  `status` INT NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_ab` (`a`,`b`),
  KEY `idx_ba` (`b`,`a`),
  KEY `idx_ca` (`c`,`a`),
  KEY `idx_cb` (`c`,`b`),
  KEY `idx_acb` (`a`,`c`,`b`),
  KEY `idx_bca` (`b`,`c`,`a`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
