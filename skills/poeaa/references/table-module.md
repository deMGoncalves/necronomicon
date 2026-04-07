# Table Module

**Layer:** Domain Logic
**Complexity:** Moderate
**Intent:** A single instance handles the business logic for all rows in a database table or view.

---

## When to Use

- Moderate business logic strongly tied to table structure
- Applications with Record Set (DataSet) as central data abstraction
- Legacy or reporting systems where operations are per data set
- When logic is more about set manipulation than individual objects

## When NOT to Use

- When domain has objects with rich behavior and their own identity (use Domain Model)
- When logic goes beyond simple set operations
- In modern systems without Record Set infrastructure

## Minimal Structure (TypeScript)

```typescript
// One class per table, operates on record sets
class OrderTable {
  constructor(private readonly db: Database) {}

  async findPendingByCustomer(customerId: string): Promise<OrderRecord[]> {
    return this.db.query(
      'SELECT * FROM orders WHERE customer_id = ? AND status = ?',
      [customerId, 'pending']
    )
  }

  async calculateTotalRevenue(startDate: Date, endDate: Date): Promise<number> {
    const result = await this.db.query(
      'SELECT SUM(total) as revenue FROM orders WHERE created_at BETWEEN ? AND ?',
      [startDate, endDate]
    )
    return result[0]?.revenue ?? 0
  }

  async updateStatus(orderId: string, status: string): Promise<void> {
    await this.db.execute(
      'UPDATE orders SET status = ? WHERE id = ?',
      [status, orderId]
    )
  }
}
```

## Related

- [table-data-gateway.md](table-data-gateway.md): depends — Table Data Gateway is the natural data access pattern for Table Module
- [domain-model.md](domain-model.md): substitutes when rich behavior of individual objects is needed
- [rule 022 - Prioritization of Simplicity and Clarity](../../../rules/022_priorizacao-simplicidade-clareza.md): complements — suitable for moderately complex domains

---

**PoEAA Layer:** Domain Logic
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
