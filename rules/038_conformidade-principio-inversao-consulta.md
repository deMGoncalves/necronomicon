# Conformance with Command-Query Separation Principle (CQS)

**ID**: COMPORTAMENTAL-038
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Requires that a method be either a **Query** that returns data without state alteration, or a **Command** that alters state but does not return data (except DTOs/Entities).

## Why It Matters

CQS violation introduces **unexpected side effects** and makes reasoning about code difficult, as the client assumes a "query" method is safe, but it silently alters system state. This leads to concurrency and state bugs.

## Objective Criteria

- [ ] Methods that alter state (Commands) must have return type `void` or an entity type (e.g., `User`, `Order`), but **not** a `boolean` or success code.
- [ ] Methods that return a value (Queries) must not have perceptible side effects (e.g., instance variable modification, calls to write methods).
- [ ] The number of hybrid methods (doing Query and Command) must be zero.

## Allowed Exceptions

- **Caches**: Read methods that have the side effect of updating an internal cache (*cache-aside*) are accepted, provided this effect is an optimization and not business logic.

## How to Detect

### Manual

Search for methods that return a value but contain persistence logic (`save()`) or state modification.

### Automatic

ESLint: Custom rules that verify the pattern of read/write method names and their returns.

## Related To

- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
