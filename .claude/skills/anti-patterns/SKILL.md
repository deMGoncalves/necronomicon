---
name: anti-patterns
description: "Catálogo de 26 anti-patterns com sintomas e refactorings. Use quando @architect identificar code smells relacionados às rules 052-070, ou @coder quiser entender o que evitar."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Code review por @architect; análise de code smells; discussões sobre qualidade de design; anotação de violações em PR |
| **Prerequisites** | Familiaridade com as rules 052-070; capacidade de identificar sintomas estruturais e comportamentais no código |
| **Constraints** | Não usar como desculpa para reescrever código funcional; priorizar anti-patterns críticos antes dos de média severidade |
| **Scope** | Catálogo de 26 anti-patterns mapeados às rules do projeto, com sintomas, exemplos e estratégias de refactoring |

---

## Quando Usar

Use anti-patterns quando precisar:
- **Identificar code smells** em code review por padrões conhecidos
- **Entender sintomas** de problemas de design sem análise profunda
- **Sugerir refactorings** baseados em padrões documentados
- **Mapear rules para anti-patterns** (rules 052-070 são anti-patterns)

Gatilhos específicos:
- @architect identifica problema mas não sabe como nomear
- @coder pergunta "o que há de errado neste código?"
- Discussão sobre "código ruim" sem diagnóstico específico
- Necessidade de referenciar padrões negativos conhecidos em comentários de PR

---

## Índice de Anti-Patterns (26 total)

### 🔴 Críticos (Bloqueadores)

| Pattern | Rule | Sintoma Principal | Arquivo |
|---------|------|-------------------|---------|
| **The Blob** | 025 | Classe que faz tudo — centenas de linhas | [[the-blob.md]] |
| **Spaghetti Code** | 060 | Fluxo de controle caótico — impossível seguir | [[spaghetti-code.md]] |
| **Shared Mutable State** | 070 | Múltiplos módulos mutam mesmo objeto | [[shared-mutable-state.md]] |
| **Primitive Obsession** | 003 | String/number ao invés de Value Object | [[primitive-obsession.md]] |

### 🟠 Alta (Requerem Justificativa)

| Pattern | Rule | Sintoma Principal | Arquivo |
|---------|------|-------------------|---------|
| **Long Method** | 055 | Método com > 20 linhas, múltiplas responsabilidades | [[long-method.md]] |
| **Large Class** | 007 | Classe com > 300 linhas, muitos atributos | [[large-class.md]] |
| **Divergent Change** | 054 | Uma classe muda por N razões diferentes | [[divergent-change.md]] |
| **Shotgun Surgery** | 058 | Uma mudança requer alterar N arquivos | [[shotgun-surgery.md]] |
| **Lava Flow** | 056 | Código morto, funções nunca chamadas | [[lava-flow.md]] |
| **Accidental Mutation** | 052 | Função muta parâmetro sem intenção explícita | [[accidental-mutation.md]] |
| **Callback Hell** | 063 | Aninhamento excessivo de callbacks assíncronos | [[callback-hell.md]] |
| **Pyramid of Doom** | 066 | Aninhamento excessivo de if/else/loops | [[pyramid-of-doom.md]] |
| **Clever Code** | 062 | Código "inteligente" — legibilidade sacrificada | [[clever-code.md]] |
| **Overengineering** | 064 | Solução complexa demais para problema simples | [[overengineering.md]] |
| **Cut-and-Paste** | 021 | Código duplicado por cópia | [[cut-and-paste-programming.md]] |
| **Golden Hammer** | 068 | Mesma ferramenta para todos os problemas | [[golden-hammer.md]] |

### 🟡 Média (Melhorias Esperadas)

| Pattern | Rule | Sintoma Principal | Arquivo |
|---------|------|-------------------|---------|
| **Feature Envy** | 057 | Método usa dados de outra classe mais que os próprios | [[feature-envy.md]] |
| **Data Clumps** | 053 | Grupos de dados sempre juntos sem objeto próprio | [[data-clumps.md]] |
| **Message Chains** | 005 | `a.getB().getC().getD()` — train wreck | [[message-chains.md]] |
| **Middle Man** | 061 | Classe que só delega, sem valor próprio | [[middle-man.md]] |
| **Refused Bequest** | 059 | Subclasse recusa métodos herdados | [[refused-bequest.md]] |
| **Speculative Generality** | 023 | Código para casos hipotéticos | [[speculative-generality.md]] |
| **Poltergeists** | 065 | Classes de vida curta, sem estado real | [[poltergeists.md]] |
| **Boat Anchor** | 067 | Dependência instalada mas nunca usada | [[boat-anchor.md]] |
| **Premature Optimization** | 069 | Otimização sem medir necessidade | [[premature-optimization.md]] |

