---
description: "Workflow progress dashboard: lists features in changes/, completed tasks, current phase and attempt counters per agent."
allowed-tools: Read, Glob, Grep, Bash(ls *)
---

## Purpose

Displays current state of all features in progress, reading `tasks.md` in `changes/`.

Detected features:
!`ls changes/ 2>/dev/null | sort || echo "(no features in progress)"`

Last added rule:
!`ls .claude/rules/ 2>/dev/null | sort | tail -1 || echo "(rules not found)"`

## Instructions

1. **List directories** in `changes/` — if empty, show guidance to use `/start`

2. **For each feature**, read `changes/XXX/tasks.md` and extract:
   - Feature name (from directory)
   - Current phase (`**Current Phase**` in header)
   - Progress: count of `- [x]` (completed) vs `- [ ]` (pending)
   - `<!-- attempts-developer: N -->`
   - `<!-- attempts-tester: N -->`
   - `<!-- attempts-reviewer: N -->`
   - `<!-- mode: Quick|Task|Feature -->`

3. **Display dashboard** in format:

```
══════════════════════════════════════════════
  oh my claude — Workflow Status
  Next available rule ID: [N+1 based on .claude/rules/]
══════════════════════════════════════════════

📋 FEATURES IN PROGRESS
──────────────────────────────────────────────

[001] feature-name  [Feature]
  Phase:      🔬 Phase 1 — Research
  Progress: ██░░░░░░░░  2/6 tasks (33%)
  Agent:    @architect
  Attention:   —

[002] other-task  [Task]
  Phase:      ⚙️  Phase 3 — Code
  Progress: ████░░░░░░  3/6 tasks (50%)
  Attempts: dev=2  tester=1  reviewer=0
  Attention:   ⚠️  2 @developer attempts

──────────────────────────────────────────────
📊 SUMMARY
  Active features:   N
  Completed tasks:  X / Y
  Total progress:   Z%
──────────────────────────────────────────────
```

4. **Attention indicators**:
   - `attempts-developer >= 3` → `⚠️ Re-spec recommended`
   - All `[x]` → `✅ Complete — use /ship to commit`
   - No features → guide to `/start feature-name`

5. **At end**, display next available rule ID:
   - List `.claude/rules/` and identify highest existing number + 1
