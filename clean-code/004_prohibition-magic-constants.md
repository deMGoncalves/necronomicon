# Prohibition of Magic Constants (Magic Strings and Numbers)

**ID**: CREATIONAL-024
**Severity**: 🔴 Critical
**Category**: Creational

---

## What it is

Prohibits the direct use of literal values (numbers or strings) that have contextual or business meaning (e.g., status codes, time limits) instead of named constants or *Value Objects*.

## Why it matters

Magic constants degrade readability. A value change in multiple locations introduces serious errors and makes maintenance difficult, as the value's context is lost.

## Objective Criteria

- [ ] Numeric values (except 0 and 1) used in business logic or conditions should be replaced by `UPPER_SNAKE_CASE` constants.
- [ ] Strings used to represent states, types, base URLs, or *tokens* should be replaced by `Enums` or constants.
- [ ] Constants should be defined in a centralized module and imported, not duplicated.

## Allowed Exceptions

- **Pure Mathematics**: Numeric values used in basic mathematical operations (e.g., `total / 2`).
- **Frameworks/Infrastructure**: Strings required by low-level APIs.

## How to Detect

### Manual

Search for `string` or `number` literals inside `if`, `switch`, or business calculations.

### Automatic

SonarQube/ESLint: `no-magic-numbers`, `no-magic-strings`.

## Related to

- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): reinforces
- [006 - Prohibition of Abbreviated Names](../object-calisthenics/006_prohibition-abbreviated-names.md): complements
- [030 - Prohibition of Unsafe Functions](010_prohibition-unsafe-functions.md): complements
- [042 - Configuration via Environment](../twelve-factor/003_configuration-via-environment.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
