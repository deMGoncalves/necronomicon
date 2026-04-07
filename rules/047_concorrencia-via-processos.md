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

# Scalability via Process Model (Concurrency)

**ID**: INFRAESTRUTURA-047
**Severity**: 🟠 High
**Category**: Infrastructure

---

## What It Is

The application must scale horizontally through execution of **multiple independent processes**, not through internal threads or a single monolithic process. Different types of work (web, worker, scheduler) must be separated into distinct process types.

## Why It Matters

The process model enables elastic scalability — adding more web processes to handle traffic, or more workers to process queues. Each process type can be scaled independently according to demand, optimizing resources.

## Objective Criteria

- [ ] The application must support running **multiple instances** of the same process without conflict.
- [ ] Different workloads (HTTP, background jobs, scheduled tasks) must be separated into distinct processes.
- [ ] The process must not *daemonize* or write PID files — process management is the runtime environment's responsibility.

## Allowed Exceptions

- **Internal Workers**: Use of worker threads for CPU-bound operations within a request, provided state is not shared between requests.

## How to Detect

### Manual

Check if the application can run N simultaneous instances with a load balancer in front, without conflicts.

### Automatic

Load tests: Scale horizontally and check if throughput increases linearly.

## Related To

- [045 - Stateless Processes](045_processos-stateless.md): complements
- [046 - Port Binding](046_port-binding.md): complements
- [048 - Process Disposability](048_descartabilidade-processos.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
