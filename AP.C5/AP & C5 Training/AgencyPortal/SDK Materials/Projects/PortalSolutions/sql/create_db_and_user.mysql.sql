

DROP DATABASE IF EXISTS `AgencyPortal5`;
CREATE DATABASE `AgencyPortal5`;
CREATE USER 'AgencyPortal'@'localhost' IDENTIFIED BY 'AgencyPortal';
GRANT ALL ON `AgencyPortal5`.* TO 'AgencyPortal'@'localhost';