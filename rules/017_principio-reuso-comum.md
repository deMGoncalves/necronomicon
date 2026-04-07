# Common Reuse Principle (CRP)

**ID**: ESTRUTURAL-017
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Classes in a package should be reused together. If you use one, you should use all.

## Why It Matters

CRP helps refine package granularity, ensuring that clients are not forced to depend on classes they don't use, which avoids unnecessary recompilations/redeploys and reduces unwanted coupling.

## Objective Criteria

- [ ] The package should be split if there are classes that are not used by at least **50%** of clients importing the package.
- [ ] If a class is used in isolation, it should be moved to a utility package or outside the cohesive package.
- [ ] There should not be more than **3** public classes within a package that are not externally referenced.

## Permitted Exceptions

- **Private Support Methods**: Internal helper classes that are strictly used to support the public classes of the package.

## How to Detect

### Manual

Check the `imports` directory of a client and see how many classes from the imported package it actively uses.

### Automatic

Dependency analysis: Tools that map the percentage of classes consumed within a package.

## Related To

- [015 - Release Reuse Equivalency Principle](015_principio-equivalencia-lancamento-reuso.md): complements
- [013 - Interface Segregation Principle](013_principio-segregacao-interfaces.md): reinforces
- [016 - Common Closure Principle](016_principio-fechamento-comum.md): complements
- [056 - Prohibition of Zombie Code (Lava Flow)](056_proibicao-codigo-zombie-lava-flow.md): reinforces
- [067 - Prohibition of Boat Anchor Dependency](067_proibicao-dependencia-barco-ancora.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
