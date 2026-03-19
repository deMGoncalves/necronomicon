# Class Table Inheritance

**Type**: Object-Relational Mapping Pattern (Structural)

---

## Intent and Purpose

Represent a class inheritance hierarchy with a database table for each class in the hierarchy, where each table contains only the fields defined in that specific class.

## Also Known As

- Table-per-Class
- Joined Strategy
- Normalized Inheritance Mapping

---

## Motivation

Single Table Inheritance is simple but suffers from space waste and impossibility of NOT NULL constraints on subclass-specific fields. Class Table Inheritance solves these problems through normalization: each class in the hierarchy has its own table containing only its specific fields.

Consider the hierarchy `Animal` → `Dog`, `Cat`. With Class Table Inheritance, we create three tables: `animals` (id, name), `dogs` (id FK→animals, breed), `cats` (id FK→animals, furColor). A Dog record has one row in `animals` and another in `dogs`, linked by foreign key. This eliminates NULL columns and allows appropriate constraints (e.g., `breed NOT NULL` in `dogs`).

The advantage is perfect normalization — no space waste, each table has clear semantics, and the schema directly reflects the inheritance structure. The cost is complexity: queries require joins to reconstruct the complete object, and read performance can degrade in deep hierarchies. The choice between Single Table and Class Table is a classic trade-off between simplicity/performance and normalization/integrity.

---

## Applicability

Use Class Table Inheritance when:

- The hierarchy has many subclass-specific fields that are rarely shared
- Referential integrity and NOT NULL constraints are important to the domain
- Queries frequently operate on a single subclass (e.g., "all dogs")
- Schema normalization is an architectural priority
- The hierarchy is deep (more than 3 levels) and NULL column waste would be significant
- The data model needs to be understandable without consulting code (self-documenting schema)

---

## Structure

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Code                          │
└────────────────────────────────┬────────────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   <<abstract>>          │
                    │      Animal             │
                    │ ─────────────────────   │
                    │ - id: Long              │
                    │ - name: String          │
                    │ + makeSound(): void     │
                    └──────────┬──────────────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
    ┌───────────▼──────────┐      ┌──────────▼──────────┐
    │   Dog                │      │   Cat               │
    │ ──────────────────   │      │ ──────────────────  │
    │ - breed: String      │      │ - furColor: String  │
    │ + bark(): void       │      │ + meow(): void      │
    └──────────────────────┘      └─────────────────────┘

Database Schema:
┌──────────────────────────┐
│   Table: animals         │
├──────────┬───────────────┤
│ id (PK)  │ name          │
│ BIGINT   │ VARCHAR       │
├──────────┼───────────────┤
│ 1        │ Rex           │
│ 2        │ Felix         │
│ 3        │ Buddy         │
└──────────┴───────────────┘
         △
         │ FK
         │
