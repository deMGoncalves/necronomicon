# Row Data Gateway

**Classification**: Data Source Architectural Pattern

---

## Intent and Purpose

An object that acts as Gateway to a single row of a database table. One instance of the class represents one row; object knows how to load, update, and delete itself in the database.

## Also Known As

- Row Gateway
- Record Gateway
- Table Row

## Motivation

Row Data Gateway provides a simple object-relational layer where each object corresponds exactly to a database row. Each table field has a corresponding property in the object. Methods encapsulate SQL operations to load, save, and delete the row.

Unlike Table Data Gateway (which handles multiple rows), each instance of Row Data Gateway represents a single row. Creating a new record means creating a new instance and calling insert() method. Updating means modifying properties and calling update(). Deleting means calling delete() on the object.

For example, PersonGateway (object) represents a row in the Person table. It has properties id, name, email, age that reflect columns. Methods insert(), update(), delete() encapsulate SQL. Static finder findById() returns loaded instance. It's more object-oriented than Table Data Gateway but still doesn't contain business logic.

## Applicability

Use Row Data Gateway when:

- Object structure corresponds well to table structure
- Domain logic is simple and separated from data access
- Clear separation between data (Gateway) and behavior (Transaction Script) is desired
- No need for rich behavior in data objects
- Transaction Scripts or Table Modules are chosen domain pattern
- Object-relational impedance mismatch is minimal

## Structure

```
Client (Transaction Script or Business Logic)
└── Uses: Row Data Gateway instances

Row Data Gateway (one class per table)
├── PersonGateway
│   ├── Properties: id, name, email, age
│   ├── insert(): saves new row
│   ├── update(): updates existing row
│   ├── delete(): removes row
│   └── findById(id): PersonGateway (static)
│
├── OrderGateway
│   ├── Properties: id, customerId, date, total, status
│   ├── insert()
│   ├── update()
│   ├── delete()
│   ├── findById(id): OrderGateway (static)
│   └── findByCustomer(customerId): OrderGateway[] (static)
│
└── ProductGateway
    ├── Properties: id, name, price, stock
    ├── insert()
    ├── update()
    ├── delete()
    └── findById(id): ProductGateway (static)

Database
└── Tables mirrored by Gateway classes
```

## Participants

- [**Row Data Gateway**](002_row-data-gateway.md): Class representing table row structure
- **Properties/Fields**: Fields corresponding to table columns
- **Instance Methods**: insert(), update(), delete() operating on instance
- **Static Finder Methods**: Static methods that return instances (findById, etc)
- **Database Connection**: Connection used to execute SQL
- **Client**: Transaction Script or business code using Gateway

## Collaborations

- Client creates new Row Data Gateway instance or obtains via finder
- To create new record: Client creates instance, sets properties, calls insert()
- Gateway.insert() executes INSERT SQL and stores generated ID in instance
- To load: Client calls PersonGateway.findById(5) (static method)
- Finder executes SELECT, creates instance, populates properties, returns object
- To update: Client modifies object properties and calls update()
- Gateway.update() executes UPDATE SQL using property values
- To delete: Client calls delete() on instance
- Gateway.delete() executes DELETE SQL using instance ID

## Consequences

### Advantages

- **Simplicity**: Direct and simple mapping between row and object
- **Data separation**: Data separated from business logic
- **Ease of use**: Intuitive object-oriented interface
- **SQL encapsulation**: SQL concentrated in Gateway
- **Testability**: Easy to create Gateway mocks
- **Identity**: Each object represents specific row

### Disadvantages

- **Data only**: Objects are anemic; no business behavior
- **Schema coupling**: Schema changes affect Gateway
- **Relationships**: Difficult to handle complex relationships
- **Performance**: One query per object can be inefficient
- **Impedance mismatch**: Doesn't solve more complex OO problems
- **Class proliferation**: One class per table can be too many

## Implementation

### Considerations

1. **Properties per column**: Each table column becomes object property
2. **Instance methods**: insert(), update(), delete() operate on current instance
3. **Static finders**: Static methods to load instances from database
4. **Identity field**: Store row ID in object property
5. **State management**: Track if object is new or loaded
6. **Database connection**: Decide how Gateway obtains connection

### Techniques

- [**Lazy Load**](../object-relational/003_lazy-load.md): Load properties on demand
- [**Identity Field**](../object-relational/004_identity-field.md): Use ID to identify corresponding row
- **Foreign Key Properties**: Store relationship IDs
- **Finder Methods**: Static find* methods for queries
- **Validation**: Basic validations before saving
- **Optimistic Locking**: Use version to detect conflicts

## Known Uses

- **Ruby on Rails (partial)**: ActiveRecord has Row Gateway aspects
- **.NET DataRow**: DataRow in ADO.NET works as Row Gateway
- **Python Libraries**: Some lightweight ORM libraries use pattern
- **CRUD Applications**: Simple data maintenance applications
- **Prototyping**: Rapid prototypes with simple data access
- **Legacy System Wrappers**: Encapsulate access to legacy systems

## Related Patterns

- [**Table Data Gateway**](001_table-data-gateway.md): Handles multiple rows; Row per single row
- [**Active Record**](003_active-record.md): Row Gateway + business logic
- [**Data Mapper**](004_data-mapper.md): Completely separates domain objects from persistence
- [**Transaction Script**](../domain-logic/001_transaction-script.md): Uses Row Gateways for data access
- [**Table Module**](../domain-logic/003_table-module.md): Can use Row Gateways to load data
- [**Identity Field**](../object-relational/004_identity-field.md): Technique to identify row
- [**GoF Gateway**](../base/001_gateway.md): Base generic pattern

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): Gateway only access
- [008 - Prohibition of Getters/Setters](../../object-calisthenics/008_proibicao-getters-setters.md): Gateway can have getters/setters
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): well-defined interface
- [003 - Encapsulation of Primitives](../../object-calisthenics/003_encapsulamento-primitivos.md): properties can be Value Objects

---

**Created**: 2025-01-11
**Version**: 1.0
