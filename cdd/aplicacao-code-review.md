---
titulo: Aplicação do CDD em Code Review
aliases:
  - CDD em Code Review
  - Code Review com CDD
  - Processo de Code Review CDD
tipo: conceito
origem: cdd
tags:
  - cdd
  - code-review
  - icp
  - processo
relacionados:
  - "[[metodologia-cdd]]"
  - "[[calculo-icp]]"
  - "[[fundamentos-carga-cognitiva]]"
criado: 2026-03-23
---

# Aplicação do CDD em Code Review

*Code Review com CDD — O Processo de 3 Passos*

---

## Definição

O CDD fornece um **processo estruturado de 3 passos** para conduzir code reviews com foco em carga cognitiva — substituindo a revisão subjetiva ("esse código está confuso") por uma avaliação objetiva ("esse método tem ICP = 8, o que viola o limite de 5").

## Por que o Code Review Precisa de Estrutura

Sem estrutura, code reviews tendem a:
- Focar em estilo e formatação em vez de carga cognitiva real
- Gerar debates subjetivos sem consenso
- Aprovar código com ICP alto por pressão de prazo
- Bloquear PRs pequenos por perfeccionismo desnecessário

O processo CDD resolve isso com **critérios objetivos** e **tempo estruturado**.

---

## O Processo de 3 Passos

### Passo 1 — Varredura Rápida (2–5 minutos)

**Objetivo:** Identificar os problemas mais óbvios sem análise profunda.

**O que verificar:**
- Arquivos ou funções com mais de 20–30 linhas (candidatos a ICP alto)
- Estruturas com 3+ níveis de aninhamento visíveis (Aninhamento ≥ 3)
- Anti-patterns conhecidos: [[anti-patterns/the-blob|The Blob]], [[anti-patterns/pyramid-of-doom|Pyramid of Doom]], [[anti-patterns/callback-hell|Callback Hell]]
- Violações óbvias de rules críticas: nomes enganosos, `eval`, imports relativos com `../`

**Sinal de alerta:** Se a varredura rápida já revela múltiplos problemas, a análise profunda será necessária.

**Output:** Lista de arquivos e funções que precisam de análise profunda.

---

### Passo 2 — Análise Profunda (10–20 minutos)

**Objetivo:** Calcular o ICP dos métodos candidatos e verificar conformidade com rules.

#### Calcular ICP

Para cada método identificado na varredura:

```
ICP = CC_base + Aninhamento + Responsabilidades + Acoplamento
```

**Checklist de cálculo:**

- [ ] Contar pontos de decisão (`if`, `for`, `&&`, `catch`, `?`) → CC → CC_base
- [ ] Identificar profundidade máxima de aninhamento → Pontos de Aninhamento
- [ ] Identificar as 8 dimensões de responsabilidade presentes → Pontos de Responsabilidades
- [ ] Contar dependências externas distintas → Pontos de Acoplamento

#### Verificar Rules

Para cada arquivo modificado, verificar:

**Estruturais (sempre verificar):**
- [ ] Nomes revelam intenção? ([[proibicao-nomes-enganosos]], [[nomes-classes-metodos-consistentes]])
- [ ] Ausência de constantes mágicas? ([[proibicao-constantes-magicas]])
- [ ] Imports usando path aliases? ([[restricao-imports-relativos]])

**Comportamentais (verificar em código de domínio):**
- [ ] Funções são puras ou claramente Commands? ([[restricao-funcoes-efeitos-colaterais]])
- [ ] Queries não alteram estado? ([[conformidade-principio-inversao-consulta]])
- [ ] Promises todas tratadas? ([[tratamento-excecao-assincrona]])

**Críticas (bloqueadoras):**
- [ ] Ausência de `eval`? ([[proibicao-funcoes-inseguras]])
- [ ] Exceções de domínio em vez de `return null`? ([[qualidade-tratamento-erros-dominio]])
- [ ] Cobertura de testes ≥ 85% no domínio? ([[cobertura-teste-minima-qualidade]])

**Output:** Comentários objetivos no PR com ICP calculado e rule violada.

---

### Passo 3 — Calibração Contextual (5 minutos)

**Objetivo:** Decidir a ação com base no contexto real — não apenas nas métricas.

