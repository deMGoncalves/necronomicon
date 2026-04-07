# Prohibition of Poltergeists

**ID**: AP-12-065
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Poltergeists (or Short-Lived Entities) occur when classes or objects are created only to call another method or object and then are immediately discarded. Like poltergeists (transient spirits) that appear briefly and disappear, these objects don't add value, they only add transient complexity. Short-lived middle men.

## Why It Matters

- Unnecessary complexity: each poltergeist adds +1 class/set name to learn and maintain
- Reading confusion: developers wonder "why does this exist?" only to discover it has no reason
- Debugging difficulty: object creation/disposal add noise to stack trace and analysis
- Indicates incomplete refactoring or mechanical pattern application without thinking
- Spreads boilerplate code: when poltergeists are common, many files exist without purpose

## Objective Criteria

- [ ] Classes/services created only to adapt parameters or format calls and discarded
- [ ] Objects created and discarded within same scope (single line or few lines)
- [ ] Classes that exist only to pass data between layers without validation, transformation or behavior
- [ ] Frequent pattern of `new SomeAdapter(object).execute()` instead of using object directly
- [ ] Constructed objects never stored, never tested, never referenced beyond immediate call

## Allowed Exceptions

- Builder patterns where builder adds readability via fluent API even if discarded
- Adapters/wrappers that transform formats between boundaries (API → internal domain)
- Commands/Queries encapsulated in CQRS patterns that exist by design
- DTOs that are created, populated, passed to boundary then discarded (standard pattern in boundary layers)

## How to Detect

### Manual
- Look for instantiations where object is created, used, discarded immediately (all in same scope)
- Identify classes never used as fields, never referenced in tests, never part of module exports; only used locally in functions
- Code review: question "what value does this object add?" for each transient class
- Visualize call graphs: detect leaf nodes called only once

### Automatic
- Linters: detect objects created + called + discarded within same scope
- Static analysis: detect classes only referenced via instantiation and unpredictable usage
- Coverage: detect classes with 0% or < 5% usage coverage

## Related To

- [061 - Prohibition of Middle Man](061_proibicao-middle-man.md): complements
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [057 - Prohibition of Feature Envy](057_proibicao-feature-envy.md): complements
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
