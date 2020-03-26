USE `imobiliaria` ;

-- GROUP BY
-- Agrupando os imóveis pelo status (disponivel para venda, deisponivel para aluguel, indisponivel, vendido, alugado)
SELECT * FROM `imovel` GROUP BY `status`;
-- Agrupando os funcionarios pelo cargo e mostrando o nome e cpf;
SELECT U.`nome`, U.`sobrenome`, U.`cpf` FROM `usuario` U, `funcionario` F, `cargo` C WHERE F.`usuario_idusuario` = U.`idusuario` GROUP BY C.`nome`;
-- Agrupando os clientes pelo tipo deles (propietario, usuario)
SELECT U.* FROM `usuario` U, `cliente` C WHERE C.`usuario_idusuario` = U.`idusuario` GROUP BY C.`tipo`;

-- ORDER BY
-- Selecionando os imóveis que estão disponiveis para venda ou aluguel ordenados pela data de construcao
SELECT * FROM `imovel` WHERE `status` = 'disponivel para venda' OR `status` = 'disponivel para aluguel' ORDER BY `data_construcao`;
-- Selecionando os imóveis que estão disponiveis para venda ou aluguel ordenados pela data de anuncio
SELECT * FROM `imovel` WHERE `status` = 'disponivel para venda' OR `status` = 'disponivel para aluguel' ORDER BY `data_anuncio`;
-- Selecionando o nome e cpf de todos os funcionarios ordenados pela data de ingresso
SELECT U.`nome`, U.`sobrenome`, U.`cpf` FROM `usuario` U, `funcionario` F WHERE F.`usuario_idusuario` = `idusuario` ORDER BY F.`data_ingresso`;

-- DISTINCT
-- Selecionando todas os valores distintos das transações
SELECT DISTINCT `valor` FROM `valor`;
-- Selecionando todos os bairros e cidades que tem imoveis
SELECT DISTINCT E.`cidade`, E.`bairro` FROM `imovel` I, `endereco` E WHERE I.`endereco_idendereco` = E.`idendereco`;

-- JOIN
-- Selecionando todas as transações e seus valores correspondentes
SELECT T.`data_transacao`, T.`tipo`, V.`valor` FROM `transacao` T join `valor` V ON T.`valor_idvalor` = V.`idvalor`;

-- SUB-CONSULTA
-- Selecionando todos os imóveis que são de Feira de Santana
SELECT * FROM `imovel` WHERE `endereco_idendereco` IN (SELECT `idendereco` FROM `endereco` WHERE `cidade` = 'Feira de Santana');

-- COUNT
-- Quantidade totas de clientes usuarios do imobiliaria
SELECT COUNT(*) FROM `cliente_usuario`;
-- Quantidade total de imóveis disponíveis para venda
SELECT COUNT(*) FROM `imovel` WHERE `status` = 'disponivel para venda';
-- Quantidade total de imóveis disponíveis para aluguel
SELECT COUNT(*) FROM `imovel` WHERE `status` = 'disponivel para aluguel';

-- AVG
-- Media dos salario dos funcionarios do imobiliaria;
SELECT AVG(C.`salario`) FROM `funcionario` F, `cargo` C WHERE F.`cargo_idcargo` = C.`idcargo`;
-- Media dos valores das transações feitas pela imobiliaria
SELECT AVG(`valor`) FROM `valor`;

-- SUM
-- Valor total das comissões de cada funcionario
SELECT SUM(T.`comissao`) FROM `funcionario` F, `funcionario_transacao` T WHERE T.`funcionario_idfuncionario` = F.`idfuncionario`;
-- Valor total de comissao da empresa de todas as transações efetuadas
SELECT SUM(`comissao_empresa`) FROM `valor`;

-- MAX
-- Selecionando o ID da transção de maior valor;
SELECT T.`idtransacao`, MAX(V.`valor`) FROM  `transacao` T, `valor` V WHERE T.`valor_idvalor` = V.`idvalor`;

-- MIN
-- Selecionando o ID da transção de menor valor;
SELECT T.`idtransacao`, MIN(V.`valor`) FROM  `transacao` T, `valor` V WHERE T.`valor_idvalor` = V.`idvalor`;

 -- SOMENTE SELECT COM WHERE
 -- Selecionando todos os imóveis disponíveis para venda
SELECT * FROM `imovel` WHERE `status` = 'disponivel para venda';
-- Selecionando todos os imóveis disponíveis para aluguel
SELECT * FROM `imovel` WHERE `status` = 'disponivel para aluguel';

