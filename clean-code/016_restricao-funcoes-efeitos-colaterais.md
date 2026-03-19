# Side Effects Function Restriction

**ID**: BEHAVIORAL-036
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

Requires that functions or methods, except those explicitly designated as **Commands** (which alter state), be pure and **not alter the state** of instance variables, global objects, or external objects passed by reference.

## Why it matters

Unexpected side effects introduce severe errors and make reasoning about code difficult, breaking **predictability** and the **Principle of Least Surprise**. Impure code is difficult to test and debug.

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

## Related to

- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [027 - Error Handling Quality](../clean-code/007_qualidade-tratamento-erros-dominio.md): reinforces
- [038 - Command-Query Separation Principle](../clean-code/018_conformidade-principio-inversao-consulta.md): reinforces
- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): complements
- [012 - Liskov Substitution Principle](003_liskov-substitution-principle.md): reinforces
- [029 - Object Immutability](../clean-code/009_imutabilidade-objetos-freeze.md): reinforces
- [045 - Stateless Processes](../twelve-factor/006_processos-stateless.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
