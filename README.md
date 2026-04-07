# oh my claude

**Author:** Cleber de Moraes Goncalves · [@deMGoncalves](https://github.com/deMGoncalves)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-CLI-blueviolet)](https://code.claude.com)
[![Agents](https://img.shields.io/badge/Agents-5-blue)](#agents)
[![Skills](https://img.shields.io/badge/Skills-35-green)](#skills-35-skills)
[![Rules](https://img.shields.io/badge/Rules-70-orange)](#rules-70-rules)
[![MCPs](https://img.shields.io/badge/MCPs-8-lightgrey)](#mcps)

Personal workflow for AI-assisted development. It's not a framework, not a tool — it's the way I think, write and build software, encoded into agents, rules and skills for [Claude Code](https://code.claude.com).

---

## Setup

### Prerequisites

| Tool                                       | What it's for                    | Installation                                |
| ------------------------------------------ | -------------------------------- | ------------------------------------------- |
| [Claude Code CLI](https://code.claude.com) | Run agents and workflow          | `npm install -g @anthropic-ai/claude-code`  |
| [Bun](https://bun.sh)                      | Runtime + test runner            | `curl -fsSL https://bun.sh/install \| bash` |
| [Biome](https://biomejs.dev)               | Linter + formatter (auto via hook) | already included — runs via `bunx biome`   |
| [GitHub CLI](https://cli.github.com)       | Used by `/audit` and `/ship`     | `brew install gh`                           |
| [jq](https://jqlang.github.io/jq/)         | JSON parsing in hooks            | `brew install jq`                           |

### Configuration

```bash
# 1. Clone the repository
git clone https://github.com/melisource/fury_oh-my-claude
cd fury_oh-my-claude

# 2. Open in Claude Code
claude .
```

Claude Code automatically detects `.claude/` and loads all agents, skills, rules and hooks.

### Required tokens (optional MCPs)

Two MCPs need tokens to work — edit `.mcp.json` with real values:

```bash
# Figma token
# figma.com → Settings → Security → Personal access tokens
FIGMA_TOKEN="your-token-here"

# GitHub token
# github.com → Settings → Developer settings → Personal access tokens → Classic
# Required scopes: repo, workflow
GITHUB_TOKEN="ghp_your-token-here"
```

Replace placeholders in `.mcp.json`:

- `SEU_FIGMA_TOKEN_AQUI` → Figma token
- `SEU_GITHUB_TOKEN_AQUI` → GitHub token

The other 6 MCPs (`cloudflare`, `context7`, `fetch`, `memory`, `puppeteer`, `storybook`) work without additional configuration.

---

## Structure

```
.claude/
├── CLAUDE.md          ← central hub
├── GRAPH.md           ← dependency map (Mermaid)
├── agents/            ← 5 specialized agents
├── skills/            ← 35 skills (code + architecture + quality)
├── rules/             ← 70 architectural rules (001–070)
├── commands/          ← 5 workflow commands
├── hooks/             ← 3 automatic hooks
└── settings.json      ← permissions + hooks

changes/               ← persistent feature context
└── 00X_feature-name/
    ├── PRD.md         ← (Feature only) requirements + business rules
    ├── design.md      ← (Feature only) technical decisions + patterns
    ├── specs.md       ← (Task + Feature) interfaces + acceptance criteria
    └── tasks.md       ← T-001…T-NNN + attempt counters

docs/                  ← synced architectural documentation
├── arc42/             ← 12 architectural sections
├── c4/                ← 4 abstraction levels
├── adr/               ← Architecture Decision Records
└── bdd/               ← Gherkin features in pt-BR
```

---

## Architecture

### Components and connections

```
 ┌──────────────────────────────────────────────────────────────┐
 │                          .claude/                            │
 │                                                              │
 │  ┌──────────────┐  ┌────────────────┐  ┌─────────────────┐   │
 │  │   hooks/     │  │   commands/    │  │    agents/      │   │
 │  │              │  │                │  │                 │   │
 │  │ prompt.sh    │  │  /start        │  │  🔵 @leader     │   │
 │  │ ↳ mode hint  │  │  /status       │  │  🟢 @architect  │   │
 │  │              │  │  /audit        │  │  🟡 @developer  │   │
 │  │ lint.sh      │  │  /docs         │  │  🔴 @tester     │   │
 │  │ ↳ biome fmt  │  │  /ship  /sync  │  │  🟣 @reviewer   │   │
 │  │              │  │                │  │                 │   │
 │  │ loop.sh      │  └────────────────┘  └────────┬────────┘   │
 │  │ ↳ tasks.md   │                               │            │
 │  └──────┬───────┘                               │            │
 │         └───────────────────────────────────────┘            │
 │                              │ load                          │
 │  ┌───────────────────────────▼───────────────────────────┐   │
 │  │   skills/ (35)                    rules/ (70)         │   │
 │  │                                                       │   │
 │  │  cdd · codetags · complexity    001–009 Object Cal.   │   │
 │  │  solid · gof · poeaa            010–014 SOLID         │   │
 │  │  colocation · clean-code · ...  052–070 Anti-Patterns │   │
 │  └───────────────────────────────────────────────────────┘   │
 │                                                              │
 │  ┌───────────────────────────────────────────────────────┐   │
 │  │  .mcp.json — MCPs (8)                                 │   │
 │  │  figma · github · fetch · memory · puppeteer · ...    │   │
 │  └───────────────────────────────────────────────────────┘   │
 └──────────────────────────────────────────────────────────────┘
```

### Task flow

```
  user input
       │
  ┌────▼──────────────────────────────────────────┐
  │ prompt.sh — detects action verb → injects mode │
  └────┬──────────────────────────────────────────┘
       │
  ┌────▼─────────────────────────────────────────────────┐
  │                  🔵 @leader                          │
  │         classifies → Quick / Task / Feature          │
  └────┬─────────────────────┬──────────────┬────────────┘
       │                     │              │
    Quick                  Task          Feature
       │                     │              │
       │              ┌──────▼──────┐  ┌───▼──────────────┐
       │              │ 🟢 @arch    │  │   🟢 @architect   │
       │              │ light specs │  │ PRD+design+specs │
       │              └──────┬──────┘  └───┬──────────────┘
       │                     │             │
       └─────────────────────┴─────────────┘
                             │
                  src/[context]/[container]/[component]/
                             │
  ┌──────────────────────────▼────────────────────────────┐
  │ 🟡 @developer — controller · service · model · repo   │
  └──────────────────────────┬────────────────────────────┘
                  [lint.sh → biome format on each Write]
  ┌──────────────────────────▼────────────────────────────┐
  │ 🔴 @tester — bun test --coverage  ≥ 85% domain        │
  └──────────────────────────┬────────────────────────────┘
  ┌──────────────────────────▼────────────────────────────┐
  │ 🟣 @reviewer — ICP · 70 rules · security              │
  │               educational codetags in code            │
  └────────────┬─────────────────────────┬────────────────┘
               │                         │
         ✅ Approved              ❌ Rejected
               │                    ↩ @developer (up to 3x)
  [loop.sh checks tasks.md · blocks if - [ ] exists]
```

---

## How it works

Every development request goes through `@leader`, which **classifies the request into one of 3 modes before acting**:

### Quick Mode — 🟡 @developer direct

For point changes in ≤ 2 files without new domain entity.

```
"fix typo in UserController"
"remove console.log from src/"
"adjust timeout from 30s to 60s"
    ↓
🟡 @developer → 🔴 @tester → 🟣 @reviewer → Done
```

### Task Mode — light specs + Code

For new interface contract, clear scope, without architectural uncertainty.

```
"add endpoint POST /users/:id/roles"
"integrate SendGrid in registration flow"
    ↓
changes/00X/ + 🟢 @architect specs.md
    ↓
🟡 @developer → 🔴 @tester → 🟣 @reviewer → Done
```

### Feature Mode — Full Spec Flow

For new domain entity, technical uncertainty, broad architectural impact.

```
"implement OAuth2 authentication with Google"
"create billing module with Stripe"
    ↓
Phase 1: 🟢 @architect Research (PRD + design + specs)
Phase 2: 🔵 @leader creates tasks.md
Phase 3: 🟡 @developer → 🔴 @tester → 🟣 @reviewer (loops ≤ 3x)
Phase 4: 🟢 @architect Docs Sync (arc42, c4, adr, bdd)
```

### Feedback loop (Phase 3)

```
🟡 @developer → 🔴 @tester ──(failed ≤3x)──→ 🟡 @developer
                      │
                   (passed)
                      ↓
              🟣 @reviewer ──(rejected ≤3x)──→ 🟡 @developer
                      │                                │
                  (approved)            (attempts-developer ≥ 3)
                      ↓                                ↓
              🔵 @leader finalizes          🔵 @leader → Re-Spec
             (Docs if Feature)         (🟢 @architect revises specs.md)
```

---

## Agents

| Agent        | Model  | Role                                                                         |
| ------------ | ------ | ---------------------------------------------------------------------------- |
| `@leader`    | opus   | Classifies Quick/Task/Feature, orchestrates phases, manages re-spec          |
| `@architect` | opus   | Full Research (PRD+design+specs) or light specs — maintains docs/            |
| `@developer` | sonnet | Implements via specs.md or direct request (Quick)                            |
| `@tester`    | sonnet | Generates and runs tests — `bun test --coverage` — coverage ≥85% domain      |
| `@reviewer`  | opus   | CDD/ICP + 70 rules + security (ApplicationSecurityMCP) — annotates via codetags |

### Anti-goals (what each agent does NOT do)

| Agent        | Does not                                                                     |
| ------------ | ---------------------------------------------------------------------------- |
| `@leader`    | Write code, create tests, do review, create architectural docs              |
| `@architect` | Implement code, run tests, do functional review                              |
| `@developer` | Decide architecture/patterns, create specs, do CDD/ICP review                |
| `@tester`    | Change production code, do architectural review                              |
| `@reviewer`  | Implement code, create tests, sync docs                                      |

---

## Commands

Used directly in Claude Code with `/command-name`:

| Command                             | When to use                                                                  |
| ----------------------------------- | ---------------------------------------------------------------------------- |
| `/start [feature-name]`             | Initializes `changes/00X_name/` with PRD, design, specs and tasks templates  |
| `/status`                           | Dashboard: features in progress, completed tasks, current phase, counters    |
| `/audit [branch\|pr <n>\|src/path]` | Full code review via @reviewer — posts result directly to PRs                |
| `/docs [src/path]`                  | Syncs `docs/` (arc42, c4, adr, bdd) — works without Spec Flow               |
| `/ship`                             | Prepares Conventional Commits commit and pushes to remote                    |
| `/sync`                             | Updates branch with latest changes from remote repository                    |

### Usage example

```bash
# Start a new feature
/start user-authentication

# See what's in progress
/status

# Commit and publish
/ship
```

---

## Automatic hooks

The 3 hooks form an automatic chain — execute without any manual invocation:

```
User types something
    ↓
[1] prompt.sh ← UserPromptSubmit
    Detects if dev task → injects mode hint for @leader

Claude responds, writes/edits files
    ↓
[2] lint.sh ← PostToolUse (Write|Edit|NotebookEdit)
    Auto-formats with biome entire .ts/.tsx/.js/.jsx/.json file

Claude finishes responding
    ↓
[3] loop.sh ← Stop
    Checks tasks.md — blocks if pending tasks exist ( - [ ] )
```

### Details of each hook

**`prompt.sh` — Mode routing**

When user types a request with action verb (`implement`, `create`, `fix`, etc.), the hook injects context into system prompt guiding `@leader` to classify the request before acting:

```bash
# Triggers routing
"create endpoint POST /users"    → hint: Task Mode
"implement OAuth2"               → hint: Feature Mode
"fix typo in controller"         → hint: Quick Mode

# Does NOT trigger (conceptual questions are ignored)
"what is SOLID principle?"
"how does @reviewer work?"
```

**`lint.sh` — Automatic formatting**

Executed after any `Write` or `Edit` on code files. Runs `bunx biome check --write` on newly modified file. Covered extensions: `.ts` `.tsx` `.js` `.jsx` `.json`.

**`loop.sh` — Workflow guardian**

Executes at end of each Claude response. Searches for `changes/*/tasks.md` and checks if unchecked checkboxes exist (`- [ ]`). If found, blocks finalization and returns to `@leader` to continue.

```bash
# Escape hatch — use if workflow gets stuck for any reason:
touch .claude/.loop-skip

# Remove after resolving:
rm .claude/.loop-skip
```

| Event                                       | Hook        | File                      |
| ------------------------------------------- | ----------- | ------------------------- |
| `PostToolUse` — `Write\|Edit\|NotebookEdit` | `lint.sh`   | `.claude/hooks/lint.sh`   |
| `Stop`                                      | `loop.sh`   | `.claude/hooks/loop.sh`   |
| `UserPromptSubmit`                          | `prompt.sh` | `.claude/hooks/prompt.sh` |

---

## Rules (70 rules)

Architectural rules organized by category. Each rule has: definition, objective criteria, exceptions, how to detect (manual + automatic) and bidirectional cross-references.

| Category            | IDs     | Source                       |
| ------------------- | ------- | ---------------------------- |
| Object Calisthenics | 001–009 | Jeff Bay                     |
| SOLID               | 010–014 | Uncle Bob                    |
| Package Principles  | 015–020 | Uncle Bob                    |
| Clean Code          | 021–039 | Clean Code + general practices |
| Twelve-Factor       | 040–051 | 12factor.net                 |
| Anti-Patterns       | 052–070 | Fowler + Brown               |

**Severity:** 🔴 blocks PR · 🟠 requires justification · 🟡 improvement expected

**Next available ID:** `071`

### How to create a new rule

```markdown
# [Rule Title]

**ID**: [CATEGORY-NNN or AP-NN-NNN]
**Severity**: [🔴 Critical | 🟠 High | 🟡 Medium]
**Category**: [Structural | Behavioral | Creational | Infrastructure]

---

## What it is

## Why it matters

## Objective Criteria ← checkboxes

## Allowed Exceptions

## How to Detect ← Manual and Automatic

## Related to ← typed links (reinforces · complements · replaces · depends)

---

**Created on**: YYYY-MM-DD **Version**: 1.0
```

---

## Skills (35 skills)

Skills are knowledge modules that agents load on demand. They follow the **Progressive Disclosure** principle: `SKILL.md` is the lightweight index; details are in `references/`.

| Group               | Skills                                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------------------------ |
| Class structure     | anatomy, constructor, bracket                                                                          |
| Members             | getter, setter, method                                                                                 |
| Behavior            | event, dataflow, render, state                                                                         |
| Data                | enum, token, alphabetical                                                                              |
| Organization        | colocation, revelation, story                                                                          |
| Composition         | mixin, complexity                                                                                      |
| Performance         | big-o                                                                                                  |
| Annotation          | **codetags** (16 documented tags)                                                                      |
| OOP Principles      | **object-calisthenics** (9 rules), **solid** (5 principles), **package-principles** (6 principles)     |
| Code Practices      | **clean-code** (rules 021–039)                                                                         |
| Methodology         | **cdd** (Cognitive-Driven Development — ICP = CC_base + Nesting + Responsibilities + Coupling)         |
| Infrastructure      | **twelve-factor** (12 factors)                                                                         |
| Design Patterns     | **gof** (23 patterns), **poeaa** (51 patterns)                                                         |
| Documentation       | **arc42** (12 sections), **c4model** (4 levels), **adr**, **bdd**                                      |
| Quality             | **software-quality** (McCall Model — 12 factors)                                                       |
| Frontend            | **react** (patterns + 2026 rendering strategies)                                                       |
| Anti-Patterns       | **anti-patterns** (26 cataloged patterns)                                                              |

### Skill template

```yaml
---
name: skill-name
description: "[What it is]. Use when [condition] — [specific triggers]."
model: haiku|sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---
```

Body: `When to Use` → `Content` → `## Examples` (❌/✅) → `Prohibitions` → `Rationale`

---

## Dependency graph

`.claude/GRAPH.md` contains 4 Mermaid diagrams documenting how everything connects:

1. **Rule layers** — OC → SOLID → Package → Clean Code → 12-Factor + Anti-Patterns
2. **Skills → Rules** — which skill covers which rules
3. **Skills → Skills** — interdependencies between skills
4. **Agents → Skills → Rules** — which agent uses what

---

## ICP — Integrated Cognitive Persistence

`@reviewer` measures cognitive load of each method using ICP:

```
ICP = CC_base + Nesting + Responsibilities + Coupling
```

| ICP  | Status         | Action                              |
| ---- | -------------- | ----------------------------------- |
| ≤ 3  | 🟢 Excellent   | Maintain                            |
| 4–6  | 🟡 Acceptable  | Consider refactoring                |
| 7–10 | 🟠 Concerning  | Refactor before new feature         |
| > 10 | 🔴 Critical    | Mandatory refactoring               |

Objective limits that define approved/rejected ICP:

| Metric                               | Limit  | Rule |
| ------------------------------------ | ------ | ---- |
| Cyclomatic Complexity per method     | ≤ 5    | 022  |
| Lines per class                      | ≤ 50   | 007  |
| Lines per method                     | ≤ 15   | 055  |
| Parameters per function              | ≤ 3    | 033  |
| Chaining per line                    | ≤ 1    | 005  |
| Indentation level                    | ≤ 1    | 001  |

---

## Codetags

`@reviewer` annotates violations directly in code with educational tone — explaining why and the path to improve:

```typescript
// FIXME: This class is taking on too many responsibilities — handles both
// authentication and database access. This makes it hard to test each part
// independently. Separating into Repository resolves this.

// TODO: With 5 parameters, it's hard to know what each represents.
// Grouping into UserCreateInput makes the call more expressive and makes
// it easier to add fields in the future.

// XXX: The nested if/else works, but reading is tiring.
// Early returns (guard clauses) linearize the flow.

// FIXME: The query concatenates user input directly, opening space
// for SQL Injection. Prepared statements separate code from data.
```

| Tag             | Severity | Blocks PR?          |
| --------------- | -------- | ------------------- |
| `FIXME`         | Critical | Yes                 |
| `TODO`          | High     | No — should fix     |
| `XXX`           | Medium   | No — improvement    |
| `SECURITY`      | Critical | Yes                 |
| `HACK`          | High     | No                  |
| `OPTIMIZE`      | Medium   | No                  |
| `NOTE` / `INFO` | Low      | No                  |

---

## Technologies

- **Runtime:** Bun
- **Linter/Formatter:** Biome
- **Language:** TypeScript (framework-agnostic)
- **Tests:** `bun test --coverage` (fallback: Vitest)
- **AI:** Claude Code CLI with opus/sonnet models

---

## MCPs

The `.mcp.json` file configures MCP servers available to Claude Code in this project.

### Active MCPs

| MCP            | Package                               | Token          | What it's for                                                                |
| -------------- | ------------------------------------- | -------------- | ---------------------------------------------------------------------------- |
| **cloudflare** | `mcp-remote` → cloudflare docs        | No             | Documentation for Workers, Pages, KV, R2, D1                                 |
| **context7**   | `@upstash/context7-mcp`               | Included       | Semantic lookup of lib docs (React, Tailwind, Radix, etc.)                   |
| **fetch**      | `@modelcontextprotocol/server-fetch`  | No             | Fetches any URL and converts to Markdown — doc research                      |
| **figma**      | `figma-developer-mcp`                 | `FIGMA_TOKEN`  | Reads variables, components and layout from Figma files                      |
| **github**     | `@modelcontextprotocol/server-github` | `GITHUB_TOKEN` | Manages PRs, issues, branches — integrates with `/audit`                     |
| **memory**     | `@modelcontextprotocol/server-memory` | No             | Persistent knowledge graph — stores architectural decisions between sessions |
| **puppeteer**  | `puppeteer-mcp-server`                | No             | Browser automation — screenshots, visual tests                               |
| **storybook**  | `mcp-remote` → localhost:6006         | No             | Access to local Storybook components                                         |

### How each MCP is used

**`fetch`** — Documentation and reference search

Fetches any URL and converts to Markdown. Useful for consulting React, Tailwind, Radix, shadcn/ui, MDN docs directly in session.

**`figma`** — Design system integration

Reads design variables (colors, spacing, typography), inspects components and extracts layout to generate code faithful to design. Requires Figma desktop app open.

```bash
# Configure token:
# figma.com → Settings → Security → Personal access tokens
# Replace SEU_FIGMA_TOKEN_AQUI in .mcp.json
```

**`github`** — PR and issue automation

Creates PRs, comments on issues, lists branch changes, checks CI/CD status. Integrates with `/audit` command to post reviews directly to PRs.

```bash
# Configure token:
# github.com → Settings → Developer settings → Personal access tokens → Classic
# Scopes: repo, workflow
# Replace SEU_GITHUB_TOKEN_AQUI in .mcp.json
```

**`memory`** — Persistent context between sessions

Unlike `context7` (which searches external docs), `memory` stores project-specific knowledge: patterns discovered in codebase, architectural decisions, adopted conventions.

**`puppeteer`** — Browser automation

Screenshots of components in different viewports, visual tests, UI state capture. Used in conjunction with `/audit` for visual analysis.

**`storybook`** — Local components

Queries existing stories and generates component documentation. Requires `bun run storybook` running at `http://localhost:6006`.

---

## Contributing

Contributions are welcome! You can:

- **Open an issue** to report bugs or propose new rules/skills
- **Open a PR** following [CONTRIBUTING.md](CONTRIBUTING.md)
- **Start a discussion** to align before implementing something bigger

Read the [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

---

## License

MIT © [Cleber de Moraes Goncalves](https://github.com/deMGoncalves)

See [LICENSE](LICENSE) file for details.

---

_oh my claude — Personal AI-assisted development workflow and style._