┌────────┴─────────────────┐
│                          │
│  Table: dogs             │    Table: cats
├──────────┬───────────────┤    ├──────────┬──────────────┤
│ id (PK)  │ breed         │    │ id (PK)  │ furColor     │
│ FK       │ VARCHAR       │    │ FK       │ VARCHAR      │
├──────────┼───────────────┤    ├──────────┼──────────────┤
│ 1        │ Labrador      │    │ 2        │ Black        │
│ 3        │ Poodle        │    └──────────┴──────────────┘
└──────────┴───────────────┘
```

---

## Participants

- **Animal** (Base Table): Stores the primary ID and all fields common to the entire hierarchy. Serves as anchor for foreign keys from subclass tables.

- **Dog / Cat** (Subclass Tables): Store only the specific fields of each subclass. Their primary keys are simultaneously foreign keys to the base table.

- **Foreign Key Relationship**: Links each subclass record to the corresponding record in the base table, ensuring referential integrity.

- **Mapper/ORM**: Responsible for coordinating JOINs between tables to reconstruct the complete object when loading, and for INSERT/UPDATE in multiple tables when saving.

- [**Identity Field**](004_identity-field.md): The ID is shared across all tables — the same ID value identifies the same object in all hierarchy tables.

---

## Collaborations

When saving a Dog object, the Mapper first inserts a record in the `animals` table with common fields (name) and obtains the generated ID. Then, it inserts into the `dogs` table using that same ID as both primary key and foreign key, including specific fields (breed). The operation requires two coordinated writes.

When loading a Dog by ID, the Mapper executes a JOIN between `animals` and `dogs` (`SELECT * FROM animals INNER JOIN dogs ON animals.id = dogs.id WHERE animals.id = ?`), retrieves data from both tables, and constructs the complete Dog object with all fields.

---

## Consequences

### Advantages

1. **Perfect Normalization**: No unnecessary NULL columns — each table contains only relevant data.
2. **Integrity Constraints**: Subclass fields can have appropriate NOT NULL, UNIQUE, CHECK constraints.
3. **Self-Documenting Schema**: The table structure directly reflects the class hierarchy, facilitating understanding.
4. **Space Economy**: No storage waste with empty columns.
5. **Independent Evolution**: Adding fields to a subclass doesn't affect other hierarchy tables.
6. **Extension Support**: Easy to add new subclasses without polluting existing tables.

### Disadvantages

1. **Read Performance**: Each object load requires JOIN of multiple tables, degrading performance.
2. **Query Complexity**: Polymorphic queries ("all animals") require UNION or multiple LEFT JOINs.
3. **Write Overhead**: Saving an object requires multiple coordinated INSERTs/UPDATEs, increasing error chance.
4. **Refactoring Problems**: Moving a field between superclass and subclass requires data migration between tables.
5. **Deep Hierarchies**: In hierarchies with 5+ levels, the number of JOINs can make queries impractical.

---

## Implementation

### Implementation Considerations

1. **Primary Key Strategy**: The subclass table's PK must simultaneously be FK to the base table. Use `ON DELETE CASCADE` to maintain integrity.

2. **Type Identification**: Without explicit discriminator column, the ORM identifies type by presence of record in subclass table after JOINs.

3. **Operation Ordering**: When saving, always insert in superclass first (to obtain ID), then in subclasses. When deleting, delete from subclasses first.

4. **Transactions**: Multi-table operations must be wrapped in transactions to guarantee atomicity (either everything is saved, or nothing is).

5. **Indexes**: Create indexes on foreign keys of subclass tables to optimize JOINs.

6. **Views**: For frequent polymorphic queries, consider creating views that UNION all subclasses.

### Implementation Techniques

1. **ORM Mapping**: Hibernate uses `@Inheritance(strategy = InheritanceType.JOINED)`. Entity Framework uses `Table-per-Type` (TPT).

2. **SQL Inheritance**: Use Common Table Expressions (CTEs) for complex hierarchical queries.

3. **Lazy Loading of Subclasses**: Configure ORM to lazily load subclass properties if not immediately needed.

4. **Batch Fetching**: Use batch fetching (N+1 SELECT problem solution) to load multiple subclass objects efficiently.

5. **Polymorphism via UNION**: For "SELECT all", use `SELECT id, name, 'Dog' as type FROM animals JOIN dogs UNION SELECT id, name, 'Cat' as type FROM animals JOIN cats`.

6. **Abstract Table**: If the superclass is abstract, the base table can be kept only for referential integrity, without "orphan" records.

---

## Known Uses

1. **Hibernate ORM**: The `JOINED` strategy is widely used in enterprise systems that prioritize normalization.

2. **Entity Framework**: TPT (Table-per-Type) is one of the three standard inheritance mapping strategies.

3. **Financial Systems**: Use Class Table for Financial Instrument hierarchies (Stock, Bond, Derivative) where each type has specific fields.

4. **HR Systems**: Map Employee hierarchy → Manager, Developer, Salesperson with table per type.

5. **E-commerce Platforms**: Use for Products → PhysicalProduct, DigitalProduct, Subscription, where each type has different logistics.

6. **PostgreSQL Inheritance**: PostgreSQL has native support for table inheritance (`CREATE TABLE dogs (...) INHERITS (animals)`), which implements this pattern at database level.

---

## Related Patterns

- [**Single Table Inheritance**](010_single-table-inheritance.md): Simpler alternative that uses a single table with discriminator.
- [**Concrete Table Inheritance**](012_concrete-table-inheritance.md): Alternative that duplicates common fields in each concrete table.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Structures Mappers in hierarchy to reflect object hierarchy.
- [**Foreign Key Mapping**](005_foreign-key-mapping.md): Used to link subclass tables to base table.
- [**Identity Field**](004_identity-field.md): The ID is shared between base and subclass tables.
- [**Lazy Load**](003_lazy-load.md): Essential to avoid unnecessary JOINs when loading deep hierarchies.
- [**Unit of Work**](001_unit-of-work.md): Coordinates INSERTs/UPDATEs in multiple tables atomically.

### Relationship with Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): table per responsibility
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): substitutable subclasses

---

## Relationship with Business Rules

- **[012] Liskov Substitution Principle**: The separate table structure reflects substitutability between classes.
- **[010] Single Responsibility Principle**: Each table has the sole responsibility of storing fields of a specific class.
- **[014] Dependency Inversion Principle**: The Mapper abstracts JOIN complexity, keeping domain independent of schema.
- **[021] Prohibition of Logic Duplication**: Eliminates duplication of common columns that would occur in Concrete Table Inheritance.

---

**Created on**: 2025-01-10
**Version**: 1.0
