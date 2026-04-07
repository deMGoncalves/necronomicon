# Adaptability — Adaptabilidade

**Dimension:** Operation
**Default Severity:** 🟠 Important
**Key Question:** Is it configurable?

## What It Is

The ease with which software can be modified to meet different user needs, environments, or requirements without source code alteration. Adaptability includes configurability, parameterization, and extensibility via plugins.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Hardcoded credentials/URLs | 🔴 Blocker |
| Client-specific logic hardcoded | 🟠 Important |
| Timeout/retry without configuration | 🟠 Important |
| UI texts without i18n | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not adaptable - fixed values in code
function shouldRetry(attempts) {
  return attempts < 3; // Always 3 attempts
}

// ✅ Adaptable - configurable values
function shouldRetry(attempts) {
  const maxRetries = config.get('MAX_RETRIES', 3);
  return attempts < maxRetries;
}
```

## Suggested Codetags

```javascript
// CONFIG(042): This value should be configurable via environment
// CONFIG(024): Consider feature flag for this functionality
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Hardcoded environment credentials/URLs | 🔴 Blocker |
| Client-specific logic hardcoded | 🟠 Important |
| Timeout/retry without configuration | 🟠 Important |
| UI texts without i18n | 🟡 Suggestion |

## Related Rules

- 042 - Configurations via Environment
- 024 - Prohibition of Magic Constants
- 011 - Open/Closed Principle
