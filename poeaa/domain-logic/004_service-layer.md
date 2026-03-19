# Service Layer

**Classification**: Domain Logic Pattern

---

## Intent and Purpose

Define application boundary with a service layer that establishes a set of available operations and coordinates application response in each operation. Encapsulates application logic and controls transactions.

## Also Known As

- Application Service Layer
- Use Case Layer
- Application Facade

## Motivation

Enterprise applications typically expose functionality through multiple interfaces - web application, REST API, mobile interface, batch processes. Each interface needs the same business operations but in different contexts. Without Service Layer, business logic gets duplicated or scattered across presentation layers.

Service Layer defines the application boundary by establishing a set of available operations and coordinating response in each operation. When a client requests to create an order, Service Layer initiates transaction, validates data, coordinates necessary domain objects (Customer, Product, Order), persists changes, and commits transaction. Client doesn't need to know internal complexity.

This approach creates a single entry point for application logic, facilitating transaction control, security, authorization, and auditing. Service Layer can be thin (merely delegating to Domain Model) or thicker (containing significant coordination logic), depending on complexity.

## Applicability

Use Service Layer when:

- Application has multiple types of clients (web, mobile, API, batch)
- Business logic needs to be reused across different interfaces
- Transaction management needs to be centralized and consistent
- Clear application boundary facilitates testing and maintenance
- Security and authorization need to be applied uniformly
- Integration with external systems requires well-defined interface

## Structure

```
Clients (multiple types)
├── Web UI
├── Mobile App
├── REST API
└── Batch Jobs
    └── All call: Service Layer

Service Layer
├── OrderService
│   ├── createOrder(orderData)
│   ├── cancelOrder(orderId)
│   └── shipOrder(orderId)
├── CustomerService
│   ├── registerCustomer(customerData)
│   └── updateProfile(customerId, data)
└── ProductService
    ├── addProduct(productData)
    └── updateInventory(productId, quantity)

    └── Each service:
        ├── Initiates transaction
        ├── Coordinates Domain Objects
        ├── Applies business rules
        └── Commits/rollbacks transaction

Domain Layer
├── Domain Model (Entities, Value Objects)
└── Domain Services

Data Source Layer
└── Repositories, Data Mappers
```

## Participants

- **Service Layer Interface**: Defines contracts of available application operations
- **Application Service**: Implements application operations; coordinates work
- **Domain Objects**: Entities and Value Objects that execute domain logic
- **Domain Services**: Domain operations that don't belong to entities
- **Repositories**: Provide access to persisted aggregates
- **Transaction Manager**: Manages transactional boundaries
- **Clients**: Presentation layer, APIs, other systems that invoke services

## Collaborations

- Client invokes operation on Application Service through interface
- Service initiates transaction and obtains necessary domain objects via Repository
- Service coordinates interactions between Domain Objects to execute operation
- Domain Objects execute business logic as coordinated by Service
- Service persists changes through Repository or Unit of Work
- Service commits transaction if operation successful or rollback on error
- Service returns result (DTO or domain object) to Client

## Consequences

### Advantages

- **Clear application interface**: Well-defined and documented operations
- **Reusability**: Shared logic between multiple clients
- **Transaction management**: Transactions controlled consistently
- **Separation of responsibilities**: Presentation separated from business logic
- **Testability**: Services can be tested independently of UI
- **Centralized security**: Authorization and authentication applied uniformly

### Disadvantages

- **Additional layer**: Increases architectural complexity
- **Anemia risk**: Can become simple passthrough without added value
- **Granularity decisions**: Difficult to decide correct operation granularity
- **Over-engineering**: Can be unnecessary overhead for simple applications
- **Duplication**: Risk of duplicating logic that should be in domain
- **Coupling**: Clients become coupled to service contracts

## Implementation

### Considerations

1. **Operation granularity**: Define operations representing complete use cases, not generic CRUD
2. **Transaction management**: Decide where transactions start and end (usually in Service Layer)
3. **Service thickness**: Decide how much logic goes in Service vs Domain Model
4. **DTOs vs Domain Objects**: Define what crosses Service Layer boundary
5. **Error handling**: Translate domain exceptions to appropriate format
6. **Stateless**: Keep Services stateless between calls

### Techniques

- **Facade Pattern**: Service Layer as Facade over complex Domain Model
- **Transaction Script Organization**: Group Transaction Scripts into Services
- **Domain Model Coordination**: Coordinate rich Domain Model objects
- **DTO Assembly**: Assemble DTOs from Domain Objects for return
- **Unit of Work Integration**: Use Unit of Work to manage persistence
- **Dependency Injection**: Inject dependencies (Repositories, Domain Services)

## Known Uses

- **Enterprise Java Applications**: EJB Session Beans, Spring Services
- **ASP.NET Applications**: Service classes in layered architecture
- **REST APIs**: Service layer exposing HTTP endpoints
- **Microservices**: Each microservice with its Service Layer
- **CQRS Implementations**: Command Handlers and Query Handlers
- **Clean Architecture**: Use Case Interactors in application layer

## Related Patterns

- [**Transaction Script**](001_transaction-script.md): Service Layer can contain and organize Scripts
- [**Domain Model**](002_domain-model.md): Service Layer coordinates rich Domain Model
- [**Table Module**](003_table-module.md): Service Layer can use Table Modules
- [**Remote Facade**](055_remote-facade.md): Service Layer often exposed as Remote Facade
- [**Data Transfer Object**](056_data-transfer-object.md): DTOs cross Service boundary
- [**Unit of Work**](../object-relational/001_unit-of-work.md): Service Layer manages Unit of Work
- [**Repository**](../object-relational/016_repository.md): Service Layer uses Repositories for data access
- [**GoF Facade**](../../gof/structural/005_facade.md): Service Layer is application Facade

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): coordination as responsibility
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): depend on abstractions
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): extensible via new services
- [038 - Conformance with CQS](../../clean-code/018_conformidade-principio-inversao-consulta.md): separate commands and queries
- [032 - Test Coverage](../../clean-code/012_cobertura-teste-minima-qualidade.md): service testability

---

**Created**: 2025-01-11
**Version**: 1.0
