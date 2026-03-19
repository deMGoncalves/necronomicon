# Table Module

**Classification**: Domain Logic Pattern

---

## Intent and Purpose

Organize domain logic with one class per database table. A single instance of the class contains shared behavior operating over a RecordSet representing multiple rows of the table.

## Also Known As

- Table Gateway
- Table Object

## Motivation

Table Module offers a middle ground between simplicity of Transaction Script and richness of Domain Model. Instead of independent procedures or objects per row, you have one class that encapsulates common behavior for all rows of a table.

Consider a contract system where you need to calculate recognized revenue. With Table Module, a ContractsModule class would have a calculateRecognitions(contractsRecordSet) method that processes multiple contracts simultaneously. The RecordSet passes between layers carrying data, while the module provides all business logic.

This approach works particularly well on platforms with robust support for tabular data structures, like ADO.NET DataSets or JDBC Result Sets. Shared behavior is centralized, but you still work with familiar data structures.

## Applicability

Use Table Module when:

- Domain logic has moderate complexity
- Platform provides excellent support for RecordSet structures
- Team is comfortable with data-oriented programming
- There is common behavior shared between rows of the same table
- Batch processing over multiple rows is common
- Overhead of full Domain Model is not justified

## Structure

```
Client (Presentation Layer)
└── Uses: TableModule + RecordSet

TableModule (one class per table)
├── ProductsModule
│   ├── calculateDiscount(RecordSet)
│   ├── applyPriceAdjustment(RecordSet)
│   └── findAvailableProducts(): RecordSet
│
├── OrdersModule
│   ├── calculateTotal(RecordSet)
│   ├── applyShippingRules(RecordSet)
│   └── findOrdersByCustomer(customerId): RecordSet
│
└── CustomersModule
    ├── calculateLoyaltyPoints(RecordSet)
    └── findActiveCustomers(): RecordSet

RecordSet
└── Data structure containing multiple rows and columns
```

## Participants

- [**Table Module**](003_table-module.md): Class containing business logic for all rows of a specific table
- **RecordSet**: Data structure representing multiple rows; can be DataSet, DataTable, or similar
- [**Table Data Gateway**](../data-source/001_table-data-gateway.md): Provides data to Table Module (often returns RecordSets)
- **Client**: User interface or service layer that invokes Table Modules

## Collaborations

- Client obtains RecordSet from Table Data Gateway or directly from database
- Client passes RecordSet to Table Module to process business logic
- Table Module executes operations over all rows in the RecordSet
- Table Module may modify RecordSet in-place or return new RecordSet
- Modified RecordSet returns to Client or is passed for persistence

## Consequences

### Advantages

- **Moderate simplicity**: More structured than Transaction Script; less complex than Domain Model
- **Native RecordSet**: Leverages platform's native support for tabular structures
- **Centralized behavior**: All logic for table in one place
- **Batch performance**: Processes multiple rows efficiently
- **Familiar to developers**: Familiar data structure; low learning curve
- **Natural sharing**: Easy to share behavior between rows

### Disadvantages

- **RecordSet coupling**: Strong dependency on platform-specific data structures
- **Limited complexity**: Doesn't scale well to very complex domains
- **Limited OO**: Doesn't leverage polymorphism, inheritance, and other advanced features
- **Object-relational mapping**: Still has impedance mismatch, just different
- **Weak identity**: Difficult to track identity of individual objects
- **Difficulty with relationships**: Complex relationships are hard to manage

## Implementation

### Considerations

1. **One class per table**: Create separate Table Module for each database table
2. **Instance vs static**: Decide if methods should be static or instance methods
3. **RecordSet as parameter**: Methods receive RecordSets and operate on them
4. **Returning RecordSets**: Queries return RecordSets for subsequent processing
5. **Validation**: Encapsulate business validations in modules
6. **Transactions**: Manage transactions externally to the module

### Techniques

- **Static Methods**: Use static methods if no state in module
- **Instance Methods**: Use instance if module needs to maintain state (connections, configuration)
- **RecordSet Manipulation**: Operations that modify RecordSet in-place
- **Query Methods**: Return filtered or transformed RecordSets
- **Calculation Methods**: Calculate values based on data in RecordSet
- **Validation Methods**: Validate business rules over multiple rows

## Known Uses

- **ADO.NET Applications**: .NET applications using DataSets and DataTables
- **Classic ASP/VB6**: Classic Visual Basic applications with ADO RecordSets
- **Java with JDBC**: Java applications processing ResultSets
- **Report Generation**: Reporting systems operating over tabular data
- **Data Migration Tools**: ETL tools processing batch data
- **Administrative Interfaces**: Admin interfaces with batch operations

## Related Patterns

- [**Transaction Script**](001_transaction-script.md): Table Module adds organization by table
- [**Domain Model**](002_domain-model.md): Richer and OO; Table Module simpler
- [**Service Layer**](004_service-layer.md): Table Modules can form Service Layer
- [**Table Data Gateway**](../data-source/001_table-data-gateway.md): Provides RecordSets to Table Module
- [**Row Data Gateway**](../data-source/002_row-data-gateway.md): Alternative oriented to single row
- [**Active Record**](../data-source/003_active-record.md): Combines data and behavior per instance
- [**Record Set**](../base/011_record-set.md): Data structure used by Table Module

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): module per table
- [004 - First-Class Collections](../../object-calisthenics/004_colecoes-primeira-classe.md): operates on row collections
- [007 - Maximum Lines per Class Limit](../../object-calisthenics/007_limite-maximo-linhas-classe.md): modules should be concise
- [022 - Prioritization of Simplicity](../../clean-code/002_prioritization-simplicity-clarity.md): simple solution for moderate complexity

---

**Created**: 2025-01-11
**Version**: 1.0
