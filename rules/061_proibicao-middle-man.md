# Prohibition of Middle Man

**ID**: AP-19-061
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Middle Man occurs when a class delegates most of its methods to another class without adding its own value. If 50%+ of a class's methods only pass calls (one-line `return this.obj.method(args)`), it's a useless Middle Man. It's the inverse of Feature Envy: here, the middle man delegates everything; there, the method does another object's work.

## Why It Matters

- Unnecessary complexity: more files, more imports, more names to learn
- Duplicated maintenance: each change in the real interface requires change in the Middle Man
- Slower debugging: stack trace with unnecessary layers and confusion about where real logic is
- Indirect coupling: if removing real object, middle man loses existence without value
- Indicates over-engineering or incomplete refactoring: class was useful once but lost purpose

## Objective Criteria

- [ ] 50%+ of class methods are one-line delegates without adding value
- [ ] Class exists only to hide another object initially exposed directly
- [ ] Whenever adding a method to real object, add same wrapper to Middle Man
- [ ] Stack trace always shows same method names in two consecutive layers
- [ ] Middle Man isn't used/tested in isolation — always needs real object working

## Allowed Exceptions

- Facade patterns that simplify complex interface (adding value via simplification)
- Proxies with cross-cutting concerns (logging, caching, authentication)
- Adapters that transform interfaces of different formats
- DTOs/ViewModels that transform entity objects for presentation layer

## How to Detect

### Manual
- Read class: identify methods that only do `return this.obj.method(args)` without modification
- Look for classes where adding method always requires adding same delegate in another class
- Check tests: middle man tests only test that it forwards correctly, not own logic
- Analyze calls: always navigate through middle man to reach real object

### Automatic
- Static analysis: detect classes with high rate of methods that only delegate (vs implement logic)
- Code complexity: detect classes where cyclomatic complexity per method ≈ 1 (more delegating code)
- Coupling analysis: detect classes that only exist to encapsulate others without adding behavior

## Related To

- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [057 - Prohibition of Feature Envy](057_proibicao-feature-envy.md): complements
- [008 - Prohibition of Getters and Setters](008_proibicao-getters-setters.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): complements
- [065 - Prohibition of Poltergeists](065_proibicao-poltergeists.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
