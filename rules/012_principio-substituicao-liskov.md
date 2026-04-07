# Conformance to the Liskov Substitution Principle (LSP)

**ID**: COMPORTAMENTAL-012
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Requires that derived classes (subclasses) be substitutable for their base classes (superclasses) without altering the expected behavior of the program.

## Why It Matters

LSP violation breaks the cohesion of the type system and the inheritance contract, forcing clients to check the object type, which leads to OCP violation and introduces serious runtime bugs.

## Objective Criteria

- [ ] Subclasses should not throw exceptions that are not thrown by the base class (behavior).
- [ ] Subclasses should not weaken preconditions or strengthen postconditions of the base class (signature/contract).
- [ ] The use of type checks (`instanceof` or complex *type guards*) in client code using the base class interface is prohibited.

## Permitted Exceptions

- **Testing Frameworks**: Use of *mocks* and *spies* in unit tests to simulate substitution behaviors in a controlled manner.

## How to Detect

### Manual

Search for `if (object instanceof Subclass)` or use of a base class method that throws `UnsupportedOperationException`.

### Automatic

TypeScript/Compiler: Strict type checking of parameters and returns of overridden methods.

## Related To

- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [003 - Encapsulation of Primitives](003_encapsulamento-primitivos.md): complements
- [013 - Interface Segregation Principle](013_principio-segregacao-interface.md): reinforces
- [036 - Restriction on Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
