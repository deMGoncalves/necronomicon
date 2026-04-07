# Release Reuse Equivalency Principle for Packages (REP)

**ID**: ESTRUTURAL-015
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

The module/package intended for reuse should have the same release scope as its consumer. The granularity of reuse is the granularity of release.

## Why It Matters

REP violations lead to packages that are difficult to version and consume, forcing clients to accept modules they don't use, or to wait for unnecessary releases to obtain a fix.

## Objective Criteria

- [ ] The reusable package should be minimally cohesive (SRP applied at package level).
- [ ] All items in the reusable package should be released under the same version (no *sub-versioning*).
- [ ] The folder/package should have a single reuse objective (e.g., *Logging*, *Validation*, *DomainPrimitives*).

## Permitted Exceptions

- **Monorepos with Workspaces**: Environments where dependency management is strictly controlled so that versions are always synchronized.

## How to Detect

### Manual

Check if the package contains classes that are not used together by clients.

### Automatic

Dependency analysis: `dependency-analysis` to identify unused classes.

## Related To

- [016 - Common Closure Principle](016_principio-fechamento-comum.md): complements
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [017 - Common Reuse Principle](017_principio-reuso-comum.md): complements
- [040 - Single Codebase](040_base-codigo-unica.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
