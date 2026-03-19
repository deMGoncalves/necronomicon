# Singleton

**Classification**: Creational Pattern

---

## Intent and Objective

Ensure a class has only one instance and provide a global point of access to it. Controls access to shared resources such as database connections or files.

## Also Known As

- Single Instance

## Motivation

It's important that some classes have exactly one instance. Although there may be many printers in a system, there should be only one print spooler. There should be only one file system and one window manager.

How to ensure a class has only one instance and that it's easily accessible? A global variable makes the object accessible, but doesn't prevent instantiation of multiple objects. The solution is to make the class itself responsible for maintaining its single instance, ensuring no other can be created.

## Applicability

Use the Singleton pattern when:

- There must be exactly one instance of a class, accessible to clients from a well-known point
- The single instance must be extensible by subclassing, and clients must be able to use the extended instance without modifying code
- You need stricter control over global variables
- Costly resources must be shared (connections, thread pools)
- A central coordinator object is necessary (event bus, logger)

## Structure

```
Singleton
├── Private static property: instance
├── Private/protected constructor
└── Public static method getInstance()
    ├── If instance is null
    │   └── instance = new Singleton()
    └── Returns instance

Client
└── Accesses: Singleton.getInstance()
```

## Participants

- [**Singleton**](005_singleton.md): Defines getInstance() operation that allows clients to access its single instance; getInstance() is a class operation (static method); may be responsible for creating its own single instance

## Collaborations

- Clients access Singleton instance exclusively through getInstance() operation

## Consequences

### Advantages

- **Controlled access**: Encapsulates its single instance, having control over how and when it's accessed
- **Reduced namespace**: Improvement over global variables; avoids polluting namespace
- **Allows refinement**: Can be extended by subclassing; configurable to use desired instance
- **Flexible**: More flexible than class operations (static methods); can change decision about single instance
- **Lazy initialization**: Instance created only when needed

### Disadvantages

- **SRP violation**: Class has two responsibilities (business logic + instance control)
- **Difficult to test**: Mocks and isolation are complicated
- **Hidden global state**: Creates implicit dependencies and coupling
- **Concurrency**: Requires care in multi-threaded environments
- **DIP violation**: Clients depend on concrete class

## Implementation

### Considerations

1. **Ensure single instance**: Make constructor private/protected

2. **Subclassing**: If allowing subclassing, use singleton registry or make getInstance() consult environment variable/configuration

3. **Thread-safety**: In multi-threaded environments, synchronize access to getInstance() or use eager initialization

4. **Lazy vs Eager initialization**:
   - Lazy: Creates when first requested (resource economy)
   - Eager: Creates at class loading (thread-safe by default)

5. **ES6 Modules**: In JavaScript, modules are naturally singletons

### Techniques

- **Double-checked locking**: Optimize lazy initialization in multi-threaded
- **Enum Singleton**: In Java, use enum to guarantee single instance
- **Module Pattern**: In JavaScript, use ES6 module or IIFE
- **Dependency Injection**: Prefer injecting singleton via DI instead of calling getInstance()

## Known Uses

- **Logger**: `Logger.getInstance()` in various languages
- **Configuration Manager**: Application configuration manager
- **Thread Pools**: Shared thread pool
- **Cache**: Global application cache
- **Database Connection Pool**: Database connection pool
- **Event Bus**: Centralized event bus
- **Window Manager**: Window manager in operating systems

## Related Patterns

- **Abstract Factory/Builder/Prototype**: Can be implemented as Singletons
- [**Facade**](../structural/005_facade.md): Facade objects are often Singletons
- **State/Strategy**: Stateless state/strategy objects can be Singletons
- [**Flyweight**](../structural/006_flyweight.md): Flyweight Factory is often Singleton
- **Monostate**: Alternative that shares state but allows multiple instances

### Relation to Rules

- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): conflicts (prefer DI)
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): violates (double responsibility)
- [032 - Minimum Test Coverage](../../clean-code/012_cobertura-teste-minima-qualidade.md): hinders
- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): complements
- [045 - Stateless Processes](../../twelve-factor/006_processos-stateless.md): conflicts

---

**Created on**: 2025-01-11
**Version**: 1.0
