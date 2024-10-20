CREATE TABLE `consultacep`.`enderecos` (
  `codigo` bigint NOT NULL auto_increment,
  `cep` VARCHAR(45) NOT NULL,
  `logradouro` VARCHAR(45) NULL,
  `complemento` VARCHAR(45) NULL,
  `bairro` VARCHAR(45) NULL,
  `localidade` VARCHAR(45) NULL,
  `uf` VARCHAR(2) NULL,
  PRIMARY KEY (`codigo`));
