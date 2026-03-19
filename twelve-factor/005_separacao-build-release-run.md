# Strict Separation of Build, Release, and Run

**ID**: INFRASTRUCTURE-044
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

The deploy process must be separated into three distinct and immutable stages: **Build** (compiles the code), **Release** (combines build with configuration), and **Run** (executes the application). Each release must have a unique identifier and be immutable.

## Why it matters

Separation enables fast rollbacks, release auditing, and ensures that the code in execution is exactly the same that was tested. Mixing stages creates ambiguity about what is running and prevents reproducibility.

## Objective Criteria

- [ ] The **Build** stage must produce an executable artifact (bundle, container image) without environment configuration dependencies.
- [ ] The **Release** stage must be immutable — once created, the release cannot be altered; fixes require a new release.
- [ ] Every release must have a **unique identifier** (timestamp, hash, sequential number) for traceability.

## Allowed Exceptions

- **Local Development Environment**: Build and run may be combined to expedite the development cycle (e.g., `bun run dev`).

## How to Detect

### Manual

Check if it is possible to alter code or configuration of a release already in production without creating a new release.

### Automatic

CI/CD: Pipeline that rejects manual deploys and requires passage through the three stages with versioning.

## Related to

- [040 - Single Codebase](../twelve-factor/001_base-codigo-unica.md): complements
- [041 - Explicit Declaration of Dependencies](../twelve-factor/002_declaracao-explicita-dependencias.md): reinforces
- [042 - Configurations via Environment](../twelve-factor/003_configuracoes-via-ambiente.md): complements
- [049 - Dev/Prod Parity](../twelve-factor/010_paridade-dev-prod.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
