# Unit of Work

**Classification**: Object-Relational Behavioral Pattern

---

## Intent and Purpose

Maintains a list of objects affected by a business transaction and coordinates writing of changes and resolution of concurrency problems. Tracks all changes during a session and writes everything at once.

## Also Known As

- Transaction Manager
- Change Tracker
- Session

## Motivation

When working with objects in memory that need to be persisted, tracking which objects changed, were created, or deleted is complex. Without centralized control, you may forget to save changes, save the same object multiple times, or execute operations in wrong order causing integrity violations.

Unit of Work solves this by maintaining a list of all loaded objects and tracking changes to them. When you modify an object, Unit of Work registers the change. When you create a new object, Unit of Work registers it as "new". When you delete, Unit of Work registers as "removed". On commit, Unit of Work calculates correct order of operations and executes all changes in one database transaction.

For example, in an order transaction you may create Order, add OrderItems, update Product stock, and update Customer credit. Unit of Work tracks everything. On commit, it executes INSERTs for Order and Items, UPDATEs for Products and Customer, all in correct order and in one transaction. If something fails, everything is rolled back automatically.

## Applicability

Use Unit of Work when:

- Multiple objects are modified in a business transaction
- Changes need to be committed atomically
- Optimization of update queries is important (batch updates)
- Order of database operations needs to be managed
- Domain Model is used (frequently with Data Mapper)
- Concurrency problems need to be detected and resolved

## Structure

```
Client (Service Layer)
└── Uses: Unit of Work

Unit of Work
├── Object Registries:
│   ├── newObjects: List<Object>
│   ├── dirtyObjects: List<Object>
│   ├── removedObjects: List<Object>
│   └── clean: List<Object>
├── Public Methods:
│   ├── registerNew(object)
│   ├── registerDirty(object)
│   ├── registerRemoved(object)
│   ├── registerClean(object)
│   └── commit()
└── Collaborates with:
    ├── Data Mappers (to persist)
    └── Identity Map (to load)

Flow:
1. Client loads objects
2. Client modifies objects → UoW registers as dirty
3. Client creates objects → UoW registers as new
4. Client deletes objects → UoW registers as removed
5. Client calls commit()
6. UoW orders operations
7. UoW starts database transaction
8. UoW executes INSERTs (new objects)
9. UoW executes UPDATEs (dirty objects)
10. UoW executes DELETEs (removed objects)
11. UoW commits transaction
```

## Participants

- **Unit of Work**: Tracks changes and coordinates persistence
- **Domain Objects**: Objects being modified during transaction
- **Data Mappers**: Execute SQL to persist changes
- [**Identity Map**](002_identity-map.md): Maintains loaded objects unique
- **Object Lists**: Lists of new, dirty, removed, clean objects
- **Transaction**: Database transaction managed

## Collaborations

- Client loads objects via Repository or Data Mapper
- Loaded objects are registered as "clean" in Unit of Work
- Client modifies objects; objects self-register as "dirty" or Client registers explicitly
- Client creates new objects and registers them as "new"
- Client marks objects for deletion by registering as "removed"
- Client calls commit() on Unit of Work
- Unit of Work calculates operation order based on dependencies
- Unit of Work starts database transaction
- Unit of Work iterates over "new" objects and calls Mapper.insert()
- Unit of Work iterates over "dirty" objects and calls Mapper.update()
- Unit of Work iterates over "removed" objects and calls Mapper.delete()
- If all succeeds, Unit of Work commits transaction
- If error occurs, Unit of Work rolls back transaction

## Consequences

### Advantages

- **Atomicity**: All changes committed or none
- **Performance**: Batch updates reduce round-trips to database
- **Consistency**: Correct order of operations guaranteed
- **Simplicity for client**: Client doesn't manage transactions manually
- **Concurrency detection**: Can detect conflicts before committing
- **Optimization**: Can eliminate redundant updates

### Disadvantages

- **Complexity**: Complex implementation; difficult to do correctly
- **Memory overhead**: Maintains references to all modified objects
- **Hidden state**: Transaction state may not be obvious
- **Commit timing**: Difficult to know when to commit for best performance
- **Cascades**: Difficult to manage cascading operations
- **Debugging**: Problems appear only on commit, far from where error was introduced

## Implementation

### Considerations

1. **Object registration**: Decide if objects self-register or client registers explicitly
2. **Change detection**: Original snapshot vs dirty tracking vs proxy
3. **Ordering**: Calculate correct order based on dependencies
4. **Identity**: Integrate with Identity Map to avoid duplicates
5. **Concurrency**: Implement optimistic or pessimistic locking
6. **Scope**: Define lifetime of Unit of Work (per request, etc)

### Techniques

- **Object Registration**: register* methods to track objects
- **Caller Registration**: Client registers objects explicitly
- **Object Self-Registration**: Objects register themselves when modified
- **Change Tracking**: Compare snapshots to detect changes
- **Topological Sort**: Order operations based on dependencies
- **Transaction Management**: Start/commit/rollback transactions
- **Batch Operations**: Group similar operations

## Known Uses

- **Hibernate Session**: Hibernate Unit of Work pattern
- **Entity Framework DbContext**: EF uses Unit of Work
- **JPA EntityManager**: JPA EntityManager is Unit of Work
- **NHibernate Session**: NHibernate implementation
- **SQLAlchemy Session**: Python ORM Session
- **TypeORM EntityManager**: TypeScript ORM

## Related Patterns

- [**Data Mapper**](../data-source/004_data-mapper.md): Unit of Work coordinates Mappers
- [**Identity Map**](002_identity-map.md): Works together to ensure identity
- [**Repository**](016_repository.md): Repository uses Unit of Work internally
- [**Lazy Load**](003_lazy-load.md): Unit of Work can trigger lazy loads
- [**Optimistic Offline Lock**](057_optimistic-offline-lock.md): Detects conflicts
- [**Service Layer**](../domain-logic/004_service-layer.md): Service Layer manages Unit of Work

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): UoW responsible for transactions
- [027 - Quality in Error Handling](../../clean-code/007_qualidade-tratamento-erros-dominio.md): automatic rollback
- [028 - Asynchronous Exception Handling](../../clean-code/008_tratamento-excecao-assincrona.md): manages async transactions

---

**Created**: 2025-01-11
**Version**: 1.0
