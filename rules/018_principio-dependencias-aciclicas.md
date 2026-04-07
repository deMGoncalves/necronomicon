# Acyclic Dependencies Principle (ADP)

**ID**: ESTRUTURAL-018
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

The dependency graph between packages should be acyclic, meaning there should be no circular dependencies between modules.

## Why It Matters

Circular dependencies create a tight knot where classes in involved modules become inseparable. This prevents isolated testing, makes deployment more complex, and makes it impossible to reuse modules individually.

## Objective Criteria

- [ ] It is prohibited for Module A to depend on Module B, and Module B to depend on Module A.
- [ ] Circular modules (with dependency loops) should be immediately broken via DIP (extracting common interface).
- [ ] Dependency graph analysis should result in a Directed Acyclic Graph (DAG).

## Permitted Exceptions

- **Infrastructure Classes**: Circular dependencies between *internal* classes of the same package, as long as they don't involve the public interface.

## How to Detect

### Manual

Search for `import { B } from 'module-b'` in `module-a` and `import { A } from 'module-a'` in `module-b`.

### Automatic

Dependency analysis: `dependency-graph-analysis` (detects cycles).

## Related To

- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [019 - Stable Dependencies Principle](019_principio-dependencias-estaveis.md): complements
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
