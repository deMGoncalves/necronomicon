# Single Codebase

**ID**: INFRASTRUCTURE-040
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

An application must have exactly one codebase tracked in version control, with multiple *deploys* originating from that same base. The relationship between codebase and application is always 1:1.

## Why it matters

Multiple codebases for the same application indicate a distributed system, not an application. Shared code should be extracted into libraries and managed via dependencies. Violation hinders traceability, versioning, and maintenance.

## Objective Criteria

- [ ] The application must have **a single repository** of source code, with branches for different stages (dev, staging, prod).
- [ ] Code shared between applications must be extracted to **independent libraries** with their own versioning.
- [ ] Copying code between repositories of different applications (*copy-paste deployment*) is prohibited.

## Allowed Exceptions

- **Organizational Monorepos**: Multiple applications in a single repository, provided each application has its own root directory and independent deploy pipeline.

## How to Detect

### Manual

Check if there are multiple repositories with duplicate code or if the same functionality is maintained in different locations.

### Automatic

Git: Commit history and branch analysis to identify unintentional divergences.

## Related to

- [021 - Prohibition of Logic Duplication](../clean-code/001_prohibition-logic-duplication.md): reinforces
- [015 - Release Reuse Equivalence Principle](001_release-reuse-equivalency-principle.md): reinforces
- [044 - Strict Separation of Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): complements

---

**Created on**: 2025-01-10
**Version**: 1.0
