# Mandatory Use of First Class Collections

**ID**: ESTRUTURAL-004
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Determines that any collection (list, array, map) with associated business logic or behavior must be encapsulated in a dedicated class (*First Class Collection*).

## Why It Matters

Native collections violate SRP if they have distributed manipulation logic. Encapsulating the collection centralizes responsibility, facilitates adding behaviors (e.g., filters, sums), and prevents internal state from being exposed and modified by clients.

## Objective Criteria

- [ ] Native collection types (Array, List, Map) should not be passed as parameters or returned by public methods, except for pure DTOs.
- [ ] Each collection with domain meaning should be wrapped by a dedicated class (e.g., `OrderList`, `Employees`).
- [ ] The collection class should provide behavior methods (e.g., `add()`, `filterByStatus()`), not just direct access to elements.

## Permitted Exceptions

- **Low-Level Interfaces**: Collections used purely as internal data structures without associated business logic (e.g., `tokens` in a *scanner*).
- **Framework APIs**: Use of collections in Framework interfaces (e.g., React, ORMs) that require them.

## How to Detect

### Manual

Check the use of `Array.prototype` (map, filter, reduce) in methods of classes that are not *First Class Collections*.

### Automatic

ESLint: Custom rules to prohibit returning `Array` in domain classes.

## Related To

- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): reinforces
- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): complements
- [003 - Encapsulation of Primitives](003_encapsulamento-primitivos.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
