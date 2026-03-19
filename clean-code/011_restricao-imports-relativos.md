# Prohibition of Relative Imports (Mandatory Path Aliases)

**ID**: STRUCTURAL-031
**Severity**: 🔴 Critical
**Category**: Structural

---

## What it is

**Completely** prohibits the use of relative paths with `../` and imposes mandatory use of *path aliases* for all imports between modules.

## Why it matters

Relative *imports* break code **portability** and **readability**. The rule reinforces **Clean Architecture**, ensuring that modules are always referenced by their aliases (`@agent`, `@dom`, `@event`, etc.), making the code more consistent and easier to refactor.

## Objective Criteria

- [ ] The use of `../` in any *import* path is **prohibited**.
- [ ] All modules must be imported exclusively by *path aliases* (e.g., `import { X } from "@dom/html"`).
- [ ] Only imports from the same directory (`./file`) are allowed for sibling files.
- [ ] The configuration file (`vite.config.js` or `tsconfig.json`) must define all necessary *paths*.

## Allowed Exceptions

- **Sibling Files**: Direct *imports* for files in the same directory (`./file`) are allowed.

## How to Detect

### Manual

Search for `../` in any source code file.

### Automatic

ESLint/Biome: `no-relative-imports` rule configured to prohibit any use of `../`.

## Related to

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reinforces
- [018 - Acyclic Dependencies Principle](004_acyclic-dependencies-principle.md): reinforces

---

**Created on**: 2025-10-08
**Updated on**: 2026-01-11
**Version**: 2.0
