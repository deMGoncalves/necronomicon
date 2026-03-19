# Single Table Inheritance

**Type**: Object-Relational Mapping Pattern (Structural)

---

## Intent and Purpose

Represent a class inheritance hierarchy in a single database table that contains columns for all fields of all classes in the hierarchy, using a discriminator column to identify the type of each record.

## Also Known As

- Single Table Strategy
- Table-per-Hierarchy
- Discriminator Column Pattern

---

## Motivation

When mapping object-oriented inheritance hierarchies to relational databases, we face the challenge that relational databases don't have a native concept of inheritance. Single Table Inheritance solves this problem in the simplest way possible: creating a single table that contains all columns necessary to represent all attributes of all classes in the hierarchy.

For example, consider an `Animal` hierarchy with subclasses `Dog` and `Cat`. Dog has a `breed` attribute, while Cat has a `furColor` attribute. With Single Table Inheritance, we create an `animals` table with columns: `id`, `type` (discriminator), `name`, `breed`, `furColor`. A Dog record would have `type='Dog'` and `furColor=NULL`, while a Cat would have `type='Cat'` and `breed=NULL`.

The pattern's simplicity comes with trade-offs. Since all subclasses share the same table, columns that belong only to one subclass remain NULL for records of other subclasses. This violates normalization and wastes space if there are many subclass-specific fields. However, the simplicity of queries (single table, no joins) and the ease of adding new subclasses (just add columns) make this pattern attractive for simple hierarchies.

---

## Applicability

Use Single Table Inheritance when:

