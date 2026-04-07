# Reliability — Confiabilidade

**Dimension:** Operation
**Default Severity:** 🔴 Critical
**Key Question:** Is it accurate?

## What It Is

The degree to which software produces consistent and accurate results under different conditions. Reliable software works correctly even in adverse situations, fails gracefully, and recovers from errors.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Error can cause data loss | 🔴 Blocker |
| Error can crash the service | 🔴 Blocker |
| Error affects user experience | 🟠 Important |
| Error in secondary flow | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not reliable - can fail silently
async function fetchUser(id) {
  const response = await api.get(`/users/${id}`);
  return response.data.user; // What if response.data is undefined?
}

// ✅ Reliable - handles errors and validates data
async function fetchUser(id) {
  if (!id) throw new UserIdRequiredError();

  const response = await api.get(`/users/${id}`);

  if (!response.data?.user) {
    throw new UserNotFoundError(id);
  }

  return response.data.user;
}
```

## Suggested Codetags

```javascript
// FIXME: Promise without error handling
// FIXME: Add retry for external call
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Error can cause data loss | 🔴 Blocker |
| Error can crash the service | 🔴 Blocker |
| Error affects user experience | 🟠 Important |
| Error in secondary flow | 🟡 Suggestion |

## Related Rules

- 027 - Domain Error Handling Quality
- 028 - Asynchronous Exception Handling
- 036 - Side Effects Function Restriction
