# Factor 12 — Admin Processes

**deMGoncalves Rule:** [051 - Admin Processes](../../../rules/051_processos-administrativos.md)
**Question:** Admin tasks executed as one-off processes (not separate scripts)?

## What It Is

Administrative or maintenance tasks (database migrations, fix scripts, REPL console) must be executed as **one-off processes** in the same environment and with the same code as the main application, not as separate scripts or persistent processes.

**Admin tasks = same code + same environment + same runtime.**

## Compliance Criteria

- [ ] Migration scripts executed as one-off using same runtime and dependencies as app
- [ ] Admin tasks **versioned in repository** along with application code
- [ ] Zero execution of scripts via direct SSH on server (use same deploy mechanism)

## ❌ Violation

```bash
# Direct SSH to prod ❌
ssh prod-server
cd /app
node scripts/fix-data.js  # code outside repo

# Migration script with different dependencies ❌
# migrations/001_add_users.sql executed manually
mysql -u root -p < migrations/001_add_users.sql
```

## ✅ Good

```bash
# Migration as one-off process ✅
# Same runtime, same dependencies, same app code

# Heroku
heroku run npm run db:migrate

# Kubernetes
kubectl run migration --image=myapp:v1.2.3 --restart=Never \
  --command -- npm run db:migrate

# Docker
docker run --rm myapp:v1.2.3 npm run db:migrate

# Scripts versioned in repo ✅
repo/
├── src/
│   └── app.ts
├── migrations/
│   └── 001_add_users.ts  # TypeScript, not SQL
└── package.json
    "scripts": {
      "db:migrate": "bun run migrations/run.ts"
    }
```

## Codetag when violated

```typescript
// FIXME: Admin script not versioned — add in migrations/
// File executed via SSH: /tmp/fix-users.js
```
