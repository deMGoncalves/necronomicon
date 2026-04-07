# Portability — Portabilidade

**Dimension:** Transition
**Default Severity:** 🟡 Suggestion
**Key Question:** Can it run in another environment?

## What It Is

The effort required to transfer software from one hardware/software environment to another. High portability means the application can run on different operating systems, browsers, or cloud infrastructures with minimal or no modification.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Hardcoded absolute path | 🟠 Important |
| Vendor lock-in in critical service | 🟠 Important |
| Shell command without fallback | 🟡 Suggestion |
| Hardcoded line ending | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not portable - system-specific path
const configPath = '/home/user/app/config.json';
const tempDir = 'C:\\Users\\Admin\\Temp';

// ✅ Portable - relative paths or via environment
const configPath = path.join(process.cwd(), 'config.json');
const tempDir = process.env.TEMP_DIR || os.tmpdir();
```

## Suggested Codetags

```javascript
// PORTABILITY(042): Absolute path - use environment variable
// PORTABILITY: Linux-specific command - add fallback
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Hardcoded absolute path | 🟠 Important |
| Vendor lock-in in critical service | 🟠 Important |
| Shell command without fallback | 🟡 Suggestion |
| Hardcoded line ending | 🟡 Suggestion |

## Related Rules

- 042 - Configurations via Environment
- 041 - Explicit Declaration of Dependencies
- 024 - Prohibition of Magic Constants
