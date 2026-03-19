# Foreign Key Mapping

**Classification**: Object-Relational Structural Pattern

---

## Intent and Purpose

Map association between objects to foreign key reference between tables. Uses foreign key in database to represent object references in memory.

## Also Known As

- FK Mapping
- Reference Mapping
- Association Mapping

## Motivation

Objects reference other objects directly through pointers or references. Relational databases represent relationships through foreign keys - columns that store ID of related row. Foreign Key Mapping translates between these two worlds.

When Order references Customer, in memory Order has direct reference to Customer object. In database, orders table has customer_id column containing Customer ID. When saving Order, Mapper extracts Customer ID and stores in customer_id. When loading Order, Mapper uses customer_id to load Customer object and establish reference.

Complexities arise with bidirectional relationships, lazy loading, and cascades. Mapper needs to decide when to load related objects, how to maintain bidirectional consistency, and which operations to propagate (cascade save, delete, etc).

## Applicability

Use Foreign Key Mapping when:

- Objects have one-to-one or many-to-one relationships
- Relational database is used for persistence
- Relationships need to be navigable in memory
- Data Mapper or Active Record is persistence pattern
- Referential integrity needs to be maintained
- Lazy loading of relationships is desirable

## Structure

```
Domain Objects (in memory)
Order
├── id: 1
└── customer: → Customer{id:5, name:"John"}

Database (persisted)
orders table
├── id: 1
├── customer_id: 5 (foreign key)
└── total: 100.00

customers table
└── id: 5, name: "John"

Mapping:
Order.customer → orders.customer_id → Customer.id
```

## Participants

- **Source Object**: Object containing reference (Order)
- **Target Object**: Object being referenced (Customer)
- **Foreign Key Column**: Column in database storing target ID
- [**Data Mapper**](../data-source/004_data-mapper.md): Translates between reference and foreign key
- [**Identity Field**](004_identity-field.md): ID used to correlate objects

## Collaborations

**When Saving:**
- Mapper checks Order object to persist
- Mapper finds Order.customer reference
- Mapper extracts customer.id (Identity Field)
- Mapper stores customer.id in orders.customer_id
- Foreign key in database points to customer row

**When Loading:**
- Mapper loads row from orders table
- Mapper finds value in customer_id
- Mapper uses customer_id to load Customer (via Identity Map or query)
- Mapper establishes reference Order.customer = customerObject
- Returns Order with populated reference

## Consequences

### Advantages

- **Simplicity**: Direct and intuitive mapping
- **Integrity**: Foreign key constraints maintain integrity
- **Performance**: Indexes on foreign keys optimize joins
- **Navigation**: Relationships navigable in objects
- **Standard SQL**: Uses standard SQL features
- **Unidirectional**: Doesn't require inverse relationship

### Disadvantages

- **N+1 queries**: Loading relationships can generate many queries
- **Null handling**: Nullable foreign keys complicate logic
- **Bidirectional sync**: Difficult to maintain bidirectional consistency
- **Cascade complexity**: Operation propagation is complex
- **Lazy load issues**: Requires open session for lazy loading
- **Coupling**: Source table coupled to target

## Implementation

### Considerations

1. **Loading strategy**: Eager vs lazy loading of relationship
2. **Directionality**: Unidirectional vs bidirectional
3. **Nullability**: Can foreign key be null?
4. **Cascade operations**: Which operations to propagate (save, delete)
5. **Inverse mapping**: How to maintain inverse relationship consistent
6. **Performance**: Avoid N+1 query problem

### Techniques

- **Eager Loading**: Load relationship with join immediately
- **Lazy Loading**: Use proxy to load relationship on demand
- **Batch Fetching**: Load multiple relationships at once
- **Cascade Save**: Save related objects automatically
- **Cascade Delete**: Delete related when parent is deleted
- **Orphan Removal**: Delete objects no longer referenced

## Known Uses

- **Hibernate @ManyToOne**: Many-to-one mapping with foreign key
- **Entity Framework Navigation Properties**: Relationships via FK
- **ActiveRecord belongs_to**: Foreign key relationship
- **Sequelize belongsTo**: Foreign key association
- **TypeORM @ManyToOne**: Foreign key column
- **SQLAlchemy ForeignKey**: Foreign key mapping

## Related Patterns

- [**Identity Field**](004_identity-field.md): Provides ID for foreign key
- [**Association Table Mapping**](006_association-table-mapping.md): For many-to-many
- [**Dependent Mapping**](007_dependent-mapping.md): Dependent objects without FK
- [**Lazy Load**](003_lazy-load.md): Loads relationships on demand
- [**Data Mapper**](../data-source/004_data-mapper.md): Implements the mapping
- [**Identity Map**](002_identity-map.md): Cache of related objects

### Relation to Rules

- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): navigable relationships
- [034 - Lazy Load**](003_lazy-load.md): avoids loading everything eagerly

---

**Created**: 2025-01-11
**Version**: 1.0
