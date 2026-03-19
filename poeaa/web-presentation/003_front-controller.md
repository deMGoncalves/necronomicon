# Front Controller

**Type**: Web Presentation Pattern

---

## Intent and Purpose

Centralize all HTTP request handling in a single object that processes common requests (authentication, logging, routing), and then dispatches to specific handlers (commands or page controllers) to process the particular logic of each request.

## Also Known As

- Central Dispatcher
- Request Processor
- Single Entry Point

---

## Motivation

As web applications grow, multiple Page Controllers tend to duplicate common logic: checking authentication, establishing database connections, logging requests, handling errors, validating CSRF tokens, configuring response headers, etc. This duplication violates DRY and makes it difficult to add new global behaviors — you would need to modify all existing controllers.

Front Controller solves this by introducing a single entry point for all requests. Every HTTP request passes first through the Front Controller, which executes common logic (security checks, logging, transaction setup), determines which specific handler should process the request (via routing or command), dispatches to that handler, and then executes post-handler processing (cleanup, response formatting).

For example, a Front Controller can: (1) verify user is authenticated, (2) begin database transaction, (3) parse URL to determine that `ProductController.show(id=123)` should be invoked, (4) call the handler, (5) commit transaction, (6) add security headers to response, (7) log the request. All this infrastructure is written once and applies to all requests, keeping individual handlers clean and focused on specific logic.

---

## Applicability

Use Front Controller when:

- The application has significant behavior that should be executed for all (or most) requests
- You need to centralize routing and dispatching decisions based on complex rules
- Multiple protocols or request formats need to be supported (HTTP, SOAP, GraphQL)
- The application is large enough that code duplication between Page Controllers is a significant problem
- You want to implement cross-cutting concerns (logging, security, transactions) consistently
- The navigation structure is complex and would benefit from centralized routing logic

---

## Structure

```
┌──────────────────────────────────────────────────────────────┐
│                    Client (Browser/API)                      │
│  All HTTP requests: /*, /api/*, /admin/*                     │
└────────────────────────────┬─────────────────────────────────┘
                             │ ALL traffic
                             │
                ┌────────────▼────────────┐
                │   Front Controller      │
                │  (DispatcherServlet)    │
                │ ─────────────────────   │
                │ 1. Authenticate user    │
                │ 2. Begin transaction    │
                │ 3. Parse request        │
                │ 4. Route to handler     │
                │ 5. Dispatch             │
                │ 6. Handle errors        │
                │ 7. Format response      │
                │ 8. Log request          │
                └────────────┬────────────┘
                             │ dispatches to
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────▼──────────┐ ┌─────▼────────────┐ ┌──▼──────────────┐
│ ProductCommand     │ │ LoginCommand     │ │ CheckoutCommand │
│ ───────────────    │ │ ───────────────  │ │───────────────  │
│ + execute(req)     │ │ + execute(req)   │ │ + execute(req)  │
│   - business logic │ │   - auth logic   │ │   - payment     │
│   - return view    │ │   - return redir │ │   - return view │
└────────────────────┘ └──────────────────┘ └─────────────────┘
          │                  │                  │
          │ use              │                  │
          ▼                  ▼                  ▼
   ┌─────────────┐    ┌─────────────┐   ┌─────────────┐
   │ Model/Service│   │ Model/Service│  │ Model/Service│
   └─────────────┘    └─────────────┘   └─────────────┘

Flow:
Request → Front Controller (common processing) →
Dispatch to specific handler → Handler execution →
Return to Front Controller → Response generation
```

---

## Participants

- [**Front Controller**](003_front-controller.md): Single object that receives all HTTP requests. Executes common processing (pre-processing) before dispatch and post-processing after.

- **Router/Dispatcher**: Front Controller component responsible for determining which handler should process each request (based on URL, HTTP method, headers, etc).

- **Command/Handler**: Specific objects that contain logic to process particular types of requests. Can be Command classes (GoF Command pattern) or Page Controller methods.

- **Handler Registry**: Mapping (config or code) of request patterns to handlers. E.g., `/products/*` → ProductCommand.

- **Interceptors/Filters**: Chain of Responsibility of objects that process request before (pre-interceptors) and after (post-interceptors) the main handler.

- **View Resolver**: Component that transforms result returned by handler into concrete response (HTML, JSON, redirect).

---

## Collaborations

When a request arrives (e.g., `GET /products/123`), the Front Controller is invoked first. It executes pre-processing: checks authentication, establishes transaction, parses headers. Then consults the Router which determines, based on the URL, that `ProductCommand` should be invoked.

The Front Controller dispatches to ProductCommand.execute(request), passing request object. The Command executes specific logic (load product), and returns a result (e.g., view name "productDetails" + model data).

