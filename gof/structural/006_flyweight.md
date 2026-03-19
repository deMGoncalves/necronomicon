# Flyweight

**Classification**: Structural Pattern

---

## Intent and Objective

Use sharing to support large numbers of fine-grained objects efficiently. Reduces memory costs through sharing common state portions between multiple objects instead of keeping all data in each object.

## Also Known As

- Flyweight
- Object Cache

## Motivation

Some applications could benefit from using objects throughout their design, but a naive implementation would be prohibitively expensive. A document editor might use objects to represent each character, allowing fine-grained formatting and layout. But this could create hundreds of thousands of objects, consuming excessive memory.

Flyweight solves this by sharing objects. Character 'a' can be represented by a single shared object. Each occurrence of the character in the document references the same flyweight object. Intrinsic state (glyph code, font) is stored in the flyweight; extrinsic state (position, specific style) is maintained by the client.

## Applicability

Use the Flyweight pattern when ALL of the following conditions are true:

- Application uses large number of objects
- Storage costs are high due to quantity of objects
- Most object state can be made extrinsic
- Many groups of objects can be replaced by relatively few shared objects once extrinsic state is removed
- Application doesn't depend on object identity (flyweight objects are shared and not distinguishable)

## Structure

```
Client
├── Maintains: extrinsic state
└── Uses: FlyweightFactory
    └── getFlyweight(key) → returns shared Flyweight

FlyweightFactory
├── Maintains: pool Map<key, Flyweight>
└── getFlyweight(key)
    ├── If flyweight exists in pool
    │   └── Return existing
    └── Else
        ├── Create new Flyweight
        ├── Add to pool
        └── Return new

Flyweight (Interface)
└── operation(extrinsicState)

ConcreteFlyweight implements Flyweight
├── Maintains: intrinsic state (shared)
└── operation(extrinsicState)
    └── Uses intrinsic + extrinsic state
```

## Participants

- [**Flyweight**](006_flyweight.md): Declares interface through which flyweights can receive and act on extrinsic state
- **ConcreteFlyweight**: Implements Flyweight interface and adds storage for intrinsic state; must be sharable; state must be intrinsic
- **UnsharedConcreteFlyweight**: Not all Flyweight objects need be shared; Flyweight interface enables sharing but doesn't enforce it
- **FlyweightFactory**: Creates and manages flyweight objects; ensures flyweights are shared appropriately; maintains pool
- **Client**: Maintains references to flyweights; computes or stores extrinsic state

## Collaborations

- State that flyweight needs must be characterized as intrinsic or extrinsic
- Intrinsic state stored in ConcreteFlyweight; extrinsic state stored or computed by clients
- Clients should not instantiate ConcreteFlyweights directly; must obtain from FlyweightFactory

## Consequences

### Advantages

- **Memory savings**: Significantly reduces memory usage when there are many similar objects
- **Runtime cost vs storage**: May introduce runtime cost to transfer, find, or compute extrinsic state
- **Object reuse**: Promotes extensive object reuse

### Disadvantages

- **Complexity**: Increases code complexity by separating intrinsic/extrinsic state
- **Extrinsic state**: Client must maintain and pass extrinsic state
- **Testing difficulty**: Shared objects can have side effects between tests

## Implementation

### Considerations

1. **Remove extrinsic state**: Pattern's applicability not worth applying unless there are enough objects to make significant storage difference

2. **Manage shared objects**: Clients shouldn't instantiate ConcreteFlyweights directly; FlyweightFactory decides when to create and share

3. **Sharing implies immutability**: Shared flyweights must not allow modification of intrinsic state

4. **Garbage collection**: In languages with GC, unused flyweights can be collected; pool can use weak references

### Techniques

- **Lazy Creation**: Create flyweights on demand
- **String Interning**: Similar technique used for strings
- **Object Pool**: Flyweight uses Object Pool pattern
- **Weak References**: To allow GC of unused flyweights

## Known Uses

- **String Interning**: Java, Python, JavaScript intern string literals
- **Integer Cache**: Java caches Integer objects -128 to 127
- **Character Sets**: Objects representing characters in editors
- **Game Objects**: Textures, 3D models shared between multiple instances
- **Database Connection Pools**: Share expensive connections
- **Thread Pools**: Share threads between tasks

## Related Patterns

- [**Composite**](003_composite.md): Often combined; leaf nodes can be flyweights
- **State/Strategy**: State and Strategy objects are often flyweights (stateless)
- [**Singleton**](../creational/005_singleton.md): FlyweightFactory is often singleton
- **Factory**: FlyweightFactory is Factory pattern variant
- **Object Pool**: Similar but focuses on temporal reuse; Flyweight focuses on spatial sharing

### Relation to Rules

- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): flyweights must be immutable
- [036 - Restriction on Functions with Side Effects](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md): no side effects
- [045 - Stateless Processes](../../twelve-factor/006_processos-stateless.md): flyweights without mutable state

---

**Created on**: 2025-01-11
**Version**: 1.0
