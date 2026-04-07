# Message Chains (Train Wreck)

**Severity:** 🟡 Medium
**Associated Rule:** Rule 005/009

## What It Is

Sequence of chained calls where each result serves as receiver for the next call: `a.getB().getC().getD().getValue()`. The client knows the internal structure of the entire chain of objects. Violation of Law of Demeter.

## Symptoms

- Lines with 3 or more chained calls navigating objects
- Code that breaks when internal structure of any object in the chain changes
- Difficult to mock for tests: needs deep stubs
- Problematic null safety: hard-to-diagnose failure in the middle of the chain

## ❌ Example (violation)

```javascript
// ❌ Chain that exposes deep internal structure (Train Wreck)
const city = order.getCustomer().getAddress().getCity().getName();

// ❌ Obscure null failure: which object is null?
const url = order.getUser().getProfile().getAvatar().getUrl();
```

## ✅ Refactoring

```javascript
// ✅ Each object encapsulates access to its neighbor (Hide Delegate)
class Order {
  getCustomerCity() {
    return this.customer.getCity(); // encapsulates navigation
  }
}

const city = order.getCustomerCity();

// ✅ Or use optional chaining for safety (if structure is unavoidable)
const url = order.getUser()?.getProfile()?.getAvatar()?.getUrl();
```

## Suggested Codetag

```typescript
// FIXME: Message Chains — order.getCustomer().getAddress().getCity().getName()
// TODO: Hide Delegate — create order.getCustomerCity()
```
