# Application of Dependency Inversion Principle (DIP)

**ID**: BEHAVIORAL-014
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

High-level modules must not depend on low-level modules. Both should depend on abstractions (interfaces).

## Why it matters

DIP is crucial for decoupling business policy from implementation. Violation creates tight coupling, making testing (unit and integration) difficult and preventing the high-level module from being reused in a new context.

## Objective Criteria

- [ ] The creation of new instances of concrete classes (*new Class()*) is prohibited within high-level classes (e.g., *Services* and *Controllers*).
- [ ] High-level modules must reference only interfaces or abstract classes (what will be injected).
- [ ] The number of *imports* for concrete classes in constructors must be zero (only abstraction injection).

## Allowed Exceptions

- **Entities and Value Objects**: Pure data classes that can be freely instantiated.
- **Root Composer**: The system initialization module where dependency injection is configured.

## How to Detect

### Manual

Search for `new ConcreteName()` within *Services* or *Business Logic* code.

### Automatic

ESLint: `no-new-without-abstraction` (with custom rules).

## Related to

- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): reinforces
- [015 - Release Reuse Equivalency Principle](001_release-reuse-equivalency-principle.md): reinforces
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complements
- [018 - Acyclic Dependencies Principle](004_acyclic-dependencies-principle.md): reinforces
- [019 - Stable Dependencies Principle](005_stable-dependencies-principle.md): reinforces
- [020 - Stable Abstractions Principle](006_stable-abstractions-principle.md): reinforces
- [032 - Minimum Test Coverage](../clean-code/012_minimum-test-coverage.md): complements
- [041 - Explicit Dependency Declaration](../twelve-factor/002_explicit-dependency-declaration.md): complements
- [043 - Backing Services as Resources](../twelve-factor/004_backing-services-resources.md): complements

---

**Created on**: 2025-10-04
**Updated on**: 2025-10-04
**Version**: 1.1
