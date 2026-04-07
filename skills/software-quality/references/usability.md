# Usability — Usabilidade

**Dimension:** Operation
**Default Severity:** 🟡 Suggestion
**Key Question:** Is it easy to use?

## What It Is

The effort required to learn, operate, prepare inputs, and interpret outputs from the software. Usability encompasses interface clarity, understandable error messages, user feedback, and accessibility.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Destructive action without confirmation | 🟠 Important |
| Technical error message exposed | 🟠 Important |
| Missing loading indicator for long operation | 🟡 Suggestion |
| Minor visual inconsistency | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not usable - generic message
try {
  await saveUser(data);
} catch (error) {
  showError('An error occurred'); // What happened? What to do?
}

// ✅ Usable - specific and actionable message
try {
  await saveUser(data);
} catch (error) {
  if (error.code === 'EMAIL_TAKEN') {
    showError('This email is already in use. Try another or log in.');
  } else if (error.code === 'NETWORK_ERROR') {
    showError('No connection. Check your internet and try again.');
  } else {
    showError('Could not save. Try again in a few minutes.');
  }
}
```

## Suggested Codetags

```javascript
// UX(034): Error message should be more specific
// UX: Add visual feedback during loading
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Destructive action without confirmation | 🟠 Important |
| Technical error message exposed | 🟠 Important |
| Missing loading indicator for long operation | 🟡 Suggestion |
| Minor visual inconsistency | 🟡 Suggestion |

## Related Rules

- 006 - Prohibition of Abbreviated Names
- 034 - Consistent Class and Method Names
- 026 - Comment Quality
