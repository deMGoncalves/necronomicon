# Factory Method

**Classification**: Creational Pattern

---

## Intent and Objective

Define an interface for creating an object, but let subclasses decide which class to instantiate. Factory Method lets a class defer instantiation to subclasses, promoting loose coupling between the creator and concrete products.

## Also Known As

- Virtual Constructor

## Motivation

Frameworks use abstract classes to define and maintain relationships between objects. A framework for applications that can present multiple documents to the user defines abstractions like Application and Document, but leaves the creation of concrete documents to specific subclasses.

The Application class is responsible for managing Documents but doesn't know which specific type to create - this depends on the concrete application. Factory Method allows Application to define the creation interface but delegate the decision about which Document class to instantiate to subclasses.

## Applicability

Use the Factory Method pattern when:

- A class cannot anticipate the class of objects it must create
- A class wants its subclasses to specify the objects it creates
- Classes delegate responsibility to one of several helper subclasses, and you want to localize the knowledge of which helper subclass is the delegate
- You want to provide users of your library with a way to extend internal components
- Replace constructors with named methods that describe the creation

## Structure

```
Creator (Abstract Class/Interface)
├── factoryMethod(): Product (abstract)
└── operation()
    ├── product = factoryMethod()
    └── uses product

ConcreteCreatorA extends Creator
└── factoryMethod() → returns new ConcreteProductA()

ConcreteCreatorB extends Creator
└── factoryMethod() → returns new ConcreteProductB()

Product (Interface)
├── ConcreteProductA implements Product
└── ConcreteProductB implements Product
```

## Participants

- **Product**: Defines interface of objects the factory method creates
- **ConcreteProduct**: Implements the Product interface
- **Creator**: Declares the factory method that returns Product type object; may define default implementation that returns default ConcreteProduct; may call factory method to create Product
- **ConcreteCreator**: Overrides factory method to return instance of ConcreteProduct

## Collaborations

- Creator relies on its subclasses to define the factory method so it returns appropriate instance of ConcreteProduct

## Consequences

### Advantages

- **Eliminates coupling**: Code doesn't depend on concrete classes, only on interfaces
- **Open/Closed Principle**: Code open for extension, closed for modification
- **Single Responsibility**: Creation code moved to a single place
- **Naming**: Factory methods with descriptive names are clearer than constructors
- **Polymorphism**: Replaces conditionals with polymorphism

### Disadvantages

- **Class hierarchy**: May lead to many small subclasses
- **Complexity**: Code can become more complicated with many additional classes

## Implementation

### Considerations

1. **Two main varieties**:
   - Creator is abstract class without default implementation of factory method
   - Creator is concrete class with default implementation

2. **Parameterized factory methods**: Accepts parameter identifying type of object to create

3. **Naming conventions**: `createProduct()`, `newProduct()`, `makeProduct()`

4. **Using templates**: In typed languages, use generics/templates to avoid subclassing

5. **Lazy initialization**: Factory method can implement lazy creation

### Techniques

- **Static Factory Method**: Static method that returns instances (not the pure pattern, but useful)
- **Named Constructor**: Factory methods with descriptive names that replace constructors
- **Registry of Factories**: Maintain registry of available creators

## Known Uses

- **Collection Factories**: `Array.from()`, `List.of()`, `Map.of()`
- **GUI Frameworks**: Creation of platform-specific components
- **Loggers**: `LoggerFactory.getLogger()`
- **Database Connections**: `ConnectionFactory.createConnection()`
- **Parser Factories**: Creation of specific parsers (XML, JSON)
- **Iterator Creation**: `collection.iterator()`

## Related Patterns

- [**Abstract Factory**](001_abstract-factory.md): Frequently implemented using Factory Methods
- [**Template Method**](../behavioral/010_template-method.md): Factory Methods are frequently called within Template Methods
- [**Prototype**](004_prototype.md): Doesn't require inheritance but requires initialize operation; Factory Method requires inheritance but not initialize
- [**Singleton**](005_singleton.md): Can use Factory Method to control single instantiation
- [**Builder**](002_builder.md): Focuses on building complex objects step-by-step; Factory Method creates objects in a single call

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): implements
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): reinforces
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): eliminates (replaces with polymorphism)
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): reinforces

---

**Created on**: 2025-01-11
**Version**: 1.0
