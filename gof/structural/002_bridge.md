# Bridge

**Classification**: Structural Pattern

---

## Intent and Objective

Decouple an abstraction from its implementation so that the two can vary independently. Allows abstraction and implementation to be developed separately and that client code in relation to the abstract interface.

## Also Known As

- Handle/Body

## Motivation

When an abstraction can have one of several possible implementations, the usual way to accommodate them is through inheritance. But inheritance permanently binds an implementation to the abstraction, making it difficult to modify, extend, and reuse abstractions and implementations independently.

Consider portable Window classes that must work on X Window System and IBM Presentation Manager. Using inheritance to define WindowXWindow and WindowPM makes it difficult to compose Window with different window abstractions (IconWindow, TransientWindow). We'd have to create platform-specific versions of each type: XIconWindow, PMIconWindow, XTransientWindow, PMTransientWindow - class explosion.

The Bridge pattern avoids this by separating the abstraction hierarchy (Window) from the implementation hierarchy (WindowImpl). Window maintains reference to WindowImpl and delegates implementation-dependent operations.

## Applicability

Use the Bridge pattern when:

- You want to avoid permanent binding between abstraction and implementation (such as when implementation must be selected or switched at runtime)
- Both abstractions and implementations should be extensible by subclassing
- Changes in the implementation of an abstraction should not impact clients
- You want to share an implementation among multiple objects and hide this fact from the client
- You have class proliferation resulting from a two-dimensional hierarchy
- You want to split a monolithic class that has several variants of functionality

## Structure

```
Client
└── Uses: Abstraction
    └── operation()

Abstraction
├── Composes: Implementor (interface)
└── operation()
    └── Delegates to: implementor.operationImpl()

RefinedAbstraction extends Abstraction
└── Can add operations or refine existing ones

Implementor (Interface)
└── operationImpl()

ConcreteImplementorA implements Implementor
└── operationImpl() → specific implementation A

ConcreteImplementorB implements Implementor
└── operationImpl() → specific implementation B
```

## Participants

- **Abstraction**: Defines the abstraction's interface; maintains reference to object of type Implementor
- **RefinedAbstraction**: Extends the interface defined by Abstraction
- **Implementor**: Defines the interface for implementation classes; doesn't need to correspond exactly to Abstraction's interface
- **ConcreteImplementor**: Implements the Implementor interface and defines its concrete implementation

## Collaborations

- Abstraction forwards client requests to its Implementor object

## Consequences

### Advantages

- **Decouples interface and implementation**: Implementation not permanently bound to interface
- **Improves extensibility**: Extend Abstraction and Implementor hierarchies independently
- **Hides implementation details**: Can hide details from clients
- **Reduces compilations**: Change in implementation doesn't require recompilation of Abstraction and clients
- **Implementation sharing**: Multiple abstractions can share same implementation

### Disadvantages

- **Increases complexity**: Introduces additional indirection
- **Overhead**: Slight performance penalty due to delegation

## Implementation

### Considerations

1. **Only one Implementor**: Bridge still useful even with only one implementation if you want to avoid coupling

2. **Creating the right Implementor object**: How and where to decide which ConcreteImplementor to instantiate
   - If Abstraction knows all ConcreteImplementors, it can instantiate appropriate one in constructor
   - Delegate decision to another object (Factory, Abstract Factory)
   - Choose default implementation and change it later as needed

3. **Sharing implementors**: Use reference counting when Implementor is shared

4. **Multiple inheritance**: Can use multiple inheritance to combine abstraction and implementation, but binds the two

### Techniques

- **Factory for Implementors**: Use Factory to choose appropriate implementation
- **Strategy within Bridge**: Implementor can be Strategy pattern
- **Lazy initialization**: Defer creation of Implementor until first needed

## Known Uses

- **JDBC**: Driver interface (Implementor) and Connection/Statement (Abstraction)
- **GUI Frameworks**: Abstract window toolkit and platform-specific implementations
- **Collections**: Interface (Abstraction) and specific implementations (ArrayList, LinkedList)
- **Graphics Rendering**: Drawing abstraction and rendering engines (DirectX, OpenGL, Vulkan)
- **Device Drivers**: Device abstraction and specific drivers
- **Persistence Layers**: ORM abstraction and database-specific implementations

## Related Patterns

- [**Abstract Factory**](../creational/001_abstract-factory.md): Can create and configure a particular Bridge
- [**Adapter**](001_adapter.md): Changes interface of existing object; Bridge separates interface from implementation proactively
- **State/Strategy**: Implementations can be States or Strategies
- [**Template Method**](../clean-code/002_template-method.md): Inheritance to vary algorithm; Bridge uses composition to vary implementation

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): allows independent extension
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): abstraction depends on interface
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separates responsibilities
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): specific interfaces

---

**Created on**: 2025-01-11
**Version**: 1.0
