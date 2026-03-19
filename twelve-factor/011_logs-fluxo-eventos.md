# Logs as Event Stream

**ID**: INFRASTRUCTURE-050
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

The application must treat logs as a **continuous stream of events** ordered by time, written to `stdout`. The application must never concern itself with routing, storage, or log rotation — this is the responsibility of the execution environment.

## Why it matters

Logs in local files are lost when containers are destroyed, difficult to aggregate in distributed systems, and create filesystem dependency. Stdout allows the execution environment to capture, aggregate, and route logs to any destination.

## Objective Criteria

- [ ] All logs must be written to **stdout** (or stderr for errors), never to local files.
- [ ] Using logging libraries that write directly to files or do log rotation is prohibited.
- [ ] Logs must be structured (JSON) to facilitate parsing and automated analysis.

## Allowed Exceptions

- **Local Development Environment**: Colorful and readable formatting for console in dev, provided stdout is maintained.
- **Temporary Debug Logs**: `console.log` for local debugging, removed before commit.

## How to Detect

### Manual

Check logging library configuration to identify file writes or rotation configuration.

### Automatic

Code analysis: Search for `FileAppender`, `RotatingFileHandler` configurations, or file paths in logging.

## Related to

- [027 - Error Handling Quality](../clean-code/007_qualidade-tratamento-erros-dominio.md): complements
- [045 - Stateless Processes](../twelve-factor/006_processos-stateless.md): reinforces
- [048 - Process Disposability](../twelve-factor/009_descartabilidade-processos.md): complements
- [026 - Comment Quality](../clean-code/006_qualidade-comentarios-porque.md): complements

---

**Created on**: 2025-01-10
**Version**: 1.0
