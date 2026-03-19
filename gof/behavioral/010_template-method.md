# Template Method

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps of an algorithm without changing the algorithm's structure.

## Also Known As

- Template Method
- Hollywood Principle ("Don't call us, we'll call you")

## Motivation

Consider an application framework that provides Application and Document classes. The Application class is responsible for opening existing documents stored in an external format, such as a file. A Document object represents the information in a document once it's opened.

Applications built with the framework can subclass Application and Document to suit specific needs. For example, a drawing application defines DrawApplication and DrawDocument subclasses. Application class defines the algorithm for opening and reading a document in a template method called OpenDocument. OpenDocument defines each step for opening a document: it can check if the document can be opened, create a Document object, read the file, add the document to its set of documents. We call OpenDocument a template method because it defines an algorithm with some abstract steps (CreateDocument, DoRead) that subclasses must implement.

## Applicability

Use the Template Method pattern when:

- To implement the invariant parts of an algorithm once and leave it up to subclasses to implement the behavior that can vary
- Common behavior among subclasses should be factored and localized in a common class to avoid code duplication
- To control subclass extensions; you can define a template method that calls "hook" operations at specific points, thereby permitting extensions only at those points
- You want to invert control (Hollywood Principle)
- You have an algorithm with fixed steps but variable implementations

## Structure

```
AbstractClass
├── templateMethod() [final]
│   ├── primitiveOperation1()
│   ├── primitiveOperation2()
│   └── hook() [optional]
├── primitiveOperation1() [abstract]
└── primitiveOperation2() [abstract]
└── hook() [empty implementation - optional]

ConcreteClass extends AbstractClass
├── primitiveOperation1()
│   └── Specific implementation
└── primitiveOperation2()
    └── Specific implementation
└── hook() [optional override]
```

## Participants

- **AbstractClass**: Defines abstract primitive operations that concrete subclasses define to implement steps of an algorithm; implements a template method defining the skeleton of an algorithm; the template method calls primitive operations as well as operations defined in AbstractClass or those of other objects
- **ConcreteClass**: Implements the primitive operations to carry out subclass-specific steps of the algorithm

## Collaborations

- ConcreteClass relies on AbstractClass to implement the invariant steps of the algorithm

## Consequences

### Advantages

- **Code reuse**: Common code factored into base class
- **Inversion of control**: Base class calls operations of a subclass and not the other way around
- **Well-defined extension points**: Hook operations provide default behavior that subclasses can override if necessary
- **Open/Closed Principle**: Open for extension (subclasses) but closed for modification (template method)

### Disadvantages

- **Can lead to complex hierarchies**: Many primitive operations can make templates hard to understand
- **Difficult debugging**: Inverted control flow can make debugging difficult
- **Liskov violation**: If template method assumes too much about subclasses

## Implementation

### Considerations

1. **Using access control**: Template methods should be protected to be overridden; primitive operations can be protected for access only by template method

2. **Minimizing primitive operations**: The fewer primitive operations that need overriding, the easier for clients

3. **Naming conventions**: Can use conventions to identify operations that should be overridden

4. **Using final/sealed**: Template method can be marked final to prevent override

### Techniques

- **Hook Operations**: Operations with default empty implementation that can be overridden
- **Required vs Optional**: Distinguish mandatory operations (abstract) from optional (hook)
- [**Factory Method**](../creational/003_factory-method.md): Template Method often uses Factory Methods
- **Frozen Spots vs Hot Spots**: Template method is frozen spot; primitive operations are hot spots

## Known Uses

- **Framework Lifecycle Methods**: React (componentDidMount, render), Angular (ngOnInit)
- **HTTP Servlets**: service() method calls doGet(), doPost()
- **Unit Testing Frameworks**: setUp(), test(), tearDown()
- **Data Processing Pipelines**: extract(), transform(), load()
- **Game Loops**: initialize(), update(), render(), cleanup()
- **Sorting Algorithms**: Template for sort with variable compare method

## Related Patterns

- [**Factory Method**](../creational/003_factory-method.md): Often called by template methods
- [**Strategy**](009_strategy.md): Template Method uses inheritance to vary part of an algorithm; Strategy uses composition
- [**Command**](002_command.md): Commands can use template method to define execution structure
- [**Visitor**](011_visitor.md): Template Method can be used to define traversal skeleton

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): extension via subclassing
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separate invariant from variant
- [021 - Prohibition of Logic Duplication](../../clean-code/001_prohibition-logic-duplication.md): eliminates duplication in subclasses
- [001 - Single Level of Indentation](../../object-calisthenics/001_nivel-unico-indentacao.md): break into small methods

---

**Created on**: 2025-01-11
**Version**: 1.0
