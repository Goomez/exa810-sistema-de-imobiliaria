-- EXA810 - BANCO DE DADOS
-- SISTEMA DE IMOBILIARIA
-- ESDRAS ABREU SILVA
-- KEVIN CERQUEIRA GOMES

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema imobiliaria
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `imobiliaria` DEFAULT CHARACTER SET utf8 ;
USE `imobiliaria` ;

-- -----------------------------------------------------
-- Table `imobiliaria`.`forma_pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`forma_pagamento` (
  `idforma_pagamento` INT NOT NULL,
  `tipo` ENUM('cartao', 'cheque', 'boleto', 'deposito') NOT NULL,
  PRIMARY KEY (`idforma_pagamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`valor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`valor` (
  `idvalor` INT NOT NULL,
  `valor` FLOAT NOT NULL,
  `comissao_empresa` FLOAT NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`idvalor`),
  INDEX `fk_valor_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  CONSTRAINT `fk_valor_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `imobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`endereco` (
  `idendereco` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rua` VARCHAR(45) NOT NULL,
  `numero` INT NOT NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idendereco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`usuario` (
  `idusuario` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `sobrenome` VARCHAR(45) NOT NULL,
  `cpf` VARCHAR(45) NOT NULL,
  `endereco_idendereco` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idusuario`),
  INDEX `fk_usuario_endereco1_idx` (`endereco_idendereco` ASC),
  CONSTRAINT `fk_usuario_endereco1`
    FOREIGN KEY (`endereco_idendereco`)
    REFERENCES `imobiliaria`.`endereco` (`idendereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`cliente` (
  `idcliente` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `sexo` VARCHAR(45) NOT NULL,
  `estado_civil` VARCHAR(45) NOT NULL,
  `profissão` VARCHAR(45) NOT NULL,
  `tipo` ENUM('proprientario', 'usuario') NOT NULL,
  `usuario_idusuario` INT NOT NULL,
  PRIMARY KEY (`idcliente`),
  INDEX `fk_cliente_usuario1_idx` (`usuario_idusuario` ASC),
  CONSTRAINT `fk_cliente_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `imobiliaria`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`cliente_proprietario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`cliente_proprietario` (
  `idcliente_proprietario` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idcliente_proprietario`),
  INDEX `fk_cliente_proprietario_cliente1_idx` (`cliente_idcliente` ASC),
  CONSTRAINT `fk_cliente_proprietario_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `imobiliaria`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`imovel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`imovel` (
  `idimovel` INT NOT NULL,
  `status` ENUM('disponivel para venda', 'disponivel para aluguel', 'indinsponivel', 'vendido', 'alugado') NOT NULL,
  `data_construcao` DATE NOT NULL,
  `data_anuncio` DATE NOT NULL,
  `cliente_proprietario_idcliente_proprietario` INT NOT NULL,
  `endereco_idendereco` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idimovel`),
  INDEX `fk_imovel_cliente_proprietario1_idx` (`cliente_proprietario_idcliente_proprietario` ASC),
  INDEX `fk_imovel_endereco1_idx` (`endereco_idendereco` ASC),
  CONSTRAINT `fk_imovel_cliente_proprietario1`
    FOREIGN KEY (`cliente_proprietario_idcliente_proprietario`)
    REFERENCES `imobiliaria`.`cliente_proprietario` (`idcliente_proprietario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_imovel_endereco1`
    FOREIGN KEY (`endereco_idendereco`)
    REFERENCES `imobiliaria`.`endereco` (`idendereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`cliente_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`cliente_usuario` (
  `idcliente_imovel` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idcliente_imovel`),
  INDEX `fk_cliente_imovel_cliente1_idx` (`cliente_idcliente` ASC),
  CONSTRAINT `fk_cliente_imovel_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `imobiliaria`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`transacao` (
  `idtransacao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_transacao` DATE NOT NULL,
  `valor_idvalor` INT NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  `cliente_usuario_idcliente_imovel` INT UNSIGNED NOT NULL,
  `tipo` ENUM('venda', 'locacao') NOT NULL,
  PRIMARY KEY (`idtransacao`),
  INDEX `fk_servico_valor1_idx` (`valor_idvalor` ASC),
  INDEX `fk_servico_imovel1_idx` (`imovel_idimovel` ASC),
  INDEX `fk_servico_cliente_usuario1_idx` (`cliente_usuario_idcliente_imovel` ASC),
  CONSTRAINT `fk_servico_valor1`
    FOREIGN KEY (`valor_idvalor`)
    REFERENCES `imobiliaria`.`valor` (`idvalor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servico_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `imobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servico_cliente_usuario1`
    FOREIGN KEY (`cliente_usuario_idcliente_imovel`)
    REFERENCES `imobiliaria`.`cliente_usuario` (`idcliente_imovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`locacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`locacao` (
  `idlocacao` INT NOT NULL,
  `data_devolucao` DATE NOT NULL,
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idlocacao`),
  INDEX `fk_locacao_transacao1_idx` (`transacao_idtransacao` ASC))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `imobiliaria`.`foto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`foto` (
  `idfoto` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  PRIMARY KEY (`idfoto`),
  INDEX `fk_foto_imovel1_idx` (`imovel_idimovel` ASC),
  CONSTRAINT `fk_foto_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `imobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`casa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`casa` (
  `idcasa` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `quartos` INT NOT NULL,
  `suites` INT NOT NULL,
  `sala_estar` INT NOT NULL,
  `sala_jantar` INT NOT NULL,
  `vagas_garagem` INT NOT NULL,
  `area` FLOAT NOT NULL,
  `armario` TINYINT NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  PRIMARY KEY (`idcasa`),
  INDEX `fk_casa_imovel1_idx` (`imovel_idimovel` ASC),
  CONSTRAINT `fk_casa_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `imobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`apartamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`apartamento` (
  `idapartamento` INT NOT NULL,
  `quartos` INT NULL,
  `suites` INT NULL,
  `sala_estar` INT NULL,
  `sala_jantar` INT NULL,
  `vagas_garagem` INT NULL,
  `area` FLOAT NULL,
  `armario` TINYINT NULL,
  `descricao` VARCHAR(45) NULL,
  `andar` INT NULL,
  `valor_condominio` FLOAT NULL,
  `portaria_24hrs` TINYINT NULL,
  `numero_apartamento` INT NULL,
  `imovel_idimovel` INT NOT NULL,
  PRIMARY KEY (`idapartamento`),
  INDEX `fk_apartamento_imovel1_idx` (`imovel_idimovel` ASC),
  CONSTRAINT `fk_apartamento_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `imobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`terreno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`terreno` (
  `idterreno` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `area` FLOAT NOT NULL,
  `largura` FLOAT NOT NULL,
  `comprimento` FLOAT NOT NULL,
  `aclive/declive` TINYINT NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  PRIMARY KEY (`idterreno`),
  INDEX `fk_terreno_imovel1_idx` (`imovel_idimovel` ASC),
  CONSTRAINT `fk_terreno_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `imobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`sala_comercial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`sala_comercial` (
  `idsala_comercial` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `area` FLOAT NOT NULL,
  `banheiro` INT NOT NULL,
  `comodos` INT NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  PRIMARY KEY (`idsala_comercial`),
  INDEX `fk_sala_comercial_imovel1_idx` (`imovel_idimovel` ASC),
  CONSTRAINT `fk_sala_comercial_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `imobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`venda` (
  `idvenda` INT NOT NULL,
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idvenda`),
  INDEX `fk_venda_transacao1_idx` (`transacao_idtransacao` ASC),
  CONSTRAINT `fk_venda_transacao1`
    FOREIGN KEY (`transacao_idtransacao`)
    REFERENCES `imobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`cargo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`cargo` (
  `idcargo` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `salario` FLOAT NULL,
  PRIMARY KEY (`idcargo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`funcionario` (
  `idfuncionario` INT NOT NULL,
  `data_ingresso` DATE NOT NULL,
  `usuario` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(128) NOT NULL,
  `usuario_idusuario` INT NOT NULL,
  `cargo_idcargo` INT NOT NULL,
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idfuncionario`),
  INDEX `fk_funcionario_usuario1_idx` (`usuario_idusuario` ASC),
  INDEX `fk_funcionario_cargo1_idx` (`cargo_idcargo` ASC),
  INDEX `fk_funcionario_transacao1_idx` (`transacao_idtransacao` ASC),
  CONSTRAINT `fk_funcionario_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `imobiliaria`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funcionario_cargo1`
    FOREIGN KEY (`cargo_idcargo`)
    REFERENCES `imobiliaria`.`cargo` (`idcargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funcionario_transacao1`
    FOREIGN KEY (`transacao_idtransacao`)
    REFERENCES `imobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`telefone` (
  `idtelefone` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(45) NULL,
  `usuario_idusuario` INT NOT NULL,
  PRIMARY KEY (`idtelefone`),
  INDEX `fk_telefone_usuario1_idx` (`usuario_idusuario` ASC),
  CONSTRAINT `fk_telefone_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `imobiliaria`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`fiador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`fiador` (
  `idfiador` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cliente_imovel_idcliente_imovel` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idfiador`),
  INDEX `fk_fiador_cliente_imovel_idx` (`cliente_imovel_idcliente_imovel` ASC),
  CONSTRAINT `fk_fiador_cliente_imovel`
    FOREIGN KEY (`cliente_imovel_idcliente_imovel`)
    REFERENCES `imobiliaria`.`cliente_usuario` (`idcliente_imovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`indicacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`indicacao` (
  `idindicacao` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `cliente_imovel_idcliente_imovel` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idindicacao`),
  INDEX `fk_indicacao_cliente_imovel1_idx` (`cliente_imovel_idcliente_imovel` ASC),
  CONSTRAINT `fk_indicacao_cliente_imovel1`
    FOREIGN KEY (`cliente_imovel_idcliente_imovel`)
    REFERENCES `imobiliaria`.`cliente_usuario` (`idcliente_imovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`cartao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`cartao` (
  `idcartao` INT NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `data_validade` DATE NOT NULL,
  `nome_pessoa` VARCHAR(45) NOT NULL,
  `cvv` MEDIUMINT(3) NOT NULL,
  `tipo` ENUM('credito', 'debito') NOT NULL,
  `banco` VARCHAR(45) NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`idcartao`),
  INDEX `fk_cartao_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  CONSTRAINT `fk_cartao_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `imobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`boleto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`boleto` (
  `idboleto` INT NOT NULL,
  `numero` VARCHAR(50) NOT NULL,
  `data_validade` DATE NOT NULL,
  `data_emissao` DATE NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`idboleto`),
  INDEX `fk_boleto_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  CONSTRAINT `fk_boleto_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `imobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`cheque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`cheque` (
  `idcheque` INT NOT NULL,
  `banco` VARCHAR(45) NOT NULL,
  `agencia` VARCHAR(45) NOT NULL,
  `numero_conta` VARCHAR(45) NOT NULL,
  `numero_cheque` VARCHAR(45) NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`idcheque`),
  INDEX `fk_cheque_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  CONSTRAINT `fk_cheque_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `imobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`deposito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`deposito` (
  `iddeposito` INT NOT NULL,
  `banco` VARCHAR(45) NOT NULL,
  `agencia` VARCHAR(45) NOT NULL,
  `conta` VARCHAR(45) NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`iddeposito`),
  INDEX `fk_deposito_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  CONSTRAINT `fk_deposito_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `imobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`historico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`historico` (
  `idhistorico` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('venda', 'locacao') NOT NULL,
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idhistorico`),
  INDEX `fk_historico_transacao1_idx` (`transacao_idtransacao` ASC),
  CONSTRAINT `fk_historico_transacao1`
    FOREIGN KEY (`transacao_idtransacao`)
    REFERENCES `imobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imobiliaria`.`funcionario_transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imobiliaria`.`funcionario_transacao` (
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  `funcionario_idfuncionario` INT NOT NULL,
  `comissao` FLOAT NOT NULL,
  PRIMARY KEY (`transacao_idtransacao`, `funcionario_idfuncionario`),
  INDEX `fk_transacao_has_funcionario_funcionario1_idx` (`funcionario_idfuncionario` ASC),
  INDEX `fk_transacao_has_funcionario_transacao1_idx` (`transacao_idtransacao` ASC),
  UNIQUE INDEX `transacao_idtransacao_UNIQUE` (`transacao_idtransacao` ASC),
  UNIQUE INDEX `funcionario_idfuncionario_UNIQUE` (`funcionario_idfuncionario` ASC),
  CONSTRAINT `fk_transacao_has_funcionario_transacao1`
    FOREIGN KEY (`transacao_idtransacao`)
    REFERENCES `imobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacao_has_funcionario_funcionario1`
    FOREIGN KEY (`funcionario_idfuncionario`)
    REFERENCES `imobiliaria`.`funcionario` (`idfuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
