# Command

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Encapsulate a request as an object, thereby letting you parameterize clients with different requests, queue or log requests, and support undoable operations.

## Also Known As

- Action
- Transaction

## Motivation

Sometimes it's necessary to issue requests to objects without knowing anything about the operation being requested or the receiver. GUI toolkits include objects like buttons and menus that carry out a request in response to user input. But the toolkit can't implement the request explicitly because only the application knows what to do.

The Command pattern allows the toolkit to make requests of objects without knowing anything about the request or the receiver. It turns the request into an object that can be stored and passed like other objects. The key is an abstract Command interface declaring an interface for executing operations.

## Applicability

Use the Command pattern when you want to:

- Parameterize objects with an action to perform (callbacks in procedural languages)
- Specify, queue, and execute requests at different times (command has lifetime independent of original request)
- Support undo; Execute operation can store state for reversing effects; Command has Undo operation; executed commands stored in history list
- Support logging of changes to recover after crash
- Structure a system around high-level operations built on primitives (transaction support)

## Structure

```
Client
└── Creates: ConcreteCommand and configures Receiver

Invoker
├── Maintains: Command
└── Executes: command.execute()

Command (Interface)
├── execute()
└── undo() (optional)

ConcreteCommand implements Command
├── Composes: Receiver
├── Maintains: state for undo
├── execute()
│   └── receiver.action()
└── undo()
    └── restore state

Receiver
└── action() → knows how to perform operations
```

## Participants

- [**Command**](002_command.md): Declares interface for executing an operation
- **ConcreteCommand**: Defines a binding between a Receiver object and an action; implements Execute by invoking corresponding operations on Receiver
- **Client**: Creates a ConcreteCommand object and sets its receiver
- **Invoker**: Asks the command to carry out the request
- **Receiver**: Knows how to perform the operations associated with carrying out the request; any class can serve as Receiver

## Collaborations

- Client creates ConcreteCommand and specifies its receiver
- Invoker stores ConcreteCommand object
- Invoker issues request by calling Execute on command; when commands are undoable, ConcreteCommand stores state before invoking Execute
- ConcreteCommand object invokes operations on its receiver to carry out the request

## Consequences

### Advantages

- **Decouples invoker from executor**: Object that invokes the operation is decoupled from the one that knows how to perform it
- **Commands are objects**: Can be manipulated and extended like any other object
- **Can assemble into composite commands**: Assemble commands into composite
- **Easy to add new Commands**: Don't need to change existing classes
- **Support for undo/redo**: Store history of executed commands
- **Support for transactions**: Group commands and execute atomically

### Disadvantages

- **Increases number of classes**: Each concrete command requires new class
- **Complexity**: Can complicate design for simple operations

## Implementation

### Considerations

1. **How intelligent should a command be**: Varies from merely defining a binding between receiver and actions to implementing everything without delegating to receiver

2. **Supporting undo/redo**: ConcreteCommand must store additional state
   - Receiver (object that performed the operation)
   - Arguments to the operation on the receiver
   - Original values in receiver that may change

3. **Avoiding error accumulation**: Errors can accumulate in undo process; use Memento to store state

4. **Using templates for Commands**: In languages that support them, use templates/generics to parameterize Command with Receiver and Action

### Techniques

- **Macro Commands**: Composite of commands for complex operations
- **Command History**: Stack of executed commands for undo/redo
- **Command Queue**: Queue of commands for later execution
- **Transactional Commands**: Commands that can be committed or rolled back

## Known Uses

- **GUI Frameworks**: MenuItem commands, Button actions
- **Text Editors**: Undo/redo operations (cut, paste, delete, format)
- **Transactional Systems**: Database transactions, business transactions
- **Task Scheduling**: Job queues, delayed execution
- **Macro Recording**: Recording and replaying sequences of commands
- **Game Commands**: Player actions, AI behaviors

## Related Patterns

- [**Composite**](008_composite.md): Can implement MacroCommands
- [**Memento**](006_memento.md): Can keep state for undo
- [**Prototype**](../creational/004_prototype.md): Command that must be copied before being placed in history can use Prototype
- [**Chain of Responsibility**](001_chain-of-responsibility.md): Commands can be handled in chain
- [**Strategy**](009_strategy.md): Command is object representing request; Strategy is object representing algorithm

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separate invocation from execution
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add commands without modifying invoker
- [038 - Command-Query Separation Principle](../../clean-code/018_conformidade-principio-inversao-consulta.md): command is pure command

---

**Created on**: 2025-01-11
**Version**: 1.0
