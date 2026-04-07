---
name: codetags
description: Convention for code marking with standardized comment tags. Use when @reviewer identifies violations in code and needs to annotate them with standardized markers, when registering technical debt, bugs or pending optimizations with traceability.
model: sonnet
allowed-tools: Read, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Codetags

Convention for code marking with standardized comment tags to manage technical debt, facilitate searches and maintain traceability of problems directly in source code.

---

## When to Use

Use when the reviewer identifies violations in code and needs to annotate sections with standardized markers, or when you want to manually mark sections that need future attention.

## Principle

| Principle | Description |
|-----------|-------------|
| Teach | Each marking explains the why of the problem and the path to improve |
| Easy search | Standardized tags allow global search by problem type |
| Clear action | Each tag indicates the type of action needed |
| Partner tone | Write as a colleague teaching, not as an audit system |

→ See [references/tags-reference.md](references/tags-reference.md) — index of 16 tags organized by severity (🔴🟠🟡🟢), with link to individual file for each tag.

## Marking Format

```typescript
// TAG(rule-id): description
```

→ See [references/reviewer-mapping.md](references/reviewer-mapping.md) for severity to tag mapping.

## Application Rules

| Rule | Description |
|------|-------------|
| One tag per violation | Each violation receives exactly one marking |
| Line above | Tag is inserted on line immediately above violated section |
| No duplication | If tag already exists on section, update instead of adding new |
| Explain impact | Describe what can go wrong because of the problem — not just the symptom |
| Concise description | Maximum one line with problem and suggested fix |

## Examples

```typescript
// ❌ Bad — free comment, vague, teaches nothing
// TODO: fix this later
// fix: validation doesn't work
function calculateDiscount(amount: number) {
  return amount * 0.1  // this is wrong
}

// ✅ Good — codetag that explains why and guides improvement
// TODO: This function accepts any number, including negatives and zero.
// This can cause incorrect discounts in edge cases. Adding validation
// at the start ensures calculation only happens with valid data.
//
// FIXME: The value 0.1 doesn't communicate what it represents. Extract to
// a named constant (e.g., DEFAULT_DISCOUNT_RATE) makes code more readable
// and makes it easier to adjust rate in future without hunting for number in code.
function calculateDiscount(amount: number) {
  return amount * 0.1
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Tags without description | Empty tag doesn't communicate problem |
| Multiple tags on same section | Choose most relevant tag for main violation |
| Codetag without why explanation | A comment that doesn't teach doesn't help dev grow |
| FIXME for minor problems | Reserve FIXME for real critical violations |
| TODO without clear action | Description should indicate what needs to be done |

## Application Flow

| Step | Action |
|------|--------|
| 1 | Receive reviewer report or identify violation |
| 2 | Locate exact line of violation in file |
| 3 | Select appropriate tag according to severity mapping |
| 4 | Insert comment on line above section with standardized format |
| 5 | Verify there's no duplicate tag on same section |

## Rationale

- [026 - Comment Quality](../../rules/026_qualidade-comentarios-porque.md): tags explain why of marking, not what code does
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): clear markings facilitate technical debt identification
- [039 - Boy Scout Rule](../../rules/039_regra-escoteiro-refatoracao-continua.md): tags guide continuous refactoring indicating where to improve
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each tag has clear communication responsibility
- [024 - Prohibition of Magic Constants](../../rules/024_proibicao-constantes-magicas.md): standardized tags eliminate ad-hoc markings without pattern

**Related skills:**
- [`software-quality`](../software-quality/SKILL.md) — complements: McCall factors determine codetag severity (Integrity → FIXME, Efficiency → OPTIMIZE)
- [`anti-patterns`](../anti-patterns/SKILL.md) — reinforces: codetags are the mechanism to annotate anti-pattern violations
