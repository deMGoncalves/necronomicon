# Facade

**Classification**: Structural Pattern

---

## Intent and Objective

Provide a unified interface to a set of interfaces in a subsystem. Facade defines a higher-level interface that makes the subsystem easier to use, reducing complexity and dependencies between systems.

## Also Known As

- Facade

## Motivation

Structuring a system into subsystems helps reduce complexity. A common design goal is to minimize communication and dependencies between subsystems. One way to achieve this is to introduce a facade object that provides a single, simplified interface to the more general facilities of a subsystem.

Consider a compiler: subsystems include scanner, parser, semantic analyzer, code generator. Some specialized programs may access these facilities directly, but most compiler clients don't care about details - they just want to compile. Compiler class provides unified interface that hides complexity.

## Applicability

Use the Facade pattern when:

- You want to provide a simple interface to a complex subsystem
- There are many dependencies between clients and implementation classes of an abstraction
- You want to layer your subsystems; facade defines entry point for each level
- You want to decouple subsystem from clients and other subsystems
- You want to promote weak coupling between subsystem and clients
- You want to hide complexity of third-party APIs

## Structure

```
Client
└── Uses: Facade
    └── operation()
        ├── subsystemClass1.operation1()
        ├── subsystemClass2.operation2()
        ├── subsystemClass3.operation3()
        └── coordinates subsystems

Facade
├── Knows: SubsystemClass1, SubsystemClass2, SubsystemClass3
└── Delegates client requests to appropriate subsystem objects

SubsystemClass1
└── Implements subsystem functionality

SubsystemClass2
└── Implements subsystem functionality

SubsystemClass3
└── Implements subsystem functionality
```

## Participants

- [**Facade**](005_facade.md): Knows which subsystem classes are responsible for a request; delegates client requests to appropriate subsystem objects
- **Subsystem classes**: Implement subsystem functionality; do work assigned by Facade; have no knowledge of Facade (don't maintain reference)

## Collaborations

- Clients communicate with subsystem by sending requests to Facade, which forwards them to appropriate subsystem objects
- Although subsystem objects do actual work, Facade may need to translate its interface to subsystem interfaces
- Clients that use facade don't need to access subsystem objects directly

## Consequences

### Advantages

- **Shields clients from subsystem components**: Reduces number of objects clients deal with, making subsystem easier to use
- **Promotes loose coupling**: Allows varying subsystem components without affecting clients
- **Doesn't prevent subsystem access**: Clients can choose between facade and direct subsystem access
- **Abstraction layers**: Simplifies dependencies between layers
- **Facilitates refactoring**: Changes in subsystem don't affect clients

### Disadvantages

- **Can become God Object**: If concentrating too many responsibilities
- **Can create unwanted coupling**: If poorly designed, can couple facade to too many classes
- **SRP violation**: If facade does more than simple coordination

## Implementation

### Considerations

1. **Reduce client-subsystem coupling**: Making Facade an abstract class with concrete subclasses for different implementations allows swapping entire implementations

2. **Public vs private subsystem classes**: Subsystem is similar to class - both have interfaces and both encapsulate something. Public subsystem interface consists of classes accessible to clients; private are for internal use

3. **Additional facade**: Not limited to having only one facade per subsystem

### Techniques

- **Layered Facade**: Create facades for different levels of abstraction
- **Facade as Singleton**: Often only one instance of facade is needed
- **Facade with Factory**: Facade can use Factory Methods to create subsystem objects

## Known Uses

- **Java Database Connectivity (JDBC)**: `DriverManager` is facade for driver subsystem
- **javax.faces.context.FacesContext**: Facade for JSF
- **Spring Framework**: Many facade classes (`JdbcTemplate`, `RestTemplate`)
- **Operating System APIs**: High-level APIs that hide kernel complexity
- **Compiler Frontends**: Simplified interface to complex compilation processes
- **Media Players**: Simple interface to codec, rendering, audio subsystems

## Related Patterns

- [**Abstract Factory**](../creational/001_abstract-factory.md): Can be used with Facade to provide interface for creating subsystem objects independently of subsystem
- [**Mediator**](017_mediator.md): Similar - abstracts functionality of existing objects; difference: Mediator centralizes communication between colleagues that know each other; Facade merely abstracts subsystem object interface
- [**Singleton**](../creational/005_singleton.md): Facade is often Singleton
- [**Adapter**](001_adapter.md): Adapts existing interface; Facade defines new simplified interface

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): coordination is single responsibility
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): provides specific interface
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): clients depend on facade
- [018 - Acyclic Dependencies Principle](../../package-principles/004_acyclic-dependencies-principle.md): breaks cycles

---

**Created on**: 2025-01-11
**Version**: 1.0
