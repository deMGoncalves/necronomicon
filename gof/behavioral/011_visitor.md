# Visitor

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Represent an operation to be performed on the elements of an object structure. Visitor lets you define a new operation without changing the classes of the elements on which it operates. Separates an algorithm from an object structure on which it operates.

## Also Known As

- Visitor

## Motivation

Consider a compiler that represents programs as abstract syntax trees. It will perform operations on these trees for analysis, optimization, code generation. Most of these operations will need to treat nodes that represent different language constructs differently. Distributing all these operations across the various node classes leads to a system that's hard to understand, maintain, and change.

We could define these operations in separate classes. To apply a particular operation like type checking, we create a TypeCheckingVisitor. This visitor traverses the tree visiting each node and performing appropriate type checking. To add a new operation, we just add a new Visitor subclass. Visitor uses a technique called double-dispatch: the operation executed depends on both the kind of request and the type of element it receives.

## Applicability

Use the Visitor pattern when:

- An object structure contains many classes of objects with differing interfaces, and you want to perform operations on these objects that depend on their concrete classes
- Many distinct and unrelated operations need to be performed on objects in an object structure, and you want to avoid "polluting" their classes with these operations
- The classes defining the object structure rarely change, but you often want to define new operations over the structure
- You need to perform operations on objects without modifying their classes
- You have a stable class hierarchy but volatile operations

## Structure

```
Client
└── Uses: ObjectStructure, Visitor

ObjectStructure
├── Maintains: List<Element>
└── accept(visitor)
    └── For each element: element.accept(visitor)

Element (Interface)
└── accept(visitor: Visitor)

ConcreteElementA implements Element
└── accept(visitor)
    └── visitor.visitConcreteElementA(this)

ConcreteElementB implements Element
└── accept(visitor)
    └── visitor.visitConcreteElementB(this)

Visitor (Interface)
├── visitConcreteElementA(ConcreteElementA)
└── visitConcreteElementB(ConcreteElementB)

ConcreteVisitor1 implements Visitor
├── visitConcreteElementA(element)
│   └── A-specific operation
└── visitConcreteElementB(element)
    └── B-specific operation

ConcreteVisitor2 implements Visitor
├── visitConcreteElementA(element)
│   └── Another operation for A
└── visitConcreteElementB(element)
    └── Another operation for B
```

## Participants

- [**Visitor**](011_visitor.md): Declares a Visit operation for each class of ConcreteElement in the object structure; the operation's name and signature identifies the class that sends the Visit request to the visitor
- **ConcreteVisitor**: Implements each operation declared by Visitor; provides the context for the algorithm and stores its local state
- **Element**: Defines an Accept operation that takes a visitor as an argument
- **ConcreteElement**: Implements an Accept operation that takes a visitor as an argument
- **ObjectStructure**: Can enumerate its elements; may provide a high-level interface to allow the visitor to visit its elements; may be a Composite or a collection

## Collaborations

- A client that uses the Visitor pattern must create a ConcreteVisitor object and then traverse the object structure, visiting each element with the visitor
- When an element is visited, it calls the Visitor operation that corresponds to its class; the element supplies itself as an argument to this operation to let the visitor access its state if necessary

## Consequences

### Advantages

- **Easy to add new operations**: Adding a new operation is easy; just add a new visitor
- **Gathers related operations**: Related operations defined in a visitor instead of spread across classes
- **Accumulate state**: Visitors can accumulate state as they traverse the structure
- **Can traverse unrelated structures**: Visitor not limited to structures that define accept

### Disadvantages

- **Adding new ConcreteElement classes is hard**: Each new ConcreteElement requires a new Visit operation in each Visitor
- **Breaking encapsulation**: Visitor may require access to elements' internal state
- **Dependency**: Visitors depend on concrete element classes

## Implementation

### Considerations

1. **Double dispatch**: Visitor uses double dispatch; the operation executed depends on both the type of Visitor and the type of Element

2. **Who is responsible for traversal**: Visitor, ObjectStructure, or another object can be responsible; if ObjectStructure is Composite, can use Iterator

3. **Visitor without abstract element class**: If the structure doesn't have a common abstract class for elements, Visitor needs a visit method for each type

### Techniques

- **Visitor with Composite**: Combine with Composite to traverse tree structures
- **Visitor with Iterator**: Use Iterator for traversal
- **Acyclic Visitor**: Variant that avoids cyclic dependencies
- **Reflective Visitor**: Use reflection to avoid double dispatch
- **Extension Methods**: In languages that support them, use extension methods as alternative

## Known Uses

- **Compilers**: AST traversal (type checking, optimization, code generation)
- **Document Processing**: Operations on document object model
- **Graphics**: Rendering operations on graphical scenes
- **File Systems**: Operations on directory structures
- **Tax Calculation**: Different tax visitors for different jurisdictions
- **Reporting**: Different report formats on same data structure

## Related Patterns

- [**Composite**](008_composite.md): Visitor can be used to apply an operation over a Composite
- [**Interpreter**](003_interpreter.md): Visitor can be used to interpret AST
- [**Iterator**](004_iterator.md): Visitor can use Iterator to traverse structure
- [**Strategy**](009_strategy.md): Visitor is Strategy applied to object structure
- [**Command**](002_command.md): Visitor can treat each element visit as Command

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add operations without modifying elements
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separate operation from structure
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): visitor defines specific interface

---

**Created on**: 2025-01-11
**Version**: 1.0
