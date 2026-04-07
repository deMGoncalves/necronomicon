# Prohibition of Misleading Names (Misinformation and Encoding)

**ID**: ESTRUTURAL-035
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

Prohibits using names that imply false clues or suggest behavior that the code does not have (e.g., calling a `Set` an `accountList`) and prohibits type encoding in names (e.g., `strName` or `fValue`).

## Why It Matters

Misleading names are a form of **misinformation** that breaks developer trust in the code. Type *encoding* (Hungarian notation) is redundant and pollutes the code, increasing the risk of runtime bugs when the type is changed.

## Objective Criteria

- [ ] Variables containing collections (`Array`, `Set`, `Map`) must be named according to the actual data structure.
- [ ] Using unnecessary type prefixes in names is prohibited (e.g., `str`, `int`, `f`).
- [ ] Variable names must not contradict the type of data they store.

## Allowed Exceptions

- **Legacy Interfaces**: Variables where Hungarian notation is required for interoperability with legacy code or low-level *frameworks*.

## How to Detect

### Manual

Check if a variable's name contradicts its use or the actual type of data it contains.

### Automatic

ESLint: Custom rules against Hungarian notation and to verify list patterns.

## Related To

- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): complements
- [003 - Primitive Encapsulation](003_encapsulamento-primitivos.md): reinforces
- [034 - Consistent Class and Method Names](034_nomes-classes-metodos-consistentes.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
