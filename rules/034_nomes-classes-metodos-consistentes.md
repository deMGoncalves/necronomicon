# Consistent Class and Method Names (Functions are Verbs)

**ID**: ESTRUTURAL-034
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Requires that class names be **singular nouns** (e.g., `User`, `Order`) and method names be **verbs or verb phrases** that describe intent (e.g., `calculateFee`, `sendNotification`).

## Why It Matters

Consistency in naming is fundamental for code **readability** and **predictability**. A violation breaks the reader's mental model, increasing **cognitive cost** and the risk of misinterpreting intent and the type system.

## Objective Criteria

- [ ] Class and interface names must be nouns and use `PascalCase`.
- [ ] Public method names must start with a verb (e.g., `get`, `create`, `validate`) and use `camelCase`.
- [ ] Variables that store boolean values (predicates) must use clear prefixes (e.g., `is`, `has`, `can`).

## Allowed Exceptions

- **Factories/Builders**: Classes with the suffix `Factory` or `Builder` are accepted, as their role is strictly creational.

## How to Detect

### Manual

Check for classes ending in verbs (`Manager`, `Processor`) or functions with noun names (`User`).

### Automatic

ESLint: `naming-convention` with rules for classes and functions.

## Related To

- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [035 - Prohibition of Misleading Names](035_proibicao-nomes-enganosos.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
