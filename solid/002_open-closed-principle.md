# Compliance with Open/Closed Principle (OCP)

**ID**: BEHAVIORAL-011
**Severity**: 🟠 High
**Category**: Behavioral

---

## What it is

Modules, classes, or functions must be open for extension and closed for modification, allowing the addition of new behaviors without changing the existing code of the unit.

## Why it matters

Violation of OCP leads to fragile code. Compliance reduces regression risk and increases maintainability, as new features are added without needing to rewrite already tested logic.

## Objective Criteria

- [ ] Adding a new "type" of behavior must be implemented through inheritance or composition, and **not** through new `if/switch` in existing code.
- [ ] Methods with more than **3** `if/else if/switch case` clauses that handle *types* (e.g., `if (type === 'A')`) violate OCP.
- [ ] High-level modules must not have direct dependency on more than **2** concrete classes that implement the same abstraction.

## Allowed Exceptions

- **Orchestration Classes**: Modules that act as *Factory* to instantiate types, where `switch` logic is centralized.

## How to Detect

### Manual

Whenever it's necessary to add new functionality, check if it was necessary to modify the base class (if yes, OCP violated).

### Automatic

ESLint: Rules that detect high number of *switch/if-else* in a method.

## Related to

- [002 - Prohibition of ELSE Clause](../object-calisthenics/002_prohibition-else-clause.md): reinforces
- [012 - Liskov Substitution Principle](../solid/003_liskov-substitution-principle.md): depends
- [013 - Interface Segregation Principle](../solid/004_interface-segregation-principle.md): complements
- [010 - Single Responsibility Principle](../solid/001_single-responsibility-principle.md): complements
- [014 - Dependency Inversion Principle](../solid/005_dependency-inversion-principle.md): reinforces
- [020 - Command-Query Separation](../clean-code/018_conformidade-principio-inversao-consulta.md): reinforces
- [043 - Backing Services as Resources](../twelve-factor/004_backing-services-resources.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
