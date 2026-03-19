# Concrete Table Inheritance

**Type**: Object-Relational Mapping Pattern (Structural)

---

## Intent and Purpose

Represent an inheritance hierarchy by creating a database table only for each concrete (non-abstract) class, where each table contains all necessary fields, including those inherited from the superclass.

## Also Known As

- Table-per-Concrete-Class
- Leaf Table Inheritance
- Denormalized Inheritance Mapping

---

## Motivation

Both Single Table and Class Table Inheritance have disadvantages: Single Table wastes space with NULLs, and Class Table requires costly JOINs. Concrete Table Inheritance takes a different approach: completely eliminates the abstract superclass table and creates tables only for concrete classes that can be instantiated, duplicating inherited fields in these tables.

Consider `Animal` (abstract) → `Dog`, `Cat`. With Concrete Table, we create only two tables: `dogs` (id, name, breed) and `cats` (id, name, furColor). The `name` column, defined in Animal, is duplicated in both tables. There is no `animals` table.

The advantage is maximum read performance — each query operates on a single table without JOINs, and there are no wasted NULL columns. The cost is duplication of column definitions (DRY violation in schema) and extreme difficulty in polymorphic queries — searching for "all animals" requires UNION of disconnected tables.

---

## Applicability

Use Concrete Table Inheritance when:

- The superclass is purely abstract and never directly instantiated
- Polymorphic queries are extremely rare or nonexistent
- Each subclass is queried independently, almost as if they were separate entities
- Read performance is absolutely critical and JOINs are unacceptable
- Subclasses have very different fields, with little overlap beyond inherited ones
- You're willing to accept schema duplication in exchange for query simplicity

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

Database Schema (NO animals table!):
┌────────────────────────────────────┐
│   Table: dogs                      │
├──────────┬───────────┬─────────────┤
│ id (PK)  │ name      │ breed       │
│ BIGINT   │ VARCHAR   │ VARCHAR     │
├──────────┼───────────┼─────────────┤
│ 1        │ Rex       │ Labrador    │
│ 3        │ Buddy     │ Poodle      │
└──────────┴───────────┴─────────────┘

┌────────────────────────────────────┐
│   Table: cats                      │
├──────────┬───────────┬─────────────┤
│ id (PK)  │ name      │ furColor    │
│ BIGINT   │ VARCHAR   │ VARCHAR     │
├──────────┼───────────┼─────────────┤
│ 2        │ Felix     │ Black       │
└──────────┴───────────┴─────────────┘

