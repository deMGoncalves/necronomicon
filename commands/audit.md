---
description: "Triggers @reviewer to review branch, PR or src/ path with CDD/ICP + 70 rules + security. Posts comment directly on PRs. Usage: /audit | /audit pr <num> | /audit src/path | /audit <branch> [en|es|pt]"
argument-hint: "[branch | pr <number> | src/context/container/component] [en|es|pt]"
allowed-tools: Bash(git *), Bash(gh *), Read, Grep, Glob
---

## Purpose

Executes complete code review using @reviewer (CDD/ICP, 70 architectural rules, security via ApplicationSecurityMCP). Accepts 4 modes:

| Argument | What it reviews |
|-----------|-------------|
| _(no argument)_ | Diff of current branch vs main |
| `src/context/container/component` | Files of specific vertical slice |
| `pr <number>` | Pull Request on GitHub |
| `<branch-name>` | Diff of specific branch vs main |

Current branch:
!`git branch --show-current`

PR associated with branch:
!`gh pr view --json number,title,url 2>/dev/null | jq -r '"PR #\(.number): \(.title) → \(.url)"' 2>/dev/null || echo "(no associated PR)"`

Changed files (current branch vs main):
!`git diff main...HEAD --name-only 2>/dev/null | head -20 || echo "(no diff detected or outside git repository)"`

---

## Instructions

### Step 0 — Comment Language

Check if `$ARGUMENTS` contains an explicit language code at the end:

| Suffix in `$ARGUMENTS` | Comment Language |
|------------------------|----------------------|
| `en` | English |
| `es` | Spanish |
| `pt` _(or absent)_ | Portuguese _(default)_ |

Examples: `/audit pr 42 es` → comments in Spanish. `/audit feat/login` → Portuguese.

Extract language code and remove it from `$ARGUMENTS` before continuing with following steps.

---

### Step 1 — Detect target based on `$ARGUMENTS`

Analyze `$ARGUMENTS` (already without language suffix):

| Condition | Mode |
|----------|------|
| Empty | **Current Branch** — diff vs main |
| Starts with `src/` | **Path** — specific vertical slice |
| Is a number or starts with `pr ` | **PR** — GitHub Pull Request |
| Any other string | **Branch** — diff of named branch vs main |

---

### Step 2 — Collect context per mode

#### Branch Mode (current or named)

```bash
# Current branch
git diff main...HEAD --name-only

# Specific branch
git diff main...<branch> --name-only

# Full diff for reading
git diff main...HEAD
```

List changed files and get full diff to pass to @reviewer.

Check if there are `.tsx` or `.jsx` files among changed — this activates React patterns analysis.

#### Path Mode (`src/...`)

Read all files within path:

```bash
find <path> -type f \( -name "*.ts" -o -name "*.tsx" \) | sort
```

Read content of each file (controller.ts, service.ts, model.ts, repository.ts, *.test.ts) using `Read`.

Check if there are `.tsx` files among read.

#### PR Mode (`pr <number>` or number)

```bash
# Metadata and PR type
gh pr view <number> --json number,title,body,headRefName,changedFiles,labels

# CI status
gh pr checks <number> 2>/dev/null || echo "(no configured checks)"

# Changed files
gh pr diff <number> --name-only

# Full diff
gh pr diff <number>
```

**Detect PR type** from title or labels:

| Prefix in title / label | Type | Severity tolerance |
|--------------------------|------|--------------------------|
| `fix:`, `bugfix`, `hotfix` | 🐛 Fix | **High** — fix comes first |
| `feat:`, `feature` | ✨ Feature | **Medium** — quality matters but doesn't block MVP |
| `refactor:`, `refact` | ♻️ Refactoring | **Low** — should improve quality |
| `docs:`, `doc` | 📝 Documentation | **Very high** — technical rigor doesn't apply |
| `chore:`, `ci:`, `build:` | 🔧 Infrastructure | **High** — limited impact |
| `style:`, `ui:` | 🎨 Visual/UI | **High** — experience trade-offs |
| _(no prefix detected)_ | ❓ Unknown | **Medium** |

Check if there are `.tsx` or `.jsx` files among changed.

---

### Step 3 — Load analysis skills

