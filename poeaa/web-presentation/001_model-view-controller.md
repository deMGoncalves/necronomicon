# Model-View-Controller (MVC)

**Type**: Web Presentation Pattern

---

## Intent and Purpose

Separate interface presentation and user interaction from underlying business logic, dividing the application into three interconnected components: Model (data and logic), View (presentation), and Controller (input management and coordination).

## Also Known As

- Model-View-Presenter (variation)
- Model-View-ViewModel (MVVM - modern variation)
- Separated Presentation

---

## Motivation

User interfaces are notoriously volatile — presentation requirements change frequently (new design, new platform, A/B testing). If presentation logic is mixed with business logic, each visual change requires touching critical business code, increasing bug risk and making independent evolution difficult.

MVC solves this problem by establishing clear separation of responsibilities. The Model encapsulates domain data and business logic, completely independent of how it will be presented. The View is responsible for rendering the visual interface, consuming data from the Model but containing no business logic. The Controller mediates between them: receives user input (clicks, form submissions), invokes operations on the Model, and selects the appropriate View to present results.

For example, in an e-commerce, the ProductModel contains pricing calculation logic and stock validation. ProductView renders HTML displaying the product. ProductController receives HTTP request "GET /product/123", loads the product via Model, and passes it to the View which generates HTML. If tomorrow a JSON API is needed, create a new View (JSONView) without touching Model or Controller. The separation allows independent evolution and reuse.

---

## Applicability

Use MVC when:

- The application has a user interface (web, desktop, mobile) that needs to be decoupled from business logic
- Multiple different views/representations need to be provided for the same data (HTML, JSON, XML, PDF)
- The interface may change frequently (redesigns, new visual features) without affecting business logic
- Different developers work on presentation and business logic independently
- You want testability — Models can be tested without UI, Views can be tested with mock data
- The application is complex enough to justify separation of concerns (not a simple static page)

---

## Structure

```
┌──────────────────────────────────────────────────────────────┐
│                          Browser                             │
│  User clicks button → HTTP Request: POST /checkout          │
└────────────────────────────┬─────────────────────────────────┘
                             │ HTTP
                ┌────────────▼────────────┐
                │      Controller         │
                │  (CheckoutController)   │
                │ ─────────────────────   │
                │ + handleRequest(req)    │
                │ + processCheckout()     │
                │ + selectView(): View    │
                └───────┬────────┬────────┘
                        │        │
                invokes │        │ uses
                        │        │
         ┌──────────────▼──┐  ┌──▼──────────────┐
         │     Model       │  │      View       │
         │  (OrderModel)   │  │ (CheckoutView)  │
         │ ──────────────  │  │ ──────────────  │
         │ + calculateTax()│  │ + render(model) │
         │ + applyDiscount │  │ + toHTML()      │
         │ + validateStock │  │                 │
         └─────────────────┘  └──────────────────┘
                │ notifies (Observer)
                ▼
         ┌─────────────────┐
         │  View (updated) │
         │  Auto-refresh   │
         └─────────────────┘

Flow:
1. User → Controller (input)
2. Controller → Model (business operation)
3. Model → Controller (result)
4. Controller → View (select & pass data)
5. View → User (HTML response)
```

---

## Participants

- **Model**: Encapsulates application data and business logic. Is independent of the user interface. Notifies Views (via Observer) when its state changes.

- **View**: Renders visual presentation of the Model. Reads data from Model but doesn't modify it. There can be multiple Views for the same Model (HTMLView, JSONView).

- **Controller**: Receives user input, interprets it, invokes operations on Model, and selects the appropriate View to present the response.

- **Observer Mechanism** (optional): Allows Model to notify Views of state changes for automatic updating (more common in desktop/mobile UIs than web request-response).

- **Router** (in web context): Maps URLs to specific Controllers (e.g., `/products/:id` → ProductController).

---

## Collaborations

When the user interacts (e.g., clicks "Add to Cart"), the corresponding Controller (CartController) receives the request. It extracts parameters (productId, quantity), invokes business method on Model (cart.addItem(productId, quantity)), which validates stock and calculates totals.

After Model operation, Controller decides which View to use (in web, typically a template). Passes necessary data (cart object) to View, which renders HTML with cart items. The HTML is returned to user as HTTP response.

In desktop applications with Observer, when Model changes, it notifies registered Views which automatically update to reflect new state. In web (request-response), View is rendered once per request.

---

## Consequences

### Advantages

