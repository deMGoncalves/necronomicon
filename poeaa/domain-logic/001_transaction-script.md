# Transaction Script

**Classification**: Domain Logic Pattern

---

## Intent and Purpose

Organize business logic through procedures where each procedure handles a single request from the presentation layer.

## Also Known As

- Procedural Business Logic
- Service Method

## Motivation

The simplest way to structure business logic is to use procedures that implement each system request as a separate script. If you receive a request to calculate revenue recognition, you write a procedure that performs the calculation.

Each transaction has its own Transaction Script that interacts directly with the database or through a thin data access wrapper. The beauty of Transaction Script is its simplicity: it requires no sophisticated frameworks or knowledge of advanced patterns.

For simple applications with relatively straightforward business logic, Transaction Script works very well. It is especially appropriate when there is little or no code duplication between transactions.

## Applicability

Use Transaction Script when:

- Business logic is relatively simple
- There is little or no code duplication between transactions
- The application doesn't have significant domain complexity
- Team has experience with procedural programming
- Performance is critical and OO overhead is not desirable
- Rapid prototyping is necessary

## Structure

```
Presentation Layer
└── Calls: TransactionScript

TransactionScript
├── validateInput()
├── performBusinessLogic()
├── accessDatabase()
└── returnResult()

Database
└── Accesses: directly or via thin wrapper
```

## Participants

- [**Transaction Script**](001_transaction-script.md): Procedure implementing a complete business transaction
- **Presentation Layer**: Interface that invokes Transaction Scripts
- **Database**: Data storage accessed by scripts
- **Data Gateway** (optional): Thin wrapper over database access

## Collaborations

- Presentation layer receives user request and calls appropriate Transaction Script
- Transaction Script executes validation, business logic, and data access in sequence
- Script may use Data Gateway to separate SQL from business code
- Script returns result to presentation layer

## Consequences

### Advantages

- **Simplicity**: Easy to understand and implement for developers
- **Procedural**: Familiar to programmers accustomed to procedural programming
- **Performance**: Minimal overhead, direct execution without extra layers
- **Suitable for simple logic**: Perfect when domain is simple and straightforward
- **Testability**: Individual scripts are easy to test in isolation

### Disadvantages

- **Code duplication**: Shared logic tends to be duplicated between scripts
- **Difficulty with complexity**: Doesn't scale well to complex domains
- **Maintainability**: Grows disorganized as application grows
- **No rich domain model**: Doesn't capture complexity or sophisticated domain rules
- **Coupling**: Scripts often become coupled to database structure

## Implementation

### Considerations

1. **Script organization**: Group related scripts into service classes or modules
2. **Data access**: Consider using Data Gateway to separate SQL from business logic
3. **Reuse**: Extract common logic into shared helper functions
4. **Transactions**: Manage database transactions explicitly
5. **Validation**: Centralize input validation to avoid duplication

### Techniques

- [**Service Layer**](004_service-layer.md): Group related Transaction Scripts in Service Layer
- **Common Functions**: Extract duplicated code into utility functions
- **Data Access Layer**: Separate data access into dedicated layer
- **Error Handling**: Consistent error handling across all scripts

## Known Uses

- **Stored Procedures**: Business logic implemented in database stored procedures
- **Servlets**: Java servlets with procedural logic to process requests
- **CGI Scripts**: Classic CGI scripts in Perl, Python, or Ruby
- **Serverless Functions**: AWS Lambda, Azure Functions with simple logic
- **Batch Jobs**: Batch jobs with sequential processing
- **Simple REST APIs**: REST endpoints with straightforward CRUD logic

## Related Patterns

- [**Domain Model**](002_domain-model.md): OO alternative for complex logic; Transaction Script is simpler
- [**Table Module**](003_table-module.md): Middle ground between Transaction Script and Domain Model
- [**Service Layer**](004_service-layer.md): Transaction Scripts can form Service Layer
- [**Table Data Gateway**](../data-source/001_table-data-gateway.md): Separate data access from business logic
- [**Row Data Gateway**](../data-source/002_row-data-gateway.md): Alternative for row-oriented data access
- [**GoF Command**](../../gof/behavioral/002_command.md): Transaction Script is simple implementation of Command pattern

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each script one transaction
- [021 - Prohibition of Logic Duplication](../../clean-code/001_prohibition-logic-duplication.md): challenge with Transaction Script
- [022 - Prioritization of Simplicity](../../clean-code/002_prioritization-simplicity-clarity.md): Transaction Script is simplest

---

**Created**: 2025-01-11
**Version**: 1.0
