# Compliance with Liskov Substitution Principle (LSP)

**ID**: BEHAVIORAL-012
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

Requires that derived classes (subclasses) be substitutable for their base classes (superclasses) without altering the expected behavior of the program.

## Why it matters

Violation of LSP breaks the cohesion of the type system and inheritance contract, forcing clients to check object type, which leads to OCP violation and introduces serious runtime bugs.

## Objective Criteria

- [ ] Subclasses must not throw exceptions that are not thrown by the base class (behavior).
- [ ] Subclasses must not weaken preconditions or strengthen postconditions of the base class (signature/contract).
- [ ] The use of type checks (`instanceof` or complex *type guards*) in client code that uses the base class interface is prohibited.

## Allowed Exceptions

- **Test Frameworks**: Use of *mocks* and *spies* in unit tests to simulate substitution behaviors in a controlled manner.

## How to Detect

### Manual

Search for `if (object instanceof Subclass)` or use of a base class method that throws `UnsupportedOperationException`.

### Automatic

TypeScript/Compiler: Strict typing verification of parameters and returns of overridden methods.

## Related to

- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): reinforces
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reinforces
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complements
- [013 - Interface Segregation Principle](../solid/004_interface-segregation-principle.md): reinforces
- [036 - Side Effect Function Restriction](../clean-code/016_side-effect-function-restriction.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
