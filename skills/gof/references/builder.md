# Builder

**Category:** Creational
**Intent:** Separate the construction of a complex object from its representation, allowing step-by-step construction.

---

## When to Use

- Object has many optional parameters in constructor (avoids telescoping constructors)
- Object construction involves multiple steps or configurations
- Different representations of an object from the same construction process
- When building SQL queries, HTTP requests, or configuration objects

## When NOT to Use

- When the object is simple and has few parameters — use direct constructor (overengineering — rule 064)
- When all parameters are mandatory and always present
- When there's no variation in construction

## Minimal Structure (TypeScript)

```typescript
class QueryBuilder {
  private table = ''
  private conditions: string[] = []
  private limitValue: number | null = null

  from(table: string): QueryBuilder {
    this.table = table
    return this
  }

  where(condition: string): QueryBuilder {
    this.conditions.push(condition)
    return this
  }

  limit(value: number): QueryBuilder {
    this.limitValue = value
    return this
  }

  build(): string {
    const where = this.conditions.length
      ? `WHERE ${this.conditions.join(' AND ')}`
      : ''
    const limit = this.limitValue ? `LIMIT ${this.limitValue}` : ''
    return `SELECT * FROM ${this.table} ${where} ${limit}`.trim()
  }
}
```

## Real Usage Example

```typescript
new QueryBuilder().from('users').where('active = true').limit(10).build()
```

## Related to

- [abstract-factory.md](abstract-factory.md): complements — Abstract Factory creates families; Builder builds a single complex product
- [prototype.md](prototype.md): complements — Prototype can be used when the Builder's final object needs to be cloned
- [rule 033 - Max Parameters per Function](../../../rules/033_limite-parametros-funcao.md): reinforces — Builder eliminates constructors with many parameters
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — don't use for simple objects
- [rule 005 - Max One Call per Line](../../../rules/005_maximo-uma-chamada-por-linha.md): complements — Builder's fluent interface is permitted exception to chaining

---

**GoF Category:** Creational
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
