# Conformity with Command-Query Separation Principle (CQS)

**ID**: BEHAVIORAL-038
**Severity**: 🟠 High
**Category**: Behavioral

---

## What it is

Requires that a method be either a **Query** that returns data without state change, or a **Command** that alters state but does not return data (except DTOs/Entities).

## Why it matters

CQS violation introduces **unexpected side effects** and makes reasoning about code difficult, as the client assumes a "query" method is safe, but it silently alters system state. This leads to concurrency and state bugs.

## Objective Criteria

- [ ] Methods that alter state (Commands) must have return type `void` or an entity type (e.g., `User`, `Order`), but **not** a `boolean` or success code.
- [ ] Methods that return a value (Queries) must not have perceivable side effects (e.g., instance variable modification, write method calls).
- [ ] The number of methods that are hybrid (do Query and Command) must be zero.

## Allowed Exceptions

- **Caches**: Read methods that have the side effect of updating an internal cache (*cache-aside*) are accepted, provided this effect is an optimization and not business logic.

## How to Detect

### Manual

Search for methods that return a value but contain persistence logic (`save()`) or state modification.

### Automatic

ESLint: Custom rules that check the pattern of read/write method names and their returns.

## Related to

- [036 - Side Effects Function Restriction](../clean-code/016_restricao-funcoes-efeitos-colaterais.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [011 - Open/Closed Principle](002_open-closed-principle.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
