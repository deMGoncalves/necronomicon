# Configurations via Environment Variables

**ID**: INFRASTRUCTURE-042
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

All configurations that vary between environments (*deploy*) must be stored in **environment variables**, not in versioned configuration files or hardcoded in code. This includes credentials, service URLs, and feature flags.

## Why it matters

Hardcoded configurations or versioned files create credential leak risk, prevent flexible deploys, and violate the separation between code and configuration. Environment variables allow the same code to run in any environment.

## Objective Criteria

- [ ] Credentials (API keys, passwords, tokens) must be accessed **exclusively** via `process.env` or equivalent.
- [ ] Versioning `.env` files with real production or staging values is prohibited.
- [ ] Code must work with **zero** environment-specific configuration files in the repository.

## Allowed Exceptions

- **Development Configurations**: `.env.example` file with example values for documentation.
- **Structural Configurations**: Build configuration files (`tsconfig.json`, `biome.json`) that do not vary between deploys.

## How to Detect

### Manual

Search for connection strings, API URLs, or hardcoded credentials in source code.

### Automatic

ESLint: Custom rules to detect strings that look like credentials. Git-secrets or Gitleaks for secret scanning.

## Related to

- [030 - Prohibition of Unsafe Functions](../clean-code/010_proibicao-funcoes-inseguras.md): reinforces
- [024 - Prohibition of Magic Constants](../clean-code/004_proibicao-constantes-magicas.md): reinforces
- [041 - Explicit Declaration of Dependencies](../twelve-factor/002_declaracao-explicita-dependencias.md): complements
- [043 - Backing Services as Resources](../twelve-factor/004_servicos-apoio-recursos.md): complements
- [049 - Dev/Prod Parity](../twelve-factor/010_paridade-dev-prod.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
