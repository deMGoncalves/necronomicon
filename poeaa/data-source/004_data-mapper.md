# Data Mapper

**Classification**: Data Source Architectural Pattern

---

## Intent and Purpose

A layer of Mappers that moves data between objects and database while keeping them independent of each other and the mapper itself. Completely separates domain objects from persistence logic.

## Also Known As

- Object-Relational Mapper (ORM)
- Persistence Layer
- Data Access Layer

## Motivation

When Domain Model is rich and complex, keeping domain objects independent of database is crucial. Data Mapper solves this by creating an intermediate layer responsible exclusively for transferring data between objects and database, allowing both to evolve independently.

Domain objects don't know about database - they have no save(), delete() methods, or any reference to persistence. They are pure POJOs (Plain Old Objects) with rich business logic. Data Mapper knows both sides: understands domain object structure and database structure, translating between the two.

For example, an Order object may have a collection of OrderItems, Money value, relationship with Customer. OrderMapper knows how to decompose Order into multiple tables (orders, order_items), convert Money to decimal fields, and resolve relationships via foreign keys. When client requests Order, Mapper executes necessary queries, constructs complete object graph, and returns fully formed Order. Domain remains pure.

## Applicability

Use Data Mapper when:

- Domain Model is complex with rich business logic
- Database schema differs significantly from object structure
- Persistence ignorance is important design requirement
- Testability of domain logic without database is priority
- Domain-Driven Design (DDD) is chosen architectural approach
- Object-relational impedance mismatch is significant

## Structure

```
Client (Application Layer)
└── Uses: Domain Objects (persistence ignorant)

Domain Layer
├── Order (Entity - no persistence knowledge)
│   ├── Properties: id, customer, items, total
│   ├── addItem(product, quantity)
│   ├── calculateTotal()
│   └── ship()
├── Customer (Entity)
│   └── placeOrder(items)
└── Money (Value Object)
    └── add(money), multiply(factor)

Data Mapper Layer
├── OrderMapper
│   ├── find(id): Order
│   ├── insert(order)
│   ├── update(order)
│   ├── delete(order)
│   └── Knows: how to decompose Order into tables
├── CustomerMapper
│   ├── find(id): Customer
│   └── Maps: Customer ↔ database
└── ProductMapper
    └── find(id): Product

Supporting Patterns
├── Unit of Work (manages transactions)
├── Identity Map (ensures unique identity)
└── Lazy Load (loads data on demand)

Database
└── Relational tables
```

## Participants

- **Domain Objects**: Entities and Value Objects without persistence knowledge
- [**Data Mapper**](004_data-mapper.md): Class responsible for moving data between objects and database
- **Finder Methods**: Methods that load objects from database (find, findBy)
- **Persistence Methods**: Methods that save/update/delete objects (insert, update, delete)
- **Metadata**: Information about mapping between objects and tables
- **Unit of Work**: Manages changes and transactions (frequently used with Mapper)
- [**Identity Map**](../object-relational/002_identity-map.md): Ensures object is loaded only once

## Collaborations

- Client obtains reference to Domain Object via Repository or Service Layer
- Repository delegates to Data Mapper to load object
- Mapper queries Identity Map to verify if object is already loaded
- If not loaded, Mapper executes SELECT SQL
- Mapper constructs Domain Object from returned data
- Mapper registers object in Identity Map and returns to Client
- Client works with Domain Object invoking business methods
- When changes are made, Unit of Work tracks modified objects
- On commit, Unit of Work consults Mappers to persist changes
- Mapper translates object back to SQL UPDATE/INSERT/DELETE

## Consequences

### Advantages

- **Persistence ignorance**: Domain Model completely independent of database
- **Testability**: Domain objects testable without database
- **Flexibility**: Database schema can change without affecting objects
- **Rich Domain Model**: Allows complex OO design without database constraints
- **Clear separation**: Well-separated responsibilities between layers
- **Independent evolution**: Domain and persistence evolve separately

### Disadvantages

- **Complexity**: Significant additional layer; more code to write
- **Performance overhead**: Translation between objects and database has cost
- **Learning curve**: More difficult to understand and implement
- **Metadata**: Requires configuration or metadata for mapping
- **Debugging**: More difficult to debug with extra indirection layer
- **Overhead for simple cases**: Overkill for simple CRUD

## Implementation

### Considerations

1. [**Metadata Mapping**](../object-relational/014_metadata-mapping.md): Define how objects map to tables (annotations, XML, code)
2. [**Identity Map**](../object-relational/002_identity-map.md): Implement to ensure object identity
3. **Unit of Work**: Use to manage transactions and changes
4. **Lazy Loading**: Decide when to load relationships
5. **Cascade operations**: Define how changes propagate
6. **Query interface**: Provide API for complex queries

### Techniques

- [**Identity Field**](../object-relational/004_identity-field.md): Use IDs to correlate objects with rows
- [**Foreign Key Mapping**](../object-relational/005_foreign-key-mapping.md): Map relationships via foreign keys
- [**Association Table Mapping**](../object-relational/006_association-table-mapping.md): Map many-to-many relations
- [**Embedded Value**](../object-relational/008_embedded-value.md): Map Value Objects to columns
- [**Dependent Mapping**](../object-relational/007_dependent-mapping.md): Map dependent objects
- [**Metadata Mapping**](../object-relational/014_metadata-mapping.md): Use metadata to configure mapping
- [**Query Object**](../object-relational/015_query-object.md): Encapsulate complex queries in objects

## Known Uses

- **Hibernate (Java)**: Full ORM using Data Mapper
- **Entity Framework (.NET)**: Microsoft ORM with Data Mapper
- **Doctrine (PHP)**: PHP ORM using Data Mapper pattern
- **SQLAlchemy (Python)**: Python ORM with Data Mapper
- **TypeORM (TypeScript)**: TypeScript ORM with Data Mapper support
- **Sequelize (Node.js)**: Node ORM with Data Mapper aspects

## Related Patterns

- [**Domain Model**](../domain-logic/002_domain-model.md): Data Mapper persists rich Domain Model
- [**Active Record**](003_active-record.md): Alternative that mixes persistence with domain
- [**Unit of Work**](../object-relational/001_unit-of-work.md): Manages transactions over mapped objects
- [**Identity Map**](../object-relational/002_identity-map.md): Maintains unique object identity
- [**Lazy Load**](../object-relational/003_lazy-load.md): Loads data on demand
- [**Repository**](../object-relational/016_repository.md): High-level interface over Data Mapper
- [**Query Object**](../object-relational/015_query-object.md): Encapsulates complex queries
- [**Metadata Mapping**](../object-relational/014_metadata-mapping.md): Configures mapping

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separates persistence from domain
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): domain doesn't depend on infra
- [032 - Test Coverage](../../clean-code/012_cobertura-teste-minima-qualidade.md): facilitates unit testing
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): objects with rich behavior

---

**Created**: 2025-01-11
**Version**: 1.0
