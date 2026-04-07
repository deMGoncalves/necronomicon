# Unit of Work

**Layer:** Object-Relational
**Complexity:** Moderate
**Intent:** Maintains a list of objects affected by a business transaction and coordinates writing of changes and resolution of concurrency problems.

---

## When to Use

- When multiple domain operations must be persisted atomically
- To avoid multiple round-trips to database in a single transaction
- When need to track changes in domain objects throughout a request
- In applications with rich Domain Model where persistence is separated from domain

## When NOT to Use

- Simple single-entity CRUD operations (overengineering — rule 064)
- With Active Record where object already manages its own persistence
- When ORM already provides Unit of Work automatically (e.g., Hibernate, Entity Framework)

## Minimal Structure (TypeScript)

```typescript
type DirtyStatus = 'new' | 'dirty' | 'removed'

class UnitOfWork {
  private readonly newObjects: DomainObject[] = []
  private readonly dirtyObjects: DomainObject[] = []
  private readonly removedObjects: DomainObject[] = []

  registerNew(obj: DomainObject): void { this.newObjects.push(obj) }
  registerDirty(obj: DomainObject): void {
    if (!this.dirtyObjects.includes(obj)) this.dirtyObjects.push(obj)
  }
  registerRemoved(obj: DomainObject): void { this.removedObjects.push(obj) }

  async commit(): Promise<void> {
    // Execute everything in a single transaction
    await db.transaction(async (tx) => {
      for (const obj of this.newObjects) await obj.insert(tx)
      for (const obj of this.dirtyObjects) await obj.update(tx)
      for (const obj of this.removedObjects) await obj.delete(tx)
    })
    this.clear()
  }

  rollback(): void { this.clear() }

  private clear(): void {
    this.newObjects.length = 0
    this.dirtyObjects.length = 0
    this.removedObjects.length = 0
  }
}

// Typical usage in a use case
async function transferFunds(fromId: string, toId: string, amount: number): Promise<void> {
  const uow = new UnitOfWork()
  const from = await accountRepo.findById(fromId)
  const to = await accountRepo.findById(toId)

  from.debit(amount)
  to.credit(amount)

  uow.registerDirty(from)
  uow.registerDirty(to)

  await uow.commit()
}
```

## Related

- [repository.md](repository.md): complements — repositories register objects in Unit of Work instead of persisting directly
- [identity-map.md](identity-map.md): complements — Identity Map ensures Unit of Work tracks unique instances by identity
- [rule 021 - Prohibition of Logic Duplication](../../../rules/021_proibicao-duplicacao-logica.md): reinforces — centralizes all persistence logic at a single commit point

---

**PoEAA Layer:** Object-Relational
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
