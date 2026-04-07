---
paths:
  - "**/*.yml"
  - "**/*.yaml"
  - "**/*.json"
  - "**/Dockerfile*"
  - "**/docker-compose*"
  - "**/.env*"
  - "**/package.json"
  - "**/tsconfig.json"
---

# Explicit Dependency Declaration (Dependencies)

**ID**: INFRAESTRUTURA-041
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

An application must declare **all** its dependencies explicitly and completely through a dependency manifest (e.g., `package.json`, `requirements.txt`). The application must never depend on implicit existence of system packages.

## Why It Matters

Implicit dependencies break portability and environment reproducibility. A new developer or new server will not be able to run the application without prior knowledge of hidden dependencies, violating the minimal *setup* principle.

## Objective Criteria

- [ ] **100%** of runtime and build dependencies must be declared in the manifest (`package.json`, `bun.lockb`).
- [ ] Using global system dependencies is prohibited (e.g., libraries installed via `npm install -g` or `apt-get`).
- [ ] The dependency *lockfile* must be versioned and kept updated to ensure deterministic builds.

## Allowed Exceptions

- **Base Runtime**: Fundamental runtime dependencies (e.g., Node.js, Bun, Python) that are declared as environment requirements.

## How to Detect

### Manual

Clone the repository on a clean machine and run `npm install && npm start` — if it fails due to missing dependency, there is a violation.

### Automatic

CI/CD: Builds in ephemeral containers (Docker) that fail if there are undeclared dependencies.

## Related To

- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): complements
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): reinforces
- [042 - Configuration via Environment](042_configuracoes-via-ambiente.md): complements
- [044 - Build, Release, Run Separation](044_separacao-build-release-run.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
