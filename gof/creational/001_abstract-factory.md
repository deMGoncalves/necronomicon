# Abstract Factory

**Classification**: Creational Pattern

---

## Intent and Objective

Provide an interface for creating families of related or dependent objects without specifying their concrete classes. Allows the system to be independent of how its products are created, composed, and represented.

## Also Known As

- Kit

## Motivation

Consider a graphical interface system that supports multiple visual styles (look-and-feel). To ensure portability across different platforms, the application code should not directly instantiate platform-specific widgets (like `WindowsButton` or `MacButton`).

Abstract Factory solves this problem by defining an abstract interface for creating each type of widget. Each platform implements its own concrete factory that creates widgets in the appropriate style. Client code uses only the abstract interfaces, becoming platform-independent.

## Applicability

Use the Abstract Factory pattern when:

- A system must be independent of how its products are created, composed, and represented
- A system must be configured with one of multiple families of related products
- A family of related objects was designed to be used together, and you need to enforce this constraint
- You want to provide a class library of products and want to reveal only their interfaces, not their implementations
- The lifetime of dependencies is shorter than that of the consumer

## Structure

```
AbstractFactory (Interface)
├── createProductA(): AbstractProductA
└── createProductB(): AbstractProductB

ConcreteFactory1 implements AbstractFactory
├── createProductA() → ProductA1
└── createProductB() → ProductB1

ConcreteFactory2 implements AbstractFactory
├── createProductA() → ProductA2
└── createProductB() → ProductB2

Client
└── Uses only: AbstractFactory, AbstractProductA, AbstractProductB
```

## Participants

- **AbstractFactory**: Declares interface for operations that create abstract product objects
- **ConcreteFactory**: Implements operations to create concrete product objects
- **AbstractProduct**: Declares interface for a type of product object
- **ConcreteProduct**: Defines a product object to be created by the corresponding concrete factory; implements the AbstractProduct interface
- **Client**: Uses only interfaces declared by AbstractFactory and AbstractProduct classes

## Collaborations

- Normally a single instance of ConcreteFactory is created at runtime
- AbstractFactory delegates product object creation to its ConcreteFactory subclass
- Client remains independent of concrete classes, working only with abstractions

## Consequences

### Advantages

- **Isolates concrete classes**: Helps control the classes of objects created by the application
- **Facilitates exchanging product families**: The concrete factory class appears only once, making changes easy
- **Promotes consistency among products**: When objects in a family are designed to work together, this is guaranteed
- **Respects Open/Closed Principle**: New families can be added without modifying client code

### Disadvantages

- **Difficult to support new product types**: Extending AbstractFactory to produce new types requires changes throughout the hierarchy
- **Increases complexity**: Introduces multiple additional interfaces and classes

## Implementation

### Considerations

1. **Factories as Singleton**: Typically only one instance of ConcreteFactory is needed
2. **Creating products**: AbstractFactory only declares interface; ConcreteFactory implements actual creation
3. **Defining extensible factories**: Adding a parameter to the creation method allows creating different types without extending the interface

### Techniques

- Use Factory Method to implement creation methods
- Use Prototype to implement factories, eliminating the need for subclasses
- Factory can be initialized through configuration or registry

## Known Uses

- **UI Frameworks**: Java Swing (UIManager), Qt (QStyle)
- **Databases**: ADO.NET (DbProviderFactory), JDBC (DriverManager)
- **Application Themes**: Systems that support multiple visual themes
- **Cross-platform toolkits**: Libraries that abstract differences between platforms
- **Game Engines**: Creation of entity families (enemies, obstacles) per level

## Related Patterns

- [**Factory Method**](003_factory-method.md): Abstract Factory is often implemented using Factory Methods
- [**Prototype**](004_prototype.md): Can use Prototype to implement factory creation methods
- [**Singleton**](005_singleton.md): Concrete factories are often Singletons
- [**Builder**](002_builder.md): Alternative pattern when creation is complex and step-by-step
- [**Facade**](../structural/005_facade.md): Abstract Factory can be used with Facade to provide an interface for creating subsystem objects

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): reinforces
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): implements
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): reinforces

---

**Created on**: 2025-01-11
**Version**: 1.0
