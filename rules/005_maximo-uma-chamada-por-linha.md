# Restriction on Method Call Chaining (*Method Chaining*)

**ID**: ESTRUTURAL-005
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Limits chaining of method calls and access to chained properties (*train wrecks*), allowing at most one method call or property access per line.

*(Prevents the anti-pattern Message Chains / Train Wreck: sequences `a.getB().getC().getD()` that couple the client to the internal structure of the entire object chain.)*

## Why It Matters

Excessive chaining (e.g., `a.b().c().d()`) violates the Law of Demeter (Principle of Least Knowledge), increasing coupling of the client to internal details of object structure. The restriction improves readability by forcing line breaks or use of temporary variables.

## Objective Criteria

- [ ] Each statement should contain, at most, one method call or one property access (e.g., `a.b()`).
- [ ] Multiple calls on the same line (e.g., `object.getA().getB()`) are prohibited.
- [ ] Multiple calls should be broken into separate lines or delegated to a new method.

## Permitted Exceptions

- **Fluent Interfaces/Builders**: Design patterns (*Builder* or *Chaining*) that return `this` to configure an object (e.g., `new Query().where().limit()`).
- **Static Constants**: Access to static constants from utility classes.

## How to Detect

### Manual

Search for two or more consecutive dots (`.`) (excluding floating point) in a single statement line.

### Automatic

ESLint: `no-chaining` (with custom plugins).

## Related To

- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): complements
- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
