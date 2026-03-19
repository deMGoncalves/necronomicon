# Prohibition of Direct State Exposure (Getters/Setters)

**ID**: BEHAVIORAL-008
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

Prohibits the creation of methods purely for accessing or directly modifying the internal state of the object (such as `getProperty()` and `setProperty()`), reinforcing encapsulation and the "Tell, Don't Ask" principle.

## Why it matters

Direct exposure of internal state violates encapsulation, forcing client code to decide business logic (*procedural programming*), resulting in anemic classes and coupling to implementation details.

## Objective Criteria

- [ ] Methods that return the exact value of an internal property without transformations or logic are prohibited (pure *getters*).
- [ ] Methods that only assign a value to an internal property are prohibited (pure *setters*).
- [ ] Interaction with the object must occur through methods that express business *intention* (e.g., `scheduleMeeting()` instead of `setStatus(Scheduled)`).

## Allowed Exceptions

- **Data Transfer Objects (DTOs)**: Pure classes used only for data transfer between layers, without business logic.
- **Serialization Frameworks**: Libraries that require *getters* and *setters* for mapping.

## How to Detect

### Manual

Search for methods containing `get` or `set` prefixes followed by a property name, or methods that have no business logic of their own.

### Automatic

ESLint: Custom rules to identify empty or trivial `get/set` method patterns.

## Related to

- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reinforces
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complements
- [002 - Prohibition of ELSE Clause](../object-calisthenics/002_prohibition-else-clause.md): reinforces
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): reinforces
- [005 - Method Chaining Restriction](../object-calisthenics/005_method-chaining-restriction.md): reinforces
- [029 - Object Immutability](../clean-code/009_object-immutability.md): reinforces
- [036 - Side Effect Function Restriction](../clean-code/016_side-effect-function-restriction.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
