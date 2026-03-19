# Adapter

**Classification**: Structural Pattern

---

## Intent and Objective

Convert the interface of a class into another interface expected by clients. Adapter allows classes with incompatible interfaces to work together, wrapping itself with a compatible interface.

## Also Known As

- Wrapper

## Motivation

Sometimes a toolkit class designed for reuse cannot be reused simply because its interface doesn't match the domain-specific interface required by an application. Consider a graphical editor that allows drawing and organizing graphical elements. The editor's interface defines abstractions like Shape for graphical objects. But there's an inherited TextView class that implements text windows, and you want to reuse it.

The solution is to define a TextShape class that adapts the TextView interface to the Shape interface. TextShape is an adapter that allows the editor to treat TextView as if it were a Shape.

## Applicability

Use the Adapter pattern when:

- You want to use an existing class but its interface doesn't match the one you need
- You want to create a reusable class that cooperates with unrelated or unforeseen classes with incompatible interfaces
- (Object adapter only) You need to use several existing subclasses, but it's impractical to adapt their interface by subclassing. An object adapter can adapt the interface of its parent class
- You want to isolate your code from external dependencies (Anti-Corruption Layer)
- You need to integrate legacy code with new code

## Structure

### Object Adapter (Composition)
```
Client
└── Uses: Target (Interface)
    └── request()

Adapter implements Target
├── Composes: Adaptee
└── request()
    └── Translates to: adaptee.specificRequest()

Adaptee
└── specificRequest()
```

### Class Adapter (Inheritance)
```
Client
└── Uses: Target (Interface)

Adapter extends Adaptee implements Target
└── request()
    └── Calls: this.specificRequest()
```

## Participants

- **Target**: Defines the domain-specific interface that Client uses
- **Client**: Collaborates with objects conforming to the Target interface
- **Adaptee**: Defines an existing interface that needs adapting
- [**Adapter**](001_adapter.md): Adapts the interface of Adaptee to the Target interface

## Collaborations

- Clients call operations on Adapter instance
- Adapter calls Adaptee operations that carry out the request

## Consequences

### Class Adapter (Inheritance)
**Advantages**:
- Adapts Adaptee to Target by committing to a concrete Adaptee class
- Allows Adapter to override some of Adaptee's behavior
- Introduces only one object; no additional pointer indirection to get to adaptee

**Disadvantages**:
- Won't work when we want to adapt a class and all its subclasses
- Requires multiple inheritance (not available in many languages)

### Object Adapter (Composition)
**Advantages**:
- Allows a single Adapter to work with multiple Adaptees
- Makes it easier to add functionality to all Adaptees at once
- More flexible (composition favored over inheritance)

**Disadvantages**:
- Makes it harder to override Adaptee behavior
- Requires reference to Adaptee

## Implementation

### Considerations

1. **How much adaptation to do**: Work varies from simple operation name conversion to supporting a completely different set of operations

2. **Pluggable adapters**: Maximize reusability by using adapters that adapt to different clients. Build minimal interface, use abstract operations, use delegates

3. **Two-way adapters**: Support multiple views of an object (multiple inheritance)

4. **Minimal interface**: Adapter should expose only what's necessary

### Techniques

- **Delegate Pattern**: Delegate calls to the Adaptee
- **Interface Adapter**: Create adapter that implements full interface with empty methods, subclasses override what's needed
- **Function Adapter**: For adapting standalone functions

## Known Uses

- **Collections Framework**: `Arrays.asList()` adapts array to List
- **I/O Streams**: `InputStreamReader` adapts InputStream to Reader
- **Event Handling**: Adapter classes in listeners (MouseAdapter, KeyAdapter)
- **Legacy Code Integration**: Wrapping legacy systems for use in modern architectures
- **Third-party Libraries**: Adapting external libraries to internal interfaces
- **Anti-Corruption Layer**: DDD - protect domain from external systems

## Related Patterns

- [**Bridge**](002_bridge.md): Similar but different intent; Bridge separates interface from implementation so they can vary independently; Adapter changes interface of existing object
- [**Decorator**](004_decorator.md): Enhances another object without changing interface; more transparent than Adapter; supports recursive composition
- [**Proxy**](007_proxy.md): Defines representative for another object without changing interface
- [**Facade**](005_facade.md): Defines new interface; Adapter reuses old interface

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): reinforces
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): implements
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): reinforces
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): adapting is single responsibility

---

**Created on**: 2025-01-11
**Version**: 1.0
