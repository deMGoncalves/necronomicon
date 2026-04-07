---
description: "Updates current branch with latest changes from remote repository. Works on any branch — main or feature."
allowed-tools: Bash(git branch *), Bash(git fetch *), Bash(git pull *), Bash(git checkout *), Bash(git merge *), Bash(git status)
---

## Purpose

Syncs local branch with remote, properly managing feature branches and main.

Current branch:
!`git branch --show-current`

Current status:
!`git status --short`

## Instructions

1. Save current branch name

2. `git fetch origin` — fetch changes without applying

3. **If on main/master:** `git pull origin main`

4. **If on feature branch:**
   - `git checkout main`
   - `git pull origin main`
   - `git checkout [original-branch]`
   - `git merge main`

5. Confirm with `git status`

**Important:** Adapt `main` or `master` per repository convention.
