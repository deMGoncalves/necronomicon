# Factor 08 — Concurrency

**deMGoncalves Rule:** [047 - Concurrency via Processes](../../../rules/047_concorrencia-via-processos.md)
**Question:** Application scales via multiple processes (not threads or single process)?

## What It Is

The application should scale horizontally through execution of **multiple independent processes**, not through internal threads or a single monolithic process. Different types of work (web, worker, scheduler) should be separated into distinct process types.

**Elastic scalability = add processes according to demand.**

## Compliance Criteria

- [ ] Application supports execution of **multiple instances** of the same process without conflict
- [ ] Different workloads (HTTP, background jobs, scheduled tasks) separated into distinct processes
- [ ] Process doesn't *daemonize* nor write PID files (management is environment's responsibility)

## ❌ Violation

```typescript
// Single process that does everything ❌
const app = express();
app.listen(3000);

// Background jobs in same process
setInterval(() => {
  processQueue();  // violates concurrency
}, 5000);

// Doesn't scale horizontally
// If duplicating process, processQueue() runs 2x
```

## ✅ Good

```typescript
// Separate web process (web.ts) ✅
const app = express();
app.listen(process.env.PORT);

// Separate worker process (worker.ts) ✅
const queue = new Queue(process.env.REDIS_URL);
queue.process('email', sendEmail);

// Procfile defines process types
# Procfile
web: bun run src/web.ts
worker: bun run src/worker.ts
scheduler: bun run src/scheduler.ts

# Independent scaling
heroku ps:scale web=4 worker=2 scheduler=1
```

## Codetag when violated

```typescript
// FIXME: Background job in web process — extract to worker process
setInterval(cleanupDatabase, 3600000);
```
