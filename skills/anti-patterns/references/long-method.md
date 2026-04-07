# Long Method

**Severity:** 🟠 High
**Associated Rule:** Rule 055

## What It Is

Function or method with too many lines, performing multiple tasks in sequence. Fowler: the longer the function, the harder to understand. Short functions with good names are self-documented.

## Symptoms

- Functions with more than 20–30 lines
- Need for comments separating "sections" within the function
- Multiple abstraction levels mixed: I/O, validation, calculation, formatting
- Impossible to test without complex setup
- More than one return point with different logic in each

## ❌ Example (violation)

```javascript
// ❌ One function doing validation, transformation, persistence and notification
async function registerUser(data) {
  // validation
  if (!data.email) throw new Error('Email required');
  if (!data.email.includes('@')) throw new Error('Invalid email');
  if (!data.password || data.password.length < 8) throw new Error('Weak password');

  // transformation
  const hashedPassword = await bcrypt.hash(data.password, 10);
  const slug = data.name.toLowerCase().replace(/\s+/g, '-');

  // persistence
  const user = await db.users.create({ ...data, password: hashedPassword, slug });

  // notification
  await emailService.send(user.email, 'Welcome!', welcomeTemplate(user));
  await analyticsService.track('user_registered', { userId: user.id });

  return user;
}
```

## ✅ Refactoring

```javascript
// ✅ Each responsibility in its own function
async function registerUser(data) {
  validateUserData(data);
  const prepared = await prepareUserData(data);
  const user = await db.users.create(prepared);
  await notifyRegistration(user);
  return user;
}
```

## Suggested Codetag

```typescript
// FIXME: Long Method — 27 lines, 4 responsibilities
// TODO: Extract validateUserData, prepareUserData, notifyRegistration
```
