# Factor 06 — Processes

**deMGoncalves Rule:** [045 - Stateless Processes](../../../rules/045_processos-stateless.md)
**Question:** Stateless processes + share-nothing (state in backing service)?

## What It Is

Application processes must be **stateless** (no state) and **share-nothing**. Any data that needs to persist must be stored in a stateful backing service (database, distributed cache, object storage).

**State in memory/local filesystem prevents horizontal scalability.**

## Compliance Criteria

- [ ] Zero session state storage in local memory (use Redis, database)
- [ ] Zero dependency on local filesystem files between requests
- [ ] Process can restart at any time without user data loss

## ❌ Violation

```typescript
// Session in local memory ❌
const sessions = new Map();  // lost on restart
app.post('/login', (req, res) => {
  sessions.set(req.body.userId, { token: '...' });
});

// Local filesystem as storage ❌
app.post('/upload', (req, res) => {
  fs.writeFileSync('/tmp/uploads/' + req.file.name, req.file.data);
  // ❌ file won't be available in another process
});
```

## ✅ Good

```typescript
// Session in backing service ✅
const redis = new RedisClient(process.env.REDIS_URL);
app.post('/login', async (req, res) => {
  await redis.set(`session:${userId}`, JSON.stringify({ token: '...' }));
});

// Upload to object storage ✅
const s3 = new S3Client({ endpoint: process.env.S3_ENDPOINT });
app.post('/upload', async (req, res) => {
  await s3.putObject({
    Bucket: 'uploads',
    Key: req.file.name,
    Body: req.file.data
  });
});
```

## Codetag when violated

```typescript
// FIXME: Session storage in local memory — move to Redis
const userSessions = new Map<string, Session>();
```
