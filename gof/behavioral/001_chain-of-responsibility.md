# Chain of Responsibility

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request. Chain the receiving objects and pass the request along the chain until an object handles it.

## Also Known As

- Chain of Responsibility

## Motivation

Consider a context-sensitive help system. If a user clicks on a part of the interface, appropriate help should be provided. But help depends on context - it may be specific to a button or more general. The help request is handled by the first object in the chain that can provide help.

The problem is that the object that eventually provides help is not known by the object that initiates the request. A mechanism is needed to decouple the button that initiates the request from the objects that can provide information. Chain of Responsibility provides this by giving multiple objects a chance to handle the request.

## Applicability

Use Chain of Responsibility when:

- More than one object can handle a request and the handler is not known a priori; the handler must be determined automatically
- You want to issue a request to one of several objects without specifying the receiver explicitly
- The set of objects that can handle a request should be specified dynamically
- You want to avoid coupling between sender and receivers
- Request processing should follow a specific but flexible order

## Structure

```
Client
└── Sends request to: Handler

Handler (Interface/Abstract)
├── Composes: Handler successor (next in chain)
├── handleRequest(request)
└── setSuccessor(Handler)

ConcreteHandler1 implements Handler
└── handleRequest(request)
    ├── If can handle
    │   └── Process request
    └── Else
        └── successor.handleRequest(request)

ConcreteHandler2 implements Handler
└── handleRequest(request)
    ├── If can handle
    │   └── Process request
    └── Else
        └── successor.handleRequest(request)
```

## Participants

- **Handler**: Defines interface for handling requests; (optionally) implements link to successor
- **ConcreteHandler**: Handles requests it is responsible for; can access successor; if it can handle request, does so; otherwise forwards to successor
- **Client**: Initiates request to a ConcreteHandler object in the chain

## Collaborations

- When client issues a request, the request propagates along the chain until a ConcreteHandler takes responsibility for handling it

## Consequences

### Advantages

- **Reduced coupling**: Frees an object from knowing which other object handles the request; both receiver and sender have no explicit knowledge of each other
- **Added flexibility in assigning responsibilities**: Adds flexibility in distributing responsibilities among objects; can add or change responsibilities by changing the chain at runtime
- **Receipt isn't guaranteed**: Request may not have an explicit receiver

### Disadvantages

- **Receipt not guaranteed**: There's no guarantee the request will be handled; it may fall off the end of the chain without being handled
- **Difficult to observe characteristics**: May be difficult to observe runtime characteristics due to indirect connections
- **Debugging**: Can be difficult to debug flow through the chain

## Implementation

### Considerations

1. **Implementing the chain of successors**: Two possibilities
   - Define new links (usually in Handler class; but may be in ConcreteHandlers)
   - Use existing links (e.g., Composite parent reference)

2. **Connecting successors**: If there are no existing references, Handler must maintain reference to successor; useful to have default operation in Handler that forwards to successor

3. **Representing requests**: Options vary from hard-coded operations to separate Request object

### Techniques

- **Default Handler**: Have default handler at end of chain for unhandled requests
- **Priority Chain**: Handlers ordered by priority
- **Broadcasting**: Allow multiple handlers to process request
- **Early Exit**: Stop propagation after first handler processes

## Known Uses

- **Event Handling**: Event bubbling in DOM (JavaScript)
- **Logging Frameworks**: Loggers with levels (DEBUG, INFO, WARN, ERROR)
- **Servlet Filters**: Chain of filters in Java Servlets
- **Middleware**: Express.js middleware chain
- **Exception Handling**: Try-catch blocks at multiple levels
- **Authorization**: Permission checking in layers

## Related Patterns

- [**Composite**](008_composite.md): Often applied together; component can be parent's successor
- [**Command**](002_command.md): Chain of Responsibility requests are often Commands
- [**Decorator**](009_decorator.md): Structurally similar but different intents; Decorator adds behavior, Chain handles or passes forward

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each handler one responsibility
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add handlers without modifying existing
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): eliminates complex conditionals

---

**Created on**: 2025-01-11
**Version**: 1.0
