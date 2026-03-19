# Decorator

**Classification**: Structural Pattern

---

## Intent and Objective

Attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality, allowing behaviors to be added to individual objects, rather than to an entire class.

## Also Known As

- Wrapper

## Motivation

Sometimes we want to add responsibilities to individual objects, not to an entire class. A graphical toolkit should allow adding properties like borders or scrolling to any user interface component. One way would be inheritance, but this is inflexible: border added statically. Client cannot control how and when to decorate component.

A more flexible approach is to enclose component in another object that adds the border. The enclosing object is decorator, conforming to the interface of the component it decorates. Decorator forwards requests to the component and can perform additional actions. Transparency allows decorating decorator recursively, allowing unlimited number of added responsibilities.

## Applicability

Use the Decorator pattern when:

- Add responsibilities to individual objects dynamically and transparently, without affecting other objects
- For responsibilities that can be withdrawn
- When extension by subclassing is impractical (would cause subclass explosion)
- You need to add functionality to objects at runtime
- You want to combine several behaviors through composition
- You want to add behavior without modifying existing code (OCP)

## Structure

```
Client
└── Uses: Component (Interface)
    └── operation()

Component (Interface)
└── operation()

ConcreteComponent implements Component
└── operation() → base implementation

Decorator implements Component
├── Composes: Component wrappedComponent
└── operation()
    └── Delegates to: wrappedComponent.operation()

ConcreteDecoratorA extends Decorator
└── operation()
    ├── Additional behavior before
    ├── super.operation()
    └── Additional behavior after

ConcreteDecoratorB extends Decorator
├── Additional state: addedState
└── operation()
    ├── Uses addedState
    └── super.operation()
```

## Participants

- **Component**: Defines interface for objects that can have responsibilities added to them dynamically
- **ConcreteComponent**: Defines object to which additional responsibilities can be attached
- [**Decorator**](004_decorator.md): Maintains reference to Component object and defines interface conforming to Component's interface
- **ConcreteDecorator**: Adds responsibilities to the component

## Collaborations

- Decorator forwards requests to its Component object
- Can optionally perform additional operations before/after forwarding

## Consequences

### Advantages

- **More flexibility than static inheritance**: Add/remove responsibilities at runtime
- **Avoids feature-laden classes**: Pay only for functionality used; functionality can be composed from simple pieces
- **Facilitates incremental customization**: Apply decorators progressively
- **Respects Open/Closed Principle**: Extends functionality without modifying existing classes
- **Single Responsibility**: Divides functionality between specialized classes

### Disadvantages

- **Many small objects**: Design can result in many small similar objects, making learning and debugging difficult
- **Object identity**: Decorator and decorated component are not identical; identity tests fail
- **Complexity**: Long chain of decorators can be hard to understand and debug

## Implementation

### Considerations

1. **Conforming interface**: Decorator must conform to interface of component it decorates

2. **Omit abstract Decorator class**: When only one responsibility needs to be added, abstract Decorator is not necessary

3. **Keep Component lightweight**: Component should focus on interface, not store data; otherwise, complexity of decorators increases

4. **Changing skin vs changing guts**: Decorator changes skin (interface); Strategy changes guts (algorithm)

### Techniques

- **Decorator Chain**: Chain multiple decorators
- **Transparent Enclosure**: Decorator is completely transparent to client
- **Semi-transparent Decorator**: Decorator adds methods to interface
- **Immutable Decorators**: Decorators that don't modify state

## Known Uses

- **Java I/O Streams**: `BufferedInputStream`, `DataInputStream` decorate `InputStream`
- **Java Collections**: `UnmodifiableList`, `SynchronizedList` decorate `List`
- **Logging Decorators**: Add logging to components
- **Caching Decorators**: Add cache to repositories or services
- **Transaction Decorators**: Add transactional control
- **Retry/Circuit Breaker**: Add resilience to calls

## Related Patterns

- [**Adapter**](001_adapter.md): Changes interface; Decorator enhances responsibilities
- [**Composite**](003_composite.md): Structurally similar; Decorator adds responsibilities, Composite aggregates
- [**Strategy**](../clean-code/001_strategy.md): Changes object's guts; Decorator changes skin
- [**Proxy**](007_proxy.md): Controls access; Decorator adds functionality
- [**Chain of Responsibility**](013_chain-of-responsibility.md): Decorator can implement chain by forwarding to decorated

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): implements (extension without modification)
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each decorator one responsibility
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): decorator substitutes component
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): depends on abstraction

---

**Created on**: 2025-01-11
**Version**: 1.0
