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

# Backing Services as Attached Resources

**ID**: INFRAESTRUTURA-043
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

Backing services (databases, queues, caches, email services, external APIs) must be treated as **attached resources**, accessed via URL or resource locator stored in configuration. The application must not distinguish between local and third-party services.

## Why It Matters

Treating services as attached resources allows swapping a local database for a managed one (e.g., RDS), or one email service for another, without code changes. This increases resilience and deployment flexibility.

## Objective Criteria

- [ ] All external services must be accessed via **URL or connection string** configurable by environment variable.
- [ ] The code must not contain conditional logic that differentiates local from remote services (e.g., `if (isLocal) useLocalDB()`).
- [ ] Swapping a backing service must require **only** configuration change, not code.

## Allowed Exceptions

- **Test Mocks**: Service substitution by mocks in unit test environment, controlled via dependency injection.

## How to Detect

### Manual

Check if swapping a service (e.g., MySQL to PostgreSQL, or local Redis to ElastiCache) requires code changes.

### Automatic

Code analysis: Search for hardcoded URLs or hosts, or for environment-based conditionals.

## Related To

- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [042 - Configuration via Environment](042_configuracoes-via-ambiente.md): complements
- [049 - Dev/Prod Parity](049_paridade-dev-prod.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
