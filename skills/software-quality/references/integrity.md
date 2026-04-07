# Integrity — Integridade

**Dimension:** Operation
**Default Severity:** 🔴 Critical (ALWAYS blocker)
**Key Question:** Does it offer security?

## What It Is

The degree to which access to software or data can be controlled and protected. Integrity encompasses protection against attacks, data validation, access control, and protection of sensitive information.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Any security vulnerability | 🔴 Blocker |
| Possible vulnerability (needs analysis) | 🔴 Blocker |
| Security improvement (not vulnerable) | 🟠 Important |

## Violation Example

```javascript
// ❌ Vulnerable - SQL Injection
function getUser(username) {
  return db.query(`SELECT * FROM users WHERE username = '${username}'`);
}

// ✅ Secure - Prepared Statement
function getUser(username) {
  return db.query('SELECT * FROM users WHERE username = ?', [username]);
}
```

## Suggested Codetags

```javascript
// SECURITY: Sanitize input before using in query
// FIXME: SQL injection vulnerability - use prepared statement
// FIXME: API key hardcoded - move to environment variable
```

## Severity Calibration

**ALWAYS 🔴 Blocker** - No exceptions for security vulnerabilities.

| Situation | Action |
|----------|------|
| Any security vulnerability | 🔴 Blocker - do not merge |
| Possible vulnerability (needs analysis) | 🔴 Blocker until confirmed |
| Security improvement (not vulnerable) | 🟠 Important |

## Related Rules

- 030 - Prohibition of Unsafe Functions
- 042 - Configurations via Environment
- 024 - Prohibition of Magic Constants
