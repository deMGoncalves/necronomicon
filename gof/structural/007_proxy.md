# Proxy

**Classification**: Structural Pattern

---

## Intent and Purpose

Provide a surrogate or placeholder for another object to control access to it. Creates a representative object that controls access to the original object, allowing you to perform something before or after the request reaches the original object.

## Also Known As

- Surrogate

## Motivation

One reason to control access to an object is to defer the full cost of its creation and initialization until we actually need to use it. Consider a document editor that can embed graphical objects. Some graphical objects (large raster images) are expensive to create. But opening a document should be fast; we shouldn't create all expensive objects at once.

The solution is to use another object, an image proxy, in place of the real image. The proxy acts like the image and takes care of instantiating it when the document requires it. The proxy forwards subsequent requests directly to the image.

## Applicability

Proxy is applicable whenever there's a need for a more versatile or sophisticated reference than a simple pointer. Common situations:

- **Remote Proxy**: Local representative for an object in a different address space
- **Virtual Proxy**: Creates expensive objects on demand (lazy initialization)
- **Protection Proxy**: Controls access to the original object (rights verification)
- **Smart Reference**: Replacement for a pointer that performs additional actions when the object is accessed (counting references, loading persistent object, locking)
- **Cache Proxy**: Maintains cache of expensive results
- **Logging Proxy**: Records calls to the real object

## Structure

```
Client
└── Uses: Subject (Interface)
    └── request()

Subject (Interface)
└── request()

RealSubject implements Subject
└── request() → real implementation

Proxy implements Subject
├── Composes: RealSubject
└── request()
    ├── Access control / lazy init
    ├── realSubject.request()
    └── Post-processing
```

## Participants

- **Subject**: Defines common interface for RealSubject and Proxy so that Proxy can be used anywhere RealSubject is expected
- **RealSubject**: Defines the real object that the proxy represents
- [**Proxy**](007_proxy.md): Maintains a reference that lets it access RealSubject; provides interface identical to Subject; controls access to RealSubject and may be responsible for creating and deleting it

## Collaborations

- Proxy forwards requests to RealSubject when appropriate, depending on the proxy type

## Consequences

### Advantages

- **Transparent control**: Introduces a level of indirection when accessing an object; specific types exploit this
- **Remote Proxy**: Hides that the object resides in a different address space
- **Virtual Proxy**: Optimizations like creating object on demand
- **Protection/Smart Proxies**: Allow additional tasks when accessing the object
- **Copy-on-write**: Virtual proxy optimization; defers copying until modification

### Disadvantages

- **Overhead**: Introduces an indirection layer that may slow down operations
- **Complexity**: Increases system complexity

## Implementation

### Considerations

1. **Operator overloading**: In languages that permit it, can overload access operator (C++ `->`); in languages like Java, it's not possible

2. **Proxy doesn't need to know concrete type**: If proxy only forwards requests, it can work with any RealSubject

3. **Lazy initialization of RealSubject**: Virtual proxy can defer creation

4. **Protection Proxy**: Check permissions before forwarding

### Techniques

- **Lazy Initialization**: Create RealSubject only when necessary
- **Reference Counting**: Count references and delete RealSubject when not used
- **Caching**: Cache results of expensive operations
- **Access Control**: Verify credentials before allowing access

## Known Uses

- **RMI/RPC**: Java RMI, gRPC use remote proxies
- **ORM Frameworks**: Hibernate lazy loading uses virtual proxies
- **Spring AOP**: Proxies for aspects (transactions, security)
- **ES6 Proxy**: JavaScript Proxy API to intercept operations
- **Image Loading**: Virtual proxies to load images on demand
- **Security Proxies**: Authentication/authorization verification

## Related Patterns

- [**Adapter**](001_adapter.md): Provides different interface to the object; Proxy provides same interface
- [**Decorator**](004_decorator.md): Adds responsibilities; Proxy controls access; Decorator may have same implementation as Proxy but different intent
- [**Facade**](005_facade.md): Provides simplified interface; Proxy provides same interface as subject
- [**Singleton**](../creational/005_singleton.md): Proxy can control access to singleton

### Relation to Rules

- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): Proxy substitutes RealSubject
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): client depends on Subject
- [036 - Function Side Effects Restriction](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md): proxy can add effects

---

**Created on**: 2025-01-11
**Version**: 1.0
