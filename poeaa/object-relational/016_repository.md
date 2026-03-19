# Repository

**Type**: Object-Relational Mapping Pattern (Metadata)

---

## Intent and Purpose

Mediate between domain and data mapping layers using a collection-like interface to access domain objects, encapsulating all persistence and query logic.

## Also Known As

- Collection-Like Interface
- Persistence Mediator
- Domain Object Store

---

## Motivation

In applications with rich domain logic, domain code frequently needs to retrieve and store objects (e.g., fetch all orders from a customer, save a new product). If domain code depends directly on Data Mappers or accesses the database directly, it becomes polluted with infrastructure details and coupled to the persistence strategy.

Repository solves this problem by providing an interface that simulates an in-memory collection of domain objects. From the domain code's perspective, a Repository is like a `Set<Order>` — you can add, remove, and search for orders without knowing anything about SQL, Data Mappers, or database details. For example: `repository.add(newOrder)`, `repository.findById(id)`, `repository.findByCustomer(customerId)`.

Internally, the Repository delegates to Data Mappers, Query Objects, and manages Identity Maps and Unit of Work. It centralizes all data access logic for an aggregate type, providing rich, domain-specific search methods. This keeps the domain clean, testable (Repositories can be mocked), and allows changing the persistence implementation without affecting the domain.

---

## Applicability

Use Repository when:

- You have a rich Domain Model and want to keep it free of persistence code
- Multiple data sources (database, cache, external API) need to be accessed uniformly
- You want to centralize complex query logic instead of scattering it across the domain
- The persistence strategy may change (switch ORM, migrate to NoSQL) and you want to isolate the impact
- You need domain-specific search methods (e.g., `findActive()`, `findExpiringOn(date)`)
- Testability is important — Repositories are easily mockable for unit tests

---

## Structure

```
┌──────────────────────────────────────────────────────────────┐
│                  Domain Layer (Client)                       │
│                                                              │
│  service = new OrderService(orderRepository)                 │
│  order = orderRepository.findById(123)                       │
│  order.approve()                                             │
│  orderRepository.save(order)                                 │
└────────────────────────────┬─────────────────────────────────┘
                             │ uses
                ┌────────────▼────────────┐
                │   <<interface>>         │
                │   IOrderRepository      │
                │ ─────────────────────   │
                │ + findById(id): Order   │
                │ + findByCustomer(id): []│
                │ + findActive(): []      │
                │ + add(order): void      │
                │ + remove(order): void   │
                └────────────△────────────┘
                             │ implements
                ┌────────────┴────────────┐
                │  OrderRepositoryImpl    │
                │ ─────────────────────   │
                │ - mapper: OrderMapper   │
                │ - identityMap: Map      │
                │ - unitOfWork: UoW       │
                │ + findById(id): Order   │
                │ + findByCustomer(id): []│
                └────────────┬────────────┘
                             │ uses
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────▼──────┐  ┌────────▼────────┐  ┌─────▼────────┐
│ Data Mapper    │  │ Identity Map    │  │ Unit of Work │
│ (SQL/ORM)      │  │ (Cache)         │  │ (Tracking)   │
└────────────────┘  └─────────────────┘  └──────────────┘
```

---

## Participants

- **Repository Interface** (`IOrderRepository`): Defines contract for accessing domain objects. Methods are expressed in domain terms, not persistence (e.g., `findExpiringToday()` not `SELECT * WHERE...`).

- **Concrete Repository** (`OrderRepositoryImpl`): Implements the interface, coordinating Data Mappers, Identity Map, Unit of Work, and Query Objects to execute persistence operations.

- **Domain Objects** (`Order`, `Customer`): Business objects that are completely agnostic of how they're persisted. They have no infrastructure dependencies.

- [**Data Mapper**](../data-source/004_data-mapper.md): Performs the actual work of translating domain objects to database records and vice versa. The Repository delegates to Mappers.

- [**Identity Map**](002_identity-map.md): Maintains cache of already loaded objects to ensure a single instance represents each entity (object identity).

- **Unit of Work**: Tracks changes to objects loaded via Repository to coordinate transactional persistence.

---

## Collaborations

When domain code (e.g., Service Layer) requests `repository.findById(123)`, the Repository first consults the Identity Map. If the object is cached, it returns it immediately. If not, it delegates to the Data Mapper which executes SELECT on the database, constructs the Order object, registers it in the Identity Map, and returns it.

For `repository.save(order)`, if the Repository is integrated with Unit of Work, it only registers the object in the UoW as modified. The UoW decides when to flush (commit) and coordinates with Mappers to generate appropriate SQL (INSERT or UPDATE). If not using UoW, the Repository directly invokes `mapper.update(order)`.

Specific search methods (`findByCustomer(customerId)`) build Query Objects or delegate to specialized Mapper methods that execute custom queries returning lists of objects.

---

## Consequences

