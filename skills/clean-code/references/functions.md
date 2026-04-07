# Functions (Rules 033, 037)

## Rules

- **033**: Maximum 3 parameters per function
- **037**: Prohibition of flag arguments (boolean flags)

## Checklist

- [ ] Functions with ≤3 parameters
- [ ] Parameters >3 → create Parameter Object (DTO)
- [ ] No boolean flags that alter main flow
- [ ] Branches → separate methods with clear names

## Examples

```typescript
// ❌ Violations
function createOrder(userId, productId, quantity, discount, coupon, address) { } // 6 params
function render(user, isAdmin) { // boolean flag
  if (isAdmin) return renderAdminView(user);
  return renderUserView(user);
}

// ✅ Compliance
interface CreateOrderInput {
  userId: string;
  productId: string;
  quantity: number;
  discount: number;
  couponCode?: string;
  deliveryAddress: string;
}

function createOrder(input: CreateOrderInput) { }

// Separate methods instead of flag
function renderUser(user: User) { }
function renderAdminUser(user: User) { }
```

## Relation to ICP

Fewer parameters = lower coupling and clearer responsibilities.
