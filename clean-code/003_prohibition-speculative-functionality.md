# Prohibition of Speculative Functionality (YAGNI Principle)

**ID**: BEHAVIORAL-023
**Severity**: 🟡 Medium
**Category**: Behavioral

---

## What it is

Requires that code be implemented only when functionality is **needed** (and not *maybe needed* in the future), avoiding the inclusion of unnecessary code or abstractions.

## Why it matters

Speculative functionality increases complexity and dead code, wasting development time. It increases the attack surface and reduces agility in responding to real changes.

## Objective Criteria

- [ ] *Empty* classes or methods that aim to be *placeholders* for future features are prohibited.
- [ ] Adding parameters or configuration options that are not immediately used by at least **one** client is prohibited.
- [ ] The code must not contain more than **5%** of lines marked as disabled or with comments indicating "TODO: future implementation".

## Allowed Exceptions

- **Interface Requirements**: Interface methods required by an external contract (e.g., `Disposable` or `Closable`) that are trivially implemented.

## How to Detect

### Manual

Search for empty methods, unused parameters, or code that is never called (dead code).

### Automatic

SonarQube/ESLint: `no-unused-vars`, `no-empty-function`.

## Related to

- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
