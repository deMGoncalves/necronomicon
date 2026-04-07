# Data Mapper

**Layer:** Data Source
**Complexity:** Complex
**Intent:** A layer of mappers that moves data between objects and database while keeping both independent of each other and the mapper itself.

---

## When to Use

- Complex domain with Domain Model that should be isolated from infrastructure
- When database schema differs from domain model
- When need to test domain without database (unit tests)
- Systems where database can change without impacting domain

## When NOT to Use

- Simple domains where Active Record would suffice (overengineering — rule 064)
- When mapping layer doesn't add real value

## Minimal Structure (TypeScript)

```typescript
// Pure domain: knows nothing about database
class User {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly email: string
  ) {}

  changeName(name: string): User {
    return new User(this.id, name, this.email)
  }
}

// Mapper: responsible for mapping between domain and database
class UserMapper {
  async findById(id: string): Promise<User | null> {
    const row = await db.query('SELECT * FROM users WHERE id = ?', [id])
    if (!row[0]) return null
    return new User(row[0].id, row[0].name, row[0].email)
  }

  async save(user: User): Promise<void> {
    await db.execute(
      'INSERT INTO users (id, name, email) VALUES (?, ?, ?) ON CONFLICT UPDATE SET name=?, email=?',
      [user.id, user.name, user.email, user.name, user.email]
    )
  }
}
```

## Related

- [active-record.md](active-record.md): substitutes when domain is simple and coupling to database is acceptable
- [repository.md](repository.md): complements — Repository uses Data Mapper internally to isolate domain
- [domain-model.md](domain-model.md): depends — Data Mapper is the natural persistence pattern for Domain Model
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — keeps domain decoupled from data infrastructure

---

**PoEAA Layer:** Data Source
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
