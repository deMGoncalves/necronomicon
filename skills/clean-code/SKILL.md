---
name: clean-code
description: "Clean Code practices (Uncle Bob) for clean and maintainable code. Use when @developer applies rules 021-039, or @reviewer verifies code quality beyond objective metrics."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Clean Code

Reference of Clean Code practices based on Robert C. Martin (*Clean Code: A Handbook of Agile Software Craftsmanship*, 2008) to apply rules 021–039.

---

## When to Use

| Agent | Context |
|-------|---------|
| @developer | When implementing rules 021–039 during coding |
| @reviewer | When verifying quality beyond objective ICP metrics |
| @architect | When evaluating design decisions that impact maintainability |

---

## Reference Structure

| Theme | Rules | Key Question | File |
|-------|-------|--------------|------|
| **Naming** | 006, 034, 035 | Do names reveal intent without comments? | `references/naming.md` |
| **Functions** | 033, 037 | Do functions do one thing with ≤3 params? | `references/functions.md` |
| **Error Handling** | 027, 028 | Domain exceptions instead of null/codes? | `references/error-handling.md` |
| **Code Structure** | 021, 022, 023, 026 | Simple, DRY, no speculation, self-documenting? | `references/code-structure.md` |
| **Immutability** | 029, 036, 038 | Immutable objects, no side effects, CQS? | `references/immutability.md` |
| **Security** | 030, 031, 042 | No eval, path aliases, secrets in env? | `references/security.md` |
| **Testing** | 032 | Coverage ≥85% domain, AAA pattern? | `references/testing.md` |
| **Refactoring** | 039 | Code better than found? | `references/boy-scout-rule.md` |

---

## Quick Smell Detector

| I see in code | Violated rule | Immediate action |
|---------------|---------------|------------------|
| `if (accountList instanceof Set)` | 035 - Misleading names | Rename to `accountSet` |
| `function process(data, shouldLog)` | 037 - Flag arguments | Extract `processAndLog()` and `process()` |
| `return null;` in service | 027 - Error handling | Throw `UserNotFoundError` |
| `eval(userInput)` | 030 - Unsafe functions | Use safe function map |
| `../../../utils/helper` | 031 - Relative imports | Use `@utils/helper` |
| `const strName = 'John'` | 035 - Hungarian notation | Remove `str` prefix |
| Function with 6 parameters | 033 - Long parameter list | Create Parameter Object (DTO) |
| `try { } catch (e) { }` | 027 - Swallowed exception | Rethrow or handle correctly |
| Class with 80 lines | 007 - Max lines | Extract responsibilities |
| `API_KEY = 'sk-123'` hardcoded | 042 - Hardcoded secrets | Move to `process.env.API_KEY` |

---

## Prohibitions (always reject)

### Naming
- ❌ Abbreviated names (e.g., `usr`, `calc`, `mngr`)
- ❌ Hungarian notation (e.g., `strName`, `bIsActive`)
- ❌ Misleading names (e.g., `accountList` for Set)
- ❌ Method names as nouns (e.g., `user()` vs `getUser()`)

### Structure
- ❌ Duplicated code (copy-paste >5 lines)
- ❌ Magic constants (numbers/strings inline without name)
- ❌ Speculative functionality ("for the future")
- ❌ Redundant comments (describe WHAT instead of WHY)

### Functions
- ❌ More than 3 parameters (create DTO)
- ❌ Boolean flags in signature
- ❌ Hybrid Query+Command methods

### Security
- ❌ `eval()` or `new Function()`
- ❌ Relative imports with `../`
- ❌ Hardcoded secrets in code

### Errors
- ❌ `return null` for business failures
- ❌ Empty `catch` or only logs
- ❌ Unhandled Promises

---

## Rationale

| Rule | Title | Severity | Quick Ref |
|------|-------|----------|-----------|
| 021 | Prohibition of Duplication (DRY) | 🔴 | `references/code-structure.md` |
| 022 | Simplicity and Clarity (KISS) | 🟠 | `references/code-structure.md` |
| 023 | No Speculative Functionality (YAGNI) | 🟡 | `references/code-structure.md` |
| 024 | No Magic Constants | 🔴 | `references/code-structure.md` |
| 026 | Comments: Why, not What | 🟡 | `references/code-structure.md` |
| 027 | Domain Exceptions | 🟠 | `references/error-handling.md` |
| 028 | Promise Handling | 🔴 | `references/error-handling.md` |
| 029 | Immutability (Object.freeze) | 🟠 | `references/immutability.md` |
| 030 | No Unsafe Functions | 🔴 | `references/security.md` |
| 031 | No Relative Imports | 🔴 | `references/security.md` |
| 032 | Test Coverage ≥85% | 🔴 | `references/testing.md` |
| 033 | Max 3 Parameters | 🟠 | `references/functions.md` |
| 034 | Consistent Names | 🟠 | `references/naming.md` |
| 035 | No Misleading Names | 🔴 | `references/naming.md` |
| 036 | No Side Effects | 🔴 | `references/immutability.md` |
| 037 | No Flag Arguments | 🟠 | `references/functions.md` |
| 038 | Command-Query Separation (CQS) | 🟠 | `references/immutability.md` |
| 039 | Boy Scout Rule | 🟡 | `references/boy-scout-rule.md` |
| 042 | Secrets in Environment | 🔴 | `references/security.md` |

---

## Application Workflow

```
1. Read relevant reference (e.g., functions.md for rule 033)
2. Identify violations using Quick Smell Detector
3. Apply correction according to reference examples
4. Validate compliance (no detectable smell)
```

**Related skills:**
- [`object-calisthenics`](../object-calisthenics/SKILL.md) — reinforces: OC are practical Clean Code exercises
- [`solid`](../solid/SKILL.md) — reinforces: SOLID is theoretical foundation of Clean Code
- [`anti-patterns`](../anti-patterns/SKILL.md) — complements: anti-patterns are Clean Code violations

---

**Created on**: 2026-04-01
**Version**: 1.0.0
