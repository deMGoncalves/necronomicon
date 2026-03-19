# Iterator

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Provide a way to access the elements of an aggregate object sequentially without exposing its underlying representation. Decouples algorithms from containers, allowing you to traverse collections without knowing their internal structure.

## Also Known As

- Cursor

## Motivation

An aggregate object like a list should provide a way to access its elements without exposing its internal structure. Moreover, you may want to traverse the list in different ways. But you don't want to bloat the List interface with different traversal operations. You may also need more than one traversal pending on the same list.

The Iterator pattern lets you do all this. The key idea is to take the responsibility for access and traversal out of the list object and put it into an iterator object. The Iterator class defines an interface for accessing elements. An Iterator instance keeps track of the current element and which ones have been traversed.

## Applicability

Use the Iterator pattern when:

- Access contents of an aggregate object without exposing its internal representation
- Support multiple traversals of aggregate objects
- Provide a uniform interface for traversing different aggregate structures (polymorphic iteration)
- Decouple algorithms from data structures
- Implement lazy evaluation of collections

## Structure

```
Client
└── Uses: Iterator, Aggregate

Aggregate (Interface)
└── createIterator(): Iterator

ConcreteAggregate implements Aggregate
├── Maintains: internal elements
└── createIterator() → return new ConcreteIterator(this)

Iterator (Interface)
├── hasNext(): boolean
├── next(): Element
└── remove() (optional)

ConcreteIterator implements Iterator
├── Composes: ConcreteAggregate
├── Maintains: current position
├── hasNext() → checks if there's next
└── next() → returns next and advances
```

## Participants

- [**Iterator**](004_iterator.md): Defines interface for accessing and traversing elements
- **ConcreteIterator**: Implements the Iterator interface; keeps track of the current position in the traversal of the aggregate
- **Aggregate**: Defines interface for creating an Iterator object
- **ConcreteAggregate**: Implements the Iterator creation interface to return an instance of the proper ConcreteIterator

## Collaborations

- ConcreteIterator keeps track of the current object in the aggregate and can compute the succeeding item in the traversal

## Consequences

### Advantages

- **Supports variations in traversal**: Complex aggregates can be traversed in many ways; can define new iterators without changing aggregate
- **Simplifies the Aggregate interface**: Don't need traversal operations on Aggregate
- **More than one traversal can be pending**: Each iterator maintains its own traversal state

### Disadvantages

- **Overhead**: For simple collections may be unnecessary overhead
- **Direct access**: May be slower than direct index access

## Implementation

### Considerations

1. **Who controls the iteration**: External iterator (client controls) vs internal iterator (iterator controls)

2. **Who defines the traversal algorithm**: Iterator or Aggregate; having it in the iterator allows different algorithms; having it in the aggregate avoids duplication

3. **Robustness of iterator**: Modifications to the aggregate during iteration can be dangerous; solution: copy aggregate or register iterator in aggregate

4. **Additional Iterator operations**: Can have previous(), currentItem(), skipTo(), etc.

5. **Using iterators in typed languages**: Use generics/templates

6. **Null iterators**: Have null object iterator for empty collections

7. **Privileged access**: Iterator may need privileged access to the aggregate's internal structure

### Techniques

- **Internal Iterator**: Iterator controls iteration (forEach)
- **External Iterator**: Client controls iteration (hasNext/next)
- **Fail-fast Iterator**: Throw exception if aggregate is modified during iteration
- **Generator/Yield**: Lazy iterators using coroutines

## Known Uses

- **Java Collections**: `Iterator` interface, enhanced for-loop
- **JavaScript**: Iteration protocol (`Symbol.iterator`), for-of loops
- **Python**: `__iter__` and `__next__` protocol, generators
- **C++ STL**: Iterators for all containers
- **Database Cursors**: Iterate over result sets
- **File Readers**: Read files line by line

## Related Patterns

- [**Composite**](008_composite.md): Iterators often applied to recursive structures
- [**Factory Method**](../creational/003_factory-method.md): Aggregate uses Factory Method to instantiate appropriate iterators
- [**Memento**](006_memento.md): Can use with Iterator to capture iteration state
- [**Visitor**](011_visitor.md): Visitor can use Iterator to traverse structure
- [**Strategy**](009_strategy.md): Iterator can be seen as Strategy for accessing collections

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separate iteration from collection
- [004 - First-Class Collections](../../object-calisthenics/004_colecoes-primeira-classe.md): iterator encapsulates access
- [036 - Function Side Effects Restriction](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md): iteration without side effects

---

**Created on**: 2025-01-11
**Version**: 1.0
