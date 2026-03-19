# Stable Abstractions Principle (SAP)

**ID**: STRUCTURAL-020
**Severity**: 🔴 Critical
**Category**: Structural

---

## What it is

A package should be as abstract as possible (have interfaces) if it is stable, and as concrete as possible if it is unstable.

## Why it matters

SAP links package stability (SDP) to its abstraction (DIP). Violation occurs when a highly stable module (hard to change) is concrete, preventing extension. Or when an unstable module (easy to change) is abstract, delaying implementation.

## Objective Criteria

- [ ] The package's **Abstraction** (A), calculated as (Total Abstractions / Total Classes), should be **high** (close to 1) if its **Instability (I)** is low (close to 0).
- [ ] The package's distance to the *Main Sequence* (D) in the A/I plane should not be greater than **0.1** (D = |A + I - 1|).
- [ ] High-level packages (policy) should have more than **60%** abstract classes or interfaces.

## Allowed Exceptions

- **Pure Data Packages**: Modules that contain only *Value Objects* or DTOs and are not designed for polymorphism (A and I can be low).

## How to Detect

### Manual

Identify an important business module (stable) that is composed only of concrete classes.

### Automatic

Dependency analysis: Calculation of package abstraction (A), instability (I), and distance (D) metrics.

## Related to

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reinforces
- [019 - Stable Dependencies Principle](../package-principles/005_stable-dependencies-principle.md): complements
- [012 - Liskov Substitution Principle](003_liskov-substitution-principle.md): reinforces
- [011 - Open/Closed Principle](002_open-closed-principle.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
