# Chain of Responsibility

**Category:** Behavioral
**Intent:** Avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request, chaining the receiving objects.

---

## When to Use

- Processing pipelines (middleware, HTTP filters)
- When more than one object can handle a request and the handler isn't known a priori
- To implement hierarchical approval systems
- Event handling with multiple cascading listeners

## When NOT to Use

- When creating very long chains without real need (overengineering — rule 064)
- When the request must always be processed by a specific known handler
- When the order of handlers matters but isn't explicit — makes maintenance difficult

## Minimal Structure (TypeScript)

```typescript
abstract class RequestHandler {
  private next: RequestHandler | null = null

  setNext(handler: RequestHandler): RequestHandler {
    this.next = handler
    return handler
  }

  handle(request: number): string | null {
    if (this.next) return this.next.handle(request)
    return null
  }
}

class AuthHandler extends RequestHandler {
  handle(request: number): string | null {
    if (request < 0) return 'Denied: invalid request'
    return super.handle(request)
  }
}

class RateLimitHandler extends RequestHandler {
  handle(request: number): string | null {
    if (request > 100) return 'Denied: rate limit exceeded'
    return super.handle(request)
  }
}
```

## Real Usage Example

```typescript
const chain = new AuthHandler()
chain.setNext(new RateLimitHandler())
chain.handle(50)
```

## Related to

- [command.md](command.md): complements — Command encapsulates request; Chain of Responsibility defines who processes it
- [observer.md](observer.md): complements — Observer notifies all subscribers; Chain stops at first handler that processes
- [rule 002 - Prohibition of ELSE Clause](../../../rules/002_proibicao-clausula-else.md): reinforces — each handler uses guard clause to decide whether to process or pass forward
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — don't create long chains without justification

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
