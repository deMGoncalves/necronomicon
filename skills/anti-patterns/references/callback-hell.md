# Callback Hell

**Severity:** 🟠 High
**Associated Rule:** Rule 063

## What It Is

Excessive nesting of asynchronous callbacks that creates a triangular structure ("pyramid") in code. Each asynchronous operation is passed as a callback of the previous one, making the flow impossible to follow. Asynchronous version of Pyramid of Doom.

## Symptoms

- More than 3 levels of callback nesting
- Indentation growing with each asynchronous operation
- Duplicated error handling at each nesting level
- `}) })` pattern at end of file — callback hell markers
- Variables captured in closures across multiple levels
- Impossible to read the flow from top to bottom

## ❌ Example (violation)

```javascript
// ❌ Pyramid of doom — each level is an asynchronous operation
getUser(userId, (err, user) => {
  if (err) return handleError(err);
  getOrders(user.id, (err, orders) => {
    if (err) return handleError(err);
    getProducts(orders[0].id, (err, products) => {
      if (err) return handleError(err);
      calculateTotal(products, (err, total) => {
        if (err) return handleError(err);
        sendInvoice(user, total, (err) => {
          if (err) return handleError(err);
          console.log('done');
        });
      });
    });
  });
});
```

## ✅ Refactoring

```javascript
// ✅ async/await — sequential and readable flow
async function processInvoice(userId) {
  try {
    const user = await getUser(userId);
    const orders = await getOrders(user.id);
    const products = await getProducts(orders[0].id);
    const total = await calculateTotal(products);
    await sendInvoice(user, total);
  } catch (err) {
    handleError(err); // centralized handling
  }
}
```

## Suggested Codetag

```typescript
// FIXME: Callback Hell — 5 levels of callback nesting
// TODO: Migrate to async/await with try/catch
```
