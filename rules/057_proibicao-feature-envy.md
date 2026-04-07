# Prohibition of Feature Envy

**ID**: AP-13-057
**Severity**: 🟡 Medium
**Category**: Behavioral

---

## What It Is

Feature Envy occurs when a method uses data and behaviors from another class more than from its own. It indicates the method is in the wrong class — it "envies" the other class and should be there. The method seems more interested in another object's data than its own.

## Why It Matters

- Encapsulation violation: method needs to expose internal data of another class (`getters`)
- Unnecessary coupling: makes it difficult to change one class without breaking the other
- Fragmented logic: to understand a complete business rule, you need to read multiple classes
- Testing difficulty: testing the method requires constructing another class's object with correct state
- Violation of Tell, Don't Ask: asking for state instead of requesting behavior

## Objective Criteria

- [ ] Method calls getters of another object 3 or more times
- [ ] Method accesses properties of another object more than `this`
- [ ] Method appears to be working on another object's data instead of its own
- [ ] To test the method, you need to configure complex state of dependent objects
- [ ] Method that uses no attribute or method of its own class, only dependencies

## Allowed Exceptions

- Methods in controllers/orchestrators that orchestrate flows between multiple service objects
- DTOs/Data mappers that extract data from multiple objects to format/serialize
- Event handlers that aggregate data from different sources for single processing
- Legacy code where refactoring would bring high risk without clear gain

## How to Detect

### Manual
- Read methods: identify those that repeatedly call `obj.getSomething()`
- Look for applications where coupling level is high even encapsulated via getters
- Check methods that don't use `this` internally (or use it minimally)
- Analyze tests: if testing method requires complex setup of external dependencies, it may be feature envy

### Automatic
- Coupling analysis: detect methods with high dependency on other classes' data
- Code complexity tools: detect methods that access many attributes of different objects
- Linters: detect attempts to access internal properties instead of methods

## Related To

- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [008 - Prohibition of Getters and Setters](008_proibicao-getters-setters.md): reinforces
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): complements
- [061 - Prohibition of Middle Man](061_proibicao-middle-man.md): complements
- [003 - Primitive Encapsulation](003_encapsulamento-primitivos.md): reinforces
- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
