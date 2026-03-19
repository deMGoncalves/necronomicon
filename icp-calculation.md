# ICP Calculation (Intrinsic Complexity Points)

## General Formula

```
ICP = CC_base + Nesting + Responsibilities + Coupling
```

## Component 1: Base Cyclomatic Complexity

CC measures the number of independent paths through the code.

### CC Calculation

CC = number of decision points + 1

**Decision points:**
- `if`, `else if`
- `for`, `while`, `do-while`
- `case` in `switch`
- `&&`, `||` in conditions
- `catch` in try-catch
- `?` in ternary operator

### Conversion to Base ICP

| CC | ICP Base | Category |
|----|----------|-----------|
| ≤ 5 | 1 | Simple |
| 6-10 | 2 | Moderate |
| 11-15 | 3 | Complex |
| 16-20 | 4 | Very Complex |
| > 20 | 5 | Critical |

**Example:**

```javascript
// CC = 4 (3 ifs + 1) → ICP Base = 1
function validateEmail(email) {
  if (!email) return false;
  if (!email.includes('@')) return false;
  if (email.length < 5) return false;
  return true;
}
```

## Component 2: Nesting Depth

Measures how many indentation levels the code has.

### Scoring

| Levels | Points | Example |
|--------|--------|---------|
| 1 | 0 | Linear code with guard clauses |
| 2 | 1 | One level of `if` or `for` |
| 3 | 2 | `if` inside `for` |
| 4+ | 3 | Deep nesting |

**Example:**

```javascript
// Nesting = 3 levels → +2 points
function processOrders(orders) {
  for (let order of orders) {           // Level 1
    if (order.isPaid) {                  // Level 2
      for (let item of order.items) {    // Level 3
        item.ship();
      }
    }
  }
}
```

## Component 3: Number of Responsibilities

Measures SRP (Single Responsibility Principle) violations.

### Responsibility Identification

A function has multiple responsibilities if it does 2+ of the following:

1. Data validation
2. Data transformation
3. Persistence (save, update, delete)
4. Query (fetch, read)
5. Business logic
6. Formatting/presentation
7. Logging/auditing
8. Error handling

### Scoring

| Responsibilities | Points |
|-------------------|--------|
| 1 | 0 |
| 2-3 | 1 |
| 4-5 | 2 |
| 6+ | 3 |

**Example:**

```javascript
// 3 responsibilities → +1 point
// 1. Validation, 2. Transformation, 3. Persistence
function createUser(data) {
  // 1. Validation
  if (!data.email) throw new Error('Invalid email');

  // 2. Transformation
  const user = {
    email: data.email.toLowerCase(),
    name: data.name.trim()
  };

  // 3. Persistence
  database.users.insert(user);
  return user;
}
```

## Component 4: Coupling (Optional)

Measures direct external dependencies.

### Scoring

| Dependencies | Points |
|--------------|--------|
| 0-2 | 0 |
| 3-5 | 1 |
| 6+ | 2 |

**Example:**

```javascript
// 4 dependencies → +1 point
import { validateEmail } from './validators';
import { hashPassword } from './crypto';
import { sendEmail } from './mailer';
import { database } from './db';

function registerUser(email, password) {
  validateEmail(email);
  const hash = hashPassword(password);
  database.insert({ email, password: hash });
  sendEmail(email, 'Welcome');
}
```

## Complete Calculation: Examples

### Example 1: Simple Function

```javascript
function sum(a, b) {
  return a + b;
}
```

- CC: 1 → ICP Base = 1
- Nesting: 0 levels → +0
- Responsibilities: 1 (transformation) → +0
- Coupling: 0 → +0

**Total ICP: 1** 🟢 (Excellent)

---

### Example 2: Moderate Function

```javascript
function processPayment(order) {
  if (!order.isPaid) {
    const result = paymentGateway.charge(order.total);
    if (result.success) {
      order.markAsPaid();
      emailService.sendReceipt(order.email);
      return true;
    }
  }
  return false;
}
```

- CC: 3 (2 ifs + 1) → ICP Base = 1
- Nesting: 2 levels → +1
- Responsibilities: 3 (validation, payment, notification) → +1
- Coupling: 3 (paymentGateway, order, emailService) → +1

**Total ICP: 4** 🟡 (Acceptable, consider refactoring)

---

### Example 3: Complex Function

```javascript
function syncUserData(userId) {
  const user = database.users.findById(userId);
  if (user) {
    if (user.needsSync) {
      const remoteData = apiClient.fetchUserData(user.externalId);
      if (remoteData) {
        for (let field of remoteData.fields) {
          if (field.changed) {
            user[field.name] = field.value;
            auditLog.record('field_updated', { userId, field: field.name });
          }
        }
        user.lastSync = new Date();
        database.users.update(user);
        return true;
      }
    }
  }
  return false;
}
```

- CC: 6 (5 ifs/for + 1) → ICP Base = 2
- Nesting: 4 levels → +3
- Responsibilities: 5 (query, validation, fetch, transformation, persistence) → +2
- Coupling: 4 (database, apiClient, auditLog, Date) → +1

**Total ICP: 8** 🟠 (Concerning, refactoring recommended)

---

## ICP Limits and Actions

| ICP | Status | Action |
|-----|--------|------|
| ≤ 3 | 🟢 Excellent | Maintain |
| 4-6 | 🟡 Acceptable | Consider refactoring |
| 7-10 | 🟠 Concerning | Refactoring recommended |
| > 10 | 🔴 Critical | Mandatory refactoring |

## ICP Reduction Strategies

### 1. Reduce CC → Extract Method

```javascript
// Before: CC = 5, ICP = 6
function processOrder(order) {
  if (!order.items.length) return false;
  if (!order.customer) return false;
  if (!order.isPaid) return false;
  if (!order.address) return false;
  order.ship();
  return true;
}

// After: CC = 2, ICP = 2
function processOrder(order) {
  if (!isValidOrder(order)) return false;
  order.ship();
  return true;
}

function isValidOrder(order) {
  return order.items.length > 0
    && order.customer
    && order.isPaid
    && order.address;
}
```

### 2. Reduce Nesting → Early Return

```javascript
// Before: Nesting = 3
function getDiscount(user) {
  if (user) {
    if (user.isPremium) {
      if (user.purchases > 10) {
        return 0.2;
      }
    }
  }
  return 0;
}

// After: Nesting = 1
function getDiscount(user) {
  if (!user) return 0;
  if (!user.isPremium) return 0;
  if (user.purchases <= 10) return 0;
  return 0.2;
}
```

### 3. Reduce Responsibilities → SRP

```javascript
// Before: 4 responsibilities
function registerUser(email, password) {
  validateEmail(email);
  const hash = hashPassword(password);
  const user = database.insert({ email, password: hash });
  sendWelcomeEmail(email);
  return user;
}

// After: 1 responsibility (orchestration)
function registerUser(email, password) {
  const user = userService.create(email, password);
  notificationService.sendWelcome(user);
  return user;
}
```

## Tools

- **Manual**: Visual counting of components
- **Automatic**: ESLint with plugins `complexity`, `max-depth`, `max-lines-per-function`
- **IDE**: Plugins that calculate CC and show metrics

## Version

ICP Calculation v1.0 - March 2026
