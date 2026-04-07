# Factor 03 — Config

**deMGoncalves Rule:** [042 - Config via Environment](../../../rules/042_configuracoes-via-ambiente.md)
**Question:** Configurations in env vars (not hardcoded)?

## What It Is

All configurations that vary between environments (*deploy*) must be stored in **environment variables**, not in versioned configuration files or hardcoded in code. This includes credentials, service URLs, and feature flags.

**Hardcoded config = leak risk + inflexible deploys.**

## Compliance Criteria

- [ ] Credentials (API keys, passwords, tokens) accessed **exclusively** via `process.env`
- [ ] Zero `.env` files with real values versioned (only `.env.example`)
- [ ] Code works with zero environment-specific config files in repository

## ❌ Violation

```typescript
// Hardcoded credential ❌
const stripeKey = "sk_live_REDACTED_EXAMPLE";

// Hardcoded URL ❌
const apiUrl = "https://api.production.com";

// Versioned .env with secrets ❌
git add .env  # contains API_KEY=sk_live_...
```

## ✅ Good

```typescript
// Config via env vars ✅
const stripeKey = process.env.STRIPE_SECRET_KEY;
const apiUrl = process.env.API_BASE_URL;

if (!stripeKey) {
  throw new Error('STRIPE_SECRET_KEY not configured');
}

// Versioned .env.example (template only)
# .env.example
STRIPE_SECRET_KEY=sk_test_your_key_here
API_BASE_URL=https://api.staging.com

// .gitignore
.env
.env.local
```

## Codetag when violated

```typescript
// FIXME: API key hardcoded — move to process.env.SENDGRID_API_KEY
const sendgridKey = "SG.abc123...";
```
