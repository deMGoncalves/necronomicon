# Restriction of Functions with Side Effects

**ID**: COMPORTAMENTAL-036
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Requires that functions or methods, except those explicitly designated as **Commands** (which alter state), be pure and **not alter the state** of instance variables, global objects, or external objects passed by reference.

## Why It Matters

Unexpected side effects introduce severe errors and make reasoning about code difficult, breaking **predictability** and the **Principle of Least Astonishment**. Impure code is difficult to test and debug.

## Objective Criteria

- [ ] Functions that are purely **Queries** must not modify class instance variables or global/external objects.
- [ ] Mutable objects passed as parameters must be cloned before any modification, unless modification is the business intent of the method.
- [ ] Functions that alter state must have names starting with Command verbs (e.g., `update`, `save`, `delete`).

## Allowed Exceptions

- **Persistence Commands**: `Repository` or `Service` methods that explicitly alter system state (e.g., `save`, `delete`).
- **Fluent Interfaces/Builders**: Classes that return `this` to modify the object itself.

## How to Detect

### Manual

Search for methods that return a query value but also call a `setter` or modify an internal/external attribute.

### Automatic

ESLint: `no-side-effects-in-conditions` and *mutability* analysis.

## Related To

- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [027 - Error Handling Quality](027_qualidade-tratamento-erros-dominio.md): reinforces
- [038 - Command-Query Segregation Principle](038_conformidade-principio-inversao-consulta.md): reinforces
- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): complements
- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): reinforces
- [029 - Object Immutability](029_imutabilidade-objetos-freeze.md): reinforces
- [045 - Stateless Processes](045_processos-stateless.md): complements
- [052 - Prohibition of Accidental Mutation](052_proibicao-mutacao-acidental.md): reinforces
- [070 - Prohibition of Shared Mutable State](070_proibicao-estado-mutavel-compartilhado.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
