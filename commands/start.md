---
description: "Initializes new Feature or Task creating changes/00X_name/ with PRD, design, specs and tasks templates. Usage: /start feature-name"
argument-hint: "[feature-name]"
allowed-tools: Read, Write, Glob, Bash(ls *)
---

## Purpose

Creates directory structure for new Feature or Task in oh my claude workflow.
Argument defines feature name: `/start user-authentication`

Features in progress:
!`ls changes/ 2>/dev/null | sort || echo "(none yet)"`

## Instructions

1. **Read argument** `$ARGUMENTS` as feature name. If empty, ask user.

2. **Determine next available number** in `changes/`:
   - List existing directories and identify highest number
   - If none exist, start at `001`
   - Increment (zero-padded to 3 digits): `001`, `002`, `003`…

3. **Normalize name**: lowercase, spaces → hyphens, no special chars

4. **Create** `changes/00X_normalized-name/` (and `changes/` if doesn't exist)

5. **Create files** per mode:
   - **Feature** → PRD.md + design.md + specs.md + tasks.md
   - **Task** → specs.md + tasks.md only

6. **File contents:**

### PRD.md (Feature only)
```markdown
# PRD — [Feature Name]

**Feature**: [name]
**ID**: [00X]
**Date**: [YYYY-MM-DD]
**Status**: 🟡 In Research

---

## Objective

> Describe the problem this feature solves and value it delivers.

## Functional Requirements

- [ ] FR-01:

## Non-Functional Requirements

- [ ] NFR-01:

## Business Rules

- BR-01:

## Acceptance Criteria

- [ ] AC-01:

## Out of Scope

-
```

### design.md (Feature only)
```markdown
# Technical Design — [Feature Name]

**Feature**: [name]
**ID**: [00X]

---

## Architectural Decisions

| Pattern | Justification |
|---------|---------------|
|         |               |

## Data Flow

[Input] → [Processing] → [Output]

## Main Interfaces

```typescript
// main interfaces
```

## Dependencies

| Module | Reason |
|--------|-------|
|        |       |
```

### specs.md (Feature + Task)
```markdown
# Specs — [Feature/Task Name]

**Feature**: [name]
**ID**: [00X]

---

## Context

[1-2 lines]

## Interfaces and Types

```typescript
// interfaces, types, schemas
```

## API Contracts

| Method | Route | Input | Output |
|--------|------|---------|-------|
|        |      |         |       |

## Acceptance Criteria

- [ ] AC-01: happy path
- [ ] AC-02: validation error
- [ ] AC-03: edge cases
```

### tasks.md (Feature + Task)
```markdown
# Tasks — [Feature/Task Name]

**Feature**: [name]
**ID**: [00X]
**Current Phase**: 🔬 Phase 1 — Research

---

## Progress

| Phase | Status | Agent |
|------|--------|--------|
| 1. Research | 🟡 Pending | @architect |
| 2. Spec | ⬜ Waiting | @leader |
| 3. Code | ⬜ Waiting | @developer → @tester → @reviewer |
| 4. Docs | ⬜ Waiting | @architect |

---

## Tasks

- [ ] T-001: Create PRD + design + specs (@architect)
- [ ] T-002: Detail implementation tasks (@leader)
- [ ] T-003: Implement code following specs.md (@developer)
- [ ] T-004: Write and run tests — ≥85% coverage (@tester)
- [ ] T-005: Code review CDD + 70 rules (@reviewer)
- [ ] T-006: Sync docs/ — arc42, c4, adr, bdd (@architect)

---

## Iteration Log

| Iteration | Phase | Agent | Result |
|----------|------|--------|-----------|
| #1       |      |        |           |

<!-- mode: Feature -->
<!-- attempts-developer: 0 -->
<!-- attempts-tester: 0 -->
<!-- attempts-reviewer: 0 -->
```

7. **Display result**:
   ```
   ✅ Feature initialized: changes/00X_name/
   Next step: @leader, start workflow for changes/00X_name/
   ```
