# Prototype

**Classification**: Creational Pattern

---

## Intent and Objective

Specify the types of objects to be created using a prototypical instance and create new objects by copying this prototype. Allows adding and removing objects at runtime, specifying new objects by varying values and structures.

## Also Known As

- Clone

## Motivation

You could build a graphical editor that allows users to add new tools and objects. The editor defines abstract classes for graphical tools and a palette of available tools. But how can the editor allow users to add new tools without recompiling the system?

The solution is to make tools create new graphical objects by copying or "cloning" a prototype instance. Users can add new tools simply by registering new prototypes in the palette. The editor then clones the appropriate prototype when it needs to create a new object.

## Applicability

Use the Prototype pattern when:

- Classes to be instantiated are specified at runtime
- Avoid building a hierarchy of factories parallel to the product hierarchy
- Instances of a class can have only a few different combinations of state
- Creating objects is costly, and cloning is more efficient
- You want to hide the complexity of creation from the client
- Objects need to be created dynamically from a database or configuration

## Structure

```
Client
└── Uses: Prototype (interface)
    └── clone(): Prototype

Prototype (Interface)
└── clone(): Prototype

ConcretePrototype1 implements Prototype
├── Maintains internal state
└── clone() → returns copy of itself

ConcretePrototype2 implements Prototype
├── Maintains internal state
└── clone() → returns copy of itself

PrototypeRegistry (optional)
├── Maintains: Map<String, Prototype>
├── register(name, prototype)
└── create(name) → return prototypes[name].clone()
```

## Participants

- [**Prototype**](004_prototype.md): Declares interface for cloning itself
- **ConcretePrototype**: Implements operation for cloning itself
- **Client**: Creates new object by asking a prototype to clone itself
- **PrototypeRegistry** (optional): Maintains registry of available prototypes

## Collaborations

- Client asks a prototype to clone itself, instead of asking a factory to create a new object

## Consequences

### Advantages

- **Hides concrete classes**: Reduces number of classes client needs to know
- **Add/remove products at runtime**: Registering new prototype instance equivalent to adding new class
- **Specify new objects by varying values**: Define new behaviors through object composition
- **Reduce subclassing**: Factory Method requires hierarchy of creators; Prototype doesn't
- **Dynamic configuration**: Classes can be determined dynamically

### Disadvantages

- **Implementing clone can be difficult**: Especially if objects have circular references or complex structures
- **Deep vs Shallow copy**: Decision about copy depth can be complex

## Implementation

### Considerations

1. **Use prototype manager**: PrototypeRegistry maintains and provides prototypes

2. **Implement clone operation**: Major difficulty when internal structures include objects without copy support

3. **Shallow vs Deep copy**:
   - Shallow: Copies only references (internal objects shared)
   - Deep: Recursively copies entire structure (independent objects)

4. **Initialize clones**: May need `initialize()` method after clone to configure internal state

5. **Protect prototypes**: Prototypes should not be modified after creation (immutability)

### Techniques

- **Copy Constructor**: Constructor that receives instance of same type
- **Serialization**: Use serialization/deserialization for deep copy
- **Registry Pattern**: Maintain catalog of named prototypes
- **Object Pool**: Combine with Object Pool for clone reuse

## Known Uses

- **JavaScript**: Language is based on prototypes (prototype-based inheritance)
- **Object.create()**: Creates object with specified prototype
- **Clone in Java**: `Cloneable` interface and `clone()` method
- **Game Development**: Clone enemies, power-ups, terrains
- **UI Components**: Clone configured widgets
- **Document Templates**: Create documents from pre-configured templates

## Related Patterns

- **Abstract Factory/Factory Method**: Can store set of prototypes to clone and return products
- **Composite/Decorator**: Designs that make heavy use of these patterns often benefit from Prototype
- [**Singleton**](005_singleton.md): Opposite - Prototype allows multiple instances, Singleton guarantees single
- [**Memento**](../behavioral/006_memento.md): Prototype can be used to implement state snapshots
- [**Command**](../behavioral/002_command.md): Commands can be cloned via Prototype

### Relation to Rules

- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): protect prototypes
- [036 - Restriction on Functions with Side Effects](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md): clone should be pure
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): allows extension via registry

---

**Created on**: 2025-01-11
**Version**: 1.0
