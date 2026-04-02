---
name: software-quality
description: "McCall Quality Model com 12 fatores organizados em Operação, Revisão e Transição. Use quando @reviewer calibrar severidade de violações, @architect definir critérios de aceite, ou @tester planejar cobertura de testes."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Software Quality (McCall Model)

O modelo de qualidade de McCall organiza 12 fatores em 3 dimensões para avaliar a excelência de software: **Operação** (uso no dia-a-dia), **Revisão** (facilidade de modificação) e **Transição** (movimentação entre ambientes).

## Quando Usar

| Agente | Situação | Ação |
|--------|----------|------|
| @reviewer | Encontrou violação de rule | Calibre severidade com base no fator de qualidade impactado |
| @architect | Definindo critérios de aceite | Especifique quality scores esperados por fator |
| @tester | Planejando testes | Priorize cobertura em fatores críticos (Correctness, Reliability, Integrity, Testability) |
| @developer | Refatorando código | Melhore fatores com score < 3.0 |
| @leader | Avaliando PR | Rejeite PRs que degradem fatores críticos |

## 12 Fatores por Dimensão

| Fator | Dimensão | Pergunta Chave | Severidade | Arquivo |
|-------|----------|----------------|------------|---------|
| **Correctness** | Operação | Faz o esperado? | 🔴 Critical | [correctness.md](references/correctness.md) |
| **Reliability** | Operação | É preciso? | 🔴 Critical | [reliability.md](references/reliability.md) |
| **Efficiency** | Operação | É performático? | 🟠 Important | [efficiency.md](references/efficiency.md) |
| **Integrity** | Operação | É seguro? | 🔴 Critical | [integrity.md](references/integrity.md) |
| **Usability** | Operação | É fácil de usar? | 🟡 Suggestion | [usability.md](references/usability.md) |
| **Adaptability** | Operação | É configurável? | 🟠 Important | [adaptability.md](references/adaptability.md) |
| **Maintainability** | Revisão | É fácil corrigir? | 🟠 Important | [maintainability.md](references/maintainability.md) |
| **Flexibility** | Revisão | É fácil mudar? | 🟠 Important | [flexibility.md](references/flexibility.md) |
| **Testability** | Revisão | É testável? | 🔴 Critical | [testability.md](references/testability.md) |
| **Portability** | Transição | É portável? | 🟡 Suggestion | [portability.md](references/portability.md) |
| **Reusability** | Transição | É reutilizável? | 🟠 Important | [reusability.md](references/reusability.md) |
| **Interoperability** | Transição | Integra bem? | 🟠 Important | [interoperability.md](references/interoperability.md) |

## Qual Fator Avaliar?

| Situação no Code Review | Fator Relevante |
|-------------------------|-----------------|
| Bug de lógica ou edge case não tratado | Correctness |
| Promise sem `.catch()`, erro não tratado | Reliability |
| Loop O(n²) desnecessário, N+1 queries | Efficiency |
| SQL injection, XSS, senha sem hash | **Integrity (SEMPRE 🔴)** |
| Mensagem de erro genérica, sem feedback | Usability |
| Timeout hardcoded, texto sem i18n | Adaptability |
| God class, função > 20 linhas, sem logs | Maintainability |
| Switch crescente, `new Concrete()` em service | Flexibility |
| Dependência concreta interna, singleton | Testability |
| Path absoluto, comando shell específico | Portability |
| Código duplicado, componente específico demais | Reusability |
| Formato proprietário, API sem versão | Interoperability |

## Scoring System

**Avalie cada fator de 1 a 5:**

| Score | Significado | Ação |
|-------|-------------|------|
| 5 | Excelente | Manter |
| 4 | Bom | Melhorias opcionais |
| 3 | Adequado | Considerar refatoração |
| 2 | Problemático | Refatoração recomendada |
| 1 | Crítico | Refatoração obrigatória |

**Quality Score Geral:**
```
Quality Score = (Σ scores de todos os 12 fatores) / 12

≥ 4.0: 🟢 Alta Qualidade
3.0-3.9: 🟡 Qualidade Aceitável
2.0-2.9: 🟠 Qualidade Baixa
< 2.0: 🔴 Qualidade Crítica (refatoração urgente)
```

## Proibições

- **NUNCA** aceite código que viole **Integrity** — SEMPRE 🔴 Blocker
- **NUNCA** aceite código impossível de testar (Testability < 2)
- **NUNCA** aceite código que não faça o esperado (Correctness < 3)
- **NUNCA** ignore erros não tratados (Reliability < 3)

## Fundamentação

| Quality Factor | Rules Relacionadas (principais) |
|----------------|----------------------------------|
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
- [`cdd`](../cdd/SKILL.md) — complementa: CDD quantifica Maintainability e Testability do McCall Model

---

**Referências:**
- McCall, J.A., Richards, P.K., & Walters, G.F. (1977). "Factors in Software Quality"
- ISO/IEC 25010:2011 - Systems and software Quality Requirements and Evaluation (SQuaRE)

**Criada em**: 2026-04-01
**Versão**: 1.0
