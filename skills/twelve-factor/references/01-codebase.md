# Factor 01 — Codebase

**deMGoncalves Rule:** [040 - Single Codebase](../../../rules/040_base-codigo-unica.md)
**Question:** One application = one repository tracked in version control?

## What It Is

An application must have exactly one codebase tracked in version control, with multiple deploys originating from that same base. The relationship between codebase and application is always **1:1**.

**Multiple codebases = distributed system, not an application.**
**Shared code = extract to library with independent versioning.**

## Compliance Criteria

- [ ] The application has **a single repository** in Git with branches for environments (dev, staging, prod)
- [ ] Shared code between applications was extracted into **independent libraries** with their own versioning
- [ ] Zero occurrences of *copy-paste deployment* between repositories

## ❌ Violation

```bash
# Multiple codebase structure for same app
repo-app-frontend/
repo-app-backend/
repo-app-workers/

# Duplicated code in multiple repos
repo-app-a/src/utils/validation.js  # duplicated
repo-app-b/src/utils/validation.js  # violation
```

## ✅ Good

```bash
# Single repository with multiple environments
repo-app/
├── .git/
├── src/
│   ├── frontend/
│   ├── backend/
│   └── workers/
└── branches: main, staging, dev

# Shared code extracted to library
@company/validation-lib  # independent npm package
  ├── version: 1.2.3
  └── used by: app-a, app-b, app-c
```

## Codetag when violated

```typescript
// FIXME: Code duplicated in multiple repos — extract to @company/shared-utils
function validateEmail(email: string): boolean { /* ... */ }
```
