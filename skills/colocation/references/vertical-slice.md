# Vertical Slice — Complete Reference

## src/ Structure for Real Project

```
src/
│
├── user/                         ← Context: "user" domain
│   ├── auth/                     ← Container: authentication
│   │   ├── login/                ← Component
│   │   │   ├── controller.ts
│   │   │   ├── service.ts
│   │   │   ├── model.ts
│   │   │   ├── repository.ts
│   │   │   └── login.test.ts
│   │   ├── register/
│   │   │   ├── controller.ts
│   │   │   ├── service.ts
│   │   │   ├── model.ts
│   │   │   ├── repository.ts
│   │   │   └── register.test.ts
│   │   └── refresh/
│   │       └── [same files]
│   │
│   └── profile/                  ← Container: user profile
│       ├── update/
│       └── avatar/
│
├── order/                        ← Context: "order" domain
│   ├── cart/                     ← Container: shopping cart
│   │   ├── add-item/
│   │   ├── remove-item/
│   │   └── checkout/
│   │
│   └── history/                  ← Container: order history
│       └── list/
│
└── notification/                 ← Context: "notification" domain
    └── in-app/                   ← Container
        ├── list/
        └── mark-read/
```

---

## Decision Guide

### When to Create a New Context?

Create a new Context when it represents an **independent business domain** — something that could be a separate microservice.

| Situation | Decision |
|-----------|----------|
| Is it a different business domain? | New Context |
| Does it share entities with another context? | Evaluate: subdomain or separate context |
| Is it a feature of an existing domain? | Container within existing Context |

### When to Create a New Container?

Create a Container to **group related operations** within a Context.

| Situation | Decision |
|-----------|----------|
| Set of CRUD operations for an entity | Container (e.g., `profile/`) |
| Specific functionality with multiple endpoints | Container (e.g., `auth/`) |
| Business process with sequential steps | Container (e.g., `checkout/`) |

### When to Create a New Component?

Each Component represents **a specific operation** — typically an HTTP endpoint or a use case.

| Operation | Component |
|-----------|-----------|
| POST /users/auth/login | `user/auth/login/` |
| GET /orders/cart | `order/cart/list/` |
| PUT /users/profile/avatar | `user/profile/avatar/` |

---

## Naming Rules

| Level | Format | Examples |
|-------|--------|----------|
| Context | `kebab-case` singular | `user`, `order`, `notification` |
| Container | `kebab-case` singular or verb | `auth`, `cart`, `profile`, `in-app` |
| Component | `kebab-case` verb or action noun | `login`, `checkout`, `add-item`, `list` |
| Test file | `[component].test.ts` | `login.test.ts`, `checkout.test.ts` |

---

## How a Feature Maps to the Path

When receiving a feature request like *"implement JWT login"*:

1. **Context**: `user` — user domain
2. **Container**: `auth` — authentication
3. **Component**: `login` — specific login operation
4. **Path**: `src/user/auth/login/`
5. **Files**:
   - `controller.ts` — POST /auth/login
   - `service.ts` — validation + JWT generation
   - `model.ts` — LoginRequest, LoginResponse, JwtPayload
   - `repository.ts` — user lookup in DB
   - `login.test.ts` — feature tests

---

## Benefits for oh my claude Workflow

| Benefit | How it Manifests |
|---------|------------------|
| **LLM efficiency** | @developer reads only `src/user/auth/login/` — no need to process entire src/ |
| **Task isolation** | Each Task has a unique path — zero conflict between parallel tasks |
| **Git hygiene** | One feature = one directory = clean PR without scattered diffs |
| **Test coverage** | Each component has its co-located `.test.ts` — easy to measure coverage |
| **Onboarding** | New dev finds everything in one place — no "where is X?" |
