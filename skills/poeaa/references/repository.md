# Repository

**Layer:** Data Source
**Complexity:** Complex
**Intent:** Mediates between domain and data mapping layers using a collection-like interface for accessing domain objects.

---

## When to Use

- When need to completely abstract data source from domain
- To facilitate database switching or testing with fakes
- With rich Domain Model that shouldn't know about data source
- When complex queries exist that should be centralized

## When NOT to Use

- Simple domains with Transaction Script (overengineering — rule 064)
- When Active Record is already sufficient for complexity level

## Minimal Structure (TypeScript)

```typescript
// Repository interface (domain abstraction)
interface UserRepository {
  findById(id: string): Promise<User | null>
  findByEmail(email: string): Promise<User | null>
  save(user: User): Promise<void>
  delete(id: string): Promise<void>
}

// Concrete implementation for production
class PostgresUserRepository implements UserRepository {
  async findById(id: string): Promise<User | null> {
    const row = await this.db.query('SELECT * FROM users WHERE id = $1', [id])
    return row ? this.toDomain(row) : null
  }

  async findByEmail(email: string): Promise<User | null> {
    const row = await this.db.query('SELECT * FROM users WHERE email = $1', [email])
    return row ? this.toDomain(row) : null
  }

  async save(user: User): Promise<void> { /* upsert */ }
  async delete(id: string): Promise<void> { /* delete */ }

  private toDomain(row: Record<string, unknown>): User {
    return new User(row.id as string, row.name as string, row.email as string)
  }
}

// Fake for tests
class InMemoryUserRepository implements UserRepository {
  private readonly store = new Map<string, User>()

  async findById(id: string): Promise<User | null> { return this.store.get(id) ?? null }
  async findByEmail(email: string): Promise<User | null> {
    return [...this.store.values()].find(u => u.email === email) ?? null
  }
  async save(user: User): Promise<void> { this.store.set(user.id, user) }
  async delete(id: string): Promise<void> { this.store.delete(id) }
}
```

## Related

- [data-mapper.md](data-mapper.md): depends — Repository delegates object-relational mapping to Data Mapper
- [unit-of-work.md](unit-of-work.md): complements — Unit of Work coordinates commits of multiple repositories atomically
- [identity-map.md](identity-map.md): complements — Identity Map prevents duplicate loads within repository
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — completely isolates domain from data infrastructure
- [rule 032 - Minimum Test Coverage](../../../rules/032_cobertura-teste-minima-qualidade.md): complements — repository interface allows substitution by fake in unit tests

---

**PoEAA Layer:** Data Source
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
