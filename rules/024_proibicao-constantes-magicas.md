# Prohibition of Magic Constants (Magic Strings and Numbers)

**ID**: CRIACIONAL-024
**Severity**: 🔴 Critical
**Category**: Creational

---

## What It Is

Prohibits direct use of literal values (numbers or strings) that have contextual or business meaning (e.g., status codes, time limits) instead of named constants or *Value Objects*.

## Why It Matters

Magic constants degrade readability. A value change in multiple locations introduces serious errors and makes maintenance difficult, as the context of the value is lost.

## Objective Criteria

- [ ] Numeric values (except 0 and 1) used in business logic or conditions should be replaced by `UPPER_SNAKE_CASE` constants.
- [ ] Strings used to represent states, types, base URLs, or *tokens* should be replaced by `Enums` or constants.
- [ ] Constants should be defined in a centralized module and imported, not duplicated.

## Permitted Exceptions

- **Pure Mathematics**: Numeric values used in basic mathematical operations (e.g., `total / 2`).
- **Frameworks/Infrastructure**: Strings required by low-level APIs.

## How to Detect

### Manual

Search for `string` or `number` literals inside `if`, `switch`, or business calculations.

### Automatic

SonarQube/ESLint: `no-magic-numbers`, `no-magic-strings`.

## Related To

- [003 - Encapsulation of Primitives](003_encapsulamento-primitivos.md): reinforces
- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): complements
- [030 - Prohibition of Unsafe Functions](030_proibicao-funcoes-inseguras.md): complements
- [042 - Environment-based Configuration](042_configuracoes-via-ambiente.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
