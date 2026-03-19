# Prohibition of Misleading Names (Disinformation and Encoding)

**ID**: STRUCTURAL-035
**Severity**: 🔴 Critical
**Category**: Structural

---

## What it is

Prohibits the use of names that imply false clues or suggest behavior that the code does not have (e.g., calling a `Set` an `accountList`) and prohibits encoding types in names (e.g., `strName` or `fValue`).

## Why it matters

Misleading names are a form of **disinformation** that breaks developer trust in the code. Type *encoding* (Hungarian notation) is redundant and pollutes the code, increasing the risk of runtime bugs when the type is changed.

## Objective Criteria

- [ ] Variables that contain collections (`Array`, `Set`, `Map`) must be named according to the actual data structure.
- [ ] Using unnecessary type prefixes in names (e.g., `str`, `int`, `f`) is prohibited.
- [ ] Variable names must not contradict the data type they store.

## Allowed Exceptions

- **Legacy Interfaces**: Variables where Hungarian notation is required for interoperability with legacy code or low-level *frameworks*.

## How to Detect

### Manual

Check if a variable name contradicts its usage or the actual data type it contains.

### Automatic

ESLint: Custom rules against Hungarian notation and to check list patterns.

## Related to

- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): complements
- [003 - Primitive Encapsulation](003_encapsulamento-primitivos.md): reinforces
- [034 - Consistent Class and Method Names](../clean-code/014_nomes-classes-metodos-consistentes.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