1. **Separation of Concerns**: Business logic (Model) is completely separated from presentation (View) and flow control (Controller).
2. **Model Reusability**: The same Model can be used by multiple Views (web HTML, JSON API, PDF report).
3. **Testability**: Models can be tested in isolation; Views can be tested with mock data; Controllers tested with mock Models.
4. **Maintainability**: UI changes don't affect business logic, and vice versa.
5. **Parallel Development**: Designers work on Views, backend developers on Models, without conflicts.
6. **Presentation Flexibility**: Easy to add new output formats (mobile app, CLI) without changing Model.

### Disadvantages

1. **Additional Complexity**: For simple applications, MVC can be unnecessary overhead.
2. **Learning Curve**: New developers need to understand responsibilities of each layer.
3. **Code Fragmentation**: Logic for a feature is spread across multiple files (Model, View, Controller).
4. **Responsibility Debate**: Where to put formatting logic? Input validation? Can generate endless debates.
5. **Performance Overhead**: Additional layers can add latency (mitigatable with optimizations).

---

## Implementation

### Implementation Considerations

1. **Fat Models, Skinny Controllers**: Keep business logic in Model; Controllers should be thin, only coordinating.

2. **Dumb Views**: Views should contain zero business logic — only presentation and simple rendering loops/conditionals.

3. **Observer vs Request-Response**: In desktop/mobile, implement Observer for notification. In web request-response, skip Observer.

4. **Separation of View Logic**: Use templates (Mustache, Handlebars) or components (React) to keep View logic separated from Controllers.

5. **Routing**: Implement Router that maps URLs/routes to appropriate Controllers (e.g., Rails routes, Express routes).

6. **Dependency Injection**: Inject Models into Controllers to facilitate testing and decoupling.

### Implementation Techniques

1. **Template Engines**: Use engines (EJS, Pug, Razor) for Views — separate HTML from presentation logic.

2. **Front Controller Pattern**: Combine MVC with Front Controller to centralize request handling before distributing to Controllers.

3. **Action Methods**: In Controllers, create methods for each action (index, show, create, update, delete) — RESTful pattern.

4. **View Models/DTOs**: Create intermediate objects (ViewModels) that transform domain Models into structures optimized for Views.

5. **Lazy Loading of Views**: Load Views only when needed to save memory.

6. [**Service Layer**](../domain-logic/004_service-layer.md): Add Service Layer between Controllers and Models for complex application logic (multi-model workflows).

---

## Known Uses

1. **Ruby on Rails**: Classic MVC framework — Models (ActiveRecord), Views (ERB templates), Controllers (ActionController).

2. **ASP.NET MVC**: Microsoft framework implementing MVC for web with C# — Models (POCOs), Views (Razor), Controllers (ControllerBase).

3. **Django (Python)**: Uses MTV (Model-Template-View) which is essentially MVC with different nomenclature.

4. **Spring MVC (Java)**: Java framework for web with annotations (@Controller, @RequestMapping) mapping URLs to methods.

5. **Express.js**: Node.js framework allowing manual MVC structuring (non-opinionated) through routers and middleware.

6. **Smalltalk-80**: Origin of MVC pattern — used for interactive desktop interfaces.

---

## Related Patterns

- [**Page Controller**](002_page-controller.md): Specific type of Controller — one Controller per logical page.
- [**Front Controller**](003_front-controller.md): Centralizes request handling before distributing to specific Controllers.
- [**Template View**](../twelve-factor/012_template-view.md): View implementation strategy using templates.
- [**Application Controller**](054_application-controller.md): Manages navigation flow between views/pages.
- [**GoF Observer**](../../gof/behavioral/007_observer.md): Used for Model to notify Views of changes (desktop/mobile MVC).
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Views can be different strategies to present the same Model.
- [**Service Layer**](../domain-logic/004_service-layer.md): Sits between Controllers and Domain Model for application logic.

### Relation with Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separate MVC responsibilities
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): controller coordinates actions

---

## Business Rules Relationship

- **[010] Single Responsibility Principle**: Each component (M, V, C) has a single, well-defined responsibility.
- **[022] Prioritization of Simplicity and Clarity**: Separation makes each component simpler and easier to understand in isolation.
- **[014] Dependency Inversion Principle**: Controllers and Views depend on Model abstractions, not concrete implementations.
- **[032] Minimum Test Coverage**: Separation facilitates testing — Models can have >85% coverage without UI.

---

**Created on**: 2025-01-10
**Version**: 1.0
