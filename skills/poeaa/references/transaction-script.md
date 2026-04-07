# Transaction Script

**Layer:** Domain Logic
**Complexity:** Simple
**Intent:** Organize business logic as a single procedure that handles each request from the presentation layer.

---

## When to Use

- Simple domain with few business rules
- Straight CRUD without complex validation or calculation logic
- Integration and data synchronization scripts
- Small applications where Domain Model complexity doesn't justify itself
- Prototypes and MVPs that need development speed

## When NOT to Use

- When multiple scripts share similar logic (creates duplication — rule 021)
- When business rules are scattered across various scripts without cohesion
- When domain has entities with their own behavior (use Domain Model)
- When scripts get over 50 lines of business logic (rule 007)

## Minimal Structure (TypeScript)

```typescript
// Each function is a complete script that handles a transaction
async function createOrder(
  customerId: string,
  items: Array<{ productId: string; quantity: number }>
): Promise<string> {
  // 1. Simple validation
  if (items.length === 0) throw new Error('Order must have at least one item')

  // 2. Direct calculation
  const total = items.reduce((sum, item) => sum + item.quantity * 10, 0)

  // 3. Direct persistence
  const orderId = await db.insert('orders', { customerId, total, status: 'pending' })
  await db.insertMany('order_items', items.map(item => ({ orderId, ...item })))

  return orderId
}
```

## Related

- [domain-model.md](domain-model.md): substitutes when domain complexity grows
- [row-data-gateway.md](row-data-gateway.md): complements — Row Data Gateway is the natural data pattern for Transaction Script
- [active-record.md](active-record.md): complements — Active Record is data access alternative for Transaction Script
- [rule 022 - Prioritization of Simplicity and Clarity](../../../rules/022_priorizacao-simplicidade-clareza.md): reinforces — use when domain doesn't justify additional complexity

---

**PoEAA Layer:** Domain Logic
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
