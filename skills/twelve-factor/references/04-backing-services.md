# Factor 04 — Backing Services

**deMGoncalves Rule:** [043 - Backing Services as Resources](../../../rules/043_servicos-apoio-recursos.md)
**Question:** External services attachable via URL/config (no code change)?

## What It Is

Backing services (databases, queues, caches, email services, external APIs) must be treated as **attachable resources**, accessed via URL or resource locator stored in configuration. The application **should not distinguish** between local and third-party services.

**Backing service = configurable resource, not hardcoded.**

## Compliance Criteria

- [ ] All external services accessed via **URL or connection string** configurable by environment variable
- [ ] Zero conditional logic differentiating local from remote services (e.g., `if (isLocal) useLocalDB()`)
- [ ] Service swap requires **only** config change, not code change

## ❌ Violation

```typescript
// Hardcoded local vs prod differentiation ❌
const db = process.env.NODE_ENV === 'production'
  ? new PostgresClient('prod-url')
  : new SQLiteClient('local.db');

// Hardcoded URL ❌
const redis = new Redis({ host: 'localhost', port: 6379 });
```

## ✅ Good

```typescript
// Service as attachable resource ✅
const dbUrl = process.env.DATABASE_URL;
const redisUrl = process.env.REDIS_URL;

const db = new DatabaseClient(dbUrl);  // PostgreSQL, MySQL, etc
const cache = new RedisClient(redisUrl);  // local or ElastiCache

// Swap SQLite → PostgreSQL = just change env var
# .env (dev)
DATABASE_URL=sqlite://local.db

# .env (prod)
DATABASE_URL=postgresql://user:pass@db.prod.com/mydb
```

## Codetag when violated

```typescript
// FIXME: Redis host hardcoded — use process.env.REDIS_URL
const redis = new Redis({ host: '10.0.1.50', port: 6379 });
```
