# REVIEW — Needs Review

**Severity:** 🟡 Medium | Resolve before merge
**Blocks PR:** Yes (if critical for correctness)

## What It Is

Marks code that needs to be reviewed by another developer, domain specialist or stakeholder. Indicates uncertainty about approach or need for external validation before considering complete.

## When to Use

- Complex business logic (tax rule needing validation)
- Architectural decision (pattern choice to confirm)
- Security code (authentication to be audited)
- Domain unknown by author (area author doesn't master)

## When NOT to Use

- Identified bug → use **FIXME**
- Code to refactor → use **REFACTOR**
- Doubt about approach → use **QUESTION**
- Contextual information → use **NOTE**

## Format

```typescript
// REVIEW: description - what to review specifically
// REVIEW: directed description
// REVIEW: [security|business|architecture] categorized description
```

## Example

```typescript
// REVIEW: ICMS calculation - validate with accounting
// Based on 2023 documentation, may be outdated
function calculateICMS(product: Product, state: string): number {
  const rates = { 'SP': 0.18, 'RJ': 0.20, 'MG': 0.18 };
  return product.price * (rates[state] || 0.17);
}

// REVIEW: rate limiting implementation
// Verify if approach is sufficient against DDoS
const rateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests'
});

// REVIEW: product matching algorithm
// Test with real dataset before deploy
// Edge cases: products without description, very short descriptions
function findSimilarProducts(product: Product, catalog: Product[]) {
  const scores = catalog.map(p => ({
    product: p,
    score: calculateSimilarity(product, p)
  }));
  return scores
    .filter(s => s.score > 0.7)
    .sort((a, b) => b.score - a.score)
    .slice(0, 10);
}

// REVIEW: behavior when user doesn't have permission
// Spec says "deny access" but doesn't specify:
// - Return 403 or 404?
// - Show message or redirect?
// - Log attempt?
function checkAccess(user: User, resource: Resource) {
  if (!user.hasPermission(resource)) {
    throw new ForbiddenError('Access denied');
  }
}
```

## Resolution

- **Timeline:** Before PR (blocker) or before merge (business validation)
- **Action:** Identify reviewer, request review explicitly, await feedback, implement adjustments, remove tag after approval
- **Converted to:** NOTE (if decision is documented) or removed (after approval)

## Related to

- Rules: [032 - Test Coverage](../../../.claude/rules/032_cobertura-teste-minima-qualidade.md) (reviewed code should have tests)
- Similar tags: REVIEW (needs validation) vs QUESTION (author's doubt)
