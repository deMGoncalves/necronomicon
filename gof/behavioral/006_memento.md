# Memento

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Without violating encapsulation, capture and externalize an object's internal state so that the object can be restored to this state later. Allows implementing undo/redo, snapshots, and checkpoints while maintaining encapsulation.

## Also Known As

- Token
- Snapshot

## Motivation

Sometimes it's necessary to record the internal state of an object to implement checkpoints and undo mechanisms. Objects normally encapsulate some or all of their state, making it inaccessible to other objects and impossible to save externally. Exposing this state would violate encapsulation, which can compromise the application's robustness and extensibility.

Consider a graphical editor that supports connectivity between objects. A user can align objects by connecting them. Alignment may modify data structures that specify connectivity. Implementing undo requires storing the data structures that specify exactly how objects are connected. But Constraint objects encapsulate these structures internally.

The Memento pattern solves this problem without compromising encapsulation. The Originator (Constraint) delegates saving state to another object (memento). Only the originator can store and retrieve information from the memento.

## Applicability

Use the Memento pattern when:

- A snapshot of (some portion of) an object's state must be saved so that it can be restored later
- A direct interface for obtaining the state would expose implementation details and break the object's encapsulation
- You need to implement undo/redo
- You want to implement transactions that can be rolled back
- You need to implement checkpoints in long-running processes

## Structure

```
Originator
├── Maintains: internal state
├── createMemento(): Memento
│   └── return new Memento(state)
└── restore(memento: Memento)
    └── state = memento.getState()

Memento
├── Maintains: saved state of Originator
├── getState() → returns state (only for Originator)
└── (Optionally) limited interface for Caretaker

Caretaker
├── Maintains: List<Memento> (history)
├── Responsible for: saving and restoring Originator
├── saveState()
│   └── history.add(originator.createMemento())
└── undo()
    └── originator.restore(history.pop())
```

## Participants

- [**Memento**](006_memento.md): Stores internal state snapshot of the Originator; protects against access by objects other than the originator
- **Originator**: Creates memento containing snapshot of its current internal state; uses the memento to restore its internal state
- **Caretaker**: Responsible for the memento's safekeeping; never operates on or examines the contents of a memento

## Collaborations

- Caretaker requests a memento from the originator, holds it for a time, and passes it back to the originator
- Mementos are passive; only the originator that created a memento will assign or retrieve its state

## Consequences

### Advantages

- **Preserves encapsulation**: Avoids exposing information that only an originator should manage but must be stored outside of it
- **Simplifies Originator**: Originator doesn't need to manage versions of internal state
- **Allows undo/redo**: History of mementos allows navigating through states
- **Separation of concerns**: Caretaker manages when and why to capture state

### Disadvantages

- **Cost of copying state**: Can be expensive if Originator must copy large amounts of information
- **Caretaker costs**: Caretaker can incur significant storage costs
- **Memory overhead**: Maintaining many mementos can consume lots of memory

## Implementation

### Considerations

1. **Language support for preserving encapsulation**: Ideally, only Originator can access memento state

2. **Storing incremental changes**: If creating and restoring state is expensive, mementos can store only incremental changes

3. **Lazy restoration**: Defer restoration until actually needed

4. **Limiting history**: Limit number of mementos to control memory usage (LRU cache)

### Techniques

- **Incremental Memento**: Store only differences since last snapshot
- **Compress Mementos**: Compress state to save memory
- **Copy-on-write**: Share state until modification
- **Prototype for cloning**: Use Prototype to copy state
- **Serialization**: Serialize object state

## Known Uses

- **Text Editors**: Undo/redo of edits (Ctrl+Z, Ctrl+Y)
- **Database Transactions**: Savepoints and rollback
- **Game State**: Save games, checkpoints
- **Graphics Editors**: Undo operations (Photoshop, GIMP)
- **Version Control**: Snapshots of project state
- **Browser History**: Back/forward navigation

## Related Patterns

- [**Command**](002_command.md): Commands can use Mementos to maintain state for undo
- [**Iterator**](004_iterator.md): Memento can be used to capture iteration state
- [**Prototype**](../creational/004_prototype.md): Mementos can use Prototype to copy state
- [**State**](008_state.md): Memento can save states from State pattern
- **Serialization**: Common technique for implementing Memento

### Relation to Rules

- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): mementos should be immutable
- [036 - Function Side Effects Restriction](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md): restoration should not have side effects
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separate state management

---

**Created on**: 2025-01-11
**Version**: 1.0
