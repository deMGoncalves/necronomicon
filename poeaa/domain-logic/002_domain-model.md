# Domain Model

**Classification**: Domain Logic Pattern

---

## Intent and Purpose

Create an object model of the domain that incorporates both behavior and data. An interconnected network of objects where each object represents some meaningful entity in the problem domain, whether as large as a corporation or as small as an order line.

## Also Known As

- Rich Domain Model
- Object Model
- Domain Object Model

## Motivation

When business logic becomes complex, using Transaction Script results in duplicated code and makes maintenance difficult. Domain Model attacks this problem by moving logic into domain objects, where each object represents a business concept and contains related data and behavior.

In an order system, instead of a procedure that calculates order total, you have an Order object that knows its items and can calculate total by asking each item for its value. Each item knows its product and quantity and can calculate its own subtotal. Logic is distributed across objects that possess the necessary information.

As domain grows in complexity, Domain Model becomes more valuable. It captures complex business rules, validations, and domain invariants in a way that is easy to understand and modify. Inheritance and polymorphism allow expressing behavior variations elegantly.

## Applicability

Use Domain Model when:

- Domain logic is complex with many rules and interactions
- There is significant behavior associated with data
- Multiple strategies or behavior variations exist
- System will have a long life and needs to evolve
- Team has experience with object-oriented design
- Benefits of rich modeling outweigh additional complexity

## Structure

```
Client (Application/UI)
└── Uses: Domain Objects

Domain Objects
├── Entity (with identity)
│   ├── Order
│   │   ├── calculateTotal()
│   │   ├── addItem()
│   │   └── validate()
│   ├── Customer
│   │   ├── placeOrder()
│   │   └── creditCheck()
│   └── Product
│       └── isAvailable()
│
└── Value Object (without identity)
    ├── Money
    ├── DateRange
    └── Address

Data Mappers
└── Translate between: Domain Objects ↔ Database
```

## Participants

- **Entity**: Objects with identity that persists over time; contain data and behavior
- [**Value Object**](../base/006_value-object.md): Objects without conceptual identity; defined by attributes; immutable
- **Aggregate**: Cluster of objects treated as unit for data changes
- **Domain Service**: Operation that doesn't naturally belong to Entity or Value Object
- [**Repository**](../object-relational/016_repository.md): Mechanism for obtaining references to Aggregates
- **Factory**: Encapsulates complex creation of Domain Objects

## Collaborations

- Client interacts with Domain Objects through rich behavior interfaces
- Entities collaborate with each other through associations to implement business logic
- Value Objects are passed as parameters and returned from methods
- Domain Services orchestrate complex interactions between multiple objects
- Repository abstracts data access and returns fully formed objects
- Data Mappers move data between objects and database without objects knowing database

## Consequences

### Advantages

- **Manages complexity**: Handles rich and complex business logic well
- **Extensibility**: Easy to add new rules and behaviors
- **Maintainability**: Cohesive logic in appropriate objects; less duplication
- **Testability**: Domain objects can be tested in isolation
- **Expressiveness**: Model expresses business concepts clearly
- **Reuse**: Domain objects can be reused in different contexts

### Disadvantages

- **Initial complexity**: Requires more design and development effort upfront
- **Learning curve**: Requires knowledge of OO and domain-driven design
- **Object-relational impedance**: Mapping between objects and database can be complex
- **Performance overhead**: May have overhead compared to procedural approaches
- **Over-engineering**: Easy to create model more complex than necessary

## Implementation

### Considerations

1. **Identify Entities vs Value Objects**: Entities have identity; Value Objects are immutable and interchangeable
2. **Define Aggregates**: Group objects that must be consistent together
3. **Encapsulate invariants**: Ensure business rules through encapsulation
4. **Avoid anemia**: Objects should have significant behavior, not just getters/setters
5. **Manage associations**: Keep bidirectional associations consistent
6. **Separate persistence**: Domain Objects should be ignorant of how they are persisted

### Techniques

- **Ubiquitous Language**: Use same terminology in code and with domain experts
- **Strategic Design**: Identify Bounded Contexts and Context Maps
- **Tactical Patterns**: Apply patterns like Aggregate, Repository, Factory
- **Lazy Loading**: Load associations on demand for performance
- **Identity Management**: Use keys for Entity identity
- **Immutability**: Make Value Objects immutable

## Known Uses

- **E-commerce**: Order systems with complex pricing logic, promotions, inventory
- **Banking**: Banking systems with accounts, transactions, complex business rules
- **Insurance**: Insurance systems with policies, claims, underwriting rules
- **Healthcare**: Medical systems with patients, treatments, clinical protocols
- **ERP Systems**: Enterprise Resource Planning with rich, interconnected domains
- **Logistics**: Shipping and warehouse management systems

## Related Patterns

- [**Transaction Script**](001_transaction-script.md): Simpler alternative; Domain Model for complex logic
- [**Table Module**](003_table-module.md): Middle ground between Transaction Script and Domain Model
- [**Service Layer**](004_service-layer.md): Defines application interface over Domain Model
- [**Data Mapper**](../data-source/004_data-mapper.md): Maps Domain Objects to database
- [**Repository**](../object-relational/016_repository.md): Abstracts access to Aggregates
- [**Unit of Work**](../object-relational/001_unit-of-work.md): Manages transactions over Domain Objects
- [**Identity Map**](../object-relational/002_identity-map.md): Ensures object is loaded only once

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each object one responsibility
- [008 - Prohibition of Getters/Setters](../../object-calisthenics/008_proibicao-getters-setters.md): rich Domain Model, not anemic
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): objects with behavior
- [003 - Encapsulation of Primitives](../../object-calisthenics/003_encapsulamento-primitivos.md): Value Objects
- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): immutable Value Objects

---

**Created**: 2025-01-11
**Version**: 1.0
