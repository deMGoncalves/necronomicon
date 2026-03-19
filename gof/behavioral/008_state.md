# State

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Allow an object to alter its behavior when its internal state changes. The object will appear to change its class. Encapsulates state-specific behaviors in separate classes.

## Also Known As

- Objects for States
- State

## Motivation

Consider a TCPConnection class that represents a network connection. A TCPConnection object can be in several states: Established, Listening, Closed. When a TCPConnection object receives requests from other objects, it responds differently depending on its current state. For example, the effect of an Open request depends on whether the connection is in its Closed state or its Established state.

The State pattern describes how TCPConnection can exhibit different behavior in each state. The key idea is to introduce an abstract class TCPState to represent the states of the network connection. TCPState declares a common interface for all classes that represent different operational states. Subclasses of TCPState implement state-specific behavior. TCPConnection maintains a state object (an instance of a subclass of TCPState) that represents the current state, and delegates all state-specific requests to this object.

## Applicability

Use the State pattern when:

- An object's behavior depends on its state, and it must change its behavior at runtime depending on that state
- Operations have large, multipart conditional statements that depend on the object's state (typically represented by enum constants)
- You want to avoid complex conditional logic that depends on state
- State transitions should be explicit
- Shared state should be avoided

## Structure

```
Context
├── Maintains: State currentState
├── request()
│   └── Delegates to: currentState.handle(this)
└── setState(State)
    └── Changes current state

State (Interface)
└── handle(Context)

ConcreteStateA implements State
├── handle(Context)
│   ├── Executes StateA-specific behavior
│   └── (Optional) context.setState(new StateB())
└── Knows: which states can follow this

ConcreteStateB implements State
├── handle(Context)
│   ├── Executes StateB-specific behavior
│   └── (Optional) context.setState(new StateC())
└── Knows: which states can follow this
```

## Participants

- **Context**: Defines the interface of interest to clients; maintains an instance of a ConcreteState subclass that defines the current state
- [**State**](008_state.md): Defines an interface for encapsulating the behavior associated with a particular state of the Context
- **ConcreteState subclasses**: Each subclass implements a behavior associated with a state of the Context

## Collaborations

- Context delegates state-specific requests to the current state object
- A context may pass itself as an argument to the State object handling the request; this lets the State object access the context if necessary
- Context is the primary interface for clients; clients can configure a context with State objects; once a context is configured, its clients don't have to deal with the State objects directly
- Either Context or the ConcreteState subclasses can decide which state succeeds another and under what circumstances

## Consequences

### Advantages

- **Localizes state-specific behavior**: Behavior for different states in separate classes
- **Makes state transitions explicit**: Instead of internal values, transitions become explicit by assigning different State objects
- **State objects can be shared**: If they have no instance state, states can be Flyweights
- **Eliminates complex conditionals**: Replaces large conditionals with polymorphism
- **Open/Closed**: Add new states without modifying existing states

### Disadvantages

- **Increases number of classes**: Each state requires a new class
- **Overhead**: If state transitions are simple, may be overhead
- **Complexity**: Can make it harder to understand state flow

## Implementation

### Considerations

1. **Who defines state transitions**:
   - State classes decide successors (more flexibility but states depend on each other)
   - Context decides (centralized transitions but Context needs to know all states)

2. **Table-based alternative**: Alternative is to maintain table that maps inputs to state transitions; less flexible but more compact

3. **Creating and destroying State objects**:
   - Create on demand and destroy afterwards (when states change infrequently)
   - Create all upfront (when changes are frequent; use Flyweight)

4. **Using dynamic state**: In dynamic languages, can swap object's class at runtime

### Techniques

- **Flyweight States**: States without instance state can be shared
- **State Transitions Table**: Table defining valid transitions
- **Hierarchical State Machines**: Composite states (substates)
- **State Stack**: Stack of states to push/pop temporary states

## Known Uses

- **TCP Connection States**: Established, Listening, Closed
- **Document States**: Draft, Moderation, Published
- **Order States**: New, Paid, Shipped, Delivered, Cancelled
- **Game Character States**: Idle, Walking, Running, Jumping, Attacking
- **UI Component States**: Normal, Hover, Pressed, Disabled
- **Workflow Engines**: Process states in business workflows

## Related Patterns

- [**Flyweight**](011_flyweight.md): Explains when and how State objects can be shared
- [**Singleton**](../creational/005_singleton.md): State objects are often Singletons
- [**Strategy**](009_strategy.md): State can be seen as Strategy where the strategy changes based on state; difference: State allows state object to change the Context's state
- [**Command**](002_command.md): States can use Commands to implement transitions
- [**Memento**](006_memento.md): Can use to save/restore states

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add states without modifying existing
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): eliminates state conditionals
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each state one responsibility

---

**Created on**: 2025-01-11
**Version**: 1.0
