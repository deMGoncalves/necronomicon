# Row Data Gateway

**Layer:** Data Source
**Complexity:** Simple
**Intent:** An object that acts as a gateway to a single record returned by a database access, with one object per row and database access methods.

---

## When to Use

- When you want object per row with SQL encapsulation
- Separate database access from domain logic in a simple way
- Simpler alternative to Data Mapper for moderate domains
- When Transaction Script is the domain pattern

## When NOT to Use

- When domain is rich and objects have behavior beyond persistence (use Data Mapper)
- When database schema differs from business model

## Minimal Structure (TypeScript)

```typescript
// One object per database row
class PersonRow {
  private id: number
  private firstName: string
  private lastName: string

  // Loaded from database
  static async load(id: number): Promise<PersonRow> {
    const row = await db.query('SELECT * FROM person WHERE id = ?', [id])
    const person = new PersonRow()
    person.id = row.id
    person.firstName = row.first_name
    person.lastName = row.last_name
    return person
  }

  // Each instance knows how to update itself
  async update(): Promise<void> {
    await db.execute(
      'UPDATE person SET first_name=?, last_name=? WHERE id=?',
      [this.firstName, this.lastName, this.id]
    )
  }

  getName(): string { return `${this.firstName} ${this.lastName}` }
}
```

## Related

- [table-data-gateway.md](table-data-gateway.md): complements — Table Data Gateway is the finder that returns Row Data Gateways
- [active-record.md](active-record.md): substitutes when domain logic grows and object needs its own behavior
- [transaction-script.md](transaction-script.md): complements — Row Data Gateway is the natural data access pattern for Transaction Script

---

**PoEAA Layer:** Data Source
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
