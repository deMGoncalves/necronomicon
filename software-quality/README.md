# Software Quality (McCall Model)

Software Quality é a medida da excelência de um programa, abrangendo critérios essenciais como corretude, confiabilidade, eficácia, integridade e usabilidade. Além disso, inclui a capacidade de adaptação, portabilidade e reusabilidade, assegurando a interoperabilidade e facilitando a manutenção. Sua flexibilidade e testabilidade são fundamentais para garantir um software duradouro e de alto desempenho.

## Overview do Modelo

O modelo de qualidade de McCall organiza **12 fatores** em **3 dimensões**:

```
┌─────────────────────────────────────────────────────────────────┐
│                    SOFTWARE QUALITY                              │
├─────────────────┬─────────────────┬─────────────────────────────┤
│    OPERAÇÃO     │    REVISÃO      │        TRANSIÇÃO            │
│  (Product Use)  │   (Changes)     │    (Environment Move)       │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ • Correctness   │ • Maintainability│ • Portability              │
│ • Reliability   │ • Flexibility    │ • Reusability              │
│ • Efficiency    │ • Testability    │ • Interoperability         │
│ • Integrity     │                  │                             │
│ • Usability     │                  │                             │
│ • Adaptability  │                  │                             │
└─────────────────┴─────────────────┴─────────────────────────────┘
```

## Dimensões

### 1. Operação (Operation) - 6 fatores

Avalia como o software se comporta **em uso**.

| Fator | Arquivo | Pergunta Chave | Severidade |
|-------|---------|----------------|------------|
| Correctness | [001_correctness.md](operation/001_correctness.md) | Faz o esperado? | 🔴 Critical |
| Reliability | [002_reliability.md](operation/002_reliability.md) | É preciso? | 🔴 Critical |
| Efficiency | [003_efficiency.md](operation/003_efficiency.md) | É performático? | 🟠 Important |
| Integrity | [004_integrity.md](operation/004_integrity.md) | É seguro? | 🔴 Critical |
| Usability | [005_usability.md](operation/005_usability.md) | É fácil de usar? | 🟡 Suggestion |
| Adaptability | [006_adaptability.md](operation/006_adaptability.md) | É configurável? | 🟠 Important |

### 2. Revisão (Revision) - 3 fatores

Avalia a **facilidade de modificar** o software.

| Fator | Arquivo | Pergunta Chave | Severidade |
|-------|---------|----------------|------------|
| Maintainability | [001_maintainability.md](revision/001_maintainability.md) | É fácil corrigir? | 🟠 Important |
| Flexibility | [002_flexibility.md](revision/002_flexibility.md) | É fácil mudar? | 🟠 Important |
| Testability | [003_testability.md](revision/003_testability.md) | É testável? | 🔴 Critical |

### 3. Transição (Transition) - 3 fatores

Avalia a **portabilidade** do software.

| Fator | Arquivo | Pergunta Chave | Severidade |
|-------|---------|----------------|------------|
| Portability | [001_portability.md](transition/001_portability.md) | É portável? | 🟡 Suggestion |
| Reusability | [002_reusability.md](transition/002_reusability.md) | É reutilizável? | 🟠 Important |
| Interoperability | [003_interoperability.md](transition/003_interoperability.md) | Integra bem? | 🟠 Important |

## Quality Assessment

### Scoring por Fator

Para cada fator, avalie de 1 a 5:

| Score | Significado | Ação |
|-------|-------------|------|
| 5 | Excelente | Manter |
| 4 | Bom | Pequenas melhorias opcionais |
| 3 | Adequado | Considerar refatoração |
| 2 | Problemático | Refatoração recomendada |
| 1 | Crítico | Refatoração obrigatória |

### Quality Score Geral

```
Quality Score = (Σ scores de todos os fatores) / 12

Score ≥ 4.0: 🟢 Alta Qualidade
Score 3.0-3.9: 🟡 Qualidade Aceitável
Score 2.0-2.9: 🟠 Qualidade Baixa
Score < 2.0: 🔴 Qualidade Crítica
```

## Relação com Rules

| Quality Factor | Rules Relacionadas |
|----------------|-------------------|
| Correctness | clean-code/007 (Error Handling), clean-code/008 (Async Exceptions) |
| Reliability | clean-code/007, clean-code/008, clean-code/016 (Side Effects) |
| Efficiency | clean-code/002 (KISS), object-calisthenics/001 (Indentation) |
| Integrity | clean-code/010 (Insecure Functions), twelve-factor/003 (Config via Env) |
| Usability | object-calisthenics/006 (No Abbreviations), clean-code/014 (Naming) |
| Maintainability | solid/001 (SRP), object-calisthenics/007 (Max Lines), clean-code/005 (No Blob) |
| Flexibility | solid/002 (OCP), solid/005 (DIP) |
| Testability | solid/005 (DIP), clean-code/012 (Test Coverage) |
| Portability | twelve-factor/003 (Config via Env), twelve-factor/002 (Dependencies) |
| Reusability | clean-code/001 (DRY), object-calisthenics/003 (Encapsulation) |
| Interoperability | twelve-factor/004 (Backing Services) |

## Relação com ICP

| Quality Factor | Impacto no ICP |
|----------------|----------------|
| Low Maintainability | +2-3 ICP (complexity) |
| Low Testability | +1-2 ICP (coupling) |
| Low Flexibility | +1-2 ICP (responsibilities) |

## Aplicação em Code Review

### Quando Mencionar Quality Factors

1. **Sempre mencionar Integrity** quando detectar vulnerabilidades
2. **Mencionar Correctness** quando encontrar bugs de lógica
3. **Mencionar Testability** quando código for impossível de testar
4. **Mencionar Maintainability** quando encontrar god classes/functions
5. **Mencionar Efficiency** apenas quando houver problemas óbvios de performance

## Referências

- McCall, J.A., Richards, P.K., & Walters, G.F. (1977). "Factors in Software Quality"
- ISO/IEC 25010:2011 - Systems and software Quality Requirements and Evaluation (SQuaRE)
- IEEE 1061-1998 - Standard for Software Quality Metrics Methodology

---

**Criada em**: 2026-03-18
**Autor**: Cleber de Moraes Goncalves (deMGoncalves)
**Versão**: 2.0
