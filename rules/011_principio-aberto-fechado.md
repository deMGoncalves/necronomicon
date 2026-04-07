# Conformance to the Open/Closed Principle (OCP)

**ID**: COMPORTAMENTAL-011
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Modules, classes, or functions should be open for extension and closed for modification, allowing the addition of new behaviors without altering the existing code of the unit.

## Why It Matters

OCP violation leads to fragile code. Conformance reduces the risk of regression and increases maintainability, as new functionalities are added without the need to rewrite already tested logic.

## Objective Criteria

- [ ] Adding a new "type" of behavior should be implemented via inheritance or composition, and **not** by new `if/switch` statements in existing code.
- [ ] Methods with more than **3** `if/else if/switch case` clauses that deal with *types* (e.g., `if (type === 'A')`) violate OCP.
- [ ] High-level modules should not have direct dependency on more than **2** concrete classes implementing the same abstraction.

## Permitted Exceptions

- **Orchestration Classes**: Modules that act as *Factory* to instantiate types, where the `switch` logic is centralized.

## How to Detect

### Manual

Whenever it is necessary to add new functionality, check if it was necessary to modify the base class (if yes, OCP violated).

### Automatic

ESLint: Rules that detect high number of *switch/if-else* in a method.

## Related To

- [002 - Prohibition of ELSE Clause](002_proibicao-clausula-else.md): reinforces
- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): depends
- [013 - Interface Segregation Principle](013_principio-segregacao-interface.md): complements
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): complements
- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [020 - Command-Query Separation](020_separacao-command-query-cqrs.md): reinforces
- [043 - Backing Services as Resources](043_servicos-apoio-recursos.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
