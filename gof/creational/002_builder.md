# Builder

**Classification**: Creational Pattern

---

## Intent and Objective

Separate the construction of a complex object from its representation, so that the same construction process can create different representations. Allows building objects step-by-step, making the creation process more controlled and readable.

## Also Known As

- Constructor
- Assembler

## Motivation

An RTF document reader must convert RTF to multiple formats (ASCII, TeX, Widget). The problem is that the number of possible conversions is unlimited, and it would be impractical to add them all as methods in the reader class.

The solution is to configure the reader with a Builder object that knows how to convert RTF to a specific format. As the reader parses the document, it notifies the builder, which gradually constructs the final product. Different builders produce different representations.

## Applicability

Use the Builder pattern when:

- The algorithm for creating a complex object should be independent of the parts that compose the object and how they are assembled
- The construction process must allow different representations of the constructed object
- You need to construct objects with many optional parameters (avoid telescoping constructors)
- You want to ensure the object is only usable after its complete construction (immutability)
- Creating an object requires multiple steps or intermediate validations

## Structure

```
Director
├── Composes: Builder (interface)
└── construct()
    ├── builder.buildPartA()
    ├── builder.buildPartB()
    └── builder.buildPartC()

Builder (Interface)
├── buildPartA()
├── buildPartB()
└── getResult(): Product

ConcreteBuilder implements Builder
├── Maintains reference to Product being built
├── buildPartA() → configures part A of Product
├── buildPartB() → configures part B of Product
└── getResult() → returns final Product

Product
└── Complex object being constructed
```

## Participants

- [**Builder**](002_builder.md): Specifies abstract interface for creating parts of a Product object
- **ConcreteBuilder**: Constructs and assembles parts of the product; defines and maintains the representation it creates; provides interface for retrieving the product
- **Director**: Constructs an object using the Builder interface
- **Product**: Represents the complex object being constructed; ConcreteBuilder constructs internal representation and defines assembly process

## Collaborations

- Client creates Director object and configures it with desired Builder
- Director notifies builder whenever a part of the product should be built
- Builder handles requests from director and adds parts to the product
- Client retrieves product from builder

## Consequences

### Advantages

- **Allows varying internal representation**: Using different builders provides different representations
- **Isolates construction and representation code**: Encapsulates how a complex object is constructed and represented
- **Refined control over construction process**: Builds the product step-by-step, under director's control
- **Immutability**: Allows creating immutable objects elegantly
- **Centralized validation**: Can validate state before returning final product

### Disadvantages

- **Requires creating specific builder**: A ConcreteBuilder is needed for each different representation
- **Increases number of classes**: Adds complexity to design

## Implementation

### Considerations

1. **Assembly and construction interface**: Builders should be generic enough to allow different Directors
2. **Why no abstract product**: Products produced by builders can differ drastically, not having a common interface
3. **Empty methods as default**: Builder methods can have empty implementation by default (only necessary ones are overridden)
4. **Fluent Interface**: Builder can return `this` to allow method chaining
5. **Validation**: Perform validation in `getResult()` or `build()` method

### Techniques

- **Step Builder**: Ensure call order through intermediate interfaces
- **Named Parameters**: Simulate named parameters in languages that don't support them
- **Validation on Build**: Validate completeness and consistency before returning product

## Known Uses

- **StringBuilder/StringBuffer**: Construction of complex strings
- **Document Builders**: XML, JSON, HTML builders (DocumentBuilder, JsonBuilder)
- **HTTP Request Builders**: HTTP libraries (OkHttp, Retrofit)
- **Test Data Builders**: Creation of complex objects in tests
- **Query Builders**: Construction of SQL or NoSQL queries
- **Configuration Builders**: Creation of complex configuration objects

## Related Patterns

- [**Abstract Factory**](001_abstract-factory.md): Similar, but Abstract Factory returns product immediately, while Builder constructs step-by-step
- [**Composite**](../structural/003_composite.md): What the Builder frequently constructs
- [**Factory Method**](003_factory-method.md): Alternative when only one construction step
- [**Prototype**](004_prototype.md): Builder and Prototype can work together (clone and then build upon copy)
- [**Singleton**](005_singleton.md): Builder can be singleton if stateless

### Relation to Rules

- [033 - Limit of Parameters per Function](../../clean-code/013_limite-parametros-funcao.md): solves (avoids telescoping constructors)
- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): facilitates
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): reinforces
- [003 - Primitive Encapsulation](../../object-calisthenics/003_encapsulamento-primitivos.md): complements

---

**Created on**: 2025-01-11
**Version**: 1.0
