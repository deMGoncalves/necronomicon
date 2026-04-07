# Spaghetti Code

**Severity:** 🔴 Critical
**Associated Rule:** Rule 060

## What It Is

Code with chaotic control flow and non-existent structure: functions calling others in arbitrary order, shared mutable global state, mixed responsibilities without layer separation.

## Symptoms

- Huge functions with multiple nesting levels
- Global state modified in unexpected places
- Execution flow jumping between files/functions without clear hierarchy
- Impossible to understand what a function does without reading everything it calls
- No separation between I/O, business logic and presentation

## ❌ Example (violation)

```javascript
// ❌ Logic, I/O and presentation mixed without structure
async function handleCheckout(req, res) {
  const user = await db.query(`SELECT * FROM users WHERE id = ${req.body.userId}`);
  if (user && user.active) {
    let total = 0;
    for (let item of req.body.items) {
      const product = await db.query(`SELECT * FROM products WHERE id = ${item.id}`);
      if (product.stock > 0) {
        total += product.price * item.qty;
        await db.query(`UPDATE products SET stock = stock - ${item.qty} WHERE id = ${item.id}`);
      }
    }
    await sendEmail(user.email, `Your order of $${total} has been confirmed`);
    globalOrderCount++;
    res.json({ ok: true, total });
  } else {
    res.status(400).json({ error: 'Inactive user' });
  }
}
```

## ✅ Refactoring

```javascript
// ✅ Responsibilities separated into layers
class CheckoutService {
  async process(userId, items) {
    const user = await this.userRepo.findActiveOrThrow(userId);
    const order = await this.orderRepo.create(user, items);
    await this.emailService.sendConfirmation(user, order);
    return order;
  }
}
```

## Suggested Codetag

```typescript
// FIXME: Spaghetti Code — I/O, validation, logic and presentation mixed
// TODO: Separate into layers: Controller → Service → Repository
```
