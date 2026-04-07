# REFACTOR — Code Violating Design Principles

**Severity:** 🟠 High
**Blocks PR:** No (but should be prioritized)

## What It Is

Marks code that violates design principles or best practices and needs to be restructured. Code works correctly but its structure hinders maintenance, testing or evolution.

## When to Use

- SOLID violation (class with multiple responsibilities)
- God Class/Function (file with 500+ lines)
- High coupling (circular dependencies)
- Duplicated code (same logic in several places)
- Excessive complexity (CC > 10)

## When NOT to Use

- Code with bug → use FIXME
- Temporary solution → use HACK
- Performance optimization → use OPTIMIZE
- Code to be removed → use DEPRECATED

## Format

```typescript
// REFACTOR: violated principle - suggested action
// REFACTOR: [SRP] description - extract to class X
// REFACTOR: CC=15 - split into smaller functions
```

## Example

```typescript
// REFACTOR: [SRP] class does validation + persistence + notification
// Extract: OrderValidator, OrderRepository, OrderNotifier
class OrderService {
  createOrder(data: OrderData): Order {
    // Validation (should be in OrderValidator)
    if (!data.items) throw new Error('Items required');
    if (!data.customer) throw new Error('Customer required');

    // Persistence (should be in OrderRepository)
    const order = db.orders.create(data);

    // Notification (should be in OrderNotifier)
    emailService.send(order.customer.email, 'Order created');

    return order;
  }
}

// REFACTOR: [DRY] formatting logic duplicated in 5 files
// Extract to utils/formatters.ts
function formatUserName(user: User): string {
  return `${user.firstName} ${user.lastName}`.trim().toUpperCase();
}

// Same code in another file...
function formatCustomerName(customer: Customer): string {
  return `${customer.firstName} ${customer.lastName}`.trim().toUpperCase();
}

// REFACTOR: [DIP] depends on concrete implementation
// Inject IEmailService interface instead of SendGridService
class NotificationService {
  constructor() {
    this.emailService = new SendGridService(); // ❌ Tight coupling
  }
}

// ✅ After refactoring
class NotificationService {
  constructor(private emailService: IEmailService) {}
}
```

## Resolution

- **Timeline:** Current sprint (critical God class) or next sprint (duplication) or backlog (incremental improvement)
- **Action:** Identify violated principle → Document refactoring → Estimate effort → Prioritize technical backlog → Execute with tests → Remove comment
- **Converted to:** Removed after complete refactoring

## Related to

- Rules: [010](../../../.claude/rules/010_principio-responsabilidade-unica.md), [011](../../../.claude/rules/011_principio-aberto-fechado.md), [021](../../../.claude/rules/021_proibicao-duplicacao-logica.md), [025](../../../.claude/rules/025_proibicao-anti-pattern-the-blob.md)
- Similar tags: REFACTOR changes structure, CLEANUP removes noise, HACK is temporary
