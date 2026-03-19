# Stable Dependencies Principle (SDP)

**ID**: STRUCTURAL-019
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

A module's dependencies should point in the direction of stability. Unstable modules (that change frequently) should depend on stable modules.

## Why it matters

SDP violations cause high-level modules (most important to business) to depend on low-level and volatile modules, spreading changes and reducing testability.

## Objective Criteria

- [ ] The package's **instability** (I), calculated as (Outgoing Dependencies / Total Dependencies), should be **less than** 0.5.
- [ ] Business policy modules (high level) should have the lowest Instability (close to 0).
- [ ] Most used packages (high degree of stability) must not depend on packages with low degree of stability (high I).

## Allowed Exceptions

- **Boundary Elements**: Elements at the system boundary (e.g., *Adapters*, *Controllers*) that are volatile by nature.

## How to Detect

### Manual

Identify the high-level layer (e.g., *Domain*) importing concrete classes from external layers (e.g., *Infrastructure*).

### Automatic

Dependency analysis: Calculation of package stability metrics (I).

## Related to

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reinforces
- [018 - Acyclic Dependencies Principle](../package-principles/004_acyclic-dependencies-principle.md): complements
- [020 - Stable Abstractions Principle](../package-principles/006_stable-abstractions-principle.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
