# Consistent Class and Method Names (Functions are Verbs)

**ID**: STRUCTURAL-034
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

Requires that class names be **singular nouns** (e.g., `User`, `Order`) and that method names be **verbs or verb phrases** describing intent (e.g., `calculateFee`, `sendNotification`).

## Why it matters

Consistency in naming is fundamental for code **readability** and **predictability**. A violation breaks the reader's mental model, increasing **cognitive cost** and the risk of misinterpreting intent and the type system.

## Objective Criteria

- [ ] Class and interface names must be nouns and use `PascalCase`.
- [ ] Public method names must start with a verb (e.g., `get`, `create`, `validate`) and use `camelCase`.
- [ ] Variables that store boolean values (predicates) should use clear prefixes (e.g., `is`, `has`, `can`).

## Allowed Exceptions

- **Factories/Builders**: Classes with the `Factory` or `Builder` suffix are accepted, as their role is strictly creational.

## How to Detect

### Manual

Check for classes ending in verbs (`Manager`, `Processor`) or functions with noun names (`User`).

### Automatic

ESLint: `naming-convention` with rules for classes and functions.

## Related to

- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [035 - Prohibition of Misleading Names](../clean-code/015_proibicao-nomes-enganosos.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
