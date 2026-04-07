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

# Administrative Processes as One-Off (Admin Processes)

**ID**: INFRAESTRUTURA-051
**Severity**: 🟠 High
**Category**: Infrastructure

---

## What It Is

Administrative or maintenance tasks (database migrations, fix scripts, REPL console) must be executed as **one-off processes** in the same environment and with the same code as the main application, not as separate scripts or persistent processes.

## Why It Matters

Administrative processes executed outside the application environment may use different versions of code or dependencies, causing inconsistencies. Executing in the same context ensures migrations and scripts use exactly the same code in production.

## Objective Criteria

- [ ] Database migration scripts must be executed as one-off processes using the same runtime and dependencies as the application.
- [ ] Administrative tasks must be **versioned in the repository** alongside the application code.
- [ ] Executing administrative scripts via direct SSH to the server is prohibited — they must use the same deployment mechanism.

## Allowed Exceptions

- **Infrastructure Tools**: Infrastructure provisioning scripts (Terraform, Ansible) that operate at a different level than the application.
- **Emergency Debugging**: Direct environment access in critical production situations, with audit.

## How to Detect

### Manual

Check if migration or maintenance scripts are executed via separate process or via manual SSH.

### Automatic

CI/CD: Pipeline that executes migrations as a deployment step, using the same container/environment as the application.

## Related To

- [040 - Single Codebase](040_base-codigo-unica.md): reinforces
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): reinforces
- [044 - Build, Release, Run Separation](044_separacao-build-release-run.md): complements
- [049 - Dev/Prod Parity](049_paridade-dev-prod.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