- The inheritance hierarchy is relatively shallow (2-3 levels) with few subclasses
- Subclasses have similar fields or share most attributes
- You need to make frequent queries involving the entire hierarchy (e.g., "all animals")
- Read performance is critical and you want to avoid joins
- Subclasses change rarely, but new types may be added occasionally
- The number of subclass-specific columns is small (acceptable space waste)

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
┌─────────────────────────────────────────────────────────────┐
│                     Table: animals                          │
├──────────┬───────────┬───────────┬──────────┬──────────────┤
│ id (PK)  │ type      │ name      │ breed    │ furColor     │
│ BIGINT   │ VARCHAR   │ VARCHAR   │ VARCHAR  │ VARCHAR      │
├──────────┼───────────┼───────────┼──────────┼──────────────┤
│ 1        │ Dog       │ Rex       │ Labrador │ NULL         │
│ 2        │ Cat       │ Felix     │ NULL     │ Black        │
│ 3        │ Dog       │ Buddy     │ Poodle   │ NULL         │
└──────────┴───────────┴───────────┴──────────┴──────────────┘
```

---

## Participants

- **Animal** (Abstract Base Class): Defines the common interface and shared attributes for all subclasses in the hierarchy.

- **Dog / Cat** (Concrete Subclasses): Implement specific behaviors and have additional attributes stored in dedicated columns in the shared table.

- **Discriminator Column** (`type`): Special column in the table that stores the concrete class type of each record, allowing the ORM to instantiate the correct class when loading from the database.

- **Mapper/ORM**: Component responsible for reading the discriminator column, instantiating the correct class, and populating only the relevant fields for that type.

- **Single Table** (`animals`): Database structure containing the union of all columns from all classes, with many NULL values.

---

## Collaborations

When the client requests saving a Dog object, the Mapper checks the object type, sets the `type='Dog'` column, fills the shared columns (`id`, `name`) and the specific column (`breed`), leaving `furColor` as NULL. The operation is a simple INSERT into a single table.

When loading, the Mapper executes a SELECT, reads the `type` column, and based on the value, instantiates the appropriate class (Dog or Cat), populating only the relevant fields for that class. Polymorphic queries ("SELECT * FROM animals") return all records of all types with a single statement.

---

## Consequences

### Advantages

1. **Schema Simplicity**: Just one table for the entire hierarchy — easy to understand and maintain.
2. **Read Performance**: Queries don't require joins — all data is in a single table.
3. **Simple Polymorphic Queries**: Fetching all objects in the hierarchy is trivial (SELECT without joins).
4. **Ease of Refactoring**: Moving fields between classes doesn't require schema changes, only code alterations.
5. **Adding New Subclasses**: Adding a new type requires only new columns (ALTER TABLE) and a new discriminator value.
6. **Simple Transactions**: Saving or updating an object is a single write operation.

### Disadvantages

1. **Normalization Violation**: Many columns remain NULL for records that don't use them, wasting space.
2. **Schema Pollution**: The table grows horizontally with each new subclass, becoming hard to manage.
3. **Impossibility of NOT NULL**: Subclass-specific columns can't have NOT NULL constraints, as other subclasses will leave them NULL.
4. **Space Waste**: In databases that allocate space for NULL columns, storage overhead can be significant.
5. **Difficulty Understanding the Model**: For someone reading the schema, it's not obvious which columns belong to which classes without consulting the code.

---

## Implementation

### Implementation Considerations

1. **Discriminator Choice**: The discriminator can be the class name (String), a numeric code, or an enum. Strings are more readable; numbers save space.

2. **Discriminator Indexing**: Always create an index on the discriminator column, as queries frequently filter by specific type.

3. **NULL vs Default Values Strategy**: Decide whether unused columns remain NULL or receive default values. NULL is more explicit, but default values can avoid checks.

4. **Integrity Validation**: Implement code validations to ensure only the correct columns are filled for each type.

5. **Column Limit**: Databases have column-per-table limits (MySQL: 4096, PostgreSQL: 1600). Plan not to exceed these limits.

6. **Data Migration**: When adding new subclasses, plan migrations that add columns with default NULL values for existing records.

### Implementation Techniques

1. **Discriminator Mapping**: Configure the ORM to map discriminator values to classes. In Hibernate: `@DiscriminatorColumn(name="type")` and `@DiscriminatorValue("Dog")`.

2. **Mapper Inheritance**: Use Inheritance Mappers pattern where each subclass Mapper inherits from the base Mapper, reusing common field mapping code.

3. **Selective Lazy Loading**: Configure lazy loading for collections or large objects within the hierarchy to avoid loading unnecessary data.

4. **Read Strategy**: Use type-specific SELECT when possible (`WHERE type='Dog'`) to avoid overhead of processing unnecessary types.

5. **Discriminated Cache**: Configure separate second-level cache per type to avoid unnecessary cache invalidation.

6. **Audit Columns**: Add audit columns (`created_at`, `updated_at`, `version`) once in the base table, applying to all types.

---

## Known Uses

1. **Hibernate ORM**: Supports Single Table Inheritance via `InheritanceType.SINGLE_TABLE` strategy with `@DiscriminatorColumn`.

2. **Entity Framework (C#)**: The TPH (Table-per-Hierarchy) strategy is the default for inheritance mapping.

3. **Rails Active Record**: Uses Single Table Inheritance (STI) as the default for hierarchies, with `type` column as automatic discriminator.

4. **Django ORM**: Doesn't support natively, but can be implemented with abstract base classes and manual type selection.

5. **Doctrine (PHP)**: Supports Single Table Inheritance with `@InheritanceType("SINGLE_TABLE")` annotation.

6. **E-commerce Systems**: Use STI to represent different Product types (Physical, Digital, Service) in a table with discriminator.

---

## Related Patterns

- [**Class Table Inheritance**](011_class-table-inheritance.md): Alternative that creates a table per class, avoiding NULLs but requiring joins.
- [**Concrete Table Inheritance**](012_concrete-table-inheritance.md): Alternative that creates table only for concrete classes, duplicating inherited fields.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Structures Mappers to reflect object inheritance hierarchy.
- [**Identity Field**](004_identity-field.md): Used to uniquely identify each record in the shared table.
- [**Lazy Load**](003_lazy-load.md): Can be used to avoid loading subclass-specific fields unnecessarily.
- [**Query Object**](015_query-object.md): Facilitates creating queries that filter by specific type using discriminator.
- [**Repository**](016_repository.md): Encapsulates logic for creating polymorphic queries over the hierarchy.

### Relationship with Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): organize hierarchy
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): extension via subclasses

---

## Relationship with Business Rules

- **[012] Liskov Substitution Principle**: Single Table Inheritance facilitates polymorphism by allowing queries that return a mix of subclasses.
- **[022] Prioritization of Simplicity and Clarity**: It's the simplest inheritance mapping pattern — ideal when simplicity is a priority.
- **[010] Single Responsibility Principle**: Each subclass Mapper is responsible only for its specific fields.
- **[019] Stable Dependencies Principle**: The single table is stable — adding subclasses doesn't break existing queries.

---

**Created on**: 2025-01-10
**Version**: 1.0
