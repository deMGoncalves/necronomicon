# Backing Services as Attached Resources

**ID**: INFRASTRUCTURE-043
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

Backing services (databases, queues, caches, email services, external APIs) must be treated as **attached resources**, accessed via URL or resource locator stored in configuration. The application must not distinguish between local and third-party services.

## Why it matters

Treating services as attached resources allows swapping a local database for a managed one (e.g., RDS), or one email service for another, without code changes. This increases resilience and deploy flexibility.

## Objective Criteria

- [ ] All external services must be accessed via **URL or connection string** configurable by environment variable.
- [ ] Code must not contain conditional logic that differentiates local from remote services (e.g., `if (isLocal) useLocalDB()`).
- [ ] Swapping a backing service must require **only** configuration change, not code change.

## Allowed Exceptions

- **Test Mocks**: Substitution of services by mocks in unit test environment, controlled via dependency injection.

## How to Detect

### Manual

Check if swapping a service (e.g., MySQL to PostgreSQL, or local Redis to ElastiCache) requires code changes.

### Automatic

Code analysis: Search for hardcoded URLs or hosts, or environment-based conditionals.

## Related to

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reinforces
- [042 - Configurations via Environment](../twelve-factor/003_configuracoes-via-ambiente.md): complements
- [049 - Dev/Prod Parity](../twelve-factor/010_paridade-dev-prod.md): reinforces
- [011 - Open/Closed Principle](002_open-closed-principle.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
