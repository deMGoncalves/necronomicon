# Prohibition of Speculative Functionality (YAGNI Principle)

**ID**: COMPORTAMENTAL-023
**Severity**: 🟡 Medium
**Category**: Behavioral

---

## What It Is

Requires that code be implemented only when a functionality is **needed** (and not *maybe needed* in the future), avoiding the inclusion of unnecessary code or abstractions.

*(Prevents the anti-pattern Speculative Generality: hooks, parameters, abstract classes and configurations created for hypothetical use cases without current use.)*

## Why It Matters

Speculative functionality increases complexity and dead code, wasting development time. It increases the attack surface and reduces agility in responding to real changes.

## Objective Criteria

- [ ] *Empty* classes or methods intended to be *placeholders* for future functionalities are prohibited.
- [ ] Adding parameters or configuration options that are not immediately used by at least **one** client is prohibited.
- [ ] Code should not contain more than **5%** of lines marked as disabled or with comments indicating "TODO: future implementation".

## Permitted Exceptions

- **Interface Requirements**: Interface methods required by an external contract (e.g., `Disposable` or `Closable`) that are trivially implemented.

## How to Detect

### Manual

Search for empty methods, unused parameters, or code that is never called (dead code).

### Automatic

SonarQube/ESLint: `no-unused-vars`, `no-empty-function`.

## Related To

- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): complements
- [069 - Prohibition of Premature Optimization](069_proibicao-otimizacao-prematura.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
