# Factor 10 — Dev/Prod Parity

**deMGoncalves Rule:** [049 - Dev/Prod Parity](../../../rules/049_paridade-dev-prod.md)
**Question:** Dev ≈ Staging ≈ Prod (technology stack + deploy time + people)?

## What It Is

Development, staging, and production environments should be as **similar as possible**. This includes minimizing time gaps (frequent deployment), people gaps (who develops also deploys), and tool gaps (same technologies in all environments).

**Divergence = bugs that only appear in production.**

## Compliance Criteria

- [ ] Same **backing services** (database, cache, queue) in dev and prod (e.g., PostgreSQL in both, not SQLite dev + PostgreSQL prod)
- [ ] Time between writing code and prod deploy < **1 day** (ideally hours)
- [ ] Container/environment configs **identical** (e.g., same Dockerfile)

## ❌ Violation

```typescript
// Different backing services ❌
const db = process.env.NODE_ENV === 'production'
  ? new PostgresClient(process.env.DATABASE_URL)
  : new SQLiteClient('dev.db');  // violation

// Manual/infrequent deploy ❌
# Dev → Prod takes 2 weeks
# Developer doesn't have deploy permission
```

## ✅ Good

```typescript
// Same backing service ✅
const db = new PostgresClient(process.env.DATABASE_URL);

# .env (dev)
DATABASE_URL=postgresql://localhost/myapp_dev

# .env (prod)
DATABASE_URL=postgresql://db.prod.com/myapp

// Docker Compose for dev with same services ✅
# docker-compose.yml
services:
  db:
    image: postgres:15  # same prod version
  redis:
    image: redis:7  # same prod version
  app:
    build: .  # same Dockerfile

// Continuous deployment ✅
# CI/CD pipeline
# Git push → Build → Test → Deploy (< 30min)
```

## Codetag when violated

```typescript
// FIXME: SQLite in dev but PostgreSQL in prod — use PostgreSQL in both
const db = isProduction ? new PostgresClient() : new SQLiteClient();
```
