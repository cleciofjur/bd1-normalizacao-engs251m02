-- Migração dos dados das planilhas para as tabelas novas (INSERT ... SELECT)
USE normalizacao_eventos;
-- =====================================================
-- BLOCO: PLANILHA 1 (3FN) - responsavel: Pessoa 3 (Marcos)
-- =====================================================
-- Ordem: primeiro as tabelas sem FK, depois as que apontam para elas
-- (a FK recusa um valor que ainda nao existe na tabela referenciada).
-- DISTINCT tira as repeticoes da planilha: cada participante, categoria,
-- oficina e inscricao aparece em varias linhas, mas entra uma vez so.

INSERT INTO participante (cod_participante, nome_participante)
SELECT DISTINCT cod_participante, nome_participante
FROM planilha;

INSERT INTO categoria (cod_categoria, categoria, valor_categoria)
SELECT DISTINCT cod_categoria, categoria, valor_categoria
FROM planilha;

INSERT INTO oficina (cod_oficina, nome_oficina, sala)
SELECT DISTINCT cod_oficina, nome_oficina, sala
FROM planilha;

-- E-mails (1FN): a coluna emails tem ate 2 valores separados por "; ".
-- A tabela n gera as posicoes 1, 2, 3; o JOIN cria uma linha por posicao
-- que existe na celula (qtd de e-mails = qtd de ";" + 1).
-- SUBSTRING_INDEX(..., pos) pega tudo ate o pos-esimo e-mail e
-- SUBSTRING_INDEX(..., -1) fica so com o ultimo deles; TRIM tira o espaco.
-- ORDER BY garante que id_email (AUTO_INCREMENT) siga a ordem da planilha,
-- e a prova sem perda remonta a celula nessa mesma ordem.
INSERT INTO email (cod_participante, email)
SELECT p.cod_participante,
       TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p.emails, ';', n.pos), ';', -1))
FROM (SELECT DISTINCT cod_participante, emails FROM planilha) AS p
JOIN (SELECT 1 AS pos UNION ALL SELECT 2 UNION ALL SELECT 3) AS n
  ON n.pos <= LENGTH(p.emails) - LENGTH(REPLACE(p.emails, ';', '')) + 1
ORDER BY p.cod_participante, n.pos;

INSERT INTO inscricao (cod_inscricao, cod_participante, cod_categoria)
SELECT DISTINCT cod_inscricao, cod_participante, cod_categoria
FROM planilha;

-- Tabela associativa: cada linha da planilha e um par (inscricao, oficina).
INSERT INTO inscricao_oficina (cod_inscricao, cod_oficina)
SELECT DISTINCT cod_inscricao, cod_oficina
FROM planilha;

-- Esperado: 4 | 6 | 2 | 4 | 4 | 9
SELECT (SELECT COUNT(*) FROM participante)      AS participante,
       (SELECT COUNT(*) FROM email)             AS email,
       (SELECT COUNT(*) FROM categoria)         AS categoria,
       (SELECT COUNT(*) FROM oficina)           AS oficina,
       (SELECT COUNT(*) FROM inscricao)         AS inscricao,
       (SELECT COUNT(*) FROM inscricao_oficina) AS inscricao_oficina;
-- ========== FIM DO BLOCO: PLANILHA 1 (3FN) ==========

-- =====================================================
-- BLOCO: PLANILHA 2 (FNBC) - responsavel: Pessoa 5 (Denys)
-- =====================================================

INSERT INTO mentor (mentor, trilha)
SELECT DISTINCT mentor, trilha
FROM planilha_fnbc;

INSERT INTO participante_mentor (participante, mentor)
SELECT DISTINCT participante, mentor
FROM planilha_fnbc;

SELECT (SELECT COUNT(*) FROM mentor) AS mentor,
       (SELECT COUNT(*) FROM participante_mentor) AS participante_mentor;
-- ========== FIM DO BLOCO: PLANILHA 2 (FNBC) ==========

-- =====================================================
-- BLOCO: PLANILHA 3 (4FN) - responsavel: Pessoa 6 (Tais)
-- =====================================================
INSERT INTO palestrante_tema (palestrante, tema)
SELECT DISTINCT palestrante, tema FROM planilha_4fn;

INSERT INTO palestrante_idioma (palestrante, idioma)
SELECT DISTINCT palestrante, idioma FROM planilha_4fn;
-- ========== FIM DO BLOCO: PLANILHA 3 (4FN) ==========
