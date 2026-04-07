---
name: c4model
description: C4 Model template with 4 levels of abstraction for architectural visualization (Context, Container, Component, Code). Use when @architect needs to create or update docs/c4/ to communicate architecture to different audiences — when creating context, container, component, or code diagrams.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# C4 Model

4 levels of progressive abstraction to communicate architecture to different audiences.

---

## When to Use

- **Phase 4 (Docs):** @architect creates/updates docs/c4/ after implementation
- **Level 1-2:** for stakeholders (business, management)
- **Level 3-4:** for developers (implementation)

## The 4 Levels

| Level | File | Audience | Key Question |
|-------|------|----------|--------------|
| 1 — System Context | 01_system_context.md | Everyone | What does the system do and who does it connect with? |
| 2 — Container | 02_container.md | Technical | What technology composes each part? |
| 3 — Component | 03_component.md | Dev | How is this service organized internally? |
| 4 — Code | 04_code.md | Dev | How is this component implemented? |

## Templates

See the templates in references/:
- [references/01_system-context.md](references/01_system-context.md) → Level 1 template
- [references/02_container.md](references/02_container.md) → Level 2 template
- [references/03_component.md](references/03_component.md) → Level 3 template
- [references/04_code.md](references/04_code.md) → Level 4 template

## Conventions

- Consistent naming across levels (same name for system/container/component)
- Level 1-2: simple language, no technical jargon
- Level 3-4: types, interfaces, specific patterns
- Language: Brazilian Portuguese
- Related to: arc42 §5 (Building Block View)

## Examples

```markdown
// ❌ Bad — a single diagram trying to show everything
[chaotic diagram mixing end users, external systems, internal APIs,
 database, class code — everything at a single level without separation of concerns]

Diagram contains:
- User → Frontend → AuthService → UserRepository → PostgreSQL
- Admin → Dashboard → OrderService → PaymentGateway (external)
- Mobile App → API Gateway → Logger → Kafka
Audience: CTO? Dev? Stakeholder? — nobody understands

---

// ✅ Good — C4 in 4 progressive abstraction levels

## Level 1 — System Context (for everyone: CTO, stakeholders, business)

```
[User] --uses--> [E-commerce System]
[E-commerce System] --integrates--> [Stripe Payment Gateway]
[E-commerce System] --integrates--> [SendGrid Email Service]
```

Question: "What does the system do?" → Sale of products with online payment.

---

## Level 2 — Container (for architects, tech leads)

```
[React SPA Frontend] --HTTP calls--> [Node.js Backend API]
[Backend API] --reads/writes--> [PostgreSQL Database]
[Backend API] --publishes events--> [RabbitMQ]
[Worker Service] --consumes--> [RabbitMQ]
```

Question: "What technologies compose the system?"
→ React, Node.js, PostgreSQL, RabbitMQ

---

## Level 3 — Component (for developers)

Node.js Backend API contains:
- AuthController (authenticates users)
- OrderService (processes orders)
- PaymentGateway (integrates with Stripe)
- UserRepository (accesses users table)

Question: "How is the backend organized internally?"
→ Controllers, Services, Repositories

---

## Level 4 — Code (for developers — only if necessary)

```typescript
class OrderService {
  constructor(
    private repo: OrderRepository,
    private payment: PaymentGateway
  ) {}

  async createOrder(order: Order): Promise<OrderId> {
    const savedOrder = await this.repo.save(order)
    await this.payment.charge(order.total)
    return savedOrder.id
  }
}
```

Question: "How is OrderService implemented?"
→ DIP: depends on abstractions (Repository, Gateway)
```

## Rationale

- c4model.com: created by Simon Brown
- Complements arc42 with visualizations per abstraction level
