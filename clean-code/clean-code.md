---
titulo: Clean Code
aliases:
  - "Clean Code"
  - "Uncle Bob"
  - "Robert Martin"
tipo: moc
tags: [clean-code, moc]
criado: 2026-03-19
---

# Clean Code

*Clean Code — Robert C. Martin (2008)*

> Princípios e práticas que tornam o código mais legível, manutenível e confiável. Popularizado por Robert C. Martin ("Uncle Bob") em *Clean Code: A Handbook of Agile Software Craftsmanship* (2008).

A premissa central: **código é lido muito mais vezes do que é escrito**. Um código limpo comunica sua intenção com clareza, minimiza a carga cognitiva de quem o lê e reduz o custo de manutenção ao longo do tempo.

---

## Por onde começar

- [[priorizacao-simplicidade-clareza]] — o princípio que governa todos os outros: se está complexo, está errado

---

## Pilares e Rules

### Clareza acima de esperteza

> Código que parece inteligente para quem o escreveu é ilegível para quem mantém. Prefira o óbvio ao engenhoso.

| Severidade | Rule |
|---|---|
| 🟠 Alto | [[priorizacao-simplicidade-clareza\|Priorização de Simplicidade e Clareza (KISS)]] |
| 🟠 Alto | [[imutabilidade-objetos-freeze\|Imutabilidade de Objetos de Domínio]] |
| 🔴 Crítico | [[tratamento-excecao-assincrona\|Tratamento Completo de Exceções Assíncronas]] |
| 🟠 Alto | [[qualidade-tratamento-erros-dominio\|Qualidade do Tratamento de Erros: Use Exceções de Domínio]] |
| 🔴 Crítico | [[proibicao-funcoes-inseguras\|Proibição de Funções Inseguras (eval, new Function)]] |
| 🟡 Médio | [[regra-escoteiro-refatoracao-continua\|Regra do Escoteiro: Refatoração Contínua]] |

### Nomes revelam intenção

> Variáveis, funções e classes devem dizer o que são e o que fazem, eliminando a necessidade de comentários explicativos.

| Severidade | Rule |
|---|---|
| 🔴 Crítico | [[proibicao-constantes-magicas\|Proibição de Constantes Mágicas]] |
| 🟠 Alto | [[nomes-classes-metodos-consistentes\|Nomes Consistentes de Classes e Métodos]] |
| 🔴 Crítico | [[proibicao-nomes-enganosos\|Proibição de Nomes Enganosos]] |
| 🔴 Crítico | [[restricao-imports-relativos\|Proibição de Imports Relativos (Path Aliases Obrigatórios)]] |

### Funções fazem uma coisa

> Uma função bem definida tem uma única responsabilidade, opera em um único nível de abstração e cabe em uma tela.

| Severidade | Rule |
|---|---|
| 🔴 Crítico | [[proibicao-anti-padrao-blob\|Proibição do Anti-Pattern The Blob (God Object)]] |
| 🟠 Alto | [[limite-parametros-funcao\|Limite Máximo de Parâmetros por Função]] |
| 🟠 Alto | [[proibicao-argumentos-sinalizadores\|Proibição de Argumentos Sinalizadores]] |
| 🟠 Alto | [[conformidade-principio-inversao-consulta\|Conformidade com o Princípio CQS]] |
| 🔴 Crítico | [[restricao-funcoes-efeitos-colaterais\|Restrição de Funções com Efeitos Colaterais]] |
| 🟡 Médio | [[proibicao-funcionalidade-especulativa\|Proibição de Funcionalidade Especulativa (YAGNI)]] |
| 🔴 Crítico | [[cobertura-teste-minima-qualidade\|Cobertura Mínima de Testes e Qualidade (TDD)]] |

### Sem duplicação (DRY)

> Cada pedaço de conhecimento deve ter uma representação única e autoritária no sistema.

| Severidade | Rule |
|---|---|
| 🔴 Crítico | [[proibicao-duplicacao-logica\|Proibição de Duplicação de Lógica (DRY)]] |

### Código autodocumentado

> A necessidade de comentar o *quê* é sinal de código obscuro. Comente apenas o *porquê*.

| Severidade | Rule |
|---|---|
| 🟡 Médio | [[qualidade-comentarios-porque\|Qualidade de Comentários: Apenas o Porquê]] |

---

## Armadilhas

- **Perfeccionismo Paralisante** — bloquear PRs por violações menores quando o impacto é baixo
- **Rigidez sem contexto** — aplicar rules sem considerar urgência, tipo de PR ou dívida técnica
- **Renomear sem refatorar** — trocar nomes sem simplificar a lógica por baixo
- **Comentar em vez de refatorar** — adicionar comentários em código complexo em vez de simplificá-lo

## Leituras Externas

- [Clean Code — Robert C. Martin](https://www.oreilly.com/library/view/clean-code-a/9780136083238/) — o livro que originou o termo
- [Refactoring — Martin Fowler](https://refactoring.com/) — catálogo de técnicas para reduzir ICP na prática

## Ver também

- [[solid]] — princípios SOLID complementam o Clean Code no design de classes e módulos
- [[object-calisthenics]] — exercícios práticos que reforçam as rules de Clean Code
- [[twelve-factor]] — boas práticas de infraestrutura alinhadas com a filosofia de código limpo
- [[gof]] — padrões de design que emergem naturalmente de código bem estruturado
