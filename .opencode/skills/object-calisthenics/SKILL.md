---
name: object-calisthenics
description: "9 regras Object Calisthenics (Jeff Bay) para melhorar código OOP. Use quando @developer implementar as rules 001-009, ou @reviewer verificar conformidade com Object Calisthenics em classes e métodos."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Object Calisthenics

## O que é

Object Calisthenics é um conjunto de 9 regras criadas por Jeff Bay para treinar desenvolvedores a escrever código orientado a objetos de melhor qualidade. Como exercícios calisthênicos fortalecem o corpo, estas regras fortalecem o design orientado a objetos.

## Quando Usar

- **@developer implementando features**: Aplique durante escrita de classes, métodos e estruturas OOP
- **@reviewer verificando código**: Valide conformidade com as 9 regras em code reviews
- **Refatoração**: Use como checklist para identificar code smells em código existente
- **Onboarding**: Ensine novos desenvolvedores sobre princípios OOP

## Regras Object Calisthenics

| # | Nome | Rule ID | Arquivo |
|---|------|---------|---------|
| 1 | Nível Único de Indentação | 001 | [rule-01-single-indentation.md](references/rule-01-single-indentation.md) |
| 2 | Proibição de ELSE | 002 | [rule-02-no-else.md](references/rule-02-no-else.md) |
| 3 | Encapsulamento de Primitivos | 003 | [rule-03-wrap-primitives.md](references/rule-03-wrap-primitives.md) |
| 4 | Coleções de Primeira Classe | 004 | [rule-04-first-class-collections.md](references/rule-04-first-class-collections.md) |
| 5 | Um Ponto por Linha | 005 | [rule-05-one-dot-per-line.md](references/rule-05-one-dot-per-line.md) |
| 6 | Proibição de Abreviações | 006 | [rule-06-no-abbreviations.md](references/rule-06-no-abbreviations.md) |
| 7 | Classes Pequenas | 007 | [rule-07-small-classes.md](references/rule-07-small-classes.md) |
| 8 | Proibição de Getters/Setters | 008 | [rule-08-no-getters-setters.md](references/rule-08-no-getters-setters.md) |
| 9 | Tell, Don't Ask | 009 | [rule-09-tell-dont-ask.md](references/rule-09-tell-dont-ask.md) |

## Guia Rápido: Qual Regra Aplicar

```
Método com if dentro de for?                    → Regra 1: Single Indentation
Método com else?                                → Regra 2: No Else
Recebendo string/number para Email/CPF?         → Regra 3: Wrap Primitives
Retornando Array[] de método de domínio?        → Regra 4: First Class Collections
Chamando a.getB().getC()?                       → Regra 5: One Dot per Line
Variável chamada "usr" ou "calc"?               → Regra 6: No Abbreviations
Classe com 100+ linhas?                         → Regra 7: Small Classes
Método chamado getStatus() ou setName()?        → Regra 8: No Getters/Setters
Perguntando estado para decidir ação?           → Regra 9: Tell, Don't Ask
```

## Proibições

Estas combinações violam **múltiplas** regras simultaneamente:

```typescript
// ❌ Viola Regras 1, 2, 5, 8
class UserManager {
  processUser(userId: string) {  // Viola Regra 3
    if (this.db.getUser(userId).getStatus() === 'active') {  // Viola Regras 1, 5, 8
      if (this.config.getFeatureFlag('premium')) {  // Viola Regras 1, 2
        // nested logic...
      } else {
        // more logic...
      }
    }
  }
}
```

✅ **Correto**: cada violação deve ser corrigida aplicando a regra correspondente.

## Fundamentação

Object Calisthenics reforça princípios SOLID e Clean Code:

- **Rules 001-002**: reduzem Complexidade Ciclomática (KISS)
- **Rules 003-004**: reforçam Encapsulamento (OOP fundamental)
- **Rules 005, 008-009**: aplicam Law of Demeter (baixo acoplamento)
- **Rule 006**: aumenta legibilidade (Clean Code)
- **Rule 007**: reforça SRP (Single Responsibility Principle)

### Links para Rules deMGoncalves

- Rule 001: [ESTRUTURAL-001](../../rules/001_nivel-unico-indentacao.md)
- Rule 002: [COMPORTAMENTAL-002](../../rules/002_proibicao-clausula-else.md)
- Rule 003: [CRIACIONAL-003](../../rules/003_encapsulamento-primitivos.md)
- Rule 004: [ESTRUTURAL-004](../../rules/004_colecoes-primeira-classe.md)
- Rule 005: [ESTRUTURAL-005](../../rules/005_maximo-uma-chamada-por-linha.md)
- Rule 006: [ESTRUTURAL-006](../../rules/006_proibicao-nomes-abreviados.md)
- Rule 007: [ESTRUTURAL-007](../../rules/007_limite-maximo-linhas-classe.md)
- Rule 008: [COMPORTAMENTAL-008](../../rules/008_proibicao-getters-setters.md)
- Rule 009: [COMPORTAMENTAL-009](../../rules/009_diga-nao-pergunte.md)

**Skills relacionadas:**
- [`solid`](../solid/SKILL.md) — complementa: ambas formam o núcleo OOP (rules 001-014)
- [`package-principles`](../package-principles/SKILL.md) — complementa: princípios de pacote dependem de OC aplicado
- [`clean-code`](../clean-code/SKILL.md) — reforça: OC é subconjunto das práticas Clean Code

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
