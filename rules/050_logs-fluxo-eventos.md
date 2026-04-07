---
paths:
  - "**/*.yml"
  - "**/*.yaml"
  - "**/*.json"
  - "**/Dockerfile*"
  - "**/docker-compose*"
  - "**/.env*"
  - "**/package.json"
  - "**/tsconfig.json"
---

# Logs as Event Stream

**ID**: INFRAESTRUTURA-050
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

The application must treat logs as a **continuous stream of events** ordered by time, written to `stdout`. The application must never concern itself with routing, storage, or log rotation — this is the runtime environment's responsibility.

## Why It Matters

Logs in local files are lost when containers are destroyed, difficult to aggregate in distributed systems, and create filesystem dependency. Stdout allows the runtime environment to capture, aggregate, and route logs to any destination.

## Objective Criteria

- [ ] All logs must be written to **stdout** (or stderr for errors), never to local files.
- [ ] Using logging libraries that write directly to files or perform log rotation is prohibited.
- [ ] Logs must be structured (JSON) to facilitate parsing and automated analysis.

## Allowed Exceptions

- **Local Development Environment**: Colored and readable console formatting in dev, provided stdout is maintained.
- **Temporary Debug Logs**: `console.log` for local debugging, removed before commit.

## How to Detect

### Manual

Check logging library configuration to identify file writes or rotation configuration.

### Automatic

Code analysis: Search for `FileAppender`, `RotatingFileHandler` configurations, or file paths in logging.

## Related To

- [027 - Error Handling Quality](027_qualidade-tratamento-erros-dominio.md): complements
- [045 - Stateless Processes](045_processos-stateless.md): reinforces
- [048 - Process Disposability](048_descartabilidade-processos.md): complements
- [026 - Comment Quality](026_qualidade-comentarios-porque.md): complements

---

**Created on**: 2025-01-10
**Version**: 1.0
