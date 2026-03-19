# Table Data Gateway

**Classification**: Data Source Architectural Pattern

---

## Intent and Purpose

An object that acts as Gateway to a database table. One instance handles all rows in the table. Methods encapsulate queries and update operations, returning data in generic structures like RecordSet.

## Also Known As

- Table Gateway
- Data Access Object (partially)
- Table DAO

## Motivation

When application code accesses the database directly, SQL gets scattered throughout the application, making it difficult to maintain and modify the database schema. Table Data Gateway solves this by encapsulating all data access for a table in a single class.

Each table has its Gateway that provides methods for common operations: insert, update, delete, find. For example, PersonGateway would have methods like insert(name, age), update(id, name, age), delete(id), findById(id), findAll(). All SQL for the Person table is isolated in this class.

Gateway returns data in generic structures like RecordSet, DataTable, or dictionaries, not in specific domain objects. This keeps Gateway focused only on data access, without knowledge of business logic. Client can be Transaction Script, Table Module, or Data Mapper.

## Applicability

Use Table Data Gateway when:

- SQL needs to be separated from domain logic and presentation
- Multiple operations on the same table need to be reused
- Data access should be centralized to facilitate maintenance
- Processing operates over multiple rows simultaneously
- Platform has good support for generic data structures (RecordSet)
- No need to map to rich domain objects

## Structure

```
Client (Transaction Script, Table Module, or UI)
└── Uses: Table Data Gateway

Table Data Gateway (one per table)
├── PersonGateway
│   ├── insert(name, email, age): id
│   ├── update(id, name, email, age)
│   ├── delete(id)
│   ├── findById(id): RecordSet
│   ├── findAll(): RecordSet
│   └── findByEmail(email): RecordSet
│
├── OrderGateway
│   ├── insert(customerId, date, total): id
│   ├── update(id, status, total)
│   ├── delete(id)
│   ├── findById(id): RecordSet
│   └── findByCustomer(customerId): RecordSet
│
└── ProductGateway
    ├── insert(name, price, stock): id
    ├── update(id, price, stock)
    ├── findById(id): RecordSet
    └── findAvailable(): RecordSet

Database
└── Tables (Person, Order, Product)
```

## Participants

- [**Table Data Gateway**](001_table-data-gateway.md): Class encapsulating access to a specific table
- **RecordSet/DataTable**: Generic data structure containing returned rows
- **Database Connection**: Database connection used by Gateway
- **SQL Statements**: SQL commands encapsulated in Gateway methods
- **Client**: Transaction Script, Table Module, or UI using Gateway

## Collaborations

- Client invokes method on Table Data Gateway (e.g., personGateway.findById(5))
- Gateway assembles appropriate SQL statement for operation
- Gateway executes SQL using database connection
- For queries, Gateway converts results to RecordSet or similar structure
- Gateway returns RecordSet to Client
- Client processes data using returned generic structure
- For updates, Gateway executes INSERT/UPDATE/DELETE and returns status

## Consequences

### Advantages

- **Centralized SQL**: All SQL for table in one place
- **Maintainability**: Schema changes affect only Gateway
- **Reusability**: Common queries available to all clients
- **Testability**: Easy to create Gateway mocks for tests
- **Separation of responsibilities**: Data access separated from logic
- **Simplicity**: Simpler than full Data Mapper

### Disadvantages

- **Data structure coupling**: Clients coupled to specific RecordSet
- **Granularity**: One Gateway per table may be too much for large schemas
- **No domain objects**: Doesn't map to rich objects; returns generic data
- **Complex queries**: Difficult to handle complex joins between multiple tables
- **Identity**: Doesn't manage object identity
- **Relationships**: Difficult to navigate relationships between entities

## Implementation

### Considerations

1. **One Gateway per table**: Create separate class for each database table
2. **Finder methods**: Methods that return RecordSets (findById, findByXXX)
3. **Command methods**: Methods for INSERT, UPDATE, DELETE
4. **Connection management**: Decide if Gateway manages connection or receives it
5. **Data return**: Use RecordSet, DataTable, array of dictionaries, or similar
6. **Transactions**: Manage transactions outside Gateway (in Service Layer)

### Techniques

- **Static Methods**: Use static methods if Gateway doesn't maintain state
- **Instance per Table**: Create Gateway instance to use
- **Generic RecordSet**: Return platform's generic data structures
- **Finder Methods**: find* methods for various queries
- **Command Methods**: insert/update/delete methods for modifications
- **Connection Injection**: Inject connection instead of creating internally

## Known Uses

- **ADO.NET Applications**: TableAdapters in DataSets
- **Java DAO Pattern**: Data Access Objects in Java applications
- **Enterprise Applications**: Data access layer in corporate apps
- **Legacy System Integration**: Gateway for table-based legacy systems
- **Reporting Systems**: Data access for report generation
- **CRUD Applications**: Simple Create-Read-Update-Delete applications

## Related Patterns

- [**Row Data Gateway**](002_row-data-gateway.md): Alternative with Gateway per row
- [**Active Record**](003_active-record.md): Combines Gateway with domain object
- [**Data Mapper**](004_data-mapper.md): Maps to rich domain objects
- [**Table Module**](../domain-logic/003_table-module.md): Uses Table Data Gateway to obtain data
- [**Transaction Script**](../domain-logic/001_transaction-script.md): Can use Gateway for access
- [**Service Layer**](../domain-logic/004_service-layer.md): Service Layer can use Gateways
- [**GoF Gateway**](../base/001_gateway.md): Base Gateway pattern
- [**Record Set**](../base/011_record-set.md): Data structure returned

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): Gateway responsible for access
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): client depends on interface
- [021 - Prohibition of Duplication](../../clean-code/001_prohibition-logic-duplication.md): SQL not duplicated
- [007 - Lines per Class Limit](../../object-calisthenics/007_limite-maximo-linhas-classe.md): concise Gateway

---

**Created**: 2025-01-11
**Version**: 1.0
