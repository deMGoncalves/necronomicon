# Dev/Prod Parity

**ID**: INFRASTRUCTURE-049
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

Development, staging, and production environments must be as **similar as possible**. This includes minimizing time gaps (frequent deploy), personnel gaps (who develops also deploys), and tool gaps (same technologies in all environments).

## Why it matters

Divergences between environments cause bugs that only appear in production, making debugging difficult and deploys risky. Parity allows developers to trust that what works locally will work in production.

## Objective Criteria

- [ ] The same **backing services** (database, cache, queue) must be used in dev and prod — using SQLite in dev and PostgreSQL in prod is prohibited.
- [ ] The time between writing code and deploying to production must be less than **1 day** (ideally hours).
- [ ] Containers or environment configurations must be **identical** between dev and prod (e.g., same Dockerfile).

## Allowed Exceptions

- **Resource Scale**: Scale differences (fewer replicas, less CPU/memory) are acceptable provided the architecture is identical.
- **Test Data**: Use of synthetic or anonymized data in dev is mandatory for security reasons.

## How to Detect

### Manual

Compare technology stack and service versions between environments. Check if bugs reported in prod are reproducible in dev.

### Automatic

Infrastructure as Code: Compare manifests (Terraform, Docker Compose) between environments to detect divergences.

## Related to

- [042 - Configurations via Environment](../twelve-factor/003_configuracoes-via-ambiente.md): reinforces
- [043 - Backing Services as Resources](../twelve-factor/004_servicos-apoio-recursos.md): reinforces
- [044 - Strict Separation of Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): reinforces
- [032 - Minimum Test Coverage](../clean-code/012_cobertura-teste-minima-qualidade.md): complements

---

**Created on**: 2025-01-10
**Version**: 1.0
