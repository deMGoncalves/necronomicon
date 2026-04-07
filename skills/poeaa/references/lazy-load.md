# Lazy Load

**Layer:** Object-Relational
**Complexity:** Moderate
**Intent:** An object that doesn't contain all the data it needs, but knows how to get it — loading occurs only when the data is actually accessed.

---

## When to Use

- Large relationships that are rarely accessed
- When loading all data at once would be too costly
- In domain objects with associations that aren't always needed
- To optimize loading time in queries with many relationships

## When NOT to Use

- When data will always be needed (load together — Eager Loading)
- When overhead of additional queries is worse than loading everything at once (N+1 problem)
- In loops where Lazy Load would cause N+1 queries (use Eager Loading with JOIN)

## Minimal Structure (TypeScript)

```typescript
class Customer {
  private _orders: Order[] | null = null

  constructor(
    readonly id: string,
    readonly name: string,
    private readonly orderRepository: OrderRepository
  ) {}

  // Lazy Load: loads orders only when accessed
  async getOrders(): Promise<Order[]> {
    if (!this._orders) {
      this._orders = await this.orderRepository.findByCustomerId(this.id)
    }
    return this._orders
  }
}

// Alternative with Virtual Proxy
class LazyOrderCollection {
  private loaded = false
  private orders: Order[] = []

  constructor(
    private readonly customerId: string,
    private readonly repository: OrderRepository
  ) {}

  async toArray(): Promise<Order[]> {
    if (!this.loaded) {
      this.orders = await this.repository.findByCustomerId(this.customerId)
      this.loaded = true
    }
    return this.orders
  }
}
```

## Related

- [identity-map.md](identity-map.md): complements — Identity Map prevents duplicate loads when Lazy Load is triggered multiple times
- [rule 069 - Prohibition of Premature Optimization](../../../rules/069_proibicao-otimizacao-prematura.md): reinforces — measure before introducing Lazy Load; can create N+1 if used without criteria

---

**PoEAA Layer:** Object-Relational
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
