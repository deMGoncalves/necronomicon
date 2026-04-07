---
description: "Syncs docs/ (arc42, c4, adr, bdd) with implemented code. Works without Spec Flow — useful for legacy code and accumulated Quick fixes."
argument-hint: "[src/path (optional)]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git diff *), Bash(git log *)
---

## Purpose

Runs Phase 4 (Docs Sync) independently, without needing complete workflow.
Useful for legacy code, accumulated Quick fixes or after completed Task.

Recently changed files:
!`git diff --name-only HEAD~1 2>/dev/null | head -20 || echo "(no recent commits)"`

## Instructions

1. **Determine scope**:
   - If `$ARGUMENTS` provided → use that path (ex: `src/user_auth/`)
   - If not → use list above as guide for changed files

2. **Read target code** in `src/` to understand current implementation

3. **Read existing documentation** in `docs/`:
   - `docs/arc42/` — currently documented architecture
   - `docs/c4/` — context, container, component diagrams
   - `docs/adr/` — previous architectural decisions
   - `docs/bdd/` — existing Gherkin features

4. **Compare code vs docs** and identify gaps:
   - New undocumented contexts or containers
   - Behaviors without Gherkin feature
   - Technical decisions without registered ADR

5. **Update** what's needed:
   - `docs/arc42/` — building blocks, runtime views, concepts
   - `docs/c4/` — affected diagrams
   - `docs/bdd/` — Gherkin features if behavior changed
   - `docs/adr/ADR-NNN.md` — create if relevant architectural decision

6. **Display summary**:
   ```
   ✅ Docs synced:
   - arc42/05_building_block_view.md — description
   - adr/ADR-019.md — documented decision
   ```

**Important:** If `docs/` doesn't exist, create directories before syncing.
