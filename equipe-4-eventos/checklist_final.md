# Roteiro cronometrado da demonstração e checklist final: Equipe 4 (Eventos)

Banco: `normalizacao_eventos` | Condução da apresentação: Clecio

## Ordem da apresentação (quem fala em cada slide)

Troca de funções: Marcos fez a migração e Eluana fez a prova sem perda.

| Slides | Conteúdo | Quem fala |
|--------|----------|-----------|
| 1 a 3 | Capa, o problema e as três formas normais | Clecio |
| 4 | Planilha 1: problemas e 3FN (anomalias e dependências funcionais) | Vitor |
| 5 | 3FN: as 6 tabelas | Vitor |
| 6 | 3FN: DDL e migração | Vitor (DDL) e Marcos (migração) |
| 7 | 3FN: prova sem perda | Eluana |
| 8 e 9 | 3FN: dicionário de dados (1/2 e 2/2) | Clecio |
| 10 a 12 | Planilha 2 (FNBC): problema, tabelas, DDL, migração, prova e dicionário | Denys |
| 13 a 15 | Planilha 3 (4FN): problema, tabelas, migração, prova e dicionário | Tais |
| 16 | Resultado geral das três planilhas | Marcos |
| 17 e 18 | Modelo conceitual (Peter Chen) | Raymond |
| 19 e 20 | Modelo lógico (James Martin) | Vitor |
| 21 | Demonstração e conclusão | Clecio conduz, todos participam |
| 22 | Obrigado |  |

## Execução (demo ao vivo: quem executa e mostra cada parte)

A demo acontece no slide 21, e o encerramento é o slide 22. Os slides explicam o trabalho; aqui só se mostra rodando. Na demo só os arquivos `01_ddl.sql`, `02_migracao.sql` e `03_prova_sem_perda.sql` são executados; os demais são abertos e mostrados. Cada pessoa aparece uma vez só.

| Tempo | Quem executa | Passo | O que mostrar |
|-------|--------------|-------|---------------|
| 0:00 | Clecio | Abrir o repositório no GitHub | Pasta `equipe-4-eventos`, README e `dicionario_dados.md` |
| 1:00 | Raymond | Banco limpo: rodar `00_planilha.sql` | Tabelas `planilha` (9 linhas), `planilha_fnbc` (7) e `planilha_4fn` (8) |
| 2:00 | Vitor | Rodar `01_ddl.sql` (3FN) | Tabelas criadas, PKs e FKs |
| 3:00 | Marcos | Rodar `02_migracao.sql` (3FN) | Contagens: participante 4, email 6, categoria 2, oficina 4, inscricao 4, inscricao_oficina 9 |
| 4:00 | Eluana | Rodar `03_prova_sem_perda.sql` (3FN) | Linhas originais, reconstruídas, faltando e sobrando (faltando = 0 e sobrando = 0) |
| 5:30 | Denys | FNBC completa: problema, DDL, migração e prova | mentor 4, participante_mentor 7; prova sem perda |
| 7:00 | Tais | 4FN completa: problema, DDL, migração e prova | palestrante_tema 5, palestrante_idioma 5; o JOIN reconstrói as 8 linhas |

## Antes de começar
- Computador do apresentador com MySQL aberto (Workbench ou terminal) e a pasta `equipe-4-eventos` aberta.
- Conferir a versão do MySQL (o EXCEPT da prova exige 8.0.31 ou superior).
- Ter prints de reserva dos resultados, caso algo falhe ao vivo.

## Se algo der errado
- Erro ao rodar um script: rodar `00_planilha.sql` de novo (ele apaga e recria o banco) e repetir a partir do banco limpo.
- Sem tempo: pular direto para a prova sem perda de cada forma normal.
- MySQL travou: usar os prints de reserva.

## Checklist final (Fase 3)

### Arquivos na pasta `equipe-4-eventos`
- [ ] README (anomalias e dependências funcionais)
- [ ] `modelo_conceitual.png` (Peter Chen)
- [ ] `modelo_logico.png` (James Martin, pé de galinha)
- [ ] `dicionario_dados.md`
- [ ] `01_ddl.sql`
- [ ] `02_migracao.sql` (só INSERT ... SELECT)
- [ ] `03_prova_sem_perda.sql`

### Teste do zero
- [ ] Banco limpo com `00_planilha.sql`
- [ ] `01_ddl.sql` roda sem erro
- [ ] `02_migracao.sql` roda sem erro
- [ ] `03_prova_sem_perda.sql`: faltando = 0 e sobrando = 0 nas 3 planilhas
- [ ] Contagens conferem com as esperadas

### GitHub
- [ ] Cada pessoa tem pelo menos 3 commits na própria branch
- [ ] Cada pessoa abriu o seu Pull Request
- [ ] Nenhum PR foi mesclado com Squash (usar Merge pull request)
- [ ] Todos os PRs foram mesclados
- [ ] O `00_planilha.sql` não foi alterado

### Apresentação
- [ ] Slides prontos
- [ ] Ensaio feito com o tempo cronometrado
- [ ] Cada pessoa sabe qual parte vai falar
