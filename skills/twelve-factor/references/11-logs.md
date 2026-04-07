# Factor 11 — Logs

**deMGoncalves Rule:** [050 - Logs as Event Streams](../../../rules/050_logs-fluxo-eventos.md)
**Question:** Logs → stdout (not local files)?

## What It Is

The application should treat logs as a **continuous stream of events** ordered by time, written to `stdout`. The application should never worry about routing, storage, or log rotation — that's the execution environment's responsibility.

**Logs in local files = lost when container destroyed.**

## Compliance Criteria

- [ ] All logs written to **stdout** (or stderr for errors), never in local files
- [ ] Zero use of logging libraries that write to files or do rotation
- [ ] Structured logs (JSON) to facilitate automated parsing

## ❌ Violation

```typescript
// Logs in local file ❌
import winston from 'winston';

const logger = winston.createLogger({
  transports: [
    new winston.transports.File({
      filename: '/var/log/app/error.log'  // violation
    })
  ]
});

// Log rotation in application ❌
const logger = createLogger({
  rotation: { maxSize: '10m', maxFiles: 5 }  // not app's responsibility
});
```

## ✅ Good

```typescript
// Structured logs to stdout ✅
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  // Default: stdout
});

logger.info({ userId: 123, action: 'login' }, 'User logged in');
// Output (JSON):
// {"level":30,"time":1678901234567,"userId":123,"action":"login","msg":"User logged in"}

// Simple console for dev ✅
if (process.env.NODE_ENV === 'development') {
  console.log('User logged in:', { userId: 123 });
}

// Environment captures stdout and routes ✅
# Docker logs → CloudWatch
# Kubernetes → Fluentd → Elasticsearch
# Heroku → Logplex → Papertrail
```

## Codetag when violated

```typescript
// FIXME: Logger writing to file — use stdout only
const fileTransport = new winston.transports.File({ filename: 'app.log' });
```
