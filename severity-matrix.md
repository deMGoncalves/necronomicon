# Severity Matrix for Code Review

## Severity Categories

### 🔴 Blocker (Critical)

**Must prevent merge until resolved.**

Criteria:
- Security vulnerabilities (SQL injection, XSS, RCE, etc.)
- Bugs that cause data loss
- Violations that prevent production functionality
- Critical architecture violations that break the system

**Examples:**

| Violation | Rule | Why it's a Blocker |
|----------|------|---------------------|
| `eval()` with user input | 030 | Direct RCE vector |
| Class with 500+ lines | 007 | Impossible to maintain, high bug risk |
| CC > 20 in critical method | 001, 022 | Extremely difficult to debug, many paths |
| Hardcoded credentials | 030, 042 | Secret leakage in repo |
| Stateful process in cloud infra | 045 | Data loss on restart |
| Code duplicated 10+ times | 021 | Unsustainable technical debt |

---

### 🟠 Important (High Priority)

**Should be fixed, but doesn't block merge if justified.**

Criteria:
- Serious SOLID principle violations
- Significant performance issues
- Rapidly growing technical debt
- Violations of established patterns

**Examples:**

| Violation | Rule | Impact |
|----------|------|---------|
| Class 150-300 lines | 007 | Hinders maintenance, should be broken |
| CC 9-12 | 001, 022 | Starting to get hard to understand |
| 4-6 occurrences of duplicated code | 021 | Medium-high risk of bugs on changes |
| God Object (10+ responsibilities) | 010, 025 | Severely violates SRP |
| Relative imports `../../../` | 031 | Breaks architecture, hinders refactor |
| Getters/Setters without logic | 008 | Exposes state, violates encapsulation |
| Promise without error handling | 028 | Can crash process in production |

---

### 🟡 Suggestion (Improvement)

**Nice to have, but not urgent. Consider in future refactorings.**

Criteria:
- Minor style guide violations
- Optimization opportunities
- Small readability improvements
- Slight deviations from patterns

**Examples:**

| Violation | Rule | Improvement |
|----------|------|----------|
| Class 51-100 lines | 007 | Slightly above ideal, but manageable |
| CC 6-8 | 001, 022 | A bit complex, consider simplifying |
| 2-3 occurrences of similar code | 021 | Could be extracted, but not urgent |
| Variable name `usr` | 006 | Could be `user` for clarity |
| Method with 4 parameters | 033 | Consider Parameter Object |
| "What" comment instead of "why" | 026 | Improves documentation |
| Missing tests for edge case | 032 | Increases coverage |

---

## Calibration by PR Type

### 🐛 Bugfix

**Priority: Fix the bug**

- 🔴 **Blocker**: Only if introduces new bugs or vulnerabilities
- 🟠 **Important**: Relax for violations that don't affect the fix
- 🟡 **Suggestion**: Most violations

**Example:**
```
PR: Fix crash on null user
Violation: Method has 8 lines (ideal 5)
Severity: 🟡 Suggestion (doesn't block the bugfix)
```

---

### ✨ Feature

**Priority: Functionality + Quality**

- 🔴 **Blocker**: Security, architecture, serious bugs
- 🟠 **Important**: SOLID, patterns, medium duplication
- 🟡 **Suggestion**: Style, minor optimizations

**Example:**
```
PR: Add user authentication
Violation: Password without hash (plain text)
Severity: 🔴 Blocker (critical security)
```

---

### ♻️ Refactor

**Priority: Quality Improvement**

- 🔴 **Blocker**: Breaks functionality, introduces bugs
- 🟠 **Important**: Doesn't achieve refactor goal
- 🟡 **Suggestion**: Future incremental improvements

**Example:**
```
PR: Refactor UserService to reduce complexity
Violation: CC went from 15 to 12 (goal was ≤5)
Severity: 🟠 Important (didn't achieve goal)
```

---

### 📝 Docs

**Priority: Documentation Clarity**

- 🔴 **Blocker**: Incorrect or dangerous information
- 🟠 **Important**: Rarely applicable
- 🟡 **Suggestion**: Most suggestions

---

### 🔧 Chore/Config

**Priority: Correct Functioning**

- 🔴 **Blocker**: Breaks build, deployment, or security
- 🟠 **Important**: Sub-optimal configuration
- 🟡 **Suggestion**: Organization improvements

---

## Calibration by Business Context

### High Urgency (Production Hotfix)

**Relax severity by 1 level:**
- 🔴 → 🔴 (Keep blockers for security/data)
- 🟠 → 🟡
- 🟡 → Mention only

**Exception:** Never relax for security or data loss.

---

### MVP (Minimum Viable Product)

**Focus on functionality:**
- 🔴 Only for serious bugs and security
- 🟠 For serious architectural violations
- 🟡 For everything else (with notes for future refactor)

**Principle:** Deliver value first, refactor later.

---

### Planned Technical Debt

**If the team is aware and plans to address:**
- Reduce severity by 1 level
- Add TODO or issue tracking
- Document in comment

**Example:**
```
// Before
Violation: God Object with 15 responsibilities
Severity: 🔴 Blocker

// After (with plan)
Violation: God Object with 15 responsibilities
Severity: 🟠 Important
Note: Team plans to refactor in Sprint 2 (Issue #123)
```

---

### Legacy Code Being Migrated

**Be pragmatic:**
- 🔴 Only for regressions or new serious problems
- 🟠 For violations introduced in PR
- 🟡 For pre-existing violations

**Principle:** Don't require complete legacy refactor in each PR.

---

## Special Exceptions

### Junior Team Code Review

- Use 🟡 more frequently
- Explain the "why" with more detail
- Be didactic, not just critical
- Acknowledge successes

---

### Third-Party/Lib Code

- Focus only on integration
- Don't review lib internals (unless customized)
- 🔴 Only if introduces vulnerabilities

---

### Generated Code

- If generated by trusted tool: ignore violations
- If custom template: review normally
- If AI-generated: review with extra attention (subtle bugs)

---

## General Principles

1. **Real Impact > Rigid Rule**
   - Ask: "Does this really cause problems?"
   - Not all violations are equal

2. **Context > Formalism**
   - PR type matters
   - Urgency matters
   - Team size matters

3. **Pragmatism > Perfection**
   - Code "good enough" that delivers value
   - Is better than "perfect" code that never ships

4. **Evolution > Revolution**
   - Gradual improvements are better
   - Than complete rewrites

5. **Education > Blocking**
   - Use 🟡 to teach
   - Reserve 🔴 for real danger

---

## Quick Reference

| ICP | CC | Lines | Default Severity |
|-----|----|----|-------------------|
| ≤3 | ≤5 | ≤50 | 🟢 Excellent |
| 4-6 | 6-8 | 51-150 | 🟡 Suggestion |
| 7-10 | 9-12 | 151-300 | 🟠 Important |
| >10 | 13+ | 300+ | 🔴 Blocker |

**Adjust according to PR context!**

## Version

Severity Matrix v1.0 - March 2026
