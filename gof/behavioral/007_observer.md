# Observer

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically. Allows loosely coupled communication between objects.

## Also Known As

- Dependents
- Publish-Subscribe
- Event-Listener
- Signals and Slots

## Motivation

A common side effect of partitioning a system into a collection of cooperating classes is the need to maintain consistency between related objects. You don't want to achieve consistency by making the classes tightly coupled, because that reduces their reusability.

Consider a GUI toolkit that separates the presentation aspects of data from the underlying data. Classes defining application data and presentations can be reused independently. They can work together: a spreadsheet and bar chart may depict information in the same application data object. The spreadsheet and chart don't know about each other; this lets you reuse them separately. But they behave as though they do: when a user changes information in the spreadsheet, the chart reflects the change immediately, and vice versa.

The key objects are subject and observer. A subject may have any number of dependent observers. All observers are notified whenever the subject undergoes a change in state. In response, each observer will query the subject to synchronize its state with the subject's state.

## Applicability

Use the Observer pattern when:

- An abstraction has two aspects, one dependent on the other; encapsulating these in separate objects lets you vary and reuse them independently
- A change to one object requires changing others, and you don't know how many objects need to be changed
- An object should be able to notify other objects without making assumptions about who these objects are (low coupling)
- You want to implement event handling
- You need broadcasting of changes

## Structure

```
Subject (Interface/Abstract)
├── Maintains: List<Observer> observers
├── attach(Observer)
├── detach(Observer)
└── notify()
    └── For each observer: observer.update(this)

ConcreteSubject extends Subject
├── Maintains: internal state
├── getState() → returns state
└── setState(state)
    └── Updates state and calls notify()

Observer (Interface)
└── update(subject: Subject)

ConcreteObserver implements Observer
├── Maintains: reference to subject
└── update(subject)
    └── Synchronizes state with subject.getState()
```

## Participants

- **Subject**: Knows its observers; any number of Observer objects may observe a subject; provides interface for attaching and detaching observers
- [**Observer**](007_observer.md): Defines an updating interface for objects that should be notified of changes in a subject
- **ConcreteSubject**: Stores state of interest to ConcreteObserver objects; sends notification to its observers when its state changes
- **ConcreteObserver**: Maintains a reference to a ConcreteSubject object; stores state that should stay consistent with the subject's; implements the Observer updating interface

## Collaborations

- ConcreteSubject notifies its observers whenever a change occurs that could make its observers' state inconsistent with its own
- After being informed of a change in the concrete subject, a ConcreteObserver object may query the subject for information; uses this information to reconcile its state with that of the subject

## Consequences

### Advantages

- **Abstract coupling between Subject and Observer**: Subject doesn't know the concrete classes of its observers; coupling is abstract and minimal
- **Support for broadcast communication**: Notification is broadcast automatically to all interested objects
- **Unexpected updates**: Observers don't have awareness of each other; a change in the subject can cause a cascade of updates

### Disadvantages

- **Unexpected updates**: Observers have no knowledge of each other; the cost of a change can be unexpected
- **Memory leaks**: Observers not removed can cause memory leaks
- **Update storms**: Cascading updates can degrade performance

## Implementation

### Considerations

1. **Mapping subjects to their observers**: The simplest way is for the subject to store references to its observers

2. **Observing more than one subject**: An observer may observe multiple subjects; the subject passes a reference to itself in update so the observer knows which changed

3. **Who triggers the update**: Subject or observers
   - Subject after each change (ensures consistency but can be inefficient)
   - Clients call notify after series of changes (more efficient but risky to forget)

4. **Dangling references to deleted subjects**: When a subject is deleted, observers should be notified

5. **Making sure Subject state is consistent before notifying**: Important that subject is in a consistent state before calling notify

6. **Pull vs Push**: Observers pull data from subject (pull) vs subject pushes data (push)

### Techniques

- **Pull Model**: Observers query subject for specific changes
- **Push Model**: Subject sends detailed information to observers
- **Event Objects**: Pass object describing change instead of entire subject
- **Weak References**: Use weak references to avoid memory leaks
- **Async Notifications**: Asynchronous notifications for long operations

## Known Uses

- **MVC Pattern**: Model is subject, Views are observers
- **Event Handling**: GUI frameworks (DOM events, Swing listeners)
- **Reactive Programming**: RxJS, Observables, Streams
- **Data Binding**: Two-way data binding in frameworks (Vue, Angular, React)
- **Pub/Sub Systems**: Message brokers, event buses
- **Stock Market**: Price updates to subscribers

## Related Patterns

- [**Mediator**](005_mediator.md): Encapsulating complex communication between colleagues using Mediator; Observer distributes communication by introducing Observer and Subject
- [**Singleton**](../creational/005_singleton.md): Subject is often a Singleton
- [**Command**](002_command.md): Observer can use Command to encapsulate update operation
- [**Strategy**](009_strategy.md): Observer can use Strategy to define different update strategies
- [**Template Method**](010_template-method.md): Update can be a template method

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separate change from notification
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add observers without modifying subject
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): subject depends on Observer interface

---

**Created on**: 2025-01-11
**Version**: 1.0
