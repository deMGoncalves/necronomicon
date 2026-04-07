# Divergent Change

**Severity:** 🟠 High
**Associated Rule:** Rule 054

## What It Is

A single class changes for multiple different and unrelated reasons. Each new type of change requires editing the same class for a completely different reason than the previous one. Complementary opposite of Shotgun Surgery: here, one class changes for N reasons.

## Symptoms

- Class has sections separated by comments (`// database logic`, `// business rules`, `// ui formatting`)
- Commit history shows commits of completely different features always modifying same file
- Unit tests need to mock multiple responsibilities to test a single functionality
- Multiple reasons to change: "I changed it because we switched databases... and because discount rule changed... and because report changed"

## ❌ Example (violation)

```javascript
// ❌ OrderService changes when: database changes, tax rule changes, report format changes
class OrderService {
  // Data layer
  async findOrders(filters) { return db.query('SELECT ...', filters); }

  // Business rule
  calculateTax(order) { return order.subtotal * TAX_RATES[order.region]; }

  // Formatting
  formatForReport(orders) { return orders.map(o => ({ id: o.id, total: formatCurrency(o.total) })); }
}
```

## ✅ Refactoring

```javascript
// ✅ Each class changes for only one reason (Extract Class)
class OrderRepository {
  async findOrders(filters) { ... }  // changes when database changes
}

class TaxCalculator {
  calculateTax(order) { ... }        // changes when law changes
}

class OrderReportFormatter {
  formatForReport(orders) { ... }    // changes when report changes
}
```

## Suggested Codetag

```typescript
// FIXME: Divergent Change — OrderService has 3 responsibilities: persistence, calculation, formatting
// TODO: Extract OrderRepository, TaxCalculator, OrderReportFormatter
```
