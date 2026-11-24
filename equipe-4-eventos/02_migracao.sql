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
