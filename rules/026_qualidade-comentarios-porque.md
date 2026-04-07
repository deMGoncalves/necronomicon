# Comment Quality: Only the Why, Not the What

**ID**: ESTRUTURAL-026
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Requires that comments explain the **why** or the **intent** of the code, the legal context, trade-offs, or non-obvious logic, and **prohibits** redundant comments that describe what the code already shows.

## Why It Matters

Redundant comments pollute the code and tend to become outdated, creating lies in the system. Forces the code to be self-documented through good naming.

## Objective Criteria

- [ ] Using comments to describe what an obvious function does is prohibited (e.g., `// returns the value`).
- [ ] Comments should be used to explain non-evident business rules, performance trade-offs, or specific bug solutions.
- [ ] Public functions should have at most **20%** of their body occupied by comment lines.

## Allowed Exceptions

- **API Documentation**: JSDoc or TSDoc comments used to generate public interface documentation.
- **Special Markers**: Comments like `// TODO:` or `// FIXME:` (in limited quantity).

## How to Detect

### Manual

Check if the code can be read and understood without needing to read the comments.

### Automatic

ESLint: Rules to detect comments on simple code lines.

## Related To

- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): complements
- [050 - Logs as Event Stream](050_logs-fluxo-eventos.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
