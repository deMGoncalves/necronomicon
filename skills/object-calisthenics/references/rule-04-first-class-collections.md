# Rule 4 — First Class Collections

**deMGoncalves Rule:** ESTRUTURAL-004
**Question:** Is this collection returned or received as native Array/Map/Set?

## What It Is

Determines that any collection (list, array, map) with associated business logic or behavior must be encapsulated in a dedicated class (First Class Collection).

## When to Apply

- Public method returns `Array<T>`
- Public method receives `Array<T>` as parameter
- Filter/sort/sum logic applied in multiple locations
- Collection with domain meaning (e.g., OrderList, Employees)

## ❌ Violation

```typescript
class OrderService {
  getActiveOrders(): Order[] {  // Returns native Array - VIOLATES
    return this.orders.filter(o => o.isActive());
  }

  getTotalValue(orders: Order[]): number {  // Receives Array - VIOLATES
    return orders.reduce((sum, o) => sum + o.value, 0);
  }
}
```

## ✅ Correct

```typescript
class OrderList {
  private readonly orders: Order[];

  constructor(orders: Order[]) {
    this.orders = [...orders];
    Object.freeze(this);
  }

  filterActive(): OrderList {
    return new OrderList(
      this.orders.filter(o => o.isActive())
    );
  }

  getTotalValue(): number {
    return this.orders.reduce((sum, o) => sum + o.value, 0);
  }

  count(): number {
    return this.orders.length;
  }
}

class OrderService {
  getActiveOrders(): OrderList {
    return this.orderList.filterActive();
  }
}
```

## Exceptions

- **Pure DTOs**: Data transfer between layers without logic
- **Framework APIs**: React props, ORM queries that require arrays

## Related Rules

- [007 - Small Classes](rule-07-small-classes.md): reinforces
- [008 - No Getters/Setters Prohibition](rule-08-no-getters-setters.md): reinforces
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): reinforces
