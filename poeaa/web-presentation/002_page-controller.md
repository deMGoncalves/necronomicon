# Page Controller

**Type**: Web Presentation Pattern

---

## Intent and Purpose

Create an object that handles HTTP requests for a specific page or action of a website, where each logical page has its own dedicated handler that processes input and coordinates response generation.

## Also Known As

- Page Handler
- Action Handler
- Script-per-Page

---

## Motivation

Websites consist of multiple pages, each with its own processing logic (e.g., login page, checkout page, profile page). A fundamental architectural question is: how to organize the code that handles HTTP requests for each page?

Page Controller solves this with the simplest possible approach: create a dedicated controller for each logical page. For example, `LoginController` handles all requests related to login (display form, validate credentials), `CheckoutController` handles checkout, etc. Each controller is responsible for extracting data from the HTTP request, invoking appropriate business logic, and selecting the view to render the response.

The advantage is simplicity and intuitiveness — developers immediately understand that to add a new page, they create a new controller. The mapping between URL and controller is direct (e.g., `/login` → LoginController, `/checkout` → CheckoutController). There are no complex indirection layers. This makes Page Controller ideal for small to medium websites where each page has relatively independent logic. However, if there's much shared logic between pages (authentication, logging, transactions), this logic tends to be duplicated between controllers, leading to the need for Front Controller.

---

## Applicability

Use Page Controller when:

- The web application has a moderate number of pages/actions (tens, not hundreds)
- Each page's logic is relatively independent, with little shared behavior
- The team values simplicity and wants to avoid complex abstractions
- Navigation between pages is direct, without complex multi-step wizard flows
- You're using a traditional MVC framework where controllers per resource are the norm
- There's no need for sophisticated centralized routing logic or request interception

---

## Structure

```
┌──────────────────────────────────────────────────────────────┐
│                     Web Browser (Client)                     │
└────────────────────────────┬─────────────────────────────────┘
                             │ HTTP Requests
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────▼──────────┐ ┌─────▼────────────┐ ┌──▼──────────────┐
│ GET /login         │ │ POST /login      │ │ GET /checkout   │
└─────────┬──────────┘ └─────┬────────────┘ └──┬──────────────┘
          │                  │                  │
          │ routed to        │                  │
          │                  │                  │
┌─────────▼──────────┐ ┌─────▼────────────┐ ┌──▼──────────────┐
│ LoginController    │ │ LoginController  │ │CheckoutController│
│ ───────────────    │ │ ───────────────  │ │───────────────── │
│ + showLoginForm()  │ │ + authenticate() │ │+ showCart()      │
│   - get view       │ │   - validate     │ │  - load items    │
│   - render         │ │   - call service │ │  - calculate $   │
│                    │ │   - redirect     │ │  - render        │
└─────────┬──────────┘ └─────┬────────────┘ └──┬──────────────┘
          │                  │                  │
          │ uses             │                  │
          │                  │                  │
          ▼                  ▼                  ▼
   ┌─────────────┐    ┌─────────────┐   ┌─────────────┐
   │ Model Layer │    │ Model Layer │   │ Model Layer │
   │ (Services)  │    │ (Services)  │   │ (Services)  │
   └─────────────┘    └─────────────┘   └─────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
   ┌─────────────┐    ┌─────────────┐   ┌─────────────┐
   │ View/Template│   │ View/Template│  │ View/Template│
   │ login.html   │   │ dashboard.html│  │ checkout.html│
   └─────────────┘    └─────────────┘   └─────────────┘
```

---

## Participants

- [**Page Controller**](002_page-controller.md) (`LoginController`, `CheckoutController`): Object or class that handles requests for a specific page. Contains methods (action methods) for different operations on the page (GET, POST, etc).

- **Router/Dispatcher**: Component that maps incoming URLs to the appropriate Page Controller. In frameworks, this is route configuration (e.g., Express routes, Rails routes).

- **HTTP Request/Response**: Objects that encapsulate HTTP request data (params, headers, body) and response (status, headers, body).

- **Model/Service Layer**: Business logic invoked by controller to process operations. Controllers delegate actual work to this layer.

- **View/Template**: Responsible for rendering visual response (HTML) using data prepared by controller.

---

## Collaborations

When an HTTP request arrives (e.g., `POST /login`), the Router identifies that it should be handled by LoginController and invokes the appropriate method (`authenticate()`). The controller extracts data from request (username, password from POST form), validates them, and invokes authentication service in Model.

If authentication succeeds, controller creates session, prepares context data (user object), and redirects to dashboard (`redirect("/dashboard")`). If it fails, returns to login page with error message, rendering `login.html` view with error context.

Each request to a different page is handled by a different controller — there's no sophisticated central coordination. Controllers are independent of each other.

