# Admin Processes as One-Off

**ID**: INFRASTRUCTURE-051
**Severity**: 🟠 High
**Category**: Infrastructure

---

## What it is

Administrative or maintenance tasks (database migrations, fix scripts, REPL console) must be executed as **one-off processes** in the same environment and with the same code as the main application, not as separate scripts or persistent processes.

## Why it matters

Administrative processes executed outside the application environment may use different versions of code or dependencies, causing inconsistencies. Running in the same context ensures that migrations and scripts use exactly the same code in production.

## Objective Criteria

- [ ] Database migration scripts must be executed as one-off processes using the same runtime and dependencies as the application.
- [ ] Administrative tasks must be **versioned in the repository** along with the application code.
- [ ] Running administrative scripts via SSH directly on the server is prohibited — they must use the same deploy mechanism.

## Allowed Exceptions

- **Infrastructure Tools**: Infrastructure provisioning scripts (Terraform, Ansible) that operate at a different level than the application.
- **Emergency Debugging**: Direct environment access in critical production situations, with auditing.

## How to Detect

### Manual

Check if migration or maintenance scripts are executed via separate process or manual SSH.

### Automatic

CI/CD: Pipeline that executes migrations as deploy step, using same container/environment as the application.

## Related to

- [040 - Single Codebase](../twelve-factor/001_base-codigo-unica.md): reinforces
- [041 - Explicit Declaration of Dependencies](../twelve-factor/002_declaracao-explicita-dependencias.md): reinforces
- [044 - Strict Separation of Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): complements
- [049 - Dev/Prod Parity](../twelve-factor/010_paridade-dev-prod.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
