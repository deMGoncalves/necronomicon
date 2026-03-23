---
titulo: CDD — Cognitive-Driven Development
aliases:
  - Cognitive-Driven Development
  - Desenvolvimento Orientado à Cognição
  - CDD
tipo: moc
tags: [cdd, moc, complexidade-cognitiva, icp, code-review]
criado: 2026-03-23
---

# CDD — Cognitive-Driven Development

*Cognitive-Driven Development — Zup Innovation (2020)*

> "O código é lido 10 vezes mais do que é escrito. Otimize para o leitor, não para o escritor."

CDD (Cognitive-Driven Development) é uma metodologia de desenvolvimento e revisão de código focada na **carga cognitiva** que o código impõe ao desenvolvedor que precisa lê-lo, entendê-lo e modificá-lo. Criada pela **Zup Innovation** (Brasil), fundamenta-se na psicologia cognitiva de **George Miller** (Lei dos 7 ± 2) e na **Teoria da Carga Cognitiva** de John Sweller.

A premissa central: a mente humana processa entre 5 e 9 *chunks* de informação simultaneamente. Código que excede essa capacidade força o desenvolvedor a construir modelos mentais incompletos, aumentando o risco de bugs e o custo de manutenção.

---

## Por onde começar

- [[metodologia-cdd|Metodologia CDD]] — os princípios e pilares da abordagem
- [[calculo-icp|Cálculo de ICP]] — a métrica central: o que mede e como calcular
- [[fundamentos-carga-cognitiva|Fundamentos de Carga Cognitiva]] — a base teórica em psicologia cognitiva

---

## Fundamentos Teóricos

> A base científica que justifica por que carga cognitiva importa para qualidade de código.

| Conceito | Descrição |
|---|---|
| [[fundamentos-carga-cognitiva\|Fundamentos de Carga Cognitiva]] | Lei de Miller, CLT, memória de trabalho e sua relação com código |
| [[metodologia-cdd\|Metodologia CDD]] | Princípios, pilares, camadas de análise e implementação em times |

---

## ICP — Intrinsic Complexity Points

> A métrica composta `ICP = CC_base + Aninhamento + Responsabilidades + Acoplamento` quantifica a carga cognitiva intrínseca de uma unidade de código.

| Componente | Descrição |
|---|---|
| [[calculo-icp\|Cálculo de ICP]] | Fórmula completa, tabelas de referência e exemplos graduais |
| [[componente-cc-base\|CC_base — Complexidade Ciclomática]] | Caminhos independentes de execução e pontos de decisão |
| [[componente-aninhamento\|Aninhamento]] | Profundidade de indentação e como guard clauses reduzem ICP |
| [[componente-responsabilidades\|Responsabilidades]] | Violações de SRP e as 8 dimensões de responsabilidade |
| [[componente-acoplamento\|Acoplamento]] | Dependências externas diretas e estratégias de inversão |

---

## Aplicação Prática

> Como usar o CDD no dia a dia de desenvolvimento e revisão de código.

| Conceito | Descrição |
|---|---|
| [[aplicacao-code-review\|Aplicação em Code Review]] | O processo de 3 passos: varredura, análise profunda e calibração |

---

## Limites de ICP

| ICP | Status | Ação |
|-----|--------|------|
| ≤ 3 | 🟢 Excelente | Manter — código com carga cognitiva mínima |
| 4–6 | 🟡 Aceitável | Considerar refatoração na próxima oportunidade |
| 7–10 | 🟠 Preocupante | Refatoração recomendada antes de nova feature |
| > 10 | 🔴 Crítico | Refatoração obrigatória — risco alto de bug em manutenção |

**Meta de projeto:** ICP médio ≤ 4, com 0% dos métodos com ICP > 10.

---

## Armadilhas

- **Perfeccionismo Paralisante** — bloquear PRs por ICP ligeiramente elevado em código de baixo risco
- **Rigidez de Rules** — aplicar limites de ICP sem considerar tipo de PR, urgência ou contexto
- **Análise Superficial** — focar em formatação sem analisar a carga cognitiva real do código
- **Falta de Pragmatismo** — exigir ICP = 1 em código que é inerentemente complexo por sua natureza

---

## Leituras Externas

- [Cognitive-Driven Development (CDD)](https://zup.com.br/blog/cognitive-driven-development-cdd/) — Zup Innovation
- [The Magical Number Seven, Plus or Minus Two — George Miller (1956)](https://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two) — a base da Lei de Miller
- [Cognitive Load Theory — John Sweller](https://en.wikipedia.org/wiki/Cognitive_load) — a teoria que fundamenta o CDD

## Ver Também

- [[clean-code|Clean Code]] — as 19 regras de código limpo que reduzem ICP na prática
- [[anti-patterns|Anti-Patterns]] — padrões negativos com alto impacto em ICP
- [[solid|SOLID]] — princípios de design que naturalmentereduzem Responsabilidades e Acoplamento no ICP
