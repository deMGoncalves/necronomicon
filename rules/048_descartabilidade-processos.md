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

# Process Disposability

**ID**: INFRAESTRUTURA-048
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

Application processes must be **disposable** — they can be started or stopped at any time. This requires fast startup, graceful shutdown, and robustness against sudden termination (SIGTERM/SIGKILL).

## Why It Matters

Disposability enables fast deploys, elastic scalability, and quick failure recovery. Processes that take long to start or don't handle shutdown correctly cause downtime, data loss, and service degradation.

## Objective Criteria

- [ ] Process **startup** time must be under **10 seconds** to be ready to receive requests.
- [ ] The process must handle **SIGTERM** and gracefully finish ongoing requests before shutting down.
- [ ] Background jobs must be **idempotent** and use retry patterns, as they can be interrupted at any time.

## Allowed Exceptions

- **Warm-up Processes**: Processes that need to load ML models or large caches may have slower startup, provided health checks reflect actual state.

## How to Detect

### Manual

Measure startup time and send SIGTERM during processing to check if it finishes gracefully.

### Automatic

Kubernetes: Configure `terminationGracePeriodSeconds` and `readinessProbe` to validate behavior.

## Related To

- [045 - Stateless Processes](045_processos-stateless.md): reinforces
- [046 - Port Binding](046_port-binding.md): complements
- [047 - Concurrency via Process Model](047_concorrencia-via-processos.md): reinforces
- [028 - Asynchronous Exception Handling](028_tratamento-excecao-assincrona.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
