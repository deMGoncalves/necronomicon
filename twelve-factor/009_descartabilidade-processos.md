# Process Disposability

**ID**: INFRASTRUCTURE-048
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

Application processes must be **disposable** — they can be started or stopped at any time. This requires fast startup, graceful shutdown, and robustness against sudden termination (SIGTERM/SIGKILL).

## Why it matters

Disposability enables fast deploys, elastic scalability, and quick recovery from failures. Processes that take too long to start or don't handle shutdown correctly cause downtime, data loss, and service degradation.

## Objective Criteria

- [ ] The process **startup** time must be less than **10 seconds** to be ready to receive requests.
- [ ] The process must handle **SIGTERM** and finish in-progress requests gracefully before terminating.
- [ ] Background jobs must be **idempotent** and use retry patterns, as they can be interrupted at any time.

## Allowed Exceptions

- **Warm-up Processes**: Processes that need to load ML models or large caches may have slower startup, provided health checks reflect the real state.

## How to Detect

### Manual

Measure startup time and send SIGTERM during processing to verify if it finishes gracefully.

### Automatic

Kubernetes: Configure `terminationGracePeriodSeconds` and `readinessProbe` to validate behavior.

## Related to

- [045 - Stateless Processes](../twelve-factor/006_processos-stateless.md): reinforces
- [046 - Port Binding](../twelve-factor/007_port-binding.md): complements
- [047 - Concurrency via Process Model](../twelve-factor/008_concorrencia-via-processos.md): reinforces
- [028 - Asynchronous Exception Handling](../clean-code/008_tratamento-excecao-assincrona.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
