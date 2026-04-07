---
name: software-quality
description: "McCall Quality Model with 12 factors organized in Operation, Revision and Transition. Use when @reviewer calibrates violation severity, @architect defines acceptance criteria, or @tester plans test coverage."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Software Quality (McCall Model)

The McCall quality model organizes 12 factors in 3 dimensions to assess software excellence: **Operation** (day-to-day use), **Revision** (ease of modification) and **Transition** (movement between environments).

## When to Use

| Agent | Situation | Action |
|-------|-----------|--------|
| @reviewer | Found rule violation | Calibrate severity based on impacted quality factor |
| @architect | Defining acceptance criteria | Specify expected quality scores per factor |
| @tester | Planning tests | Prioritize coverage in critical factors (Correctness, Reliability, Integrity, Testability) |
| @developer | Refactoring code | Improve factors with score < 3.0 |
| @leader | Evaluating PR | Reject PRs that degrade critical factors |

## 12 Factors by Dimension

| Factor | Dimension | Key Question | Severity | File |
|--------|-----------|--------------|----------|------|
| **Correctness** | Operation | Does it do what's expected? | 🔴 Critical | [correctness.md](references/correctness.md) |
| **Reliability** | Operation | Is it accurate? | 🔴 Critical | [reliability.md](references/reliability.md) |
| **Efficiency** | Operation | Is it performant? | 🟠 Important | [efficiency.md](references/efficiency.md) |
| **Integrity** | Operation | Is it secure? | 🔴 Critical | [integrity.md](references/integrity.md) |
| **Usability** | Operation | Is it easy to use? | 🟡 Suggestion | [usability.md](references/usability.md) |
| **Adaptability** | Operation | Is it configurable? | 🟠 Important | [adaptability.md](references/adaptability.md) |
| **Maintainability** | Revision | Is it easy to fix? | 🟠 Important | [maintainability.md](references/maintainability.md) |
| **Flexibility** | Revision | Is it easy to change? | 🟠 Important | [flexibility.md](references/flexibility.md) |
| **Testability** | Revision | Is it testable? | 🔴 Critical | [testability.md](references/testability.md) |
| **Portability** | Transition | Is it portable? | 🟡 Suggestion | [portability.md](references/portability.md) |
| **Reusability** | Transition | Is it reusable? | 🟠 Important | [reusability.md](references/reusability.md) |
| **Interoperability** | Transition | Does it integrate well? | 🟠 Important | [interoperability.md](references/interoperability.md) |

## Which Factor to Evaluate?

| Situation in Code Review | Relevant Factor |
|--------------------------|-----------------|
| Logic bug or untreated edge case | Correctness |
| Promise without `.catch()`, untreated error | Reliability |
| Unnecessary O(n²) loop, N+1 queries | Efficiency |
| SQL injection, XSS, password without hash | **Integrity (ALWAYS 🔴)** |
| Generic error message, no feedback | Usability |
| Hardcoded timeout, text without i18n | Adaptability |
| God class, function > 20 lines, no logs | Maintainability |
| Growing switch, `new Concrete()` in service | Flexibility |
| Internal concrete dependency, singleton | Testability |
| Absolute path, specific shell command | Portability |
| Duplicated code, too specific component | Reusability |
| Proprietary format, API without version | Interoperability |

## Scoring System

**Evaluate each factor from 1 to 5:**

| Score | Meaning | Action |
|-------|---------|--------|
| 5 | Excellent | Maintain |
| 4 | Good | Optional improvements |
| 3 | Adequate | Consider refactoring |
| 2 | Problematic | Refactoring recommended |
| 1 | Critical | Refactoring mandatory |

**Overall Quality Score:**
```
Quality Score = (Σ scores of all 12 factors) / 12

≥ 4.0: 🟢 High Quality
3.0-3.9: 🟡 Acceptable Quality
2.0-2.9: 🟠 Low Quality
< 2.0: 🔴 Critical Quality (urgent refactoring)
```

## Prohibitions

- **NEVER** accept code that violates **Integrity** — ALWAYS 🔴 Blocker
- **NEVER** accept impossible-to-test code (Testability < 2)
- **NEVER** accept code that doesn't do what's expected (Correctness < 3)
- **NEVER** ignore untreated errors (Reliability < 3)

## Rationale

| Quality Factor | Related Rules (main) |
|----------------|---------------------|
| Correctness | 027 (Error Handling), 028 (Async Exceptions), 002 (No Else) |
| Reliability | 027, 028, 036 (Side Effects) |
| Efficiency | 022 (KISS), 001 (Indentation), 055 (Long Method) |
| Integrity | 030 (Insecure Functions), 042 (Config via Env) |
| Usability | 006 (No Abbreviations), 034 (Naming), 026 (Comments) |
| Adaptability | 042 (Config via Env), 024 (Magic Constants), 011 (OCP) |
| Maintainability | 010 (SRP), 007 (Max Lines), 025 (No Blob) |
| Flexibility | 011 (OCP), 014 (DIP), 018 (Acyclic Dependencies) |
| Testability | 014 (DIP), 032 (Test Coverage), 036 (Side Effects) |
| Portability | 042 (Config via Env), 041 (Dependencies) |
| Reusability | 021 (DRY), 003 (Encapsulation), 010 (SRP) |
| Interoperability | 043 (Backing Services), 014 (DIP) |

**Related skills:**
- [`codetags`](../codetags/SKILL.md) — depends: McCall severity (Integrity→FIXME, Efficiency→OPTIMIZE) maps to codetags
- [`cdd`](../cdd/SKILL.md) — complements: CDD quantifies McCall Model's Maintainability and Testability

---

**References:**
- McCall, J.A., Richards, P.K., & Walters, G.F. (1977). "Factors in Software Quality"
- ISO/IEC 25010:2011 - Systems and software Quality Requirements and Evaluation (SQuaRE)

**Created on**: 2026-04-01
**Version**: 1.0
