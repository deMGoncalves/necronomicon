# Method Chaining Restriction

**ID**: STRUCTURAL-005
**Severity**: 🟡 Medium
**Category**: Structural

---

## What it is

Limits method call chaining and chained property access (*train wrecks*), allowing at most one method call or property access per line.

## Why it matters

Excessive chaining (e.g., `a.b().c().d()`) violates the Law of Demeter (Principle of Least Knowledge), increasing client coupling to internal details of the object structure. The restriction improves readability by forcing line breaks or the use of temporary variables.

## Objective Criteria

- [ ] Each statement must contain at most one method call or one property access (e.g., `a.b()`).
- [ ] Multiple calls on the same line (e.g., `object.getA().getB()`) are prohibited.
- [ ] Multiple calls must be broken into separate lines or delegated to a new method.

## Allowed Exceptions

- **Fluent Interfaces/Builders**: Design patterns (*Builder* or *Chaining*) that return `this` to configure an object (e.g., `new Query().where().limit()`).
- **Static Constants**: Access to static constants from utility classes.

## How to Detect

### Manual

Search for two or more consecutive dots (`.`) (excluding floating point) in a single statement line.

### Automatic

ESLint: `no-chaining` (with custom plugins).

## Related to

- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reinforces
- [006 - Prohibition of Abbreviated Names](../object-calisthenics/006_prohibition-abbreviated-names.md): complements
- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
