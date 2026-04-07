# Prohibition of Refused Bequest

**ID**: AP-17-059
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Refused Bequest occurs when a class inherits from another but doesn't use most of the inherited methods or attributes. The class refuses/rejects the inheritance it receives. Indicates poorly modeled inheritance hierarchy — the child class shouldn't inherit from parent or the inheritance should be composition instead of inheritance.

## Why It Matters

- Empty or useless abstract interface: inheritance makes class implement methods that don't make sense
- LSP (Liskov Substitution Principle) violation: replacing parent with child breaks expected behavior
- Unnecessary complexity: child class carries useless baggage from parent class
- Subtle bugs: unused methods can be accidentally invoked (e.g., via reflection, super calls)
- Indicates wrong design: if it doesn't use the inheritance, it shouldn't have inherited

## Objective Criteria

- [ ] Class overrides parent methods with exceptions (throw UnsupportedOperationException)
- [ ] Class inherits methods/attributes that are never called or used
- [ ] 60%+ of parent class methods/attributes are never used in child class
- [ ] Child class only uses 1-2 methods from parent class but inherits 10+
- [ ] Empty implementations (pass) or stubs for inherited methods that don't make sense

## Allowed Exceptions

- Marker interfaces where subclass intentionally inherits "capability" even if unused
- Abstract template method patterns where subclass overrides most behavior but inherits contract
- Framework classes where unused methods part of required interface
- Legacy code where immediate refactoring would bring high risk without clear gain

## How to Detect

### Manual
- Read subclasses: identify those with many empty overridden methods or throwing exceptions
- Look for classes where only 1-2 inherited methods are actually used
- Check inheritance where subclass doesn't "behave like a" superclass (semantic violation)
- Analyze tests: tests for subclass don't use/test inherited methods

### Automatic
- Code analysis: detect classes with high rate of overridden or unused methods
- Linters: detect overridden methods with exceptions or empty implementations
- Code coverage: branches/methods with 0% coverage in interesting subclasses

## Related To

- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): complements
- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): complements
- [008 - Prohibition of Getters and Setters](008_proibicao-getters-setters.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
