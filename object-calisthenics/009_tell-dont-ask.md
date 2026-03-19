# Application of "Tell, Don't Ask" Principle (Law of Demeter)

**ID**: BEHAVIORAL-009
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

Requires that a method call methods or access properties only of its "immediate neighbors": the object itself, objects passed as arguments, objects it creates, or objects that are direct internal properties.

## Why it matters

Violations of the Law of Demeter result in high and transitive coupling (*train wrecks*), making code fragile to internal changes in objects distant in the dependency chain, and obscuring the responsibility of each object.

## Objective Criteria

- [ ] A method should avoid calling methods of an object returned by another method (e.g., `a.getB().getC().f()`).
- [ ] Method calls must be restricted to objects that the method has direct knowledge of.
- [ ] The client object should *tell* the dependent object what to do, instead of *asking* for internal state to make a decision.

## Allowed Exceptions

- **Fluent Interface Patterns (Chaining)**: As long as the method returns `this` (or the same interface), as in Builders.
- **Access to DTOs/Value Objects**: Data access to objects that are purely data containers.

## How to Detect

### Manual

Search for call chaining (*dot-chaining*) with three or more consecutive calls, indicating knowledge of nested objects.

### Automatic

ESLint: `no-chaining` with high depth and `no-access-target` (with custom plugins).

## Related to

- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reinforces
- [005 - Method Chaining Restriction](../object-calisthenics/005_method-chaining-restriction.md): reinforces
- [012 - Liskov Substitution Principle](003_liskov-substitution-principle.md): reinforces
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): reinforces
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): complements
- [018 - Acyclic Dependencies Principle](004_acyclic-dependencies-principle.md): reinforces
- [036 - Side Effect Function Restriction](../clean-code/016_side-effect-function-restriction.md): reinforces
- [038 - Query Inversion Principle](../clean-code/018_query-inversion-principle.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
