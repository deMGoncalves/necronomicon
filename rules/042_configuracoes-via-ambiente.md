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

# Configuration via Environment Variables (Config)

**ID**: INFRAESTRUTURA-042
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

All configurations that vary between environments (*deploy*) must be stored in **environment variables**, not in versioned configuration files or hardcoded in the code. This includes credentials, service URLs, and feature flags.

## Why It Matters

Hardcoded configurations or versioned files create credential leak risk, prevent flexible deploys, and violate separation between code and configuration. Environment variables allow the same code to run in any environment.

## Objective Criteria

- [ ] Credentials (API keys, passwords, tokens) must be accessed **exclusively** via `process.env` or equivalent.
- [ ] Versioning `.env` files with real production or staging values is prohibited.
- [ ] The code must work with **zero** environment-specific configuration files in the repository.

## Allowed Exceptions

- **Development Configurations**: `.env.example` file with example values for documentation.
- **Structural Configurations**: Build configuration files (`tsconfig.json`, `biome.json`) that do not vary between deploys.

## How to Detect

### Manual

Search for connection strings, API URLs, or hardcoded credentials in source code.

### Automatic

ESLint: Custom rules to detect strings that look like credentials. Git-secrets or Gitleaks for secret scanning.

## Related To

- [030 - Prohibition of Unsafe Functions](030_proibicao-funcoes-inseguras.md): reinforces
- [024 - Prohibition of Magic Constants](024_proibicao-constantes-magicas.md): reinforces
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): complements
- [043 - Backing Services as Attached Resources](043_servicos-apoio-recursos.md): complements
- [049 - Dev/Prod Parity](049_paridade-dev-prod.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