### Advantages

1. **Domain Isolation**: Domain code contains no SQL, ORM, or persistence details — remains pure.
2. **Domain-Oriented Interface**: Search methods express business concepts (`findOverdue()`) instead of generic SQL.
3. **Testability**: Repositories can be easily mocked for unit testing domain services.
4. **Query Centralization**: All data access logic for an aggregate is in a single place, easy to maintain.
5. **Implementation Swapping**: Replacing persistence (SQL → NoSQL, ORM → custom) doesn't affect domain code.
6. **Transparent Caching**: Identity Map and second-level cache can be managed internally by the Repository.

### Disadvantages

1. **Additional Layer**: Adds abstraction between domain and persistence, increasing number of classes.
2. **Performance Overhead**: Each operation passes through multiple layers (Repository → Mapper → SQL), adding cost.
3. **Generic Repository Temptation**: Generic repositories (`IRepository<T>`) lose domain-specific methods and become just CRUD.
4. **Aggregate Complexity**: Defining aggregate boundaries to determine when to use separate Repositories can be difficult.
5. **Query Method Duplication**: Specific search methods can proliferate, creating many similar methods.

---

## Implementation

### Implementation Considerations

1. **One Repository per Aggregate**: Create Repositories for aggregate roots (e.g., `OrderRepository`), not for internal entities (e.g., don't create `OrderItemRepository`).

2. **Domain-Specific Methods**: Avoid generic methods (`findByCriteria()`). Prefer methods that express business intent (`findPendingApproval()`).

3. **Return Collections vs Iterators**: For large results, consider returning Iterators or Streams instead of materializing complete lists in memory.

4. **Unit of Work Integration**: Decide if Repository coordinates with Unit of Work (save only registers changes) or operates independently (save persists immediately).

5. [**Identity Map**](002_identity-map.md): Repositories should use Identity Map to ensure `findById(1)` called twice returns the same object instance.

6. **Specification Pattern**: For dynamic queries, accept Specifications as parameters: `findAll(specification)`.

### Implementation Techniques

1. **Segregated Interface**: Define narrow interfaces per aggregate (`IOrderRepository`), not a generic interface for all.

2. **Query Methods Naming**: Use naming conventions to generate queries automatically (Spring Data JPA): `findByNameAndStatus(name, status)`.

3. **Read-Only Repositories**: For pure queries, create separate repositories that return DTOs, not mutable entities.

4. **Batch Operations**: Provide methods for batch operations: `addAll(List<Order>)`, `removeAll(Specification)`.

5. **Async Repositories**: In high-performance systems, return `CompletableFuture<Order>` or `Observable<Order>` for asynchronous operations.

6. **Repository Base Class**: Create abstract class `AbstractRepository<T>` with common implementations (findById, cache) to reduce duplication.

---

## Known Uses

1. **Spring Data JPA**: Framework that automatically generates Repository implementations from interfaces with naming conventions.

2. **Domain-Driven Design**: Eric Evans popularized Repository as a central pattern for accessing aggregates in DDD.

3. **Entity Framework (C#)**: `DbSet<T>` acts as Repository, providing collection-like interface for entities.

4. **Doctrine ORM (PHP)**: `EntityRepository` provides search methods for entities with Query Builder support.

5. **NHibernate**: Allows creating custom Repositories that encapsulate `ISession` and provide domain methods.

6. **Axon Framework**: In CQRS/Event Sourcing, Repositories manage aggregates by loading events and persisting new events.

---

## Related Patterns

- [**Data Mapper**](../data-source/004_data-mapper.md): Repository delegates to Data Mappers to execute actual persistence operations.
- [**Identity Map**](002_identity-map.md): Repositories use Identity Map to cache objects and ensure object identity.
- [**Unit of Work**](001_unit-of-work.md): Coordinates with Repository to track changes and persist transactionally.
- [**Query Object**](015_query-object.md): Repositories can use Query Objects internally to build complex queries.
- [**Lazy Load**](003_lazy-load.md): Repositories can return lazy proxies to avoid loading complete objects immediately.
- **Specification** (DDD): Repositories accept Specifications for dynamic and composed queries.
- [**Service Layer**](../domain-logic/004_service-layer.md): Services use Repositories to access data without knowing persistence details.

### Relation with Rules

- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): persistence interface
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): encapsulate data access
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): focused interface

---

## Business Rules Relationship

- **[014] Dependency Inversion Principle**: Domain depends on abstraction (Repository interface), not persistence details.
- **[010] Single Responsibility Principle**: Repository has single responsibility of mediating access to aggregates of one type.
- **[022] Prioritization of Simplicity and Clarity**: Collection-like interface is clearer than exposing SQL/ORM to domain.
- **[043] Backing Services as Resources**: Database is treated as attachable resource through Repository abstraction.

---

**Created on**: 2025-01-10
**Version**: 1.0
