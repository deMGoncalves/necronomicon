# Active Record

**Classification**: Data Source Architectural Pattern

---

## Intent and Purpose

An object that encapsulates a row in a database table, encapsulates database access, and adds domain logic over that data. Object knows how to persist itself.

## Also Known As

- Self-Persistent Object
- Smart Record
- Domain Object with Persistence

## Motivation

Active Record combines data and behavior in a single object, where object represents a database row and contains both domain logic and persistence logic. It's an intuitive approach that reduces impedance mismatch by making object "know" how to save itself.

Consider a Person object: it has properties (name, email, age) corresponding to columns, business methods (sendEmail(), calculateAge()) implementing logic, and persistence methods (save(), delete(), find()) interacting with database. Client uses Person as a rich domain object without worrying about persistence details.

This simplicity makes Active Record extremely popular in web frameworks like Ruby on Rails and Laravel. For applications with moderate domain logic and direct mapping between objects and tables, Active Record offers significant productivity without the complexity of separate persistence layers.

## Applicability

Use Active Record when:

- Domain logic has low to moderate complexity
- Object structure maps directly to table structure
- Relationships are relatively simple
- Rapid productivity is more important than strict separation
- Chosen framework (Rails, Laravel) uses Active Record by default
- Team prefers pragmatic approach to rigorous architectural separation

## Structure

```
Client (Application/UI)
└── Uses: Active Record objects

Active Record (domain objects + persistence)
├── Person (Active Record)
│   ├── Properties: id, name, email, age
│   ├── Business Methods:
│   │   ├── sendEmail()
│   │   ├── isAdult()
│   │   └── updateProfile(data)
│   ├── Persistence Methods:
│   │   ├── save(): persists object
│   │   ├── delete(): removes from database
│   │   ├── reload(): reloads from database
│   │   └── validates(): validates before save
│   └── Static Methods (Finders):
│       ├── find(id): Person
│       ├── findByEmail(email): Person
│       └── all(): Person[]
│
├── Order (Active Record)
│   ├── Properties: id, customerId, date, total
│   ├── Business Methods:
│   │   ├── calculateTotal()
│   │   ├── addItem(product, quantity)
│   │   └── cancel()
│   └── Persistence Methods:
│       ├── save()
│       └── delete()
│
└── Product (Active Record)
    ├── Properties: id, name, price, stock
    ├── Business Methods:
    │   ├── isAvailable()
    │   └── adjustStock(quantity)
    └── Persistence Methods:
        └── save()

Database
└── Tables mirrored by Active Record classes
```

## Participants

- **Active Record Class**: Class representing table; combines data, logic, and persistence
- **Properties**: Fields corresponding to table columns
- **Business Methods**: Methods implementing domain logic
- **Persistence Methods**: save(), delete(), reload() for persistence
- **Finder Methods**: Static methods for queries (find, where, all)
- **Database Connection**: Connection used to execute SQL
- **Validations**: Validation rules before persisting

## Collaborations

- Client creates new Active Record instance or obtains via finder
- To create: Client instantiates object, sets properties, calls save()
- Active Record validates data and executes INSERT SQL
- To load: Client calls Person.find(5) (static method)
- Finder executes SELECT, creates instance, populates properties, returns object
- Client invokes business methods on loaded object
- To update: Client modifies properties or calls business methods
- Client calls save(); Active Record executes UPDATE SQL
- To delete: Client calls delete(); Active Record executes DELETE SQL

## Consequences

### Advantages

- **Simplicity**: Straightforward and intuitive approach; easy to learn
- **Productivity**: Rapid development with less boilerplate code
- **Convenience**: Object knows how to persist itself
- **Integration**: Well integrated with modern web frameworks
- **Fewer classes**: Doesn't require separate classes for mapping
- **Direct CRUD**: CRUD operations extremely simple

### Disadvantages

- **Coupling**: Domain logic coupled to persistence and database schema
- **Testing difficulty**: Difficult to test business logic without database
- **Limited complexity**: Doesn't scale well to very complex domains
- **Impedance mismatch**: Difficult to handle complex OO mappings
- **Schema changes**: Database changes affect domain objects
- **Weak separation**: Violates separation of responsibilities principle

## Implementation

### Considerations

1. **Base class inheritance**: Active Records usually inherit from common base class
2. **Convention over configuration**: Use conventions to map classes to tables
3. **Finders**: Implement static methods for common queries
4. **Validations**: Define validations executed before save()
5. **Callbacks**: Hooks for before_save, after_create, etc
6. **Relationships**: Declare has_many, belongs_to, etc

### Techniques

- **Convention over Configuration**: Class name maps to table name
- **Automatic Attributes**: Properties generated automatically from columns
- **Finder Methods**: find(), where(), all() for queries
- **Associations**: Declare relationships (has_many, belongs_to)
- **Validations**: Declarative validations before persisting
- **Callbacks**: Lifecycle hooks (before_save, after_create)
- **Scopes**: Named scopes for reusable queries

## Known Uses

- **Ruby on Rails**: ActiveRecord standard ORM in Rails
- **Laravel/Eloquent**: Laravel framework ORM (PHP)
- **Castle ActiveRecord**: Active Record for .NET
- **Django Models**: Django models have Active Record characteristics
- **Yii Framework**: PHP framework Active Record
- **RedBeanPHP**: Active Record ORM for PHP

## Related Patterns

- [**Row Data Gateway**](002_row-data-gateway.md): Active Record adds business logic
- [**Data Mapper**](004_data-mapper.md): Completely separates objects from persistence
- [**Domain Model**](../domain-logic/002_domain-model.md): Active Record is simple form of Domain Model
- [**Table Data Gateway**](001_table-data-gateway.md): Alternative without business logic
- [**Unit of Work**](../object-relational/001_unit-of-work.md): Can be combined to manage transactions
- [**Identity Map**](../object-relational/002_identity-map.md): Can be added to ensure unique identity
- [**Repository**](../object-relational/016_repository.md): Alternative that encapsulates persistence

### Relation to Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): violation; mixes responsibilities
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): domain depends on persistence
- [032 - Test Coverage](../../clean-code/012_cobertura-teste-minima-qualidade.md): makes unit testing difficult
- [022 - Prioritization of Simplicity](../../clean-code/002_prioritization-simplicity-clarity.md): simple for moderate cases

---

**Created**: 2025-01-11
**Version**: 1.0
