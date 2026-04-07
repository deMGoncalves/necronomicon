# IDEA — Future Improvement Suggestion

**Severity:** 🟢 Low | Evaluate later
**Blocks PR:** No

## What It Is

Marks future improvement suggestion or idea that hasn't been validated or prioritized yet. Unlike TODO (confirmed task), IDEA is a proposal to be considered in planning or retrospectives.

## When to Use

- Unconfirmed improvement ("it would be good if...")
- Future exploration (technology to evaluate)
- Potential optimization (may or may not be worth it)
- Informal feature request (developer's idea)

## When NOT to Use

- Confirmed task → use **TODO**
- Necessary optimization → use **OPTIMIZE**
- Identified refactoring → use **REFACTOR**
- Question about approach → use **QUESTION**

## Format

```typescript
// IDEA: improvement suggestion
// IDEA: explore X to solve Y
// IDEA: consider for v2 or next iteration
```

## Example

```typescript
// IDEA: add CSV export support in addition to JSON
// Some users requested it, but not priority now
function exportData(data: any[], format = 'json'): string {
  if (format === 'json') {
    return JSON.stringify(data);
  }
  throw new Error('Format not supported');
}

// IDEA: evaluate Rust/WASM for this heavy computation
// Current benchmark: 500ms for 100k items
// WASM could reduce to ~50ms
function heavyComputation(items: Item[]): number {
  return items.reduce((acc, item) => {
    // Intensive calculation
  }, 0);
}

// IDEA: add skeleton loading instead of spinner
// Better perceived experience on slow connections
function LoadingState() {
  return <Spinner />;
}

// IDEA: migrate to event sourcing when scale requires
// Current: ~1000 events/day - CRUD sufficient
// If exceeds 100k/day, reconsider
async function saveOrder(order: Order) {
  return db.orders.upsert(order);
}

// IDEA: accept array of IDs for batch request
// Today: clients make N requests for N items
// Future: one request with [id1, id2, ...idN]
app.get('/api/items/:id', async (req, res) => {
  const item = await getItem(req.params.id);
  res.json(item);
});

// IDEA: create CLI for scaffolding new modules
// Today: manually copy template folder
// Future: `npm run create-module module-name`

// IDEA: add visual regression testing for components
// Tools to evaluate: Chromatic, Percy, Playwright
function Button({ variant, children }) {
  return <button className={`btn-${variant}`}>{children}</button>;
}
```

## Resolution

- **Timeline:** Backlog / evaluate in planning or retrospective
- **Action:** Register with context, evaluate periodically, promote to TODO if approved, remove if doesn't make sense
- **Converted to:** TODO (if approved) or removed (if discarded)

## Related to

- Rules: [023 - YAGNI](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md) (IDEA ≠ implement now)
- Similar tags: IDEA (not confirmed) vs TODO (confirmed and prioritized)
