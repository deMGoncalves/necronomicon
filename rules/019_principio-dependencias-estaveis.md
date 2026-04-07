# Stable Dependencies Principle (SDP)

**ID**: ESTRUTURAL-019
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

A module's dependencies should point in the direction of stability. Unstable modules (that change frequently) should depend on stable modules.

## Why It Matters

SDP violations cause high-level modules (most important for business) to depend on low-level and volatile modules, spreading changes and reducing testability.

## Objective Criteria

- [ ] The package's **instability** (I), calculated as (Outgoing Dependencies / Total Dependencies), should be **less** than 0.5.
- [ ] Business policy modules (high-level) should have the lowest Instability (close to 0).
- [ ] Most used packages (high degree of stability) should not depend on packages with low degree of stability (high I).

## Permitted Exceptions

- **Boundary Elements**: Elements at the system boundary (e.g., *Adapters*, *Controllers*) that, by nature, are volatile.

## How to Detect

### Manual

Identify the high-level layer (e.g., *Domain*) importing concrete classes from external layers (e.g., *Infrastructure*).

### Automatic

Dependency analysis: Calculation of package stability metrics (I).

## Related To

- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): complements
- [020 - Stable Abstractions Principle](020_principio-abstracoes-estaveis.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
