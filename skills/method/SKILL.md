---
name: method
description: Convention for implementing class methods — when creating action methods in classes, implementing operations that coordinate behaviors and should return context for chaining
model: sonnet
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Method

Convention for implementing class methods focused on fluency and single responsibility.

---

## When to Use

Use when creating methods that execute actions, operations or coordinate behaviors in classes.

## Purpose

| Responsibility | Description |
|----------------|-------------|
| Business action | Execute operation representing business intention |
| Coordination | Orchestrate calls to other methods or services |
| Event | Respond to DOM or lifecycle events |
| Transformation | Apply data or state transformation |

## Return Rule

| Situation | Recommended Return |
|-----------|-------------------|
| Public method that modifies state | `return this` for fluent interface |
| Method with return value | Specific value type |
| Async method without return | `return this` |
| Async method with return | Specific value type via Promise |
| Event handlers and callbacks | Optional (can be `void`) |

## Return Justification

| Benefit | Description |
|---------|-------------|
| Fluent interface | Enables method call chaining |
| Consistency | Predictable pattern across codebase |
| Composition | Facilitates operation composition |
| Readability | More expressive and declarative code |

## Implementation Patterns

| Pattern | Usage |
|---------|-------|
| Public method | Externally accessible methods |
| Method with Symbol | Private methods or contracts using bracket notation |
| Method with decorator | Methods decorated with event handlers or lifecycle hooks |
| Async method | Methods that execute async operations |

## Associated Decorators

| Decorator | Function |
|-----------|----------|
| on.{event} | Bind method to specific DOM event |
| connected | Execute method when component is connected to DOM |
| disconnected | Execute method when component is disconnected from DOM |
| didPaint | Execute method after complete rendering |
| before | Execute logic before main method |
| after | Execute logic after main method |
| around | Execute logic around main method |

## Nomenclature

| Rule | Description |
|------|-------------|
| Imperative verb | Name should start with verb indicating action |
| Clear intention | Name reveals what method does without comment needed |
| Specific | Avoid generic names that don't express real intention |
| Concise | Short but sufficiently descriptive name |

## Examples

```typescript
// ❌ Bad — method without return (doesn't chain)
class QueryBuilder {
  where(condition: string) {
    this.conditions.push(condition)
    // implicit undefined return
  }
}
const q = new QueryBuilder()
q.where('id = 1')
q.where('status = active')  // separate calls

// ✅ Good — method returns this for chaining
class QueryBuilder {
  where(condition: string): this {
    this.conditions.push(condition)
    return this
  }
}
const q = new QueryBuilder()
  .where('id = 1')
  .where('status = active')  // fluent interface
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Multiple responsibilities | Method should have single responsibility (rule 010) |
| Complex logic | Maximum cyclomatic complexity of 5 (rule 022) |
| Hidden side effects | Side effects should be explicit in name |
| Excessive parameters | Maximum 3 parameters per method (rule 033) |
| Too long method | Maximum 15 lines per method (rule 007) |
| Using else | Use guard clauses instead of else (rule 002) |

## Best Practices

| Practice | Description |
|----------|-------------|
| Return this | Enable fluent interface in state-modifying methods |
| Use Symbol | Encapsulate private methods with bracket notation |
| Descriptive name | Imperative verb revealing clear intention |
| Guard clauses | Use early returns instead of else (rule 002) |
| Extract complexity | Helper methods for complex logic |

## Rationale

- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each method has single responsibility, expressed clearly in name
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): simple and predictable methods with maximum cyclomatic complexity of 5
- [033 - Function Parameter Limit](../../rules/033_limite-parametros-funcao.md): maximum 3 parameters to maintain clarity
- [007 - Maximum Lines per Class](../../rules/007_limite-maximo-linhas-classe.md): methods with maximum 15 lines
- [002 - Prohibition of Else](../../rules/002_proibicao-clausula-else.md): use guard clauses to reduce nesting and complexity
