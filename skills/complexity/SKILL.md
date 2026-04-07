---
name: complexity
description: Convention to maintain cyclomatic complexity within the limit CC ≤ 5. Use when writing or refactoring methods that contain control flow logic, nested conditionals or loops — when measuring or reducing the cyclomatic complexity of a method.
model: haiku
allowed-tools: Read, Write, Edit, Glob, Grep
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Complexity

Convention to maintain the cyclomatic complexity (CC) of methods within the maximum limit of 5.

---

## When to Use

Use when writing or refactoring methods that contain control flow structures (`if`, `for`, `while`, `switch`, `catch`, ternary operator `?:`).

## What is Cyclomatic Complexity

CC counts the number of independent paths through the code. Each control structure adds +1 to the total. A method without branches has CC = 1.

→ See [references/cc-counting-rules.md](references/cc-counting-rules.md) for detailed counting rules.

## Limits

| CC | Status | Action |
|----|--------|--------|
| 1–5 | ✅ Within limit | OK |
| 6–7 | ⚠️ Warning | Consider refactoring |
| 8–10 | 🟠 High — refactor | Mandatory (rule 022) |
| > 10 | 🔴 Critical | Urgent refactoring |

→ See [references/refactoring-techniques.md](references/refactoring-techniques.md) for CC reduction techniques.

## Examples

```typescript
// ❌ Bad — CC = 7 (exceeds limit of 5)
function processOrder(order: Order): string {
  if (order.status === 'pending') {         // +1
    if (order.items.length > 0) {           // +1
      if (order.payment === 'card') {       // +1
        if (order.amount > 1000) {         // +1
          return applyDiscount(order)
        } else {                           // +1
          return processPayment(order)
        }
      } else if (order.payment === 'pix') { // +1
        return processPix(order)
      }
    }
  }
  return 'invalid'                          // +1
}

// ✅ Good — CC = 2 per method (guard clauses + extraction)
function processOrder(order: Order): string {
  if (!isValidOrder(order)) return 'invalid'
  return order.payment === 'pix' ? processPix(order) : processCardPayment(order)
}

function processCardPayment(order: Order): string {
  return order.amount > 1000 ? applyDiscount(order) : processPayment(order)
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| CC > 5 in any method | Maximum limit of rule 022 |
| `else` or `else if` | Use guard clauses (rule 002) |
| Block nesting | Maintain single indentation level (rule 001) |
| Method with multiple responsibilities | Extract into focused methods (rule 010) |
| `switch` with more than 3 cases | Replace with function map or polymorphism (rule 011) |

## Rationale

- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): maximum cyclomatic complexity of 5 per method — objective simplicity criterion
- [001 - Single Indentation Level](../../rules/001_nivel-unico-indentacao.md): block nesting directly increases CC, limiting indentation controls complexity
- [002 - Prohibition of ELSE Clause](../../rules/002_proibicao-clausula-else.md): each `else if` adds +1 to CC, guard clauses maintain linear flow
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): methods with high CC indicate concentrated multiple responsibilities
- [007 - Maximum Lines per Class](../../rules/007_limite-maximo-linhas-classe.md): methods with maximum 15 lines naturally limit space for control structures

**Related skills:**
- [`cdd`](../cdd/SKILL.md) — depends: CDD uses CC calculated by this skill in the CC_base component of ICP
