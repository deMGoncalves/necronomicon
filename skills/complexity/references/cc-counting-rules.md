# Cyclomatic Complexity — Counting Rules

## What is CC

Cyclomatic Complexity (CC) = number of independent execution paths in a method.
Formula: CC = E - N + 2 (edges - nodes + 2) or simply: 1 + number of decision points.

## Decision Points (+1 per occurrence)

| Structure | Points | Example |
|-----------|--------|---------|
| `if` | +1 | `if (condition)` |
| `else if` | +1 | `else if (condition)` |
| `for` | +1 | `for (let i = 0; ...)` |
| `for...of` | +1 | `for (const item of list)` |
| `for...in` | +1 | `for (const key in obj)` |
| `while` | +1 | `while (condition)` |
| `do...while` | +1 | `do { ... } while (condition)` |
| `case` in switch | +1 | `case 'value':` |
| `catch` | +1 | `catch (error)` |
| Ternary `?:` | +1 | `a ? b : c` |
| `&&` in condition | +1 | `if (a && b)` |
| `\|\|` in condition | +1 | `if (a \|\| b)` |

## Limit Interpretation

| CC | Status | Action |
|----|--------|--------|
| 1–5 | ✅ Within limit | OK |
| 6–7 | ⚠️ Warning | Consider refactoring |
| 8–10 | 🟠 High — refactor | Mandatory (rule 022) |
| > 10 | 🔴 Critical | Urgent refactoring |

## Counting Example

```typescript
function process(x: number, y: string): string {  // CC = 1 (base)
  if (x > 0) {          // +1 = CC 2
    if (y === 'a') {    // +1 = CC 3
      return 'ok'
    } else if (y === 'b') { // +1 = CC 4
      return 'good'
    }
  } else {              // no extra points
    for (let i = 0; i < x; i++) {  // +1 = CC 5
      if (i % 2 === 0) {           // +1 = CC 6 ← ABOVE LIMIT
        console.log(i)
      }
    }
  }
  return 'default'
}
```
