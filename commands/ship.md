---
description: "Prepares changes, creates Conventional Commits commit and pushes to remote. Use after completing Feature, Task or Quick fix."
allowed-tools: Bash(git add *), Bash(git status), Bash(git diff *), Bash(git commit *), Bash(git push *), Bash(git log *)
---

## Purpose

Commits and pushes current changes to remote repository.

Current state:
!`git status --short`

Recent commits (style reference):
!`git log --oneline -5`

## Instructions

1. Run `git status` — confirm files to commit

2. Run `git diff --stat` — understand scope of changes

3. Elaborate commit message following Conventional Commits:

   | Prefix | When to use |
   |---------|-------------|
   | `feat:` | New functionality |
   | `fix:` | Bug fix |
   | `refactor:` | Refactoring without behavior change |
   | `docs:` | Documentation changes |
   | `chore:` | Maintenance, configs, scripts |
   | `test:` | Adding or fixing tests |

4. Prepare files with specific `git add` (avoid `git add -A` with sensitive files)

5. Create commit with HEREDOC:
   ```bash
   git commit -m "$(cat <<'EOF'
   type: concise description in imperative

   Co-Authored-By: deMGoncalves <noreply@github.com>
   EOF
   )"
   ```

6. Push: `git push`

7. Confirm: `git status`

**Do not commit:** `.env` with real values, secrets, hardcoded credentials.
