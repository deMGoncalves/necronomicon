# Boy Scout Rule Applied to Continuous Refactoring

**ID**: BEHAVIORAL-039
**Severity**: 🟡 Medium
**Category**: Behavioral

---

## What it is

Obliges the developer to **always leave the code better than they found it** (*Boy Scout Rule*). Even if a change is small, the developer should take the opportunity to fix small *code smells* near the work location.

## Why it matters

This principle encourages **continuous and emergent refactoring**, preventing the accumulation of small technical debt. It is key to maintaining long-term maintainability and reducing the incidence of The Blob Anti-Pattern.

## Objective Criteria

- [ ] Small *code smells* (e.g., bad variable names, missing *guard clause*) found in the change scope should be fixed.
- [ ] Files being modified that violate `STRUCTURAL-022` (Cyclomatic Complexity > 5) should be refactored to a lower level.
- [ ] The *Pull Request diff* should show quality improvements, even if unsolicited.

## Allowed Exceptions

- **Emergency Changes**: Critical production *hotfixes* where refactoring risk exceeds immediate quality gain.

## How to Detect

### Manual

Code review: Check if the developer only fixed the bug, or if they improved the quality of surrounding code.

### Automatic

Commit analysis: Check if refactoring is being done in small doses.

## Related to

- [022 - Prioritization of Simplicity and Clarity](002_prioritization-simplicity-clarity.md): reinforces
- [025 - Prohibition of The Blob Anti-Pattern](005_proibicao-anti-pattern-the-blob.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
