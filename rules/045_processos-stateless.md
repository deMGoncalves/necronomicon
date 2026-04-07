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

# Stateless Processes

**ID**: INFRAESTRUTURA-045
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What It Is

Application processes must be **stateless** and **share-nothing**. Any data that needs to persist must be stored in a stateful backing service (database, distributed cache, object storage).

## Why It Matters

Stateless processes can be horizontally scaled without complexity, restarted at any time without data loss, and distributed across multiple servers. State in memory or local filesystem prevents scalability and causes data loss.

## Objective Criteria

- [ ] Storing session state in local memory is prohibited — sessions must use external stores (Redis, database).
- [ ] Assuming that files written to local filesystem will be available in future requests is prohibited.
- [ ] The process must be able to restart at any time without user data loss (*crash-only design*).

## Allowed Exceptions

- **Ephemeral In-Memory Cache**: Short-lived local cache for optimization, provided the application works correctly without it.
- **Temporary Files**: Use of `/tmp` for short-lived operations within a single request.

## How to Detect

### Manual

Check if the application fails or loses data when a process is restarted during an operation.

### Automatic

Chaos tests: Randomly restart processes and check if the application maintains consistency.

## Related To

- [029 - Object Immutability](029_imutabilidade-objetos-freeze.md): complements
- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [043 - Backing Services as Attached Resources](043_servicos-apoio-recursos.md): reinforces
- [047 - Concurrency via Process Model](047_concorrencia-via-processos.md): complements
- [048 - Process Disposability](048_descartabilidade-processos.md): reinforces
- [070 - Prohibition of Shared Mutable State](070_proibicao-estado-mutavel-compartilhado.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
