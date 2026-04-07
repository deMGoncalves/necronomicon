---
name: twelve-factor
description: "12 factors for cloud-native applications (Heroku/SaaS). Use when @developer verifies compliance with rules 040-051, or @architect defines infrastructure and deployment requirements."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Twelve-Factor App Methodology

## What It Is

The Twelve-Factor App is a methodology for building SaaS (Software-as-a-Service) applications that:

- Use **declarative configuration and automation** for setup, minimizing onboarding time and cost
- Have **maximum portability** across execution environments
- Are suitable for **deployment on modern cloud platforms**
- Minimize **divergence between dev and prod**, enabling **continuous deployment**
- Can **scale horizontally** without significant changes

Created by Heroku developers, the methodology synthesizes practices from hundreds of SaaS applications into 12 fundamental principles.

## When to Use

| Scenario | Relevant Factor(s) |
|----------|-------------------|
| Configure new project | 01-Codebase, 02-Dependencies, 03-Config |
| Prepare production deployment | 04-Backing Services, 05-Build/Release/Run |
| Scale application horizontally | 06-Processes, 08-Concurrency |
| Ensure resilience and fast recovery | 09-Disposability |
| Debug "works on my machine" | 10-Dev/Prod Parity |
| Implement observability | 11-Logs |
| Run migrations/admin tasks | 12-Admin Processes |
| Port binding and service exposure | 07-Port Binding |

## The 12 Factors

| # | Factor | deMGoncalves Rule | Key Question | Reference File |
|---|--------|-------------------|--------------|----------------|
| 01 | **Codebase** | [040](../../rules/040_base-codigo-unica.md) | 1 app = 1 repository? | [01-codebase.md](references/01-codebase.md) |
| 02 | **Dependencies** | [041](../../rules/041_declaracao-explicita-dependencias.md) | All dependencies explicit in manifest? | [02-dependencies.md](references/02-dependencies.md) |
| 03 | **Config** | [042](../../rules/042_configuracoes-via-ambiente.md) | Config in env vars (not hardcoded)? | [03-config.md](references/03-config.md) |
| 04 | **Backing Services** | [043](../../rules/043_servicos-apoio-recursos.md) | Services attachable via URL/config? | [04-backing-services.md](references/04-backing-services.md) |
| 05 | **Build, Release, Run** | [044](../../rules/044_separacao-build-release-run.md) | 3 separate and immutable stages? | [05-build-release-run.md](references/05-build-release-run.md) |
| 06 | **Processes** | [045](../../rules/045_processos-stateless.md) | Stateless processes + share-nothing? | [06-processes.md](references/06-processes.md) |
| 07 | **Port Binding** | [046](../../rules/046_port-binding.md) | Self-contained app with embedded HTTP server? | [07-port-binding.md](references/07-port-binding.md) |
| 08 | **Concurrency** | [047](../../rules/047_concorrencia-via-processos.md) | Scale via multiple processes? | [08-concurrency.md](references/08-concurrency.md) |
| 09 | **Disposability** | [048](../../rules/048_descartabilidade-processos.md) | Fast startup + graceful shutdown? | [09-disposability.md](references/09-disposability.md) |
| 10 | **Dev/Prod Parity** | [049](../../rules/049_paridade-dev-prod.md) | Dev ≈ Staging ≈ Prod (stack + time + people)? | [10-dev-prod-parity.md](references/10-dev-prod-parity.md) |
| 11 | **Logs** | [050](../../rules/050_logs-fluxo-eventos.md) | Logs → stdout (not files)? | [11-logs.md](references/11-logs.md) |
| 12 | **Admin Processes** | [051](../../rules/051_processos-administrativos.md) | Admin tasks = one-off processes? | [12-admin-processes.md](references/12-admin-processes.md) |

## Quick Selection by Context

### "Need to configure a new project"
→ **Start with**: 01-Codebase, 02-Dependencies, 03-Config

### "Application doesn't scale horizontally"
→ **Check**: 06-Processes, 08-Concurrency, 09-Disposability

### "Deploy is manual and risky"
→ **Check**: 05-Build/Release/Run, 10-Dev/Prod Parity

### "Bug works in dev, fails in prod"
→ **Check**: 03-Config, 04-Backing Services, 10-Dev/Prod Parity

### "Logs lost when container restarts"
→ **Check**: 11-Logs

### "Migration script broke prod but works in dev"
→ **Check**: 12-Admin Processes, 10-Dev/Prod Parity

## Prohibitions

This skill detects and prevents:

- **❌ Hardcoded configurations** (violates Factor 03)
- **❌ Implicit dependencies** (violates Factor 02)
- **❌ State in memory/local filesystem** (violates Factor 06)
- **❌ Logs in local files** (violates Factor 11)
- **❌ Admin scripts executed via direct SSH** (violates Factor 12)
- **❌ Mandatory external web server** (violates Factor 07)
- **❌ Dev/prod divergence in backing services** (violates Factor 10)
- **❌ Non-disposable processes** (violates Factor 09)

## Rationale

**deMGoncalves Rules 040–051** implement the 12 factors:

- **Infrastructure (040-051)**: All "INFRASTRUCTURE" category maps 1:1 to a factor
- **Critical severity (🔴)**: Factors 01-06, 09-11 are deployment blockers
- **High severity (🟠)**: Factors 07-08, 12 require justification if violated

## Usage Examples

### @developer: Verify compliance before PR
```bash
# Example: verify Factor 03 (Config)
grep -r "API_KEY\s*=\s*['\"]" src/
# ✅ Zero results = config via env vars
# ❌ Matches found = hardcoded secrets (violation)
```

### @architect: Define infra requirements for new feature
```markdown
# Feature: Notification System
## Twelve-Factor Compliance
- [ ] Factor 04: Email service via env var `EMAIL_SERVICE_URL`
- [ ] Factor 06: Stateless worker (external queue for jobs)
- [ ] Factor 08: Workers scalable independent of web processes
```

### @reviewer: Annotate violation via codetag
```typescript
// FIXME: API key hardcoded — move to process.env.STRIPE_KEY
const stripeKey = "sk_test_REDACTED_EXAMPLE";
```

---

**Created on**: 2026-04-01
**Version**: 1.0.0
