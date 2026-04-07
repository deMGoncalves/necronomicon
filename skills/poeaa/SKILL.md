---
name: poeaa
description: Reference for main Patterns of Enterprise Application Architecture (PoEAA) by Martin Fowler. Use when @architect needs to design domain, persistence or presentation layers in enterprise JavaScript/TypeScript applications — when choosing between Active Record, Data Mapper, Repository, Unit of Work.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "2.0.0"
  category: design-patterns
---

# PoEAA — Patterns of Enterprise Application Architecture

Patterns for enterprise applications organized by architectural layer.

---

## When to Use

- @architect: Research phase to design domain and persistence layers
- When deciding: Transaction Script vs Domain Model?
- When deciding: Active Record vs Data Mapper vs Repository?
- @developer: when implementing service and repository layers

## Patterns by Layer

| Layer | Pattern | Complexity | Reference |
|-------|---------|------------|-----------|
| Domain Logic | Transaction Script | Simple | [transaction-script.md](references/transaction-script.md) |
| Domain Logic | Domain Model | Complex | [domain-model.md](references/domain-model.md) |
| Domain Logic | Table Module | Moderate | [table-module.md](references/table-module.md) |
| Data Source | Active Record | Simple | [active-record.md](references/active-record.md) |
| Data Source | Data Mapper | Complex | [data-mapper.md](references/data-mapper.md) |
| Data Source | Repository | Complex | [repository.md](references/repository.md) |
| Data Source | Table Data Gateway | Simple | [table-data-gateway.md](references/table-data-gateway.md) |
| Data Source | Row Data Gateway | Simple | [row-data-gateway.md](references/row-data-gateway.md) |
| Object-Relational | Unit of Work | Moderate | [unit-of-work.md](references/unit-of-work.md) |
| Object-Relational | Identity Map | Moderate | [identity-map.md](references/identity-map.md) |
| Object-Relational | Lazy Load | Moderate | [lazy-load.md](references/lazy-load.md) |
| Web Presentation | MVC | Moderate | [mvc.md](references/mvc.md) |
| Web Presentation | Front Controller | Moderate | [front-controller.md](references/front-controller.md) |
| Web Presentation | Page Controller | Simple | [page-controller.md](references/page-controller.md) |
| Web Presentation | Application Controller | Complex | [application-controller.md](references/application-controller.md) |

## Quick Decision

| Domain Complexity | Recommended Pattern |
|-------------------|---------------------|
| Simple, few rules | Transaction Script |
| Moderate | Table Module |
| Rich, many rules | Domain Model |

| Data Access | Recommended Pattern |
|-------------|---------------------|
| Simple, object = DB row | Active Record |
| Complex domain, isolated from DB | Data Mapper + Repository |
| Multiple atomic operations | Unit of Work |

## Examples

```typescript
// ❌ Bad — Active Record: domain coupled to persistence
class User extends ActiveRecord {
  name: string
  async save() { await db.query('INSERT INTO users...') }  // business logic + DB mixed
  async validate() { return this.name.length > 0 }  // business rules in persistence class
}

// ✅ Good — Data Mapper: separation between domain and persistence
class User {  // Pure domain, doesn't know DB
  constructor(public name: string) {}
  validateName() { return this.name.length > 0 }  // isolated business logic
}
class UserMapper {  // Responsible for persistence
  async save(user: User) { await db.query('INSERT INTO users...') }
  async findById(id: string): Promise<User> { /* ... */ }
}
```

```typescript
// ❌ Bad — Transaction Script: scattered business logic
async function transferMoney(fromId: string, toId: string, amount: number) {
  const from = await db.query('SELECT * FROM accounts WHERE id = ?', [fromId])
  const to = await db.query('SELECT * FROM accounts WHERE id = ?', [toId])
  if (from.balance < amount) throw new Error('Insufficient funds')
  await db.query('UPDATE accounts SET balance = balance - ? WHERE id = ?', [amount, fromId])
  await db.query('UPDATE accounts SET balance = balance + ? WHERE id = ?', [amount, toId])
  // hard to test, validations mixed with persistence
}

// ✅ Good — Domain Model + Repository: rich and testable domain
class Account {
  constructor(public id: string, private balance: number) {}
  withdraw(amount: number) {
    if (this.balance < amount) throw new InsufficientFundsError()
    this.balance -= amount
  }
  deposit(amount: number) { this.balance += amount }
}
class TransferService {
  constructor(private repo: AccountRepository) {}
  async transfer(fromId: string, toId: string, amount: number) {
    const from = await this.repo.findById(fromId)
    const to = await this.repo.findById(toId)
    from.withdraw(amount)  // business logic in domain
    to.deposit(amount)
    await this.repo.save(from)
    await this.repo.save(to)
  }
}
// testable in isolation without DB
```

## Rationale

- rule 010 (SRP): Domain Model ensures each class has single responsibility
- rule 014 (DIP): Repository isolates domain from data infrastructure
- rule 021 (DRY): Unit of Work centralizes persistence
- rule 022 (KISS): Transaction Script when domain doesn't justify complexity

**Related skills:**
- [`gof`](../gof/SKILL.md) — depends: PoEAA uses GoF internally (Strategy, Repository, Observer)
- [`solid`](../solid/SKILL.md) — reinforces: PoEAA implements DIP via Data Mapper and Repository
