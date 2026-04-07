# Factor 09 — Disposability

**deMGoncalves Rule:** [048 - Process Disposability](../../../rules/048_descartabilidade-processos.md)
**Question:** Fast startup (<10s) + graceful shutdown (SIGTERM handled)?

## What It Is

Application processes must be **disposable** — they can be started or stopped at any time. This requires fast initialization, graceful shutdown, and robustness against sudden termination (SIGTERM/SIGKILL).

**Disposability = fast deploys + elastic scalability + fast recovery.**

## Compliance Criteria

- [ ] **Startup** time less than **10 seconds** to be ready
- [ ] Process handles **SIGTERM** and finishes in-progress requests gracefully
- [ ] Background jobs are **idempotent** and use retry (can be interrupted)

## ❌ Violation

```typescript
// Slow startup (>30s) ❌
app.listen(3000, async () => {
  await loadHugeDatasetIntoMemory();  // 45s
  await warmupAllCaches();  // 20s
  console.log('Ready');
});

// No SIGTERM handling ❌
// Process is killed abruptly
// In-progress requests are lost
```

## ✅ Good

```typescript
// Fast startup (<5s) ✅
const server = app.listen(process.env.PORT, () => {
  console.log('Server ready');
});

// Graceful shutdown ✅
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, closing server gracefully');

  server.close(async () => {
    // Finish in-progress requests
    await cleanupConnections();
    process.exit(0);
  });

  // Timeout if not finished in 30s
  setTimeout(() => {
    console.error('Forced shutdown');
    process.exit(1);
  }, 30000);
});

// Idempotent jobs ✅
queue.process('email', async (job) => {
  const { userId, templateId } = job.data;

  // Check if already processed (idempotence)
  const sent = await db.emailLog.findOne({ userId, templateId });
  if (sent) return;

  await sendEmail(userId, templateId);
});
```

## Codetag when violated

```typescript
// FIXME: No SIGTERM handling — add graceful shutdown
process.on('SIGTERM', () => process.exit(0));  // violation
```
