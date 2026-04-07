# Stable Abstractions Principle (SAP)

**ID**: ESTRUTURAL-020
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

A package should be as abstract as possible (have interfaces) if it is stable, and as concrete as possible if it is unstable.

## Why It Matters

SAP links package stability (SDP) to its abstraction (DIP). Violation occurs when a highly stable module (hard to change) is concrete, preventing extension. Or when an unstable module (easy to change) is abstract, delaying implementation.

## Objective Criteria

- [ ] The package's **Abstraction** (A), calculated as (Total Abstractions / Total Classes), should be **high** (close to 1) if its **Instability (I)** is low (close to 0).
- [ ] The package's distance to the *Main Sequence* (D) in the A/I plane should not be greater than **0.1** (D = |A + I - 1|).
- [ ] High-level packages (policy) should have more than **60%** abstract classes or interfaces.

## Permitted Exceptions

- **Pure Data Packages**: Modules containing only *Value Objects* or DTOs and are not designed for polymorphism (A and I can be low).

## How to Detect

### Manual

Identify an important business module (stable) that is composed only of concrete classes.

### Automatic

Dependency analysis: Calculation of abstraction (A), instability (I), and distance (D) metrics of the package.

## Related To

- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [019 - Stable Dependencies Principle](019_principio-dependencias-estaveis.md): complements
- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
