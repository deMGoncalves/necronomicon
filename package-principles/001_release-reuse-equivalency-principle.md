# Release Reuse Equivalency Principle (REP)

**ID**: STRUCTURAL-015
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

The module/package intended for reuse must have the same release scope as its consumer. The granularity of reuse is the granularity of release.

## Why it matters

REP violations lead to packages that are difficult to version and consume, forcing clients to accept modules they don't use, or to wait for unnecessary releases to get a fix.

## Objective Criteria

- [ ] The reusable package must be minimally cohesive (SRP applied at package level).
- [ ] All items in the reusable package must be released under the same version (no *sub-versioning*).
- [ ] The folder/package must have a single reuse purpose (e.g., *Logging*, *Validation*, *DomainPrimitives*).

## Allowed Exceptions

- **Monorepos with Workspaces**: Environments where dependency management is strictly controlled so that the version is always synchronized.

## How to Detect

### Manual

Check if the package contains classes that are not used together by clients.

### Automatic

Dependency analysis: `dependency-analysis` to identify unused classes.

## Related to

- [016 - Common Closure Principle](../package-principles/002_common-closure-principle.md): complements
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reinforces
- [017 - Common Reuse Principle](../package-principles/003_common-reuse-principle.md): complements
- [040 - Single Codebase](../twelve-factor/001_single-codebase.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
