---
name: adr
description: Template for Architecture Decision Records (ADR). Use when @architect needs to document an important architectural decision — when choosing between technologies, patterns or approaches that impact the project long-term.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# ADR (Architecture Decision Records)

Template to document important architectural decisions in a traceable way.

---

## When to Use

- When making a significant technical decision (technology choice, architectural pattern, design approach)
- In phase 4 (Docs): @architect creates ADR for each important decision of the implemented feature
- When a previous decision is reviewed or replaced

## ADR Template

→ See [`references/adr-template.md`](references/adr-template.md) for the complete template.

## Numbering

- ADRs numbered sequentially: ADR-001, ADR-002, ...
- File name: `NNN_title-kebab-case.md`
- Never delete ADRs — mark as Deprecated or Superseded
- Maintain index in docs/adr/README.md

## Common ADR Categories

| Category | Examples |
|----------|----------|
| Technology choice | DB, framework, runtime, library |
| Architectural pattern | Pipeline, MVC, Event Sourcing, CQRS |
| Code design pattern | Value Objects, Repository, DIP |
| Infrastructure | Deploy, CI/CD, monitoring |
| Integration | External API, protocol, authentication |

## Examples

```markdown
// ❌ Bad — decision documented as code comment
// we use JWT because it's simpler (author: John, 2024-01)
// don't know why we don't use sessions, but it stayed like this

---

// ✅ Good — ADR with context, decision and consequences
# ADR-019: JWT Authentication

**Status:** Accepted
**Date:** 2024-01-15

## Context

System needs stateless authentication to scale horizontally.
Users access from multiple devices.
Forecast of 100k simultaneous users in first year.

## Decision

Use JWT (JSON Web Tokens) with refresh tokens stored in Redis.
Do not use server in-memory sessions.

## Alternatives Considered

| Alternative | Pros | Cons |
|-------------|------|------|
| JWT (chosen) | Stateless, horizontal scale, no DB lookup per request | Token revocation requires blacklist/Redis |
| In-memory sessions | Simple, immediate revocation | Doesn't scale horizontally, requires sticky sessions |
| Full OAuth 2.0 | Industry standard, SSO support | High complexity for current use case |

## Consequences

### Positive
✅ Horizontal scalability without sticky sessions
✅ Low latency: no DB query on each request
✅ Multi-platform support (web, mobile) without extra configuration

### Negative / Trade-offs
❌ Token revocation requires blacklist in Redis (adds dependency)
❌ JWT tokens can grow large if we include many claims
❌ No real-time active session control without additional infrastructure

## Related to

- ADR-003: Choice of Redis as distributed cache (depends)
- arc42 §8: Crosscutting Concepts — Authentication and Authorization

---

**Author:** @architect · deMGoncalves
```

```markdown
// ❌ Bad — decision without alternatives or consequences
# ADR-025: Use PostgreSQL

We decided to use PostgreSQL.

---

// ✅ Good — complete ADR with reasoning and trade-offs
# ADR-025: PostgreSQL Relational Database

**Status:** Accepted
**Date:** 2024-02-10

## Context

E-commerce system needs:
- ACID transactions for orders and payments
- Complex queries with JOINs (products, categories, users)
- Guaranteed referential integrity
- Support for 50k orders/day

## Decision

Use PostgreSQL 15 as main database.
Use extensions: pgvector (future semantic search), pg_stat_statements (monitoring).

## Alternatives Considered

| Alternative | Pros | Cons |
|-------------|------|------|
| PostgreSQL (chosen) | ACID, efficient JOINs, JSON support, maturity | Limited horizontal scalability |
| MongoDB | Simple horizontal scalability, flexible schema | Unreliable multi-document transactions, difficult complex queries |
| MySQL | Maturity, many tools | Inferior JOIN performance to Postgres, limited JSON support |

## Consequences

### Positive
✅ ACID guarantees for financial transactions
✅ Complex queries with optimized B-tree indexes
✅ Native JSON support (JSONB) for semi-structured data

### Negative / Trade-offs
❌ Horizontal scalability requires manual sharding (future complexity)
❌ Asynchronous read replicas may have lag in reads

## Related to

- ADR-019: JWT Authentication (both depend on consistent transactions)
- arc42 §7: Deployment View — database infrastructure

---

**Author:** @architect · deMGoncalves
```

## Prohibitions

- ❌ Decisions without context or described problem
- ❌ ADRs without considered alternatives
- ❌ Missing consequences (positive and negative)
- ❌ Undocumented status or status changes without new ADR
- ❌ Deleted ADRs — use Deprecated or Superseded

## Rationale

- ADRs ensure traceability of "why we got here"
- Avoids repeating already resolved debates
- Source: Michael Nygard - Documenting Architecture Decisions (2011)
