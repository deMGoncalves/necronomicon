# Maintainability — Manutenibilidade

**Dimension:** Revision
**Default Severity:** 🟠 Important
**Key Question:** Is it easy to fix?

## What It Is

The effort required to locate and fix a defect in software. High maintainability means bugs can be found quickly, causes are obvious, and fixes can be made without side effects.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| God class (> 500 lines) | 🔴 Blocker |
| Method with CC > 10 | 🟠 Important |
| Significant duplicated code | 🟠 Important |
| Insufficient logs | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not maintainable - class does everything
class OrderManager {
  createOrder() { /* ... */ }
  validateOrder() { /* ... */ }
  calculateTax() { /* ... */ }
  sendEmail() { /* ... */ }
  // ... 500 lines of code
}

// ✅ Maintainable - separated responsibilities
class OrderService {
  constructor(validator, calculator, notifier) {
    this.validator = validator;
    this.calculator = calculator;
    this.notifier = notifier;
  }

  async createOrder(data) {
    const order = this.validator.validate(data);
    order.total = this.calculator.calculate(order);
    await this.notifier.notify(order);
    return order;
  }
}
```

## Suggested Codetags

```javascript
// REFACTOR: This class violates SRP - separate into smaller services
// REFACTOR: Method too complex - extract submethods
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| God class (> 500 lines) | 🔴 Blocker |
| Method with CC > 10 | 🟠 Important |
| Significant duplicated code | 🟠 Important |
| Insufficient logs | 🟡 Suggestion |

## Related Rules

- 010 - Single Responsibility Principle
- 007 - Maximum Lines per Class
- 025 - Prohibition of The Blob Anti-Pattern
