---
name: software-quality
description: "Modelo de Qualidade McCall com 12 fatores organizados em Operação, Revisão e Transição. Use quando @architect calibra severidade de violações, define critérios de aceitação, ou @tester planeja cobertura de testes."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Qualidade de Software (Modelo McCall)

O modelo de qualidade McCall organiza 12 fatores em 3 dimensões para avaliar excelência de software: **Operação** (uso diário), **Revisão** (facilidade de modificação) e **Transição** (movimentação entre ambientes).

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao calibrar severidade de violações de rules; ao definir critérios de aceitação de features; ao planejar cobertura de testes; ao avaliar PRs que degradam qualidade |
| **Prerequisites** | Familiaridade com as 70 rules deMGoncalves; conceitos básicos de métricas de qualidade de software |
| **Constraints** | Integrity é SEMPRE 🔴 Blocker — nunca ignorar; Testability < 2 impede merge; não usar como substituto das 70 rules — é uma camada de calibração de severidade sobre elas |
| **Scope** | 12 fatores McCall (Correctness, Reliability, Efficiency, Integrity, Usability, Adaptability, Maintainability, Flexibility, Testability, Portability, Reusability, Interoperability) com sistema de pontuação 1–5 |

---

## Quando Usar

| Agente | Situação | Ação |
|--------|----------|------|
| @architect | Encontrou violação de rule | Calibrar severidade baseado no fator de qualidade impactado |
| @architect | Definindo critérios de aceitação | Especificar pontuações esperadas de qualidade por fator |
| @tester | Planejando testes | Priorizar cobertura em fatores críticos (Correctness, Reliability, Integrity, Testability) |
| @coder | Refatorando código | Melhorar fatores com pontuação < 3.0 |
| Tech Lead | Avaliando PR | Rejeitar PRs que degradam fatores críticos |

## 12 Fatores por Dimensão

| Fator | Dimensão | Pergunta-Chave | Severidade | Arquivo |
|-------|----------|----------------|------------|---------|
| **Correctness** | Operação | Faz o que é esperado? | 🔴 Crítica | [correctness.md](references/correctness.md) |
| **Reliability** | Operação | É preciso? | 🔴 Crítica | [reliability.md](references/reliability.md) |
| **Efficiency** | Operação | É performático? | 🟠 Importante | [efficiency.md](references/efficiency.md) |
| **Integrity** | Operação | É seguro? | 🔴 Crítica | [integrity.md](references/integrity.md) |
| **Usability** | Operação | É fácil de usar? | 🟡 Sugestão | [usability.md](references/usability.md) |
| **Adaptability** | Operação | É configurável? | 🟠 Importante | [adaptability.md](references/adaptability.md) |
| **Maintainability** | Revisão | É fácil de corrigir? | 🟠 Importante | [maintainability.md](references/maintainability.md) |
| **Flexibility** | Revisão | É fácil de mudar? | 🟠 Importante | [flexibility.md](references/flexibility.md) |
| **Testability** | Revisão | É testável? | 🔴 Crítica | [testability.md](references/testability.md) |
| **Portability** | Transição | É portável? | 🟡 Sugestão | [portability.md](references/portability.md) |
| **Reusability** | Transição | É reutilizável? | 🟠 Importante | [reusability.md](references/reusability.md) |
| **Interoperability** | Transição | Integra bem? | 🟠 Importante | [interoperability.md](references/interoperability.md) |

## Qual Fator Avaliar?

| Situação no Code Review | Fator Relevante |
|-------------------------|-----------------|
| Bug de lógica ou caso edge não tratado | Correctness |
| Promise sem `.catch()`, erro não tratado | Reliability |
| Loop O(n²) desnecessário, N+1 queries | Efficiency |
| SQL injection, XSS, senha sem hash | **Integrity (SEMPRE 🔴)** |
| Mensagem de erro genérica, sem feedback | Usability |
| Timeout hardcoded, texto sem i18n | Adaptability |
| Classe god, função > 20 linhas, sem logs | Maintainability |
| Switch crescente, `new Concrete()` em service | Flexibility |
| Dependência concreta interna, singleton | Testability |
| Path absoluto, comando shell específico | Portability |
| Código duplicado, componente muito específico | Reusability |
| Formato proprietário, API sem versão | Interoperability |

## Sistema de Pontuação

**Avalie cada fator de 1 a 5:**

| Pontuação | Significado | Ação |
|-----------|-------------|------|
| 5 | Excelente | Manter |
| 4 | Bom | Melhorias opcionais |
| 3 | Adequado | Considerar refatoração |
| 2 | Problemático | Refatoração recomendada |
| 1 | Crítico | Refatoração obrigatória |

**Pontuação Geral de Qualidade:**
```
Pontuação de Qualidade = (Σ pontuações dos 12 fatores) / 12

≥ 4.0: 🟢 Alta Qualidade
3.0-3.9: 🟡 Qualidade Aceitável
2.0-2.9: 🟠 Baixa Qualidade
< 2.0: 🔴 Qualidade Crítica (refatoração urgente)
```

## Proibições

- **NUNCA** aceitar código que viola **Integrity** — SEMPRE 🔴 Blocker
- **NUNCA** aceitar código impossível de testar (Testability < 2)
- **NUNCA** aceitar código que não faz o que é esperado (Correctness < 3)
- **NUNCA** ignorar erros não tratados (Reliability < 3)

## Justificativa

| Fator de Qualidade | Rules Relacionadas (principais) |
|--------------------|--------------------------------|
| Correctness | 027 (Error Handling), 028 (Async Exceptions), 002 (No Else) |
| Reliability | 027, 028, 036 (Side Effects) |
| Efficiency | 022 (KISS), 001 (Indentation), 055 (Long Method) |
| Integrity | 030 (Insecure Functions), 042 (Config via Env) |
| Usability | 006 (No Abbreviations), 034 (Naming), 026 (Comments) |
| Adaptability | 042 (Config via Env), 024 (Magic Constants), 011 (OCP) |
| Maintainability | 010 (SRP), 007 (Max Lines), 025 (No Blob) |
| Flexibility | 011 (OCP), 014 (DIP), 018 (Acyclic Dependencies) |
| Testability | 014 (DIP), 032 (Test Coverage), 036 (Side Effects) |
| Portability | 042 (Config via Env), 041 (Dependencies) |
| Reusability | 021 (DRY), 003 (Encapsulation), 010 (SRP) |
| Interoperability | 043 (Backing Services), 014 (DIP) |

**Skills relacionadas:**
- [`codetags`](../codetags/SKILL.md) — depende: severidade McCall (Integrity→FIXME, Efficiency→OPTIMIZE) mapeia para codetags
- [`cdd`](../cdd/SKILL.md) — complementa: CDD quantifica Maintainability e Testability do Modelo McCall

---

**Referências:**
- McCall, J.A., Richards, P.K., & Walters, G.F. (1977). "Factors in Software Quality"
- ISO/IEC 25010:2011 - Systems and software Quality Requirements and Evaluation (SQuaRE)

**Criada em**: 2026-04-01
**Versão**: 1.0