---

## Consequences

### Advantages

1. **Simplicity**: Straightforward, easy-to-understand approach — each page has its handler.
2. **Low Learning Curve**: New developers quickly understand where to add code for new page.
3. **Isolation**: Controllers are independent — changes in one rarely affect others.
4. **Easy Debugging**: Request flow is linear — easy to trace from URL → Controller → View.
5. **Clear Structure**: Code organization by page reflects site structure, facilitating codebase navigation.
6. **No Over-Engineering**: Doesn't introduce unnecessary abstractions for small/medium sites.

### Disadvantages

1. **Code Duplication**: Shared logic (auth check, logging, error handling) tends to be duplicated between controllers.
2. **Limited Scalability**: For sites with hundreds of pages, number of controllers becomes unmanageable.
3. **Difficult Global Interception**: Adding behavior that should occur in all requests (e.g., CORS, security headers) requires changing all controllers.
4. **No Sophisticated Routing**: Complex routing logic (e.g., content negotiation, versioning) is difficult to implement consistently.
5. **Reduced Testability of Common Behavior**: Duplicated shared behavior needs to be tested across multiple controllers.

---

## Implementation

### Implementation Considerations

1. **One Controller per Resource**: In REST, create controllers per resource (ProductController, OrderController), not per individual page (avoids class explosion).

2. **Action Methods**: Within each controller, create methods for each action (index, show, create, update, delete) — CRUD pattern.

3. **Base Controller**: Create AbstractController class with common functionalities (render, redirect, error handling) that Page Controllers inherit.

4. **Dependency Injection**: Inject services and repositories into controllers via constructor to facilitate testing.

5. **Convention over Configuration**: Use naming conventions to automatically map URLs (e.g., `/products/show` → ProductController.show()).

6. **GET and POST Separation**: Use different methods for idempotent operations (GET showForm) and mutative (POST submitForm).

### Implementation Techniques

1. **Single Class per Page**: Create one controller class for each logical page with multiple methods for different actions.

2. **Script per Action**: Alternatively, create separate script files for each action (login.php, logout.php) — classic PHP style.

3. **Annotation-Based Routing**: Use annotations to map methods to routes (Spring: `@GetMapping("/login")`, Express decorators).

4. **Middleware Chain**: Implement common behavior (auth, logging) as middleware that executes before controllers.

5. **Helper Methods**: Extract common behavior into private helper methods within controller or in utility class.

6. **RESTful Conventions**: Adopt REST conventions for method and URL naming (index, show, store, update, destroy).

---

## Known Uses

1. **Ruby on Rails**: Classic MVC framework where each resource has a controller with standard action methods (index, show, new, create, edit, update, destroy).

2. **ASP.NET MVC**: Controllers inherit from `ControllerBase` and contain action methods decorated with `[HttpGet]`, `[HttpPost]`, etc.

3. **Spring MVC**: Uses `@Controller` and `@RequestMapping` to define Page Controllers with methods for different HTTP methods.

4. **Laravel (PHP)**: Framework that uses controllers to group related request logic, supporting resource controllers.

5. **Express.js**: Although it allows Front Controller, many applications use routers with dedicated handlers per route (Page Controller style).

6. **Django Views**: Function-based views in Django are essentially Page Controllers — one function per URL pattern.

---

## Related Patterns

- [**Front Controller**](003_front-controller.md): Alternative that centralizes request handling at a single point before dispatch.
- [**Application Controller**](054_application-controller.md): Manages navigation and flow between pages — complements Page Controller.
- [**Template View**](../twelve-factor/012_template-view.md): Page Controllers typically use Template Views to render responses.
- [**Transaction Script**](../domain-logic/001_transaction-script.md): Page Controllers frequently use Transaction Scripts for simple business logic.
- [**Model-View-Controller**](001_model-view-controller.md): Page Controller is a specific implementation of the "C" in MVC.
- [**GoF Command**](../../gof/behavioral/002_command.md): Each action method in Page Controller can be seen as a Command.
- [**Service Layer**](../domain-logic/004_service-layer.md): Page Controllers delegate business logic to Service Layer.

### Relation with Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): controller per page
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add pages without modifying existing ones

---

## Business Rules Relationship

- **[010] Single Responsibility Principle**: Each Page Controller has single responsibility of handling requests for a specific page/resource.
- **[022] Prioritization of Simplicity and Clarity**: Page Controller is the simplest and clearest approach to organize request handling.
- **[021] Prohibition of Logic Duplication**: Requires discipline to extract common code into base classes or helpers.
- **[007] Maximum Lines per Class**: Controllers should remain small, delegating to Services.

---

**Created on**: 2025-01-10
**Version**: 1.0