Front Controller regains control, executes post-processing (commit transaction, adds CORS headers), invokes View Resolver to transform result into HTTP response, and returns to client. If error occurs at any point, Front Controller captures it and renders appropriate error page.

---

## Consequences

### Advantages

1. **Elimination of Duplication**: Common logic (auth, logging, transactions) is written once in Front Controller.
2. **Centralized Cross-Cutting Concerns**: Security, logging, error handling, CORS — everything in one place.
3. **Sophisticated Routing**: Complex routing logic (content negotiation, versioning, locale) centralized and testable.
4. **Easy to Add Global Behaviors**: Adding new interceptor affects all requests without touching individual handlers.
5. **Infrastructure Testability**: Pre/post-processing can be tested independent of handlers.
6. **Consistency**: Ensures every request goes through the same processing pipeline.

### Disadvantages

1. **Single Point of Failure**: If Front Controller fails, entire application fails. Requires robust implementation.
2. **Additional Complexity**: Adds indirection layer — can be overkill for small applications.
3. **More Difficult Debugging**: Request flow crosses multiple layers (interceptors, dispatcher, handler), making tracing difficult.
4. **Performance Overhead**: Each request passes through all interceptors, even if not necessary for that specific request.
5. **Learning Curve**: Developers need to understand dispatching architecture and chain of responsibility.

---

## Implementation

### Implementation Considerations

1. **Web Server Integration**: In Java, implement as Servlet. In Node, as Express middleware. In Python, as WSGI/ASGI middleware.

2. **Routing Strategy**: Decide between config-based routing (XML, annotations) vs code-based (programmatic route tables).

3. **Command vs Controller**: Handlers can be pure Commands (Command pattern) or Controller methods (hybrid with Page Controller).

4. **Interceptor Chain**: Implement Chain of Responsibility for pre/post-processing. Allow interceptors to be registered dynamically.

5. **Exception Handling**: Front Controller should catch all exceptions and render appropriate error responses (400, 500).

6. **Request/Response Abstraction**: Encapsulate native HTTP objects (ServletRequest, Express req) in abstractions to facilitate testing.

### Implementation Techniques

1. **Dispatcher Servlet Pattern**: Use servlet/middleware that receives all requests and dispatches based on mapping.

2. **URL Pattern Matching**: Use regex or path templates (`/products/:id`) to map URLs to handlers.

3. **Chain of Responsibility**: Implement interceptors/filters as chain where each can process and pass to next or short-circuit.

4. **Command Registry**: Maintain Map of URL patterns to Command classes, allowing dynamic registration.

5. **View Resolver Strategy**: Use Strategy pattern for different view resolvers (JSP, Thymeleaf, JSON API, etc).

6. **Thread-Local Context**: Use thread-local storage to store request context accessible by all handlers.

---

## Known Uses

1. **Spring DispatcherServlet**: Spring MVC's Front Controller that centralizes request handling and dispatches to @Controller beans.

2. **Java Servlet Filters**: Servlet API architecture where FilterChain processes requests before reaching final servlet.

3. **Struts ActionServlet**: Old Java EE framework where ActionServlet was the Front Controller that dispatched to Action classes.

4. **ASP.NET Core Middleware Pipeline**: Every request passes through middleware pipeline before reaching Controller.

5. **Express.js App**: In Node, `app.use()` builds middleware chain that functions as distributed Front Controller.

6. **Django Middleware**: Middleware system that processes requests/responses globally before/after views.

---

## Related Patterns

- [**Page Controller**](002_page-controller.md): Handlers invoked by Front Controller can be Page Controllers.
- [**Application Controller**](054_application-controller.md): Can work with Front Controller to manage navigation flow.
- [**GoF Command**](../../gof/behavioral/002_command.md): Handlers can be implemented as Commands that Front Controller executes.
- [**GoF Chain of Responsibility**](../../gof/behavioral/001_chain-of-responsibility.md): Interceptors/Filters form chain that processes requests.
- [**GoF Template Method**](../../gof/behavioral/010_template-method.md): Front Controller can use Template Method to define processing skeleton.
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): View Resolver and Router can be pluggable Strategies.
- **Intercepting Filter** (J2EE): Related pattern where filters intercept requests before reaching controller.

### Relation with Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): single entry point
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): pluggable handlers

---

## Business Rules Relationship

- **[021] Prohibition of Logic Duplication**: Front Controller eliminates duplication of common logic between handlers.
- **[010] Single Responsibility Principle**: Front Controller has single responsibility of coordinating request processing.
- **[014] Dependency Inversion Principle**: Handlers depend on abstractions (Request, Response), not HTTP details.
- **[030] Prohibition of Unsafe Functions**: Centralized security checks in Front Controller prevent vulnerabilities consistently.

---

**Created on**: 2025-01-10
**Version**: 1.0
