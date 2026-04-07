---
name: object-calisthenics
description: "9 Object Calisthenics rules (Jeff Bay) to improve OOP code. Use when @developer implements rules 001-009, or @reviewer verifies Object Calisthenics compliance in classes and methods."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Object Calisthenics

## What It Is

Object Calisthenics is a set of 9 rules created by Jeff Bay to train developers to write better quality object-oriented code. As calisthenic exercises strengthen the body, these rules strengthen object-oriented design.

## When to Use

- **@developer implementing features**: Apply during writing of classes, methods and OOP structures
- **@reviewer verifying code**: Validate compliance with the 9 rules in code reviews
- **Refactoring**: Use as checklist to identify code smells in existing code
- **Onboarding**: Teach new developers about OOP principles

## Object Calisthenics Rules

| # | Name | Rule ID | File |
|---|------|---------|------|
| 1 | Single Indentation Level | 001 | [rule-01-single-indentation.md](references/rule-01-single-indentation.md) |
| 2 | No ELSE Prohibition | 002 | [rule-02-no-else.md](references/rule-02-no-else.md) |
| 3 | Primitive Encapsulation | 003 | [rule-03-wrap-primitives.md](references/rule-03-wrap-primitives.md) |
| 4 | First Class Collections | 004 | [rule-04-first-class-collections.md](references/rule-04-first-class-collections.md) |
| 5 | One Dot per Line | 005 | [rule-05-one-dot-per-line.md](references/rule-05-one-dot-per-line.md) |
| 6 | No Abbreviations Prohibition | 006 | [rule-06-no-abbreviations.md](references/rule-06-no-abbreviations.md) |
| 7 | Small Classes | 007 | [rule-07-small-classes.md](references/rule-07-small-classes.md) |
| 8 | No Getters/Setters Prohibition | 008 | [rule-08-no-getters-setters.md](references/rule-08-no-getters-setters.md) |
| 9 | Tell, Don't Ask | 009 | [rule-09-tell-dont-ask.md](references/rule-09-tell-dont-ask.md) |

## Quick Guide: Which Rule to Apply

```
Method with if inside for?                     → Rule 1: Single Indentation
Method with else?                              → Rule 2: No Else
Receiving string/number for Email/CPF?         → Rule 3: Wrap Primitives
Returning Array[] from domain method?          → Rule 4: First Class Collections
Calling a.getB().getC()?                       → Rule 5: One Dot per Line
Variable called "usr" or "calc"?               → Rule 6: No Abbreviations
Class with 100+ lines?                         → Rule 7: Small Classes
Method called getStatus() or setName()?        → Rule 8: No Getters/Setters
Asking state to decide action?                 → Rule 9: Tell, Don't Ask
```

## Prohibitions

These combinations violate **multiple** rules simultaneously:

```typescript
// ❌ Violates Rules 1, 2, 5, 8
class UserManager {
  processUser(userId: string) {  // Violates Rule 3
    if (this.db.getUser(userId).getStatus() === 'active') {  // Violates Rules 1, 5, 8
      if (this.config.getFeatureFlag('premium')) {  // Violates Rules 1, 2
        // nested logic...
      } else {
        // more logic...
      }
    }
  }
}
```

✅ **Correct**: each violation must be fixed by applying the corresponding rule.

## Rationale

Object Calisthenics reinforces SOLID and Clean Code principles:

- **Rules 001-002**: reduce Cyclomatic Complexity (KISS)
- **Rules 003-004**: reinforce Encapsulation (fundamental OOP)
- **Rules 005, 008-009**: apply Law of Demeter (low coupling)
- **Rule 006**: increases readability (Clean Code)
- **Rule 007**: reinforces SRP (Single Responsibility Principle)

### Links to deMGoncalves Rules

- Rule 001: [ESTRUTURAL-001](../../rules/001_nivel-unico-indentacao.md)
- Rule 002: [COMPORTAMENTAL-002](../../rules/002_proibicao-clausula-else.md)
- Rule 003: [CRIACIONAL-003](../../rules/003_encapsulamento-primitivos.md)
- Rule 004: [ESTRUTURAL-004](../../rules/004_colecoes-primeira-classe.md)
- Rule 005: [ESTRUTURAL-005](../../rules/005_maximo-uma-chamada-por-linha.md)
- Rule 006: [ESTRUTURAL-006](../../rules/006_proibicao-nomes-abreviados.md)
- Rule 007: [ESTRUTURAL-007](../../rules/007_limite-maximo-linhas-classe.md)
- Rule 008: [COMPORTAMENTAL-008](../../rules/008_proibicao-getters-setters.md)
- Rule 009: [COMPORTAMENTAL-009](../../rules/009_diga-nao-pergunte.md)

**Related skills:**
- [`solid`](../solid/SKILL.md) — complements: both form the OOP core (rules 001-014)
- [`package-principles`](../package-principles/SKILL.md) — complements: package principles depend on applied OC
- [`clean-code`](../clean-code/SKILL.md) — reinforces: OC is subset of Clean Code practices

---

**Created on**: 2026-04-01
**Version**: 1.0.0