---

## Como Usar em Code Review

### Passo 1 — Identificar Sintomas

Ler o código procurando por sintomas em cada categoria:
- **Estruturais:** Long Method, Large Class, Data Clumps
- **Comportamentais:** Feature Envy, Divergent Change, Shotgun Surgery
- **Manutenção:** Lava Flow, Boat Anchor, Speculative Generality

### Passo 2 — Nomear o Pattern

Usar a tabela acima para nomear o pattern:
```markdown
❌ "Este código está confuso."
✅ "Este código exibe **Pyramid of Doom** (Rule 066): 4 níveis de aninhamento.
   Refactoring sugerido: Guard Clauses para linearizar fluxo."
```

### Passo 3 — Sugerir Refactoring

Cada arquivo de referência contém:
- ❌ Exemplo problemático
- ✅ Exemplo refatorado
- Estratégias de refactoring (Extract Method, Extract Class, etc.)

---

## Mapeamento Rules → Anti-Patterns

| Rule | Anti-Pattern | Descrição |
|------|--------------|-----------|
| 003 | Primitive Obsession | String/number ao invés de Value Object |
| 005 | Message Chains | Encadeamento excessivo de chamadas |
| 007 | Large Class | Classe com > 50 linhas |
| 021 | Cut-and-Paste Programming | Duplicação de código |
| 023 | Speculative Generality | Código para casos hipotéticos |
| 025 | The Blob | God Object — classe que faz tudo |
| 052 | Accidental Mutation | Mutação acidental de parâmetros |
| 053 | Data Clumps | Grupos de dados sem objeto próprio |
| 054 | Divergent Change | Uma classe, N razões para mudar |
| 055 | Long Method | Método com > 20 linhas |
| 056 | Lava Flow | Código morto, nunca chamado |
| 057 | Feature Envy | Método inveja dados de outra classe |
| 058 | Shotgun Surgery | Uma mudança, N arquivos afetados |
| 059 | Refused Bequest | Subclasse recusa herança |
| 060 | Spaghetti Code | Fluxo de controle caótico |
| 061 | Middle Man | Classe que só delega |
| 062 | Clever Code | Código "inteligente" ilegível |
| 063 | Callback Hell | Callbacks aninhados (assíncrono) |
| 064 | Overengineering | Complexidade desnecessária |
| 065 | Poltergeists | Classes fantasma, vida curta |
| 066 | Pyramid of Doom | Aninhamento excessivo (síncrono) |
| 067 | Boat Anchor | Dependência não usada |
| 068 | Golden Hammer | Mesma ferramenta para tudo |
| 069 | Premature Optimization | Otimização sem medição |
| 070 | Shared Mutable State | Estado mutável compartilhado |

---

## Proibições

- Não chamar qualquer código ruim de "anti-pattern" sem identificar o pattern específico
- Não refatorar anti-pattern sem entender contexto — pode introduzir outro
- Não usar anti-patterns como desculpa para reescrever código — refatorar incrementalmente
- Não focar em anti-patterns de baixa severidade enquanto ignora os críticos

---

## Justificativa

**Origem:**
- **AntiPatterns (1998)** — Brown, Malveau, McCormick, Mowbray
- **Refactoring (1999/2018)** — Martin Fowler (Code Smells)
- **Clean Code (2008)** — Robert C. Martin

**Por que nomear importa:**
- Linguagem comum para discutir problemas de design
- Padrões negativos têm soluções documentadas e testadas
- Facilita code reviews: "isso é Middle Man" comunica mais que "código confuso"
- Previne recorrência: uma vez identificado, time reconhece em código futuro

**Related skills:**
- [`clean-code`](../clean-code/SKILL.md) — complementa: anti-patterns são violações de práticas Clean Code
- [`codetags`](../codetags/SKILL.md) — depende: violações de anti-patterns são anotadas com codetags pelo @architect

**Referências:**
- [AntiPatterns Book (1998)](https://www.oreilly.com/library/view/antipatterns-refactoring-software/0471197130/)
- [Refactoring (Fowler)](https://refactoring.com/)
- [Code Smells Catalog](https://refactoring.guru/refactoring/smells)