**Fatores de calibração:**

| Fator | ICP Alto Pode Ser Aceito Se... |
|---|---|
| **Tipo de PR** | Hotfix crítico em produção instável |
| **Frequência de mudança** | Código raramente modificado (ex.: parsers legados) |
| **Complexidade inerente** | Domínio de negócio genuinamente complexo |
| **Dívida registrada** | Equipe já sabe e tem refatoração agendada |
| **Cobertura de testes** | ICP = 7 mas cobertura = 95% — risco mitigado |

**Escala de ação:**

| ICP | Contexto | Ação |
|-----|----------|------|
| ≤ 5 | Qualquer | ✅ Aprovar |
| 6–7 | Feature normal | 🔄 Pedir refatoração antes do merge |
| 6–7 | Hotfix crítico | ✅ Aprovar + registrar dívida técnica |
| 8–10 | Qualquer | 🔄 Pedir refatoração — ICP preocupante |
| > 10 | Qualquer | 🚫 Bloquear — refatoração obrigatória |

---

## Exemplos de Comentários CDD em PRs

### Comentário Objetivante (❌ Subjetivo → ✅ Objetivo)

```markdown
❌ "Esse código está muito complexo e difícil de entender."

✅ "Este método tem ICP = 8 (CC=3, Aninhamento=3, Responsabilidades=1, Acoplamento=1).
   O aninhamento de 4 níveis (if > if > for > if) excede o limite de 3.
   Sugestão: aplicar Guard Clauses para linearizar o fluxo:
   https://refactoring.com/catalog/replaceNestedConditionalWithGuardClauses.html"
```

### Comentário de Aprovação com Ressalva

```markdown
"ICP = 6 — acima do ideal (5), mas aceitável dado o contexto de hotfix.
 Por favor, crie uma issue para refatorar `processPayment()` na próxima sprint."
```

### Comentário de Rule Violation

```markdown
"Violação de CC-07 (Qualidade do Tratamento de Erros):
 A linha 42 retorna `null` em vez de lançar `OrderNotFoundError`.
 Clientes precisarão verificar null em todos os pontos de uso — spread de complexidade."
```

---

## Checklist Rápido de Code Review CDD

```markdown
## Varredura Rápida
- [ ] Nenhum método com > 20 linhas sem justificativa
- [ ] Nenhum aninhamento visível com 4+ níveis
- [ ] Nenhum anti-pattern óbvio (Blob, Pyramid of Doom)

## ICP (para métodos suspeitos)
- [ ] CC_base ≤ 2 (CC ≤ 10) — ideal: CC ≤ 5
- [ ] Aninhamento ≤ 1 ponto (profundidade ≤ 2)
- [ ] Responsabilidades ≤ 1 ponto (≤ 3 dimensões)
- [ ] Acoplamento ≤ 1 ponto (≤ 5 dependências)
- [ ] ICP Total ≤ 5

## Rules Críticas
- [ ] Sem `eval` ou `new Function`
- [ ] Sem `return null` em código de domínio
- [ ] Todas as Promises tratadas com `await` ou `.catch()`
- [ ] Sem imports com `../`
- [ ] Cobertura de testes ≥ 85% no domínio
```

---

## Anti-Padrões de Code Review

### Bloquear Sem Alternativa

❌ "Refatore isso." (sem sugestão de como)
✅ "ICP = 9. Extraia `validateCheckoutData()` e `buildOrderFromCart()` para reduzir para ICP ≤ 5."

### Focar em Estilo, Ignorar Substância

❌ Comentar apenas sobre formatação e nomes sem calcular ICP em código complexo
✅ Calcular ICP em qualquer método com > 10 linhas ou aninhamento visível

### Calibração Inflexível

❌ Reprovar todo PR com ICP > 5, independente do contexto
✅ Aplicar o Passo 3 (calibração) antes de bloquear — hotfixes merecem tratamento diferente

## Relacionados

- [[metodologia-cdd]] — a metodologia completa e seus princípios
- [[calculo-icp]] — como calcular o ICP que alimenta o processo
- [[fundamentos-carga-cognitiva]] — por que a carga cognitiva importa
- [[clean-code|Clean Code]] — as rules verificadas no Passo 2
