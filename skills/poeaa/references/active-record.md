# Active Record

**Layer:** Data Source
**Complexity:** Simple
**Intent:** An object that encapsulates a row in a database table, encapsulates database access, and adds domain logic on the data.

---

## When to Use

- Simple applications where domain object = database row
- When business logic is simple and doesn't benefit from database isolation
- Straight CRUDs with little additional logic
- Frameworks like Rails ActiveRecord, Eloquent — where the pattern is idiomatic

## When NOT to Use

- When domain has complex rules that shouldn't be coupled to database (use Data Mapper)
- When need to test domain without database
- When database schema differs significantly from domain model

## Minimal Structure (TypeScript)

```typescript
class User {
  id?: number
  name: string
  email: string

  constructor(name: string, email: string) {
    this.name = name
    this.email = email
  }

  // Object knows how to save itself
  async save(): Promise<void> {
    if (this.id) {
      await db.execute('UPDATE users SET name=?, email=? WHERE id=?', [this.name, this.email, this.id])
    } else {
      const result = await db.execute('INSERT INTO users (name, email) VALUES (?, ?)', [this.name, this.email])
      this.id = result.insertId
    }
  }

  static async findById(id: number): Promise<User | null> {
    const rows = await db.query('SELECT * FROM users WHERE id = ?', [id])
    if (!rows[0]) return null
    const user = new User(rows[0].name, rows[0].email)
    user.id = rows[0].id
    return user
  }
}
```

## Related

- [data-mapper.md](data-mapper.md): substitutes when domain becomes complex and needs to be isolated from infrastructure
- [transaction-script.md](transaction-script.md): complements — Active Record is the natural persistence choice for Transaction Script
- [row-data-gateway.md](row-data-gateway.md): substitutes when domain logic grows beyond simple data access
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — use Active Record when Data Mapper doesn't add real value

---

**PoEAA Layer:** Data Source
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
