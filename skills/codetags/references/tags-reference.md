# Codetags — Tag Index

16 tags organized by severity. Each tag has its own file with complete definition, examples and resolution guidance.

---

## 🔴 Critical — Resolve before commit

| Tag | Meaning | File |
|-----|---------|------|
| `FIXME` | Confirmed bug — immediate correction | [fixme.md](fixme.md) |
| `BUG` | Tracked defect with ticket | [bug.md](bug.md) |
| `SECURITY` | Security vulnerability | [security.md](security.md) |
| `XXX` | Dangerous or extremely fragile code | [xxx.md](xxx.md) |

## 🟠 High — Resolve before merge

| Tag | Meaning | File |
|-----|---------|------|
| `HACK` | Temporary workaround that works but isn't correct | [hack.md](hack.md) |
| `DEPRECATED` | Obsolete code in removal process | [deprecated.md](deprecated.md) |
| `REFACTOR` | Violates design principles — needs restructuring | [refactor.md](refactor.md) |
| `CLEANUP` | Disorganized code — dead code, unused imports | [cleanup.md](cleanup.md) |

## 🟡 Medium — Resolve in sprint

| Tag | Meaning | File |
|-----|---------|------|
| `TODO` | Planned task not yet implemented | [todo.md](todo.md) |
| `OPTIMIZE` | Optimization opportunity (theoretical, no current problem) | [optimize.md](optimize.md) |
| `PERF` | Measured performance bottleneck causing real problem | [perf.md](perf.md) |
| `REVIEW` | Needs specialist review before merge | [review.md](review.md) |

## 🟢 Low — Informative

| Tag | Meaning | File |
|-----|---------|------|
| `NOTE` | High relevance important context | [note.md](note.md) |
| `INFO` | Technical detail or explanatory reference | [info.md](info.md) |
| `IDEA` | Unvalidated suggestion for future exploration | [idea.md](idea.md) |
| `QUESTION` | Doubt or ambiguity needing resolution | [question.md](question.md) |

---

## Important distinctions

| Confused pair | Difference |
|---------------|------------|
| `FIXME` vs `BUG` | FIXME = fix now without ticket; BUG = tracked defect |
| `HACK` vs `REFACTOR` | HACK = works but incorrect; REFACTOR = works but violates design |
| `OPTIMIZE` vs `PERF` | OPTIMIZE = theoretical opportunity; PERF = measured problem |
| `NOTE` vs `INFO` | NOTE = high importance, read before modifying; INFO = optional detail |
| `IDEA` vs `TODO` | IDEA = not validated; TODO = confirmed for implementation |

---

## Marking format

```typescript
// TAG: violation description — necessary action
// TAG: #ticket description when tracked
// SECURITY: potential SQL injection — use prepared statements
```
