# Feature Envy

**Severity:** 🟡 Medium
**Associated Rule:** Rule 057

## What It Is

Method that uses data and behaviors of another class more than its own. Indicates the method is in the wrong class — it "envies" the other class and should be there. The method seems more interested in another object's data than its own.

## Symptoms

- Method calls getters of another object 3 or more times
- Method accesses properties of another object more than `this`
- To test the method, you need to configure complex state of dependent objects
- Method doesn't use any attributes or methods of its own class, only dependencies

## ❌ Example (violation)

```javascript
// ❌ calculateBill is in Reservation but uses Customer data
class Reservation {
  calculateBill(customer) {
    const base = this.nights * this.room.rate;
    // uses 3 customer attributes — it's in the wrong class
    if (customer.membershipYears > 2) return base * 0.9;
    if (customer.totalSpent > 5000) return base * 0.95;
    return base;
  }
}
```

## ✅ Refactoring

```javascript
// ✅ Discount logic belongs to Customer (Move Method)
class Customer {
  applyDiscount(base) {
    if (this.membershipYears > 2) return base * 0.9;
    if (this.totalSpent > 5000) return base * 0.95;
    return base;
  }
}

class Reservation {
  calculateBill(customer) {
    const base = this.nights * this.room.rate;
    return customer.applyDiscount(base); // Tell, Don't Ask
  }
}
```

## Suggested Codetag

```typescript
// FIXME: Feature Envy — calculateBill uses customer.membershipYears, customer.totalSpent
// TODO: Move Method — move discount logic to Customer.applyDiscount()
```
