# Prohibition of Shared Mutable State

**ID**: AP-08-070
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Shared Mutable State occurs when multiple modules, functions, or execution contexts read and modify the same object without coordination. Any part of the system can change state at any time, making behavior unpredictable. Distinct from Accidental Mutation (052): here the sharing is structural, not accidental.

## Why It Matters

- Phantom bugs: the mutation origin is in a different module from the failure point
- Fragile tests: result depends on global state left by previous tests
- Zero traceability: impossible to know who changed state without breakpoints
- Impossible concurrency: any parallelism introduces race conditions

## Objective Criteria

- [ ] Domain object passed by reference and modified in two or more distinct modules
- [ ] Module or global variable changed by multiple functions without explicit coordination
- [ ] Tests that fail depending on execution order (signal of shared state)
- [ ] Array or object used as "communication buffer" between system parts without copy
- [ ] Absence of `Object.freeze()` in objects passed to multiple consumers

## Allowed Exceptions

- **Explicit Stores**: State managers (Redux, Zustand, MobX) where mutation pattern is centralized, tracked, and intentional.
- **Read-Only Configuration Objects**: Frozen configurations with `Object.freeze()` passed as read constants.

## How to Detect

### Manual

Track an object's lifecycle: if it's passed to multiple functions and each can modify it, it's Shared Mutable State.

### Automatic

ESLint: `no-param-reassign`, TypeScript: `Readonly<T>`, `as const`. Tests: running in random order detects global state dependency.

## Related To

- [029 - Object Immutability](029_imutabilidade-objetos-freeze.md): reinforces
- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [045 - Stateless Processes](045_processos-stateless.md): complements
- [052 - Prohibition of Accidental Mutation](052_proibicao-mutacao-acidental.md): complements
- [069 - Prohibition of Premature Optimization](069_proibicao-otimizacao-prematura.md): complements

---

**Created on**: 2026-03-29
**Version**: 1.0
