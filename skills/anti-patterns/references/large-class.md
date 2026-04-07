# Large Class

**Severity:** 🟠 High
**Associated Rule:** Rule 007

## What It Is

Class with too many attributes and methods, indicating it's trying to do too much. Fowler: when a class has too many responsibilities, code smells like duplication and lack of cohesion naturally emerge. Initial stage of a The Blob.

## Symptoms

- Class files with more than 50 lines of code (excluding blank lines and comments)
- Classes reaching 40 lines should be refactoring candidates
- More than 300–500 lines
- Prefixes/suffixes on attributes to distinguish groups (`userEmail`, `orderEmail`, `shippingEmail`)
- Subsets of attributes used only by subsets of methods
- Tests that need extensive mocks to test a single behavior
- A class should not contain more than 10 public methods

## ❌ Example (violation)

```javascript
// ❌ Class mixing profile, address and payment (> 50 lines)
class User {
  constructor() {
    this.name = '';
    this.email = '';
    this.street = '';       // address
    this.city = '';         // address
    this.zipCode = '';      // address
    this.cardNumber = '';   // payment
    this.cardExpiry = '';   // payment
  }
  formatAddress() { ... }
  validateCard() { ... }
  sendEmail() { ... }
}
```

## ✅ Refactoring

```javascript
// ✅ Each concept in its own class (Extract Class)
class User { constructor({ name, email }) { ... } }
class Address { constructor({ street, city, zipCode }) { ... } }
class PaymentMethod { constructor({ cardNumber, cardExpiry }) { ... } }

// Composition instead of monolithic class
class UserAccount {
  constructor(user, address, paymentMethod) {
    this.user = user;
    this.address = address;
    this.paymentMethod = paymentMethod;
  }
}
```

## Suggested Codetag

```typescript
// FIXME: Large Class — User has 87 lines, mixes profile + address + payment
// TODO: Extract Class — create separate Address, PaymentMethod
```
