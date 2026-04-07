# Flexibility — Flexibilidade

**Dimension:** Revision
**Default Severity:** 🟠 Important
**Key Question:** Is it easy to change?

## What It Is

The effort required to modify software to meet new requirements or business changes. High flexibility means new features can be added without altering existing code (Open/Closed Principle).

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Circular dependency between modules | 🔴 Blocker |
| Switch with > 5 growing cases | 🟠 Important |
| new Concrete() in business class | 🟠 Important |
| Inheritance > 3 levels | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not flexible - needs modification for each new type
function calculateShipping(order) {
  switch (order.type) {
    case 'standard': return order.weight * 5;
    case 'express': return order.weight * 10;
    // Each new type requires modifying this function
  }
}

// ✅ Flexible - extensible without modification
class ShippingCalculator {
  constructor(strategies) {
    this.strategies = strategies;
  }

  calculate(order) {
    const strategy = this.strategies.get(order.type);
    return strategy.calculate(order);
  }
}
```

## Suggested Codetags

```javascript
// OCP(011): This switch violates Open/Closed - consider Strategy
// DIP(014): Concrete dependency - inject via constructor
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Circular dependency between modules | 🔴 Blocker |
| Switch with > 5 growing cases | 🟠 Important |
| new Concrete() in business class | 🟠 Important |
| Inheritance > 3 levels | 🟡 Suggestion |

## Related Rules

- 011 - Open/Closed Principle
- 014 - Dependency Inversion Principle
- 018 - Acyclic Dependencies Principle
