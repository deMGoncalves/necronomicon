# Dependent Mapping

**Classification**: Object-Relational Structural Pattern

---

## Intent and Purpose

Map dependent objects that have no identity of their own and exist only in the context of their parent object.

## Also Known As

- Cascading Mapper
- Child Mapping

## Motivation

Dependent objects are those that have no meaning outside of their owner. For example, Order Items don't make sense without an Order. They have no independent identity and their lifecycle is coupled to the parent object.

Dependent Mapping handles this by making the parent object's mapper responsible for also mapping its dependents. When you load an Order, you automatically load its Order Items. When you save an Order, you also save all items.

This pattern simplifies mapping by eliminating the need for separate mappers for dependent objects, centralizing all persistence logic in the aggregate root's mapper. It's especially useful in Domain-Driven Design (DDD) to enforce aggregate boundaries.

## Applicability

Use Dependent Mapping when:

- Dependent objects have no identity outside the parent
- The dependent's lifecycle is tied to the parent
- Dependents are always loaded/saved with the parent
- There's no direct access to dependents without the parent
- Aggregate boundaries in Domain-Driven Design
- Performance: you always need the dependents together with the parent

## Structure

```
Order (Aggregate Root)
├── OrderItem (Dependent)
├── OrderItem (Dependent)
└── OrderItem (Dependent)

OrderMapper
├── load(id) → loads Order + all OrderItems
├── save(Order) → saves Order + all OrderItems
└── delete(id) → deletes Order + all OrderItems

OrderItemMapper does not exist
(OrderItems are mapped via OrderMapper)
```

## Participants

- **Aggregate Root**: Parent object with independent identity
- **Dependent Object**: Object that exists only in the context of the parent
- **Owner Mapper**: Mapper of the aggregate root that also maps the dependents
- **Database**: Tables related by foreign key

## Collaborations

- Client requests Owner Mapper to load aggregate root
- Owner Mapper loads parent data from main table
- Owner Mapper automatically loads dependent data from related tables
- Owner Mapper constructs complete object graph (parent + dependents)
- On save, Owner Mapper persists both parent and dependents in cascade

## Consequences

### Advantages

- **Simplicity**: Single mapper for complete aggregate
- **Consistency**: Parent and dependents always synchronized
- **Performance**: Efficient batch loading
- **Aggregate boundary**: Enforces DDD aggregate boundaries
- **Maintainability**: Centralized persistence logic
- **Atomicity**: Parent and dependent operations are atomic

### Disadvantages

- **Unnecessary loading**: Always loads dependents even if not needed
- **Mapper complexity**: Parent mapper becomes more complex
- **Limited flexibility**: Cannot access dependents independently
- **Coupling**: Dependents strongly coupled to parent lifecycle
- **Hard to refactor**: If dependent needs to become independent in the future

## Implementation

### Considerations

1. **Identify dependents**: Objects without identity or independent lifecycle
2. **Cascade operations**: Implement save/delete cascade in parent mapper
3. **Loading strategy**: Use joins or separate queries to load dependents
4. **Collection handling**: Map collections of dependents correctly
5. **Delete orphans**: Remove dependents that no longer exist in the collection
6. **Versioning**: Include dependents in aggregate version calculation

### Techniques

- **Join fetching**: Load parent and dependents in single query with JOIN
- **Batch loading**: Load dependents in separate query after loading parents
- **Diff algorithm**: Compare old and new collections to determine what to insert/update/delete
- **Mark for deletion**: Mark orphaned dependents for deletion
- **Unit of Work integration**: Integrate with Unit of Work to manage cascade operations
- **Cascade rules**: Define clear cascade rules (save, delete, update)

## Known Uses

- **Order/OrderItem**: Orders and order items in e-commerce
- **Invoice/InvoiceItem**: Invoices and invoice lines
- **Document/Paragraph**: Documents and paragraphs
- **Album/Photo**: Photo albums and individual photos when photo only exists in album
- **Playlist/Song**: Playlists and songs when song only exists in playlist
- **Form/Field**: Forms and dynamic form fields

## Related Patterns

- [**Embedded Value**](008_embedded-value.md): Alternative when dependent fits in parent table
- [**Identity Map**](002_identity-map.md): Not applicable to dependents (no identity)
- [**Unit of Work**](001_unit-of-work.md): Coordinates cascade operations
- [**Data Mapper**](../data-source/004_data-mapper.md): Base pattern for mapping
- [**Foreign Key Mapping**](005_foreign-key-mapping.md): Implements relationship in database
- [**Lazy Load**](003_lazy-load.md): Alternative to avoid always loading dependents
- [**GoF Composite**](../../gof/structural/003_composite.md): Aggregate structure with dependents

### Relationship with Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): mapper responsible for aggregate
- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): consider immutability of dependents

---

**Created on**: 2025-01-11
**Version**: 1.0