Note: "name" is duplicated in both tables!
```

---

## Participants

- **Animal** (Abstract Class): Defines common interface and inherited fields, but has NO corresponding database table.

- **Dog / Cat** (Concrete Classes): Have their own independent tables that include ALL fields (own + inherited).

- **Concrete Tables** (`dogs`, `cats`): Completely independent tables with no foreign key relationship between them.

- **Mapper/ORM**: Responsible for distributing save/load operations among multiple disconnected tables when working polymorphically.

- **Sequence/ID Generator**: Must generate globally unique IDs to avoid collisions between different tables (e.g., shared sequence or UUID).

---

## Collaborations

When saving a Dog, the Mapper inserts directly into the `dogs` table, including both specific fields (breed) and inherited ones (name). It's a single INSERT operation, with no coordination between tables.

When loading a Dog by ID, the Mapper executes SELECT directly on the `dogs` table. Simple and fast.

For polymorphic queries ("all animals"), the Mapper must execute UNION: `SELECT id, name, 'Dog' as type FROM dogs UNION SELECT id, name, 'Cat' as type FROM cats`. This is costly and requires the ORM to know all concrete subclasses.

---

## Consequences

### Advantages

1. **Maximum Read Performance**: Each query operates on a single table, without JOINs — maximum speed.
2. **Simple Schema per Table**: Each table is independent and self-contained, easy to understand in isolation.
3. **No NULL Waste**: All columns are always filled — no unused fields.
4. **Complete Constraints**: All fields can have NOT NULL, UNIQUE, and other constraints without conflicts.
5. **Simple Write Operations**: Save/Update/Delete operate on a single table, without coordination.
6. **Subclass Isolation**: Changes to one subclass don't affect schemas of other subclasses.

### Disadvantages

1. **Schema Duplication**: Inherited columns are duplicated in multiple tables (DRY violated at schema level).
2. **Complex Polymorphic Queries**: Searching for "all animals" requires complex UNIONs of all concrete tables.
3. **Dangerous Refactoring**: Moving a field from subclass to superclass requires ALTER TABLE on ALL concrete tables.
4. **Maintenance Difficulty**: Adding field to abstract superclass requires updating schema of all subclasses.
5. **Global ID Problems**: Ensuring ID uniqueness between disconnected tables requires coordination (shared sequences or UUIDs).

---

## Implementation

### Implementation Considerations

1. **Unique ID Generation**: Use a single shared sequence between tables or UUIDs to avoid ID collisions between tables.

2. **Subclass Knowledge**: The ORM needs to know all concrete subclasses to execute polymorphic queries (can't discover dynamically).

3. **Avoid Polymorphic Queries**: Design the application to minimize the need to search for "all X from superclass" — work with specific subclasses.

4. **Synchronized Migration**: Changes to superclass require coordinated migrations in all concrete tables simultaneously.

5. **Views for Polymorphism**: Create database views that UNION the tables to facilitate occasional polymorphic queries.

6. **Versioning/Auditing**: Implementing auditing requires adding audit columns in each concrete table separately.

### Implementation Techniques

1. **ORM Mapping**: Hibernate uses `@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)`. Entity Framework uses TPC (Table-per-Concrete-class) strategy.

2. **UUID as PK**: Prefer UUIDs over auto-increment to avoid complexity of shared sequence.

3. **Code Generation**: Use code generators to propagate superclass changes to all concrete tables automatically.

4. **Selective Loading**: Configure ORM not to attempt polymorphic loading unless explicitly requested.

5. **Composite Discriminator**: In UNION queries, add synthetic column with type to allow ORM to instantiate correct class.

6. **Database Functions**: Create stored procedures that encapsulate complex UNIONs for frequent polymorphic queries.

---

## Known Uses

1. **Hibernate ORM**: Supports via `TABLE_PER_CLASS`, but documentation warns against use due to complexity of polymorphic queries.

2. **Legacy Systems**: Common in systems that evolved organically where each "type" was added as separate table without inheritance planning.

3. **Data Warehouses**: Use similar pattern where dimensions of different types (Customer, Supplier, Employee) are completely separate tables.

4. **Multi-tenant Systems**: Each tenant can have its own subclass table, completely isolating data.

5. **Reporting Systems**: Where aggregations are always by specific type, never polymorphic.

6. **Rails (workaround)**: Although Rails prefers STI, some applications use separate tables with manual `type` for performance.

---

## Related Patterns

- [**Single Table Inheritance**](010_single-table-inheritance.md): Alternative that centralizes everything in one table with discriminator.
- [**Class Table Inheritance**](011_class-table-inheritance.md): Alternative that normalizes with table per class including abstract ones.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Still applicable to organize Mappers for each concrete class.
- [**Identity Field**](004_identity-field.md): Requires special strategy (UUID or global sequence) for unique IDs across tables.
- [**Lazy Load**](003_lazy-load.md): Less relevant since each load is from single table.
- [**Repository**](016_repository.md): Repository must know all concrete subclasses for polymorphic queries.
- [**Query Object**](015_query-object.md): Needs to construct complex UNIONs for polymorphic queries.

### Relationship with Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): focused concrete class
- [021 - Prohibition of Logic Duplication](../../clean-code/001_prohibition-logic-duplication.md): avoid column duplication

---

## Relationship with Business Rules

- **[022] Prioritization of Simplicity and Clarity**: Maximizes simplicity of individual queries, but complicates polymorphic queries.
- **[021] Prohibition of Logic Duplication**: Violates DRY in schema by duplicating inherited columns, but accepted for performance gain.
- **[010] Single Responsibility Principle**: Each table has the sole responsibility of storing data for a concrete class.
- **[019] Stable Dependencies Principle**: Changes to unstable superclass propagate to all concrete tables.

---

**Created on**: 2025-01-10
**Version**: 1.0
