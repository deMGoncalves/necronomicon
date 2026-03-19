# Explicit Declaration of Dependencies

**ID**: INFRASTRUCTURE-041
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

An application must declare **all** its dependencies explicitly and completely through a dependency manifest (e.g., `package.json`, `requirements.txt`). The application must never depend on the implicit existence of packages in the system.

## Why it matters

Implicit dependencies break portability and environment reproducibility. A new developer or a new server will not be able to run the application without prior knowledge of hidden dependencies, violating the principle of minimal *setup*.

## Objective Criteria

- [ ] **100%** of runtime and build dependencies must be declared in the manifest (`package.json`, `bun.lockb`).
- [ ] Using global system dependencies (e.g., libraries installed via `npm install -g` or `apt-get`) is prohibited.
- [ ] The dependency *lockfile* must be versioned and kept up to date to ensure deterministic builds.

## Allowed Exceptions

- **Base Runtime**: Fundamental runtime dependencies (e.g., Node.js, Bun, Python) that are declared as environment requirements.

## How to Detect

### Manual

Clone the repository on a clean machine and run `npm install && npm start` — if it fails due to a missing dependency, there is a violation.

### Automatic

CI/CD: Builds in ephemeral containers (Docker) that fail if there are undeclared dependencies.

## Related to

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): complements
- [018 - Acyclic Dependencies Principle](004_acyclic-dependencies-principle.md): reinforces
- [042 - Configurations via Environment](../twelve-factor/003_configuracoes-via-ambiente.md): complements
- [044 - Strict Separation of Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
