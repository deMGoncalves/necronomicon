# Interoperability — Interoperabilidade

**Dimension:** Transition
**Default Severity:** 🟠 Important
**Key Question:** Does it integrate well with other systems?

## What It Is

The effort required to couple software to other systems. High interoperability means the system uses open standards, common protocols, and well-defined data formats for communication with external systems.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Public API without versioning | 🔴 Blocker |
| Webhook without idempotence | 🟠 Important |
| Inconsistent error format | 🟠 Important |
| Undocumented contract | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not interoperable - proprietary format
function exportData() {
  return `USER|${user.id}|${user.name}|${user.email}|END`;
  // Custom format that only this system understands
}

// ✅ Interoperable - standard format
function exportData() {
  return JSON.stringify({
    type: 'user',
    data: {
      id: user.id,
      name: user.name,
      email: user.email
    }
  });
}
```

## Suggested Codetags

```javascript
// API: Endpoint needs versioning
// CONTRACT: Document response format
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Public API without versioning | 🔴 Blocker |
| Webhook without idempotence | 🟠 Important |
| Inconsistent error format | 🟠 Important |
| Undocumented contract | 🟡 Suggestion |

## Related Rules

- 043 - Backing Services as Resources
- 014 - Dependency Inversion Principle
- 042 - Configurations via Environment
