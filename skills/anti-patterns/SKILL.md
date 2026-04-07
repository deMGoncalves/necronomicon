---
name: anti-patterns
description: "Catalog of 26 anti-patterns with symptoms and refactorings. Use when @reviewer identifies code smells related to rules 052-070, or @developer wants to understand what to avoid."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

## When to Use

Use anti-patterns when you need to:
- **Identify code smells** in code review by known patterns
- **Understand symptoms** of design problems without deep analysis
- **Suggest refactorings** based on documented patterns
- **Map rules to anti-patterns** (rules 052-070 are anti-patterns)

Specific triggers:
- @reviewer identifies problem but doesn't know how to name it
- @developer asks "what's wrong with this code?"
- Discussion about "bad code" without specific diagnosis
- Need to reference known negative patterns in PR comments

---

## Anti-Patterns Index (26 total)

### 🔴 Critical (Blockers)

| Pattern | Rule | Main Symptom | File |
|---------|------|--------------|------|
| **The Blob** | 025 | Class that does everything — hundreds of lines | [[the-blob.md]] |
| **Spaghetti Code** | 060 | Chaotic control flow — impossible to follow | [[spaghetti-code.md]] |
| **Shared Mutable State** | 070 | Multiple modules mutate same object | [[shared-mutable-state.md]] |
| **Primitive Obsession** | 003 | String/number instead of Value Object | [[primitive-obsession.md]] |

### 🟠 High (Require Justification)

| Pattern | Rule | Main Symptom | File |
|---------|------|--------------|------|
| **Long Method** | 055 | Method with > 20 lines, multiple responsibilities | [[long-method.md]] |
| **Large Class** | 007 | Class with > 300 lines, too many attributes | [[large-class.md]] |
| **Divergent Change** | 054 | One class changes for N different reasons | [[divergent-change.md]] |
| **Shotgun Surgery** | 058 | One change requires N files altered | [[shotgun-surgery.md]] |
| **Lava Flow** | 056 | Dead code, functions never called | [[lava-flow.md]] |
| **Accidental Mutation** | 052 | Function mutates parameter without explicit intent | [[accidental-mutation.md]] |
| **Callback Hell** | 063 | Excessive nesting of async callbacks | [[callback-hell.md]] |
| **Pyramid of Doom** | 066 | Excessive nesting of if/else/loops | [[pyramid-of-doom.md]] |
| **Clever Code** | 062 | "Intelligent" code — sacrificed readability | [[clever-code.md]] |
| **Overengineering** | 064 | Too complex solution for simple problem | [[overengineering.md]] |
| **Cut-and-Paste** | 021 | Code duplicated by copying | [[cut-and-paste-programming.md]] |
| **Golden Hammer** | 068 | Same tool for all problems | [[golden-hammer.md]] |

### 🟡 Medium (Expected Improvements)

| Pattern | Rule | Main Symptom | File |
|---------|------|--------------|------|
| **Feature Envy** | 057 | Method uses data from another class more than its own | [[feature-envy.md]] |
| **Data Clumps** | 053 | Data groups always together without own object | [[data-clumps.md]] |
| **Message Chains** | 005 | `a.getB().getC().getD()` — train wreck | [[message-chains.md]] |
| **Middle Man** | 061 | Class that only delegates, no own value | [[middle-man.md]] |
| **Refused Bequest** | 059 | Subclass refuses inherited methods | [[refused-bequest.md]] |
| **Speculative Generality** | 023 | Code for hypothetical cases | [[speculative-generality.md]] |
| **Poltergeists** | 065 | Short-lived classes, no real state | [[poltergeists.md]] |
| **Boat Anchor** | 067 | Installed dependency but never used | [[boat-anchor.md]] |
| **Premature Optimization** | 069 | Optimization without measuring necessity | [[premature-optimization.md]] |

---

## How to Use in Code Review

### Step 1 — Identify Symptoms

Read the code looking for symptoms in each category:
- **Structural:** Long Method, Large Class, Data Clumps
- **Behavioral:** Feature Envy, Divergent Change, Shotgun Surgery
- **Maintenance:** Lava Flow, Boat Anchor, Speculative Generality

### Step 2 — Name the Pattern

Use the table above to name the pattern:
```markdown
❌ "This code is confusing."
✅ "This code exhibits **Pyramid of Doom** (Rule 066): 4 nesting levels.
   Suggested refactoring: Guard Clauses to linearize flow."
```

### Step 3 — Suggest Refactoring

Each reference file contains:
- ❌ Problematic example
- ✅ Refactored example
- Refactoring strategies (Extract Method, Extract Class, etc.)

---

## Rules → Anti-Patterns Mapping

| Rule | Anti-Pattern | Description |
|------|--------------|-------------|
| 003 | Primitive Obsession | String/number instead of Value Object |
| 005 | Message Chains | Excessive call chaining |
| 007 | Large Class | Class with > 50 lines |
| 021 | Cut-and-Paste Programming | Code duplication |
| 023 | Speculative Generality | Code for hypothetical cases |
| 025 | The Blob | God Object — class that does everything |
| 052 | Accidental Mutation | Accidental mutation of parameters |
| 053 | Data Clumps | Data groups without own object |
| 054 | Divergent Change | One class, N reasons to change |
| 055 | Long Method | Method with > 20 lines |
| 056 | Lava Flow | Dead code, never called |
| 057 | Feature Envy | Method envies data from another class |
| 058 | Shotgun Surgery | One change, N affected files |
| 059 | Refused Bequest | Subclass refuses inheritance |
| 060 | Spaghetti Code | Chaotic control flow |
| 061 | Middle Man | Class that only delegates |
| 062 | Clever Code | "Intelligent" unreadable code |
| 063 | Callback Hell | Nested callbacks (async) |
| 064 | Overengineering | Unnecessary complexity |
| 065 | Poltergeists | Ghost classes, short life |
| 066 | Pyramid of Doom | Excessive nesting (sync) |
| 067 | Boat Anchor | Unused dependency |
| 068 | Golden Hammer | Same tool for everything |
| 069 | Premature Optimization | Optimization without measurement |
| 070 | Shared Mutable State | Shared mutable state |

---

## Prohibitions

- Don't name any bad code as "anti-pattern" without identifying specific pattern
- Don't refactor anti-pattern without understanding context — may introduce another
- Don't use anti-patterns as excuse to rewrite code — refactor incrementally
- Don't focus on low-severity anti-patterns while ignoring critical ones

---

## Rationale

**Origin:**
- **AntiPatterns (1998)** — Brown, Malveau, McCormick, Mowbray
- **Refactoring (1999/2018)** — Martin Fowler (Code Smells)
- **Clean Code (2008)** — Robert C. Martin

**Why naming matters:**
- Common language to discuss design problems
- Negative patterns have documented and tested solutions
- Facilitates code reviews: "this is a Middle Man" communicates more than "confusing code"
- Prevents recurrence: once identified, team recognizes in future code

**Related skills:**
- [`clean-code`](../clean-code/SKILL.md) — complements: anti-patterns are violations of Clean Code practices
- [`codetags`](../codetags/SKILL.md) — depends: anti-pattern violations are annotated with codetags by @reviewer

**References:**
- [AntiPatterns Book (1998)](https://www.oreilly.com/library/view/antipatterns-refactoring-software/0471197130/)
- [Refactoring (Fowler)](https://refactoring.com/)
- [Code Smells Catalog](https://refactoring.guru/refactoring/smells)
