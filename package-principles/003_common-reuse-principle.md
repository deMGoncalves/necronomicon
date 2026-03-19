# Common Reuse Principle (CRP)

**ID**: STRUCTURAL-017
**Severity**: 🟡 Medium
**Category**: Structural

---

## What it is

Classes in a package should be reused together. If you use one, you should use all.

## Why it matters

CRP helps refine package granularity, ensuring clients are not forced to depend on classes they don't use, which avoids unnecessary recompilations/redeploy and reduces unwanted coupling.

## Objective Criteria

- [ ] The package should be split if there are classes not used by at least **50%** of the clients that import the package.
- [ ] If a class is used in isolation, it should be moved to a utility package or out of the cohesive package.
- [ ] There should not be more than **3** public classes within a package that are not externally referenced.

## Allowed Exceptions

- **Private Support Methods**: Internal helper classes that are strictly used to support the public classes of the package.

## How to Detect

### Manual

Check the `imports` directory of a client and see how many classes from the imported package it actively uses.

### Automatic

Dependency analysis: Tools that map the percentage of classes consumed within a package.

## Related to

- [015 - Release Reuse Equivalency Principle](../package-principles/001_release-reuse-equivalency-principle.md): complements
- [013 - Interface Segregation Principle](004_interface-segregation-principle.md): reinforces
- [016 - Common Closure Principle](../package-principles/002_common-closure-principle.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
