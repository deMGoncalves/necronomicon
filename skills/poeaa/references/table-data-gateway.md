# Table Data Gateway

**Layer:** Data Source
**Complexity:** Simple
**Intent:** An object that acts as a gateway to a database table, with one object per table and all accesses going through it.

---

## When to Use

- With Table Module as domain pattern
- Centralize all queries for a table in a single place
- When you want SQL abstraction but without complex object-domain mapping
- In data-oriented systems rather than domain object-oriented

## When NOT to Use

- With complex Domain Model (use Data Mapper + Repository)
- When business logic goes beyond simple table operations

## Minimal Structure (TypeScript)

```typescript
// One gateway per table — all accesses go through here
class PersonGateway {
  async findAll(): Promise<PersonRecord[]> {
    return this.db.query('SELECT * FROM person')
  }

  async findByLastName(lastName: string): Promise<PersonRecord[]> {
    return this.db.query('SELECT * FROM person WHERE last_name = ?', [lastName])
  }

  async insert(firstName: string, lastName: string, numberOfDependents: number): Promise<number> {
    const result = await this.db.execute(
      'INSERT INTO person (first_name, last_name, number_of_dependents) VALUES (?, ?, ?)',
      [firstName, lastName, numberOfDependents]
    )
    return result.insertId
  }

  async update(id: number, firstName: string, lastName: string, numberOfDependents: number): Promise<void> {
    await this.db.execute(
      'UPDATE person SET first_name=?, last_name=?, number_of_dependents=? WHERE id=?',
      [firstName, lastName, numberOfDependents, id]
    )
  }
}
```

## Related

- [row-data-gateway.md](row-data-gateway.md): complements — Row Data Gateway operates per row while Table Data Gateway operates on entire table
- [table-module.md](table-module.md): complements — Table Module uses Table Data Gateway as its data access layer

---

**PoEAA Layer:** Data Source
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
