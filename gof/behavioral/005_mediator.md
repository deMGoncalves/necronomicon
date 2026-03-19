# Mediator

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.

## Also Known As

- Mediator
- Intermediary

## Motivation

Object-oriented design encourages the distribution of behavior among objects. Such distribution can result in many connections between objects; in the worst case, every object knows about every other. Although partitioning a system into many objects generally enhances reusability, proliferating interconnections tend to reduce it again.

Lots of interconnections make it less likely that an object can work without the support of others. Mediator addresses this by encapsulating collective behavior in a separate object. A mediator is responsible for controlling and coordinating the interactions of a group of objects. The mediator serves as an intermediary that keeps objects in the group from referring to each other explicitly. The objects only know the mediator, reducing the number of interconnections.

## Applicability

Use the Mediator pattern when:

- A set of objects communicate in well-defined but complex ways
- Reusing an object is difficult because it refers to and communicates with many other objects
- Behavior that's distributed between several classes should be customizable without a lot of subclassing
- You want to decouple colleagues that communicate with each other
- You have highly coupled classes that are difficult to modify

## Structure

```
Mediator (Interface)
└── notify(sender, event)

ConcreteMediator implements Mediator
├── Knows: Colleague1, Colleague2, ColleagueN
└── notify(sender, event)
    ├── Coordinates communication between colleagues
    └── Implements interaction logic

Colleague (Interface/Abstract)
├── Composes: Mediator
└── Communicates via: mediator.notify(this, event)

ConcreteColleague1 implements Colleague
└── operation()
    └── mediator.notify(this, "event1")

ConcreteColleague2 implements Colleague
└── operation()
    └── mediator.notify(this, "event2")
```

## Participants

- [**Mediator**](005_mediator.md): Defines interface for communicating with Colleague objects
- **ConcreteMediator**: Implements cooperative behavior by coordinating Colleague objects; knows and maintains its colleagues
- **Colleague classes**: Each Colleague class knows its Mediator object; each colleague communicates with its mediator whenever it would have otherwise communicated with another colleague

## Collaborations

- Colleagues send and receive requests from a Mediator object
- The mediator implements the cooperative behavior by routing requests between the appropriate colleagues

## Consequences

### Advantages

- **Limits subclassing**: Localizes behavior that otherwise would be distributed among several objects; changing behavior requires only subclassing Mediator
- **Decouples colleagues**: Mediator promotes loose coupling between colleagues; can vary and reuse Colleague and Mediator classes independently
- **Simplifies object protocols**: Replaces many-to-many communications with one-to-many; one-to-many easier to understand, maintain, and extend
- **Abstracts object cooperation**: Mediator separates how objects cooperate from their individual logic
- **Centralizes control**: Trades complexity of interaction for complexity in mediator

### Disadvantages

- **Centralization can create monolith**: Mediator can become a complex, hard-to-maintain monolith
- **Mediator can become God Object**: If it concentrates too many responsibilities

## Implementation

### Considerations

1. **Omitting abstract Mediator class**: When colleagues work with only one mediator, don't need abstraction

2. **Colleague-Mediator communication**: Use Observer pattern to communicate state changes

3. **Avoiding God Mediator**: If mediator becomes too complex, split responsibilities or use Chain of Responsibility

### Techniques

- **Observer for notifications**: Colleagues observe changes via mediator
- **Event-based communication**: Use events to decouple further
- **Message-based**: Use typed messages for communication
- **Mediator chain**: Mediators can form chain for delegation

## Known Uses

- **GUI Frameworks**: Dialog boxes coordinating widgets (MVC controller)
- **Air Traffic Control**: Coordination between planes and tower
- **Chat Rooms**: Server mediates messages between users
- **Event Buses**: Event mediators in applications
- **MVC Controller**: Coordinates Model and View
- **Service Bus**: Enterprise Service Bus coordinates services

## Related Patterns

- [**Facade**](010_facade.md): Abstracts subsystem to simplify interface; Mediator abstracts communication between cooperating colleagues
- [**Observer**](007_observer.md): Colleagues can communicate with mediator using Observer pattern
- [**Singleton**](../creational/005_singleton.md): Mediator is often a singleton
- [**Strategy**](009_strategy.md): Mediator can use Strategy to vary coordination behavior
- [**Command**](002_command.md): Commands can be mediated through mediator

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): centralize coordination
- [005 - Call Chaining Restriction](../../object-calisthenics/005_maximo-uma-chamada-por-linha.md): avoid direct communication
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): colleagues notify mediator
- [025 - Prohibition of The Blob Anti-Pattern](../../clean-code/005_proibicao-anti-pattern-the-blob.md): avoid God Mediator

---

**Created on**: 2025-01-11
**Version**: 1.0
