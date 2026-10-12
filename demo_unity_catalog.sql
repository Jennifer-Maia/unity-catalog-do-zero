-- ============================================================
-- Demo: Unity Catalog do zero
-- Dados fictícios.
-- Execute um bloco por vez, na ordem.
-- ============================================================

-- ------------------------------------------------------------
-- BLOCO 1: criar catálogo (prédio), schema (andar) e tabela (sala)
-- ------------------------------------------------------------

-- Cria o catálogo jornada_demo (prédio)
CREATE CATALOG IF NOT EXISTS jornada_demo;

-- Cria o schema vendas dentro do catálogo (andar)
CREATE SCHEMA IF NOT EXISTS jornada_demo.vendas;

-- Cria a tabela pedidos (sala); OR REPLACE evita registros duplicados ao repetir a gravação
CREATE OR REPLACE TABLE jornada_demo.vendas.pedidos (
  id INT,
  cliente STRING,
  valor DOUBLE
);

-- Insere 6 pedidos de 3 clientes fictícios
INSERT INTO jornada_demo.vendas.pedidos VALUES
  (1, 'Ana Souza',     150.00),
  (2, 'Bruno Lima',     80.50),
  (3, 'Ana Souza',     200.00),
  (4, 'Carla Mendes',   45.90),
  (5, 'Bruno Lima',    310.00),
  (6, 'Carla Mendes',   99.90);

-- Confere os registros
SELECT * FROM jornada_demo.vendas.pedidos;


-- ------------------------------------------------------------
-- BLOCO 2: permissões para o grupo data_analysts (as três chaves)
-- ------------------------------------------------------------

-- Chave 1: entrar no catálogo
GRANT USE CATALOG ON CATALOG jornada_demo TO `data_analysts`;

-- Chave 2: subir no schema
GRANT USE SCHEMA ON SCHEMA jornada_demo.vendas TO `data_analysts`;

-- Permissão de leitura na tabela
GRANT SELECT ON TABLE jornada_demo.vendas.pedidos TO `data_analysts`;

-- Mostra as permissões concedidas na tabela
SHOW GRANTS ON TABLE jornada_demo.vendas.pedidos;

-- Auditoria (~30 s na gravação): registro dos grants feitos acima.
-- Não mostrar a coluna user_identity (e-mail) na tela; o "quem" fica na fala.
SELECT
  event_time,
  action_name,
  request_params['securable_type'] AS tipo,
  request_params['securable_full_name'] AS objeto,
  request_params['changes'] AS mudanca
FROM system.access.audit
WHERE action_name = 'updatePermissions'
  AND request_params['securable_full_name'] LIKE 'jornada_demo%'
ORDER BY event_time;


-- ------------------------------------------------------------
-- BLOCO 3: tabela derivada para gerar o lineage
-- ------------------------------------------------------------

-- Total por cliente, calculado a partir de pedidos
CREATE OR REPLACE TABLE jornada_demo.vendas.pedidos_resumo AS
SELECT
  cliente,
  SUM(valor) AS total_valor
FROM jornada_demo.vendas.pedidos
GROUP BY cliente;

-- Confere o resultado
SELECT * FROM jornada_demo.vendas.pedidos_resumo ORDER BY cliente;


-- ------------------------------------------------------------
-- BLOCO 4: limpeza, para repetir a gravação do zero
-- ------------------------------------------------------------

-- Apaga o schema e tudo que está dentro dele
DROP SCHEMA IF EXISTS jornada_demo.vendas CASCADE;

-- Apaga o catálogo de demo
DROP CATALOG IF EXISTS jornada_demo CASCADE;
