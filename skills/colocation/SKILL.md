---
name: colocation
description: Vertical Slice Architecture for src/ organization in 3 hierarchical levels (Context → Container → Component). Use when creating new files, defining feature structure or deciding where to position new code.
model: haiku
allowed-tools: Bash, Glob, Read
metadata:
  author: deMGoncalves
  version: "2.0.0"
---

# Colocation — Vertical Slice Architecture

All implementation in `src/` follows a vertical slice architecture: each feature is a complete vertical slice from request to database, organized in **3 hierarchical levels**. Related code stays together — never spread by type.

→ See [references/vertical-slice.md](references/vertical-slice.md) for the complete reference with examples and decision guide.

---

## When to Use

Use whenever:
- Creating new feature (Task or Feature mode)
- Deciding where to position a new file in `src/`
- @architect defining implementation path in `specs.md`
- @developer creating directory structure for a task

---

## The 3 Levels

```
src/
└── [context]/           ← Business domain
    └── [container]/     ← Subdomain or service
        └── [component]/ ← Specific operation
            ├── controller.ts        ← HTTP handlers + input validation
            ├── service.ts           ← Pure business logic
            ├── model.ts             ← Types, interfaces, schemas
            ├── repository.ts        ← Data access (DB, APIs)
            └── [component].test.ts  ← Unit and integration tests
```

| Level | What it is | Examples |
|-------|------------|---------|
| **Context** | High-level business domain | `user`, `order`, `notification`, `payment` |
| **Container** | Subdomain or functional grouping | `auth`, `cart`, `profile`, `inbox` |
| **Component** | Specific operation or resource | `login`, `checkout`, `list`, `create` |

---

## Responsibility of each file

| File | Responsibility |
|------|----------------|
| `controller.ts` | Receives HTTP request, validates input, calls service, returns response |
| `service.ts` | Pure business logic — no HTTP, no direct DB |
| `model.ts` | Types, interfaces, schemas, DTOs |
| `repository.ts` | Data access — queries, writes, DB/API abstractions |
| `[component].test.ts` | Unit and integration tests for the feature |

---

## Examples

### ❌ Bad — horizontal organization by type

```
src/
├── controllers/
│   ├── user.controller.ts
│   └── order.controller.ts
├── services/
│   ├── user.service.ts
│   └── order.service.ts
├── models/
│   ├── user.model.ts
│   └── order.model.ts
└── repositories/
    ├── user.repository.ts
    └── order.repository.ts
```

To work on `user/auth/login`, @developer needs to open 4 different directories.

### ✅ Good — vertical slice (everything together vertically)

```
src/
├── user/                    ← Context
│   ├── auth/                ← Container
│   │   ├── login/           ← Component
│   │   │   ├── controller.ts
│   │   │   ├── service.ts
│   │   │   ├── model.ts
│   │   │   ├── repository.ts
│   │   │   └── login.test.ts
│   │   └── register/
│   │       └── [same files]
│   └── profile/
│       └── update/
│
└── order/                   ← Context
    └── cart/                ← Container
        ├── add-item/        ← Component
        └── checkout/
```

To work on `user/auth/login`, @developer opens **a single directory**.

---

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| `src/controllers/`, `src/services/` | Horizontal organization by type — violates cohesion (rule 016) |
| `src/utils/`, `src/helpers/`, `src/common/` | Generic without domain — attracts code from anywhere |
| Component mixing HTTP + direct DB | Each file has one responsibility (rule 010) |
| Feature spread across multiple contexts | If it's in 2 contexts, review domain model |

---

## Rationale

**Related rules:**
- [016 - Common Closure Principle](../../rules/016_principio-fechamento-comum.md): classes that change together should be in the same package — reinforces
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each file has one responsibility — reinforces
- [021 - Prohibition of Logic Duplication](../../rules/021_proibicao-duplicacao-logica.md): vertical slice prevents the same logic from being duplicated in multiple contexts — complements

**Related skills:**
- [`revelation`](../revelation/SKILL.md) — complements: index.ts of each module exposes only the public interface of the component
- [`solid`](../solid/SKILL.md) — reinforces: SRP and DIP guide responsibilities within each component file
