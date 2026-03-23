---
titulo: Anti-Patterns
aliases:
  - "Anti-Patterns"
  - "AntiPatterns"
tipo: moc
tags: [anti-pattern, moc]
criado: 2026-03-20
---

# Anti-Patterns

*AntiPatterns — Brown, Malveau, McCormick, Mowbray (1998)*

> Anti-patterns são soluções recorrentes para problemas comuns que parecem razoáveis mas produzem consequências negativas. Diferem de simples bugs: são abordagens sistematicamente ruins, com nome, contexto e solução documentados.

O termo foi cunhado por **Andrew Koenig** (1995) e sistematizado no livro **"AntiPatterns"** (1998) — o equivalente ao GoF para padrões problemáticos. **Martin Fowler** complementou em **"Refactoring"** (1999/2018) com os *Code Smells*, sintomas que indicam anti-patterns no código.

---

## Por onde começar

- [[the-blob]] — o anti-pattern mais destrutivo: uma classe que controla tudo
- [[spaghetti-code]] — código sem estrutura: o anti-pattern mais antigo
- [[pyramid-of-doom]] — aninhamento excessivo: o mais fácil de identificar visualmente

---

## AntiPatterns (Brown et al., 1998)

> Problemas recorrentes em design e arquitetura de software, identificados e nomeados como padrões negativos.

| Severidade | Anti-Pattern |
|---|---|
| 🔴 Crítico | [[the-blob\|The Blob (God Object)]] |
| 🔴 Crítico | [[spaghetti-code\|Spaghetti Code]] |
| 🟠 Alto | [[lava-flow\|Lava Flow (Código Morto)]] |
| 🟠 Alto | [[golden-hammer\|Golden Hammer (Solução Universal)]] |
| 🟠 Alto | [[cut-and-paste-programming\|Cut-and-Paste Programming]] |
| 🟡 Médio | [[boat-anchor\|Boat Anchor (Âncora de Barco)]] |
| 🟡 Médio | [[poltergeists\|Poltergeists (Classes Fantasma)]] |

---

## Code Smells (Fowler, Refactoring — 1999/2018)

> Sintomas no código que indicam problemas de design mais profundos. Não são bugs — são sinais de que uma refatoração é necessária.

| Severidade | Anti-Pattern |
|---|---|
| 🟠 Alto | [[long-method\|Long Method (Método Longo)]] |
| 🟠 Alto | [[large-class\|Large Class (Classe Grande)]] |
| 🟠 Alto | [[shotgun-surgery\|Shotgun Surgery (Cirurgia de Espingarda)]] |
| 🟠 Alto | [[divergent-change\|Divergent Change (Mudança Divergente)]] |
| 🟡 Médio | [[feature-envy\|Feature Envy (Inveja de Funcionalidade)]] |
| 🟡 Médio | [[primitive-obsession\|Primitive Obsession (Obsessão por Primitivos)]] |
| 🟡 Médio | [[speculative-generality\|Speculative Generality (Generalidade Especulativa)]] |
| 🟡 Médio | [[refused-bequest\|Refused Bequest (Herança Recusada)]] |
| 🟡 Médio | [[middle-man\|Middle Man (Intermediário Inútil)]] |
| 🟡 Médio | [[data-clumps\|Data Clumps (Aglomerados de Dados)]] |
| 🟡 Médio | [[message-chains\|Message Chains (Cadeia de Mensagens)]] |

---

## Gerais / Clean Code (Martin, 2008)

> Anti-patterns amplamente reconhecidos sem uma origem única, ou derivados diretamente dos princípios do Clean Code.

| Severidade | Anti-Pattern |
|---|---|
| 🟠 Alto | [[overengineering\|Overengineering (Complexidade Desnecessária)]] |
| 🟠 Alto | [[clever-code\|Clever Code (Código Inteligente)]] |
| 🟠 Alto | [[callback-hell\|Callback Hell (Inferno de Callbacks)]] |
| 🟠 Alto | [[pyramid-of-doom\|Pyramid of Doom (Pirâmide da Perdição)]] |
| 🟠 Alto | [[shared-mutable-state\|Shared Mutable State (Estado Mutável Compartilhado)]] |
| 🟠 Alto | [[accidental-mutation\|Accidental Mutation (Mutação Acidental)]] |
| 🟡 Médio | [[premature-optimization\|Premature Optimization (Otimização Prematura)]] |

---

## Armadilhas

- **Nomear sem entender** — chamar qualquer código ruim de "anti-pattern" dilui o conceito
- **Refatoração por princípio** — refatorar um anti-pattern sem entender o contexto pode introduzir outro
- **Análise paralisante** — identificar anti-patterns não é o mesmo que corrigi-los; o valor está na refatoração

## Leituras Externas

- [AntiPatterns — Brown, Malveau, McCormick, Mowbray (1998)](https://www.oreilly.com/library/view/antipatterns-refactoring-software/0471197130/) — a referência canônica
- [Refactoring — Martin Fowler (2018)](https://refactoring.com/) — catálogo de Code Smells e suas refatorações

## Ver também

- [[clean-code]] — rules que previnem os anti-patterns listados aqui
- [[solid]] — princípios que eliminam categorias inteiras de anti-patterns estruturais
- [[object-calisthenics]] — exercícios práticos que tornam anti-patterns impossíveis de cometer
