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

# Single Codebase

**ID**: INFRAESTRUTURA-040
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

An application must have exactly one codebase tracked in version control, with multiple *deploys* originating from this same base. The relationship between codebase and application is always 1:1.

## Why It Matters

Multiple codebases for the same application indicate a distributed system, not an application. Shared code should be extracted into libraries and managed via dependencies. Violation makes traceability, versioning, and maintenance difficult.

## Objective Criteria

- [ ] The application must have **a single repository** of source code, with branches for different stages (dev, staging, prod).
- [ ] Shared code between applications must be extracted into **independent libraries** with their own versioning.
- [ ] Copying code between repositories of different applications (*copy-paste deployment*) is prohibited.

## Allowed Exceptions

- **Organizational Monorepos**: Multiple applications in a single repository, provided each application has its own root directory and independent deploy pipeline.

## How to Detect

### Manual

Check if there are multiple repositories with duplicated code or if the same functionality is maintained in different locations.

### Automatic

Git: Analysis of commit history and branches to identify unintentional divergences.

## Related To

- [021 - Prohibition of Logic Duplication](021_proibicao-duplicacao-logica.md): reinforces
- [015 - Release Reuse Equivalence Principle](015_principio-equivalencia-lancamento-reuso.md): reinforces
- [044 - Build, Release, Run Separation](044_separacao-build-release-run.md): complements

---

**Created on**: 2025-01-10
**Version**: 1.0
