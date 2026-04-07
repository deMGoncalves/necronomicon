---
name: big-o
description: Convention for Big-O algorithmic complexity analysis. Use when evaluating performance of methods that iterate over collections, perform searches, combine nested loops, or execute recursive operations — when optimizing algorithms with complexity above O(n).
model: haiku
allowed-tools: Read, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Big-O

Convention for algorithmic complexity analysis to identify and classify method performance according to Big-O notation.

---

## When to Use

Use when evaluating methods that iterate over collections, perform searches, combine nested loops, or execute recursive operations.

## Classification

| Notation | Name | Severity |
|---------|------|------------|
| O(1) | Constant | Ideal |
| O(log n) | Logarithmic | Ideal |
| O(n) | Linear | Acceptable |
| O(n log n) | Log-linear | Acceptable |
| O(n^2) | Quadratic | Warning |
| O(n^3) | Polynomial | Critical |
| O(2^n) | Exponential | Critical |
| O(n!) | Factorial | Critical |

## Detection by Structure

| Code Structure | Big-O | Pattern |
|---------------------|-------|--------|
| Direct access by index or key | O(1) | `map.get(key)`, `array[i]`, `object.prop` |
| Binary search or division by half | O(log n) | `while (low <= high) { mid = ... }` |
| Simple loop over collection | O(n) | `for`, `for...of`, `forEach`, `map`, `filter`, `reduce` |
| Native sort or merge sort | O(n log n) | `array.sort()`, `Array.from().sort()` |
| Loop within loop on same collection | O(n^2) | `for { for }`, `forEach { filter }`, `map { find }` |
| Triple nesting on same collection | O(n^3) | `for { for { for } }` |
| Recursion that doubles each call | O(2^n) | `f(n) = f(n-1) + f(n-2)` without memoization |
| Complete permutations or combinations | O(n!) | Generate all permutations of a set |

## Limits

| Big-O | Limit | Action |
|-------|--------|------|
| O(1), O(log n) | Ideal | No action necessary |
| O(n), O(n log n) | Acceptable | No action necessary |
| O(n^2) | Warning | Evaluate if linear alternative exists — annotate with OPTIMIZE if n can grow |
| O(n^3) | Critical | Mandatory refactoring — annotate with FIXME |
| O(2^n) | Critical | Mandatory refactoring — apply memoization or dynamic programming |
| O(n!) | Critical | Mandatory refactoring — replace with heuristic or limit input |

## Refactoring Techniques

| From | To | Technique |
|----|------|---------|
| O(n^2) with internal search | O(n) | Replace inner loop with Map/Set for O(1) lookup |
| O(n^2) with pair comparison | O(n log n) | Sort first and use binary search |
| O(n^2) with filter inside loop | O(n) | Pre-compute Set with filtered values |
| O(2^n) recursion without cache | O(n) | Apply memoization or dynamic programming |
| O(n) multiple passes | O(n) single pass | Combine operations in single iteration |

## Common Combinations

| Code | Resulting Big-O |
|--------|------------------|
| `array.filter().map()` | O(n) — two linear passes = O(2n) = O(n) |
| `array.sort().filter()` | O(n log n) — sort dominates |
| `array.map(x => other.find())` | O(n * m) — quadratic if n ≈ m |
| `array.map(x => other.includes())` | O(n * m) — quadratic if n ≈ m |
| `array.forEach(x => set.has())` | O(n) — Set.has is O(1) |

## Examples

```typescript
// ❌ Bad — O(n²) find duplicates with nested loop
function findDuplicates(items: string[]): string[] {
  const duplicates: string[] = []
  for (let i = 0; i < items.length; i++) {      // O(n)
    for (let j = i + 1; j < items.length; j++) { // O(n)
      if (items[i] === items[j]) duplicates.push(items[i])
    }
  }
  return duplicates
}

// ✅ Good — O(n) using Set
function findDuplicates(items: string[]): string[] {
  const seen = new Set<string>()
  const duplicates = new Set<string>()
  for (const item of items) {  // O(n)
    if (seen.has(item)) duplicates.add(item)  // O(1) lookup
    else seen.add(item)
  }
  return [...duplicates]
}
```

## Prohibitions

| What to avoid | Reason |
|--------------|-------|
| Nested loop without justification in collections that can grow | O(n^2) or worse degrades quickly |
| `find`/`includes`/`indexOf` inside `map`/`forEach`/`filter` | Creates hidden O(n^2) |
| Recursion without memoization in problems with repeated subproblems | O(2^n) when O(n) is possible |
| Multiple consecutive `sort()` on same collection | Each sort is unnecessary O(n log n) |
| `Array.from(set).filter()` when `set.has()` solves | Transforms O(1) lookup into O(n) scan |

## Rationale

- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): high algorithmic complexity obscures intent and reduces clarity
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): nested loops indicate multiple responsibilities in same method
- [007 - Maximum Lines per Class](../../rules/007_limite-maximo-linhas-classe.md): complex algorithms tend to exceed line limits
- [001 - Single Level of Indentation](../../rules/001_nivel-unico-indentacao.md): nested loops directly violate indentation restriction
- [039 - Boy Scout Rule](../../rules/039_regra-escoteiro-refatoracao-continua.md): identifying and improving performance is part of continuous refactoring