Before triggering @reviewer, read following files to load analysis methodologies:

```
.claude/skills/cdd/SKILL.md               → ICP methodology (CC_base + nesting + responsibilities + coupling)
.claude/skills/software-quality/SKILL.md  → severity calibration via McCall (12 quality factors)
.claude/skills/anti-patterns/SKILL.md     → catalog of 26 anti-patterns for diff identification
```

> **Why read explicitly:** skills are only auto-injected in subagents via Task. In role-switching
> pattern used by commands, files need to be read before analysis.

---

### Step 4 — Trigger @reviewer

Assemble complete context and pass to @reviewer with instructions below. Adapt instructions per mode and what was collected.

---

> **@reviewer**: Perform complete code review of code below.
>
> **Language:** Write all comments in **[LANGUAGE DETECTED IN STEP 0]**.
>
> ---
>
> **Business context:**
> - Type of change: **[DETECTED TYPE]** — severity tolerance **[HIGH/MEDIUM/LOW]**
> - CI status: **[RESULT FROM gh pr checks OR "not available"]**
> - Files with React (.tsx/.jsx): **[YES/NO]**
>
> **How to calibrate severity:**
>
> Calibration should consider **real business impact**, not just isolated technical violation.
>
> - In a **bug fix**, prioritize fix correctness — style violations are not blocking
> - In a **feature**, balance between quality and delivery — don't block for details
> - In a **refactoring**, be more rigorous — declared goal is to improve quality
> - **Never use 🔴 for line limits (50 vs 51)** — reserve for real bugs, security and serious maintainability issues (>300 lines, critical logic without test)
> - Acknowledge evolution: if code improved from previous state, say so
>
> **How to analyze:**
> - Measure cognitive complexity of each method via ICP (CC + nesting + responsibilities + coupling)
> - Verify compliance with architectural rules prioritizing impact on maintainability, security and correctness
> - Use ApplicationSecurityMCP to detect security vulnerabilities
> - If React files: verify `useEffect` deps, prop drilling, effect cleanup, component size
>
> **Comment tone and format — CRITICAL:**
>
> You are a **development colleague**, not an auditor. Goal is to help developer grow, not score errors.
>
> **What to NEVER do:**
> - Use markdown headers (`##`, `###`) in PR comments
> - Create structured reports with sections like "Context", "Problem 1:", "Positive Points"
> - Transform comment into numbered bullets list formal
> - Mention methodology names (CDD, ICP, McCall, SOLID) in text to developer
> - Use same sentence beginning in all comments
>
> **What to ALWAYS do:**
> - Write as if messaging a colleague — natural, direct, friendly
> - Vary beginnings: "I saw that...", "One thing...", "Attention here...", "Good there with...", "Can work but..."
> - Explain WHY of problem — not just what's wrong, but impact it causes
> - Show path to improve with code example when helps understanding
> - Acknowledge what's good — goal is growth, not just criticism
> - Apply **Slack Test**: before formatting comment, ask "would I send this to colleague on Slack?" — if no, rewrite
>
> **Context of this review:** you're analyzing PR diff on GitHub — **do not edit local files nor insert codetags in code**. Codetags are @reviewer's responsibility in local code reviews. Here, output is exclusively natural language comments posted on PR.
>
> **Never mention internal config files, rule IDs as paths or skill names.**
>
> ---
>
> Produce a **final report in natural language** (not structured with headers), organized by impact — from most critical to least urgent — with clear encouraging verdict at end.

---

### Step 5 — Report and post-review action

After @reviewer concludes:

1. **Display report** in natural language:
   - Start with what's good (if applicable)
   - Group findings by theme and real impact, not just severity
   - For each point, explain why it matters for code, tests or business
   - End with clear encouraging verdict

   **Example:**
   > "Code is well organized and structure is correct.
   > Found a security point needing attention before proceeding,
   > and two quality points that will ease future maintenance."

2. **If PR mode**, ask user:

   > Want to post comment on PR?
   > - `yes` — post as general comment
   > - `no` — keep only here

   If `yes`, execute:

   ```bash
   gh pr review <number> --comment -b "<report text>"
   ```

**Important:** Never post review on PR without explicit user confirmation.
