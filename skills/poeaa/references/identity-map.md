# Identity Map

**Layer:** Object-Relational
**Complexity:** Moderate
**Intent:** Ensures each object is loaded only once by keeping a map of every object that has been loaded, and looks up objects in that map when referring to them.

---

## When to Use

- Prevent same record from being loaded multiple times in a request
- Ensure identity consistency — two `findById('123')` should return the same object
- In systems with Domain Model where object identity matters
- To optimize redundant queries within a unit of work

## When NOT to Use

- Simple applications where duplicate loading is not a problem
- When request scope is too short to justify the overhead
- In stateless systems where map would be recreated with each request anyway

## Minimal Structure (TypeScript)

```typescript
class IdentityMap {
  private readonly maps = new Map<string, Map<string, DomainObject>>()

  get<T extends DomainObject>(className: string, id: string): T | null {
    return (this.maps.get(className)?.get(id) as T) ?? null
  }

  set(className: string, id: string, obj: DomainObject): void {
    if (!this.maps.has(className)) {
      this.maps.set(className, new Map())
    }
    this.maps.get(className)!.set(id, obj)
  }
}

// Repository using Identity Map
class UserRepository {
  constructor(
    private readonly db: Database,
    private readonly identityMap: IdentityMap
  ) {}

  async findById(id: string): Promise<User | null> {
    // First check identity map
    const cached = this.identityMap.get<User>('User', id)
    if (cached) return cached

    // Load from database only if not in map
    const row = await this.db.query('SELECT * FROM users WHERE id = ?', [id])
    if (!row) return null

    const user = new User(row.id, row.name, row.email)
    this.identityMap.set('User', id, user)
    return user
  }
}
```

## Related

- [unit-of-work.md](unit-of-work.md): complements — Unit of Work uses Identity Map to track unique instances throughout transaction
- [repository.md](repository.md): complements — repositories consult Identity Map before going to database

---

**PoEAA Layer:** Object-Relational
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
