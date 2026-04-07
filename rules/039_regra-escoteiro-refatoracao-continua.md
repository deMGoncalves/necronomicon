# Boy Scout Rule Applied to Continuous Refactoring

**ID**: COMPORTAMENTAL-039
**Severity**: 🟡 Medium
**Category**: Behavioral

---

## What It Is

Obligates the developer to **always leave the code better than found** (*Boy Scout Rule*). Even if a change is small, the developer should take the opportunity to fix small *code smells* near the work location.

## Why It Matters

This principle encourages **continuous and emergent refactoring**, preventing the accumulation of small technical debt. It's the key to maintaining long-term maintainability and reducing the incidence of The Blob Anti-Pattern.

## Objective Criteria

- [ ] Small *code smells* (e.g., bad variable names, missing *guard clause*) found in the change scope must be fixed.
- [ ] Files being modified that violate `ESTRUTURAL-022` (Cyclomatic Complexity > 5) must be refactored to a lower level.
- [ ] The *Pull Request* *diff* must show quality improvements, even if not requested.

## Allowed Exceptions

- **Emergency Changes**: Critical *hotfixes* in production where refactoring risk exceeds immediate quality gain.

## How to Detect

### Manual

Code review: Check if the developer only fixed the bug, or improved surrounding code quality.

### Automatic

*Commit* analysis: Check if refactoring is being done in small doses.

## Related To

- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [025 - Prohibition of The Blob Anti-Pattern](025_proibicao-anti-pattern-the-blob.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
