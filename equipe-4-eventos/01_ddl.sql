-- Modelo normalizado: CREATE TABLE de todas as tabelas, com PK e FK
USE normalizacao_eventos;

-- =====================================================
-- BLOCO: PLANILHA 1 (3FN) - responsavel: Pessoa 2 (Vitor)
-- =====================================================
-- A planilha original tem 10 colunas e repete dados em varias linhas.
-- Aqui ela vira 6 tabelas, cada uma sobre um unico assunto:
--   participante, email, categoria, oficina, inscricao, inscricao_oficina
-- Os tipos sao os mesmos do 00_planilha.sql, para os dados caberem sem conversao.

-- Apaga as tabelas, se ja existirem, para o script poder rodar de novo.
-- A ordem e a inversa da criacao: primeiro quem tem FK, depois quem e referenciado.
DROP TABLE IF EXISTS inscricao_oficina;
DROP TABLE IF EXISTS inscricao;
DROP TABLE IF EXISTS email;
DROP TABLE IF EXISTS oficina;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS participante;

-- 1) Tabelas sem FK (nao dependem de nenhuma outra)

-- Cada participante uma unica vez (cod_participante -> nome_participante).
CREATE TABLE participante (
  cod_participante  CHAR(3)     NOT NULL,
  nome_participante VARCHAR(60) NOT NULL,
  PRIMARY KEY (cod_participante)
);

-- Tabela de precos: cod_categoria -> categoria, valor_categoria.
-- Era a dependencia transitiva que violava a 3FN.
CREATE TABLE categoria (
  cod_categoria   CHAR(2)      NOT NULL,
  categoria       VARCHAR(20)  NOT NULL,
  valor_categoria DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (cod_categoria)
);

-- Cada oficina e a sua sala uma unica vez (cod_oficina -> nome_oficina, sala).
CREATE TABLE oficina (
  cod_oficina  CHAR(2)     NOT NULL,
  nome_oficina VARCHAR(40) NOT NULL,
  sala         VARCHAR(10) NOT NULL,
  PRIMARY KEY (cod_oficina)
);

-- 2) Tabelas que dependem das de cima

-- Um e-mail por linha (resolve a 1FN: a coluna "emails" tinha 2 valores na mesma celula).
-- id_email e gerado pelo banco; UNIQUE impede o mesmo e-mail duas vezes para a mesma pessoa.
CREATE TABLE email (
  id_email         INT         NOT NULL AUTO_INCREMENT,
  cod_participante CHAR(3)     NOT NULL,
  email            VARCHAR(90) NOT NULL,
  PRIMARY KEY (id_email),
  UNIQUE (cod_participante, email),
  FOREIGN KEY (cod_participante) REFERENCES participante (cod_participante)
);

-- Cada inscricao e de um participante e tem uma categoria de preco
-- (cod_inscricao -> cod_participante, cod_categoria).
CREATE TABLE inscricao (
  cod_inscricao    INT     NOT NULL,
  cod_participante CHAR(3) NOT NULL,
  cod_categoria    CHAR(2) NOT NULL,
  PRIMARY KEY (cod_inscricao),
  FOREIGN KEY (cod_participante) REFERENCES participante (cod_participante),
  FOREIGN KEY (cod_categoria)    REFERENCES categoria (cod_categoria)
);

-- 3) Tabela associativa: resolve o N:N entre inscricao e oficina.
-- Uma linha por par (inscricao, oficina). A PK composta impede escolher a mesma oficina duas vezes.
CREATE TABLE inscricao_oficina (
  cod_inscricao INT     NOT NULL,
  cod_oficina   CHAR(2) NOT NULL,
  PRIMARY KEY (cod_inscricao, cod_oficina),
  FOREIGN KEY (cod_inscricao) REFERENCES inscricao (cod_inscricao),
  FOREIGN KEY (cod_oficina)   REFERENCES oficina (cod_oficina)
);
-- ========== FIM DO BLOCO: PLANILHA 1 (3FN) ==========

-- =====================================================
-- BLOCO: PLANILHA 2 (FNBC) - responsavel: Pessoa 5 (Denys)
-- =====================================================

DROP TABLE IF EXISTS participante_mentor;
DROP TABLE IF EXISTS mentor;

CREATE TABLE mentor (
  mentor VARCHAR(60) NOT NULL,
  trilha VARCHAR(30) NOT NULL,
  PRIMARY KEY (mentor)
);

CREATE TABLE participante_mentor (
  participante VARCHAR(60) NOT NULL,
  mentor VARCHAR(60) NOT NULL,
  PRIMARY KEY (participante, mentor),
  FOREIGN KEY (mentor) REFERENCES mentor(mentor)
);
-- ========== FIM DO BLOCO: PLANILHA 2 (FNBC) ==========

-- =====================================================
-- BLOCO: PLANILHA 3 (4FN) - responsavel: Pessoa 6 (Tais)
-- =====================================================
DROP TABLE IF EXISTS palestrante_tema;
DROP TABLE IF EXISTS palestrante_idioma;

CREATE TABLE palestrante_tema (
  palestrante VARCHAR(60) NOT NULL,
  tema VARCHAR(40) NOT NULL,
  PRIMARY KEY (palestrante, tema)
);

CREATE TABLE palestrante_idioma (
  palestrante VARCHAR(60) NOT NULL,
  idioma VARCHAR(20) NOT NULL,
  PRIMARY KEY (palestrante, idioma)
);
-- ========== FIM DO BLOCO: PLANILHA 3 (4FN) ==========
