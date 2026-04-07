# QUESTION — Doubt or Question

**Severity:** 🟢 Low | Resolve in code review
**Blocks PR:** Can be 🟡 Medium if blocking correctness

## What It Is

Marks doubt or question about approach, requirement or implementation decision. Indicates author's uncertainty that needs to be clarified through discussion in code review or sync with team.

## When to Use

- Ambiguous requirement (spec isn't clear)
- Approach choice (which pattern to use?)
- Expected behavior (what to do in this case?)
- Understanding validation (is this correct?)

## When NOT to Use

- Code to be reviewed → use **REVIEW**
- Important information → use **NOTE**
- Identified bug → use **FIXME**
- Pending task → use **TODO**

## Format

```typescript
// QUESTION: the specific question
// QUESTION: question directed to someone
// QUESTION: option A vs option B - which to prefer?
```

## Example

```typescript
// QUESTION: when user cancels, should we keep data in form?
// Spec says "cancel operation" but doesn't specify form state
function handleCancel() {
  closeModal();
  // resetForm() ???
}

// QUESTION: Strategy vs Factory to create payment processors?
// Strategy: more flexible, can switch at runtime
// Factory: simpler, decision at creation time
function createPaymentProcessor(type: string) {
  // Implementation pending decision
}

// QUESTION: what to return when list is empty?
// Options: [], null, throw EmptyListError
// Impacts API contract
function getActiveUsers(): User[] | null {
  const users = db.users.findAll({ active: true });
  if (users.length === 0) {
    return []; // Or null? Or throw?
  }
  return users;
}

// QUESTION: worth optimizing for O(1) lookup or keep simple array?
// Array: 100 items max, O(n) lookup = ~100 comparisons
// Map: creation overhead, O(1) lookup
// Context: called ~10x per request
const config = [
  { key: 'theme', value: 'dark' },
  // ... ~100 items
];

// QUESTION: silent failure or throw on log failure?
// Silent: doesn't interrupt main flow
// Throw: ensures problems are noticed
async function logEvent(event: Event) {
  try {
    await analytics.track(event);
  } catch (error) {
    console.error('Log failed', error);
    // throw error; ???
  }
}

// QUESTION: understood correctly that max discount is 50%?
// Client email said "up to half the value"
// Confirm before deploy
function applyDiscount(price: number, discountPercent: number): number {
  const maxDiscount = 0.5; // 50%
  const safeDiscount = Math.min(discountPercent, maxDiscount);
  return price * (1 - safeDiscount);
}

// QUESTION: CPF validation should accept formatted?
// Ex: "123.456.789-00" vs "12345678900"
// Maria defined original requirements
```

## Resolution

- **Timeline:** Code review or sync with team
- **Action:** Formulate clear question, offer alternatives, direct to right person, discuss, document answer, remove or convert to NOTE
- **Converted to:** NOTE (if decision is important) or removed (after answer)

## Related to

- Rules: [026 - Comments Quality](../../../.claude/rules/026_qualidade-comentarios-porque.md) (QUESTION is temporary communication)
- Similar tags: QUESTION (author's doubt) vs REVIEW (needs external validation)
