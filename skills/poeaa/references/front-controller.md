# Front Controller

**Layer:** Web Presentation
**Complexity:** Moderate
**Intent:** A single handler handles all requests for a website, channeling them to a common object before dispatching to individual handlers.

---

## When to Use

- REST APIs with centralized routing
- When common logic (auth, logging, CORS) should be applied to all requests
- Modern web frameworks (Express.js, Fastify) use Front Controller natively
- When you want centralized control over request flow

## When NOT to Use

- Single-page applications with single endpoint (unnecessary overhead)
- When framework already provides Front Controller automatically (avoid duplication — rule 021)

## Minimal Structure (TypeScript)

```typescript
// Front Controller: single entry point
class FrontController {
  private readonly routes = new Map<string, RequestHandler>()
  private readonly middlewares: Middleware[] = []

  use(middleware: Middleware): void {
    this.middlewares.push(middleware)
  }

  register(path: string, handler: RequestHandler): void {
    this.routes.set(path, handler)
  }

  async handle(request: Request, response: Response): Promise<void> {
    // Apply all middlewares
    for (const middleware of this.middlewares) {
      await middleware.process(request, response)
    }

    // Dispatch to correct handler
    const handler = this.routes.get(request.path)
    if (!handler) { response.status(404).send('Not Found'); return }

    await handler.handle(request, response)
  }
}

// Usage
const controller = new FrontController()
controller.use(new AuthMiddleware())
controller.use(new LoggingMiddleware())
controller.register('/users/:id', new UserController())
```

## Related

- [mvc.md](mvc.md): complements — Front Controller is the entry point that forwards requests to MVC Controllers
- [page-controller.md](page-controller.md): complements — Page Controllers are the handlers registered and dispatched by Front Controller
- [application-controller.md](application-controller.md): complements — Application Controller can determine which handler Front Controller should use
- [rule 021 - Prohibition of Logic Duplication](../../../rules/021_proibicao-duplicacao-logica.md): reinforces — centralizes common logic (auth, logging) that would be duplicated in each Page Controller

---

**PoEAA Layer:** Web Presentation
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
