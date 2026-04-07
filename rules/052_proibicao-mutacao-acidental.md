# Prohibition of Accidental Mutation

**ID**: AP-07-052
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Accidental mutation occurs when objects or data structures are modified inadvertently, often through pass-by-reference or undocumented side effects. The original state is changed without explicit developer intent, causing bugs that are difficult to trace.

## Why It Matters

- Unpredictable bugs: silently mutated state fails tests and produces incorrect behavior
- Difficult tracking: the location where mutation occurs may be far from where the error is detected
- Non-idempotent behavior: same code can have different results depending on previous state
- Low code confidence: developers hesitate to reuse functions due to hidden side effects

## Objective Criteria

- [ ] Functions modify received parameters without explicit documentation
- [ ] Objects are returned from functions after property modification
- [ ] Arrays are modified via `push()`, `splice()`, `pop()` without creating a copy
- [ ] Shared data structures are mutated from multiple locations
- [ ] Local variables have their value reassigned without clear reason
- [ ] Changes in objects propagate to other unrelated components

## Allowed Exceptions

- Methods explicitly identified as mutators (e.g., `save()`, `update()`)
- Temporary objects constructed and used exclusively within the same scope
- Mandatory mutator implementations in interfaces/frameworks that do not support immutability
- Legacy code with documented mutation and tests that ensure expected behavior

## How to Detect

### Manual
- Search for `push()`, `pop()`, `splice()`, `unshift()` in transient arrays
- Identify functions that return the same object received as parameter
- Look for parameter reassignments
- Verify objects shared between multiple modules

### Automatic
- Linters (ESLint): `no-param-reassign`, `no-const-assign`
- Type strictness: use `Readonly<T>`, `as const`, `readonly`
- Libraries: Immer, Immutable.js to detect mutations
- Snapshot tests: capture state before/after to detect unexpected changes

## Related To

- [029 - Object Immutability (Freeze)](029_imutabilidade-objetos-freeze.md): reinforces
- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): complements
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): complements
- [039 - Boy Scout Rule (Continuous Refactoring)](039_regra-escoteiro-refatoracao-continua.md): reinforces
- [070 - Prohibition of Shared Mutable State](070_proibicao-estado-mutavel-compartilhado.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
