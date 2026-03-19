# Acyclic Dependencies Principle (ADP)

**ID**: STRUCTURAL-018
**Severity**: 🔴 Critical
**Category**: Structural

---

## What it is

The dependency graph between packages must be acyclic, meaning there must be no circular dependencies between modules.

## Why it matters

Circular dependencies create a tight knot where classes in involved modules become inseparable. This prevents isolated testing, makes deployment more complex, and makes individual module reuse impossible.

## Objective Criteria

- [ ] It is prohibited for Module A to depend on Module B, and Module B to depend on Module A.
- [ ] Circular modules (with dependency loops) must be immediately broken via DIP (extracting common interface).
- [ ] The dependency graph analysis must result in a Directed Acyclic Graph (DAG).

## Allowed Exceptions

- **Infrastructure Classes**: Circular dependencies between classes *internal* to the same package, as long as they don't involve the public interface.

## How to Detect

### Manual

Search for `import { B } from 'module-b'` in `module-a` and `import { A } from 'module-a'` in `module-b`.

### Automatic

Dependency analysis: `dependency-graph-analysis` (detects cycles).

## Related to

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reinforces
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reinforces
- [019 - Stable Dependencies Principle](../package-principles/005_stable-dependencies-principle.md): complements
- [041 - Explicit Dependency Declaration](../twelve-factor/002_explicit-dependency-declaration.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
