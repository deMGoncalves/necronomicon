# Scalability via Process Model (Concurrency)

**ID**: INFRASTRUCTURE-047
**Severity**: 🟠 High
**Category**: Infrastructure

---

## What it is

The application must scale horizontally through the execution of **multiple independent processes**, not through internal threads or a single monolithic process. Different types of work (web, worker, scheduler) must be separated into distinct process types.

## Why it matters

The process model enables elastic scalability — adding more web processes to handle traffic, or more workers to process queues. Each process type can be scaled independently according to demand, optimizing resources.

## Objective Criteria

- [ ] The application must support execution of **multiple instances** of the same process without conflict.
- [ ] Different workloads (HTTP, background jobs, scheduled tasks) must be separated into distinct processes.
- [ ] The process must not *daemonize* or write PID files — process management is the responsibility of the execution environment.

## Allowed Exceptions

- **Internal Workers**: Use of worker threads for CPU-bound operations within a request, provided state is not shared between requests.

## How to Detect

### Manual

Check if the application can run N simultaneous instances with a load balancer in front, without conflicts.

### Automatic

Load tests: Scale horizontally and verify if throughput increases linearly.

## Related to

- [045 - Stateless Processes](../twelve-factor/006_processos-stateless.md): complements
- [046 - Port Binding](../twelve-factor/007_port-binding.md): complements
- [048 - Process Disposability](../twelve-factor/009_descartabilidade-processos.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
