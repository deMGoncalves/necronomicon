# Prohibition of Relative Imports (Mandatory Path Aliases)

**ID**: ESTRUTURAL-031
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

**Completely** prohibits the use of relative paths with `../` and mandates the obligatory use of *path aliases* for all imports between modules.

## Why It Matters

Relative *imports* break code **portability** and **readability**. The rule reinforces **Clean Architecture**, ensuring modules are always referenced by their aliases (`@agent`, `@dom`, `@event`, etc.), making the code more consistent and easier to refactor.

## Objective Criteria

- [ ] Using `../` in any *import* path is **prohibited**.
- [ ] All modules must be imported exclusively via *path aliases* (e.g., `import { X } from "@dom/html"`).
- [ ] Only same-directory imports (`./file`) are allowed for sibling files.
- [ ] The configuration file (`vite.config.js` or `tsconfig.json`) must define all necessary *paths*.

## Allowed Exceptions

- **Sibling Files**: Direct *imports* to files in the same directory (`./file`) are allowed.

## How to Detect

### Manual

Search for `../` in any source code file.

### Automatic

ESLint/Biome: `no-relative-imports` rule configured to prohibit any use of `../`.

## Related To

- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): reinforces

---

**Created on**: 2025-10-08
**Updated on**: 2026-01-11
**Version**: 2.0
