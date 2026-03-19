# Composite

**Classification**: Structural Pattern

---

## Intent and Objective

Compose objects into tree structures to represent part-whole hierarchies. Composite lets clients treat individual objects and compositions of objects uniformly.

## Also Known As

- Composite Object

## Motivation

Graphical applications allow constructing complex diagrams from simple components. The user can group components to form larger components which can be grouped again. A simple implementation could define classes for graphical primitives and container classes that act as composites.

The problem is that code using these classes needs to treat primitive objects and containers differently, even though most of the time it treats both identically. Composite solves this by defining an abstract Component class that represents both primitives and containers. Primitives are leaves, containers are composites.

## Applicability

Use the Composite pattern when:

- You want to represent part-whole hierarchies of objects
- You want clients to ignore the difference between compositions of objects and individual objects
- The structure can have any level of complexity and is dynamic
- You need to apply operations over the entire hierarchical structure
- You have objects with recursive behaviors (trees, menus, file systems)

## Structure

```
Client
└── Uses: Component (Interface)
    ├── operation()
    └── add/remove(Component)

Component (Interface)
├── operation()
├── add(Component)
└── remove(Component)

Leaf implements Component
└── operation() → implementation for leaf

Composite implements Component
├── Maintains: List<Component> children
├── operation()
│   └── For each child: child.operation()
├── add(Component) → adds to children
└── remove(Component) → removes from children
```

## Participants

- **Component**: Declares interface for objects in composition; implements default behavior common to all classes; declares interface for accessing and managing child components; (optional) defines interface for accessing parent
- **Leaf**: Represents leaf objects (no children); defines behavior for primitive objects
- [**Composite**](003_composite.md): Defines behavior for components with children; stores children; implements child-related operations in Component interface
- **Client**: Manipulates objects in composition through Component interface

## Collaborations

- Clients use Component interface to interact with objects in composite structure
- If recipient is Leaf, request is handled directly
- If recipient is Composite, it usually forwards requests to children, possibly performing additional operations before/after

## Consequences

### Advantages

- **Defines class hierarchies**: Primitive objects can be composed into complex objects recursively
- **Simplifies client**: Client treats all objects uniformly
- **Makes it easy to add new components**: New Leafs or Composites work automatically with existing structures and code
- **Promotes Single Responsibility**: Each component has single responsibility

### Disadvantages

- **Can make design too general**: Makes it hard to restrict components of composite
- **Overhead**: Operations need to check child type
- **Difficulty in restricting children**: Components can accept any child

## Implementation

### Considerations

1. **Explicit parent references**: Maintaining child-to-parent reference simplifies traversal and Chain of Responsibility implementation

2. **Sharing components**: Difficult when components have only one parent; Flyweight can help

3. **Maximizing Component interface**: Place maximum of common operations in Component; may need to override operations that don't make sense in Leaf

4. **Declaring child management operations**: Declare in Component (transparency) vs declare only in Composite (safety)

5. **Ordering children**: When order matters, careful design of access and management interface

6. **Caching**: Composite can cache results of traversals or searches

7. **Visitor for operations**: When specific operations on composite structure, use Visitor

### Techniques

- **Type Safety**: In typed languages, use generics/templates to restrict child types
- **Null Object Pattern**: Use Null Object instead of null for nonexistent children
- **Iterator Pattern**: Provide iterators for tree traversal

## Known Uses

- **File Systems**: Directories (Composite) and files (Leaf)
- **GUI Components**: Containers (panels, windows) and widgets (buttons, labels)
- **Organization Charts**: Organizations composed of departments and employees
- **Document Structure**: Documents with paragraphs, sections, chapters
- **Menu Systems**: Menus containing items and submenus
- **Expression Trees**: Syntax trees in compilers

## Related Patterns

- [**Chain of Responsibility**](013_chain-of-responsibility.md): Often used with Composite; component can pass request to its parent
- [**Decorator**](004_decorator.md): Often used together; both share similar diagrams; Decorator adds responsibilities, Composite aggregates children
- [**Flyweight**](006_flyweight.md): Allows sharing components but they can't reference parents
- [**Iterator**](016_iterator.md): Used for traversing composites
- [**Visitor**](../clean-code/003_visitor.md): Localizes operations that would otherwise be distributed across Composite and Leaf classes

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): easy to add new components
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): Leaf and Composite interchangeable
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each component has single responsibility
- [004 - First-Class Collections](../../object-calisthenics/004_colecoes-primeira-classe.md): Composite encapsulates collection

---

**Created on**: 2025-01-11
**Version**: 1.0
