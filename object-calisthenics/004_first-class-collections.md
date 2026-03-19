# Mandatory Use of First Class Collections

**ID**: STRUCTURAL-004
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

Determines that any collection (list, array, map) with business logic or associated behavior must be encapsulated in a dedicated class (*First Class Collection*).

## Why it matters

Native collections violate SRP if they have distributed manipulation logic. Encapsulating the collection centralizes responsibility, facilitates adding behaviors (e.g., filters, sums), and prevents internal state from being exposed and modified by clients.

## Objective Criteria

- [ ] Native collection types (Array, List, Map) must not be passed as parameters or returned by public methods, except for pure DTOs.
- [ ] Each collection with domain meaning must be wrapped by a dedicated class (e.g., `OrderList`, `Employees`).
- [ ] The collection class must provide behavior methods (e.g., `add()`, `filterByStatus()`), and not just direct access to elements.

## Allowed Exceptions

- **Low-Level Interfaces**: Collections used purely as internal data structures without associated business logic (e.g., `tokens` in a *scanner*).
- **Framework APIs**: Use of collections in Framework interfaces (e.g., React, ORMs) that require them.

## How to Detect

### Manual

Check the use of `Array.prototype` (map, filter, reduce) in methods of classes that are not *First Class Collections*.

### Automatic

ESLint: Custom rules to prohibit returning `Array` in domain classes.

## Related to

- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reinforces
- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): complements
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
