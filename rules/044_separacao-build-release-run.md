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

# Strict Build, Release, and Run Separation

**ID**: INFRAESTRUTURA-044
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

The deployment process must be separated into three distinct and immutable stages: **Build** (compiles the code), **Release** (combines build with configuration), and **Run** (executes the application). Each release must have a unique identifier and be immutable.

## Why It Matters

Separation enables fast rollbacks, release auditing, and ensures the running code is exactly the same that was tested. Mixing stages creates ambiguity about what is running and prevents reproducibility.

## Objective Criteria

- [ ] The **Build** stage must produce an executable artifact (bundle, container image) without environment configuration dependencies.
- [ ] The **Release** stage must be immutable — once created, the release cannot be changed; fixes require a new release.
- [ ] Every release must have a **unique identifier** (timestamp, hash, sequential number) for traceability.

## Allowed Exceptions

- **Local Development Environment**: Build and run can be combined to speed up development cycle (e.g., `bun run dev`).

## How to Detect

### Manual

Check if it's possible to change code or configuration of a release already in production without creating a new release.

### Automatic

CI/CD: Pipeline that rejects manual deploys and requires passing through all three stages with versioning.

## Related To

- [040 - Single Codebase](040_base-codigo-unica.md): complements
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): reinforces
- [042 - Configuration via Environment](042_configuracoes-via-ambiente.md): complements
- [049 - Dev/Prod Parity](049_paridade-dev-prod.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
