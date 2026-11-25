# Dicionário de dados

* Tabela: `participante`

Armazena os dados dos participantes da Semana de Tecnologia.

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| cod_participante | CHAR | 3 | Não | PK | Código identificador do participante | Formato P00, como P01, P02 e P03 |
| nome_participante | VARCHAR | 60 | Não | — | Nome completo do participante | Texto de até 60 caracteres |


* Tabela: `inscricao`

Armazena as inscrições realizadas pelos participantes e suas respectivas categorias de preço.

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| cod_inscricao | INT | — | Não | PK | Código identificador da inscrição | Número inteiro positivo e único |
| cod_participante | CHAR | 3 | Não | FK | Código do participante responsável pela inscrição | Referencia participante(cod_participante) |
| cod_categoria | CHAR | 2 | Não | FK | Código da categoria da inscrição | Referencia categoria(cod_categoria) |


* Tabela: `oficina`

Armazena as oficinas oferecidas durante a Semana de Tecnologia.

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| cod_oficina | CHAR | 2 | Não | PK | Código identificador da oficina | Formato O0, como O1, O2 e O3 |
| nome_oficina | VARCHAR | 40 | Não | — | Nome da oficina | Texto de até 40 caracteres |
| sala | VARCHAR | 10 | Não | — | Localização onde a oficina será realizada | Texto de até 10 caracteres |


* Tabela: `email`

Armazena os endereços de e-mail dos participantes, permitindo que cada participante possua múltiplos e-mails sem violar a Primeira Forma Normal (1FN).

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| id_email | INT | — | Não | PK | Identificador único do registro de e-mail | AUTO_INCREMENT |
| cod_participante | CHAR | 3 | Não | FK | Código do participante proprietário do e-mail | Referencia participante(cod_participante) |
| email | VARCHAR | 90 | Não | — | Endereço de e-mail do participante | Endereço de e-mail válido de até 90 caracteres |


* Tabela: `categoria`

Armazena as categorias de inscrição e seus respectivos valores, evitando a repetição dessas informações em diferentes inscrições.

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| cod_categoria | CHAR | 2 | Não | PK | Código identificador da categoria | Formato K0, como K1 e K2 |
| categoria | VARCHAR | 20 | Não | — | Nome da categoria de inscrição | Ex.: Estudante e Profissional |
| valor_categoria | DECIMAL | 8,2 | Não | — | Valor monetário da categoria de inscrição | Valor maior ou igual a zero, com duas casas decimais |


* Tabela: `inscricao_oficina`

Tabela associativa responsável por estabelecer o relacionamento muitos para muitos (N:N) entre inscrições e oficinas.

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| cod_inscricao | INT | — | Não | PK, FK | Código da inscrição associada à oficina | Referencia inscricao(cod_inscricao) |
| cod_oficina | CHAR | 2 | Não | PK, FK | Código da oficina escolhida na inscrição | Referencia oficina(cod_oficina) |

**Chave primária composta:** (cod_inscricao, cod_oficina).

---

<!-- BLOCO: PLANILHA 2 (FNBC) - Pessoa 5 (Denys) -->
* Tabela: `mentor`

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| mentor | VARCHAR | 60 | Não | PK | Nome do mentor | Único. Cada mentor acompanha uma única trilha |
| trilha | VARCHAR | 30 | Não | | Trilha que o mentor acompanha | Determinada pelo mentor (`mentor → trilha`) |

* Tabela: `participante_mentor`

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| participante | VARCHAR | 60 | Não | PK | Nome do participante | Parte da PK composta `(participante, mentor)` |
| mentor | VARCHAR | 60 | Não | PK, FK → mentor | Mentor que acompanha o participante | Deve existir em `mentor` |

A regra "em cada trilha o participante tem um único mentor" não é imposta pelo banco. Ela é conferida pela consulta de validação do `03_prova_sem_perda.sql`.
<!-- FIM DO BLOCO: PLANILHA 2 (FNBC) -->

---

<!-- BLOCO: PLANILHA 3 (4FN) - Pessoa 6 (Tais) -->
* Tabela: `palestrante_tema`

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| palestrante | VARCHAR | 60 | Não | PK (composta) | Nome do palestrante | Parte da chave junto com `tema` |
| tema | VARCHAR | 40 | Não | PK (composta) | Tema sobre o qual o palestrante fala | Não repete a combinação (palestrante, tema) |

---

* Tabela: `palestrante_idioma`

| Atributo | Tipo | Tamanho | Nulo? | Chave | Descrição | Restrição / domínio |
| --- | --- | --- | --- | --- | --- | --- |
| palestrante | VARCHAR | 60 | Não | PK (composta) | Nome do palestrante | Parte da chave junto com `idioma` |
| idioma | VARCHAR | 20 | Não | PK (composta) | Idioma em que o palestrante fala | Não repete a combinação (palestrante, idioma) |
<!-- FIM DO BLOCO: PLANILHA 3 (4FN) -->
