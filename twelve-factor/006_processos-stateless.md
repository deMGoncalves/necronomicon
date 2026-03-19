# Stateless Processes

**ID**: INFRASTRUCTURE-045
**Severity**: 🔴 Critical
**Category**: Infrastructure

---

## What it is

Application processes must be **stateless** and **share-nothing**. Any data that needs to persist must be stored in a stateful backing service (database, distributed cache, object storage).

## Why it matters

Stateless processes can be scaled horizontally without complexity, restarted at any time without data loss, and distributed across multiple servers. In-memory state or local filesystem prevents scalability and causes data loss.

## Objective Criteria

- [ ] Storing session state in local memory is prohibited — sessions must use external stores (Redis, database).
- [ ] Assuming that files written to local filesystem will be available in future requests is prohibited.
- [ ] The process must be able to restart at any time without user data loss (*crash-only design*).

## Allowed Exceptions

- **Ephemeral In-Memory Cache**: Short-duration local cache for optimization, provided the application works correctly without it.
- **Temporary Files**: Use of `/tmp` for short-duration operations within a single request.

## How to Detect

### Manual

Check if the application fails or loses data when a process is restarted during an operation.

### Automatic

Chaos tests: Restart processes randomly and verify if the application maintains consistency.

## Related to

- [029 - Object Immutability](../clean-code/009_imutabilidade-objetos-freeze.md): complements
- [036 - Side Effects Function Restriction](../clean-code/016_restricao-funcoes-efeitos-colaterais.md): reinforces
- [043 - Backing Services as Resources](../twelve-factor/004_servicos-apoio-recursos.md): reinforces
- [047 - Concurrency via Process Model](../twelve-factor/008_concorrencia-via-processos.md): complements
- [048 - Process Disposability](../twelve-factor/009_descartabilidade-processos.md): reinforces

---

**Created on**: 2025-01-10
**Version**: 1.0
