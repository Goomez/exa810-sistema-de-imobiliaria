-- EXA810 - SISTEMA DE IMOBÍLIARIA
-- Esdras Abreu Silva
-- Kevin Cerqueira Gomes

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mobiliaria` DEFAULT CHARACTER SET utf8 ;
USE `mobiliaria` ;

-- -----------------------------------------------------
-- Table `mobiliaria`.`forma_pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`forma_pagamento` (
  `idforma_pagamento` INT NOT NULL,
  `tipo` ENUM('cartao', 'cheque', 'boleto', 'deposito') NOT NULL,
  PRIMARY KEY (`idforma_pagamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`valor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`valor` (
  `idvalor` INT NOT NULL,
  `valor` FLOAT NOT NULL,
  `comissao_empresa` FLOAT NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`idvalor`),
  INDEX `fk_valor_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  CONSTRAINT `fk_valor_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `mobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`endereco` (
  `idendereco` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rua` VARCHAR(45) NOT NULL,
  `numero` INT NOT NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idendereco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`usuario` (
  `idusuario` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cpf` VARCHAR(45) NOT NULL,
  `endereco_idendereco` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idusuario`),
  INDEX `fk_usuario_endereco1_idx` (`endereco_idendereco` ASC),
  CONSTRAINT `fk_usuario_endereco1`
    FOREIGN KEY (`endereco_idendereco`)
    REFERENCES `mobiliaria`.`endereco` (`idendereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`cliente` (
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
    REFERENCES `mobiliaria`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`cliente_proprietario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`cliente_proprietario` (
  `idcliente_proprietario` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idcliente_proprietario`),
  INDEX `fk_cliente_proprietario_cliente1_idx` (`cliente_idcliente` ASC),
  CONSTRAINT `fk_cliente_proprietario_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `mobiliaria`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`imovel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`imovel` (
  `idimovel` INT NOT NULL,
  `data_construcao` DATE NOT NULL,
  `categora` INT NOT NULL,
  `data_anuncio` DATE NOT NULL,
  `imovelcol` VARCHAR(45) NOT NULL,
  `status_locacao` TINYINT NOT NULL,
  `status_venda` TINYINT NOT NULL,
  `cliente_proprietario_idcliente_proprietario` INT NOT NULL,
  `endereco_idendereco` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idimovel`),
  INDEX `fk_imovel_cliente_proprietario1_idx` (`cliente_proprietario_idcliente_proprietario` ASC),
  INDEX `fk_imovel_endereco1_idx` (`endereco_idendereco` ASC),
  CONSTRAINT `fk_imovel_cliente_proprietario1`
    FOREIGN KEY (`cliente_proprietario_idcliente_proprietario`)
    REFERENCES `mobiliaria`.`cliente_proprietario` (`idcliente_proprietario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_imovel_endereco1`
    FOREIGN KEY (`endereco_idendereco`)
    REFERENCES `mobiliaria`.`endereco` (`idendereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`cliente_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`cliente_usuario` (
  `idcliente_imovel` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idcliente_imovel`),
  INDEX `fk_cliente_imovel_cliente1_idx` (`cliente_idcliente` ASC),
  CONSTRAINT `fk_cliente_imovel_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `mobiliaria`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`transacao` (
  `idtransacao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_transacao` DATE NOT NULL,
  `valor_idvalor` INT NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  `cliente_usuario_idcliente_imovel` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idtransacao`),
  INDEX `fk_servico_valor1_idx` (`valor_idvalor` ASC),
  INDEX `fk_servico_imovel1_idx` (`imovel_idimovel` ASC),
  INDEX `fk_servico_cliente_usuario1_idx` (`cliente_usuario_idcliente_imovel` ASC),
  CONSTRAINT `fk_servico_valor1`
    FOREIGN KEY (`valor_idvalor`)
    REFERENCES `mobiliaria`.`valor` (`idvalor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servico_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `mobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servico_cliente_usuario1`
    FOREIGN KEY (`cliente_usuario_idcliente_imovel`)
    REFERENCES `mobiliaria`.`cliente_usuario` (`idcliente_imovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`locacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`locacao` (
  `idlocacao` INT NOT NULL,
  `data_devolucao` DATE NOT NULL,
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idlocacao`),
  INDEX `fk_locacao_transacao1_idx` (`transacao_idtransacao` ASC))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `mobiliaria`.`foto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`foto` (
  `idfoto` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  PRIMARY KEY (`idfoto`),
  INDEX `fk_foto_imovel1_idx` (`imovel_idimovel` ASC),
  CONSTRAINT `fk_foto_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `mobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`casa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`casa` (
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
    REFERENCES `mobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`apartamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`apartamento` (
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
    REFERENCES `mobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`terreno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`terreno` (
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
    REFERENCES `mobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`sala_comercial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`sala_comercial` (
  `idsala_comercial` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `area` FLOAT NOT NULL,
  `banheiro` INT NOT NULL,
  `comodos` INT NOT NULL,
  `imovel_idimovel` INT NOT NULL,
  PRIMARY KEY (`idsala_comercial`),
  INDEX `fk_sala_comercial_imovel1_idx` (`imovel_idimovel` ASC),
  CONSTRAINT `fk_sala_comercial_imovel1`
    FOREIGN KEY (`imovel_idimovel`)
    REFERENCES `mobiliaria`.`imovel` (`idimovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`venda` (
  `idvenda` INT NOT NULL,
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idvenda`),
  INDEX `fk_venda_transacao1_idx` (`transacao_idtransacao` ASC),
  CONSTRAINT `fk_venda_transacao1`
    FOREIGN KEY (`transacao_idtransacao`)
    REFERENCES `mobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`cargo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`cargo` (
  `idcargo` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `salario` FLOAT NULL,
  PRIMARY KEY (`idcargo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`funcionario` (
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
    REFERENCES `mobiliaria`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funcionario_cargo1`
    FOREIGN KEY (`cargo_idcargo`)
    REFERENCES `mobiliaria`.`cargo` (`idcargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funcionario_transacao1`
    FOREIGN KEY (`transacao_idtransacao`)
    REFERENCES `mobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`telefone` (
  `idtelefone` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(45) NULL,
  `usuario_idusuario` INT NOT NULL,
  PRIMARY KEY (`idtelefone`),
  INDEX `fk_telefone_usuario1_idx` (`usuario_idusuario` ASC),
  CONSTRAINT `fk_telefone_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `mobiliaria`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`fiador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`fiador` (
  `idfiador` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cliente_imovel_idcliente_imovel` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idfiador`),
  INDEX `fk_fiador_cliente_imovel_idx` (`cliente_imovel_idcliente_imovel` ASC),
  CONSTRAINT `fk_fiador_cliente_imovel`
    FOREIGN KEY (`cliente_imovel_idcliente_imovel`)
    REFERENCES `mobiliaria`.`cliente_usuario` (`idcliente_imovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`indicacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`indicacao` (
  `idindicacao` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `cliente_imovel_idcliente_imovel` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idindicacao`),
  INDEX `fk_indicacao_cliente_imovel1_idx` (`cliente_imovel_idcliente_imovel` ASC),
  CONSTRAINT `fk_indicacao_cliente_imovel1`
    FOREIGN KEY (`cliente_imovel_idcliente_imovel`)
    REFERENCES `mobiliaria`.`cliente_usuario` (`idcliente_imovel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`cartao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`cartao` (
  `idcartao` INT NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `data_validade` DATE NOT NULL,
  `nome_pessoa` VARCHAR(45) NOT NULL,
  `cvv` MEDIUMINT(3) NOT NULL,
  `tipo` ENUM('credito', 'debito') NOT NULL,
  `banco` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcartao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`boleto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`boleto` (
  `idboleto` INT NOT NULL,
  `numero` VARCHAR(50) NOT NULL,
  `data_validade` DATE NOT NULL,
  `data_emissao` DATE NOT NULL,
  PRIMARY KEY (`idboleto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`cheque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`cheque` (
  `idcheque` INT NOT NULL,
  `banco` VARCHAR(45) NOT NULL,
  `agencia` VARCHAR(45) NOT NULL,
  `numero_conta` VARCHAR(45) NOT NULL,
  `numero_cheque` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcheque`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`deposito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`deposito` (
  `iddeposito` INT NOT NULL,
  `banco` VARCHAR(45) NOT NULL,
  `agencia` VARCHAR(45) NOT NULL,
  `conta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddeposito`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`historico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`historico` (
  `idhistorico` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('venda', 'locacao') NOT NULL,
  `transacao_idtransacao` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idhistorico`),
  INDEX `fk_historico_transacao1_idx` (`transacao_idtransacao` ASC),
  CONSTRAINT `fk_historico_transacao1`
    FOREIGN KEY (`transacao_idtransacao`)
    REFERENCES `mobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`pagamento_cartao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`pagamento_cartao` (
  `cartao_idcartao` INT NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`cartao_idcartao`, `forma_pagamento_idforma_pagamento`),
  INDEX `fk_cartao_has_forma_pagamento_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  INDEX `fk_cartao_has_forma_pagamento_cartao1_idx` (`cartao_idcartao` ASC),
  CONSTRAINT `fk_cartao_has_forma_pagamento_cartao1`
    FOREIGN KEY (`cartao_idcartao`)
    REFERENCES `mobiliaria`.`cartao` (`idcartao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cartao_has_forma_pagamento_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `mobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`pagamento_cheque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`pagamento_cheque` (
  `cheque_idcheque` INT NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`cheque_idcheque`, `forma_pagamento_idforma_pagamento`),
  INDEX `fk_cheque_has_forma_pagamento_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  INDEX `fk_cheque_has_forma_pagamento_cheque1_idx` (`cheque_idcheque` ASC),
  CONSTRAINT `fk_cheque_has_forma_pagamento_cheque1`
    FOREIGN KEY (`cheque_idcheque`)
    REFERENCES `mobiliaria`.`cheque` (`idcheque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cheque_has_forma_pagamento_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `mobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`pagamento_boleto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`pagamento_boleto` (
  `boleto_idboleto` INT NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`boleto_idboleto`, `forma_pagamento_idforma_pagamento`),
  INDEX `fk_boleto_has_forma_pagamento_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  INDEX `fk_boleto_has_forma_pagamento_boleto1_idx` (`boleto_idboleto` ASC),
  CONSTRAINT `fk_boleto_has_forma_pagamento_boleto1`
    FOREIGN KEY (`boleto_idboleto`)
    REFERENCES `mobiliaria`.`boleto` (`idboleto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_boleto_has_forma_pagamento_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `mobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`pagamento_deposito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`pagamento_deposito` (
  `deposito_iddeposito` INT NOT NULL,
  `forma_pagamento_idforma_pagamento` INT NOT NULL,
  PRIMARY KEY (`deposito_iddeposito`, `forma_pagamento_idforma_pagamento`),
  INDEX `fk_deposito_has_forma_pagamento_forma_pagamento1_idx` (`forma_pagamento_idforma_pagamento` ASC),
  INDEX `fk_deposito_has_forma_pagamento_deposito1_idx` (`deposito_iddeposito` ASC),
  CONSTRAINT `fk_deposito_has_forma_pagamento_deposito1`
    FOREIGN KEY (`deposito_iddeposito`)
    REFERENCES `mobiliaria`.`deposito` (`iddeposito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_deposito_has_forma_pagamento_forma_pagamento1`
    FOREIGN KEY (`forma_pagamento_idforma_pagamento`)
    REFERENCES `mobiliaria`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mobiliaria`.`funcionario_transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobiliaria`.`funcionario_transacao` (
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
    REFERENCES `mobiliaria`.`transacao` (`idtransacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacao_has_funcionario_funcionario1`
    FOREIGN KEY (`funcionario_idfuncionario`)
    REFERENCES `mobiliaria`.`funcionario` (`idfuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
