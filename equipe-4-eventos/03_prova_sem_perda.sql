-- Consultas que remontam cada planilha a partir das tabelas novas e comparam com a original
USE normalizacao_eventos;
-- =====================================================
-- BLOCO: PLANILHA 1 (3FN) - responsavel: Pessoa 4 (Eluana)
-- =====================================================
-- Prova sem perda da 3FN: junta as 6 tabelas de volta no formato da
-- planilha original (uma linha por inscricao + oficina) e compara linha
-- a linha com a planilha.
--
-- Roda depois de: 00_planilha.sql, 01_ddl.sql e 02_migracao.sql.
-- Se o 03_prova_sem_perda.sql ja tiver o USE no topo, esta linha so repete
-- (nao causa erro).

-- O ponto de partida e inscricao_oficina: cada linha dela corresponde a uma
-- linha da planilha. As outras tabelas trazem os demais dados de volta.
-- Os e-mails foram separados um por linha (1FN); aqui o GROUP_CONCAT os junta
-- de novo numa celula, no mesmo formato da planilha ("a; b").
-- ORDER BY id_email mantem a ordem em que a migracao inseriu os e-mails.
-- LEFT JOIN nos e-mails: um participante sem e-mail nao some da reconstrucao.
CREATE OR REPLACE VIEW vw_3fn_reconstruida AS
SELECT i.cod_inscricao,
       p.cod_participante,
       p.nome_participante,
       e.emails,
       c.cod_categoria,
       c.categoria,
       c.valor_categoria,
       o.cod_oficina,
       o.nome_oficina,
       o.sala
FROM inscricao_oficina io
JOIN inscricao    i ON i.cod_inscricao    = io.cod_inscricao
JOIN participante p ON p.cod_participante = i.cod_participante
JOIN categoria    c ON c.cod_categoria    = i.cod_categoria
JOIN oficina      o ON o.cod_oficina      = io.cod_oficina
LEFT JOIN (
  SELECT cod_participante,
         GROUP_CONCAT(email ORDER BY id_email SEPARATOR '; ') AS emails
  FROM email
  GROUP BY cod_participante
) e ON e.cod_participante = p.cod_participante;

-- Faltando: linha da planilha que nao existe na reconstruida (dado perdido).
-- Sobrando: linha da reconstruida que nao existe na planilha (dado inventado).
-- <=> e o "igual" que tambem considera NULL igual a NULL.
-- Resultado esperado: planilha | 9 | 9 | 0 | 0
SELECT
  'planilha' AS tabela,
  (SELECT COUNT(*) FROM planilha)            AS linhas_originais,
  (SELECT COUNT(*) FROM vw_3fn_reconstruida) AS linhas_reconstruidas,
  (SELECT COUNT(*) FROM planilha o WHERE NOT EXISTS (
    SELECT 1 FROM vw_3fn_reconstruida r
    WHERE r.cod_inscricao     <=> o.cod_inscricao
      AND r.cod_participante  <=> o.cod_participante
      AND r.nome_participante <=> o.nome_participante
      AND r.emails            <=> o.emails
      AND r.cod_categoria     <=> o.cod_categoria
      AND r.categoria         <=> o.categoria
      AND r.valor_categoria   <=> o.valor_categoria
      AND r.cod_oficina       <=> o.cod_oficina
      AND r.nome_oficina      <=> o.nome_oficina
      AND r.sala              <=> o.sala
  )) AS faltando,
  (SELECT COUNT(*) FROM vw_3fn_reconstruida r WHERE NOT EXISTS (
    SELECT 1 FROM planilha o
    WHERE o.cod_inscricao     <=> r.cod_inscricao
      AND o.cod_participante  <=> r.cod_participante
      AND o.nome_participante <=> r.nome_participante
      AND o.emails            <=> r.emails
      AND o.cod_categoria     <=> r.cod_categoria
      AND o.categoria         <=> r.categoria
      AND o.valor_categoria   <=> r.valor_categoria
      AND o.cod_oficina       <=> r.cod_oficina
      AND o.nome_oficina      <=> r.nome_oficina
      AND o.sala              <=> r.sala
  )) AS sobrando;
-- ========== FIM DO BLOCO: PLANILHA 1 (3FN) ==========

-- =====================================================
-- BLOCO: PLANILHA 2 (FNBC) - responsavel: Pessoa 5 (Denys)
-- =====================================================

CREATE OR REPLACE VIEW vw_fnbc_reconstruida AS
SELECT pm.participante, m.trilha, m.mentor
FROM participante_mentor pm
JOIN mentor m ON m.mentor = pm.mentor;


SELECT
  'planilha_fnbc' AS tabela,
  (SELECT COUNT(*) FROM planilha_fnbc)        AS linhas_original,
  (SELECT COUNT(*) FROM vw_fnbc_reconstruida) AS linhas_reconstruida,
  
  (SELECT COUNT(*) FROM planilha_fnbc o
    WHERE NOT EXISTS (
      SELECT 1 FROM vw_fnbc_reconstruida r
      WHERE r.participante <=> o.participante
        AND r.trilha       <=> o.trilha
        AND r.mentor       <=> o.mentor)) AS faltando,
  
  (SELECT COUNT(*) FROM vw_fnbc_reconstruida r
    WHERE NOT EXISTS (
      SELECT 1 FROM planilha_fnbc o
      WHERE o.participante <=> r.participante
        AND o.trilha       <=> r.trilha
        AND o.mentor       <=> r.mentor)) AS sobrando;

SELECT participante, trilha, COUNT(*) AS qtd_mentores
FROM vw_fnbc_reconstruida
GROUP BY participante, trilha
HAVING COUNT(*) > 1;
-- ========== FIM DO BLOCO: PLANILHA 2 (FNBC) ==========

-- =====================================================
-- BLOCO: PLANILHA 3 (4FN) - responsavel: Pessoa 6 (Tais)
-- =====================================================
CREATE OR REPLACE VIEW vw_4fn_reconstruida AS
SELECT t.palestrante, t.tema, i.idioma
FROM palestrante_tema t
JOIN palestrante_idioma i ON i.palestrante = t.palestrante;

SELECT
  'planilha_4fn' AS tabela,
  (SELECT COUNT(*) FROM planilha_4fn) AS linhas_originais,
  (SELECT COUNT(*) FROM vw_4fn_reconstruida) AS linhas_reconstruidas,
  (SELECT COUNT(*) FROM planilha_4fn o WHERE NOT EXISTS (
    SELECT 1 FROM vw_4fn_reconstruida r
    WHERE r.palestrante <=> o.palestrante
      AND r.tema <=> o.tema
      AND r.idioma <=> o.idioma
  )) AS faltando,
  (SELECT COUNT(*) FROM vw_4fn_reconstruida r WHERE NOT EXISTS (
    SELECT 1 FROM planilha_4fn o
    WHERE o.palestrante <=> r.palestrante
      AND o.tema <=> r.tema
      AND o.idioma <=> r.idioma
  )) AS sobrando;
-- ========== FIM DO BLOCO: PLANILHA 3 (4FN) ==========
