# Domain Model

**Layer:** Domain Logic
**Complexity:** Complex
**Intent:** An object model of the domain that incorporates both behavior and data, where each business entity encapsulates its own logic.

---

## When to Use

- Rich domain with many interdependent business rules
- Entities with their own behavior (not just data)
- Business rules that need to be tested in isolation
- Systems that must evolve with new business requirements frequently

## When NOT to Use

- Simple domains where Transaction Script would suffice (overengineering — rule 064)
- When team is not familiar with DDD and advanced OOP
- When delivery time is critical and domain is genuinely simple

## Minimal Structure (TypeScript)

```typescript
class Order {
  private readonly items: OrderItem[] = []
  private status: OrderStatus = OrderStatus.PENDING

  constructor(private readonly customerId: string) {}

  addItem(product: Product, quantity: number): void {
    if (this.status !== OrderStatus.PENDING) {
      throw new Error('Cannot add items to non-pending order')
    }
    this.items.push(new OrderItem(product, quantity))
  }

  confirm(): void {
    if (this.items.length === 0) throw new Error('Empty order')
    this.status = OrderStatus.CONFIRMED
  }

  calculateTotal(): Money {
    return this.items.reduce(
      (total, item) => total.add(item.calculateSubtotal()),
      Money.zero()
    )
  }

  isConfirmed(): boolean { return this.status === OrderStatus.CONFIRMED }
}
```

## Related

- [transaction-script.md](transaction-script.md): substitutes when domain is simple
- [data-mapper.md](data-mapper.md): depends — Domain Model needs Data Mapper for persistence without database coupling
- [repository.md](repository.md): depends — Repository abstracts access to domain entities
- [unit-of-work.md](unit-of-work.md): complements — Unit of Work coordinates persistence of multiple domain entities
- [rule 010 - Single Responsibility Principle](../../../rules/010_principio-responsabilidade-unica.md): reinforces — each entity encapsulates exactly its business responsibility
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — domain doesn't depend on infrastructure

---

**PoEAA Layer:** Domain Logic
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
