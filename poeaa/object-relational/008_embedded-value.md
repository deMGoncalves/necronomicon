# Embedded Value

**Classification**: Object-Relational Structural Pattern

---

## Intent and Purpose

Map an object to multiple fields in the table containing the parent object.

## Also Known As

- Aggregate Mapping
- Composite Value

## Motivation

Many small objects make sense in code but don't warrant their own table. An address with street, city, state, and ZIP code is better as an object in code, but creating a separate addresses table would be over-engineering.

Embedded Value solves this by mapping the value object's fields directly to columns in the owner object's table. The Customer's address lives in columns CUSTOMER_STREET, CUSTOMER_CITY, etc., in the CUSTOMERS table.

This pattern maintains the benefits of having rich objects in code while keeping the database schema simple and performant. It's especially useful for DDD Value Objects.

## Applicability

Use Embedded Value when:

- Value object is always used together with its owner
- Object is small (2-6 fields)
- Object is not shared between multiple owners
- Performance: avoid unnecessary joins
- Value Objects in Domain-Driven Design
- Data is frequently accessed together

## Structure

```
Customer (in code)
├── id
├── name
└── address (Address object)
    ├── street
    ├── city
    ├── state
    └── zipCode

CUSTOMERS (in database)
├── ID
├── NAME
├── CUSTOMER_STREET
├── CUSTOMER_CITY
├── CUSTOMER_STATE
└── CUSTOMER_ZIP

Address is "embedded" in Customer columns
```

## Participants

- **Owner Object**: Object that contains the embedded value
- [**Embedded Value**](008_embedded-value.md): Object mapped to owner columns
- [**Mapper**](../base/002_mapper.md): Translates between nested object and flat columns
- **Database Table**: Single table with columns for both owner and embedded

## Collaborations

- Mapper loads data from owner table
- Mapper creates both owner object and embedded value object
- Mapper injects embedded value into owner
- On save, mapper extracts data from embedded value and persists in owner columns
- No separate table or mapper for embedded value

## Consequences

### Advantages

- **Performance**: No joins, single query
- **Simplicity**: No additional tables
- **Atomicity**: Owner and embedded always consistent
- **Encapsulation**: Rich object in code
- **Simple schema**: Fewer tables to manage
- **Value Object support**: Perfect for DDD Value Objects

### Disadvantages

- **Duplication**: Embedded value duplicated if used in multiple owners
- **Schema changes**: Changing embedded requires changing multiple tables
- **Complex queries**: Difficult to query by embedded fields
- **Table size**: Many embedded values increase number of columns
- **Null handling**: Hard to distinguish null embedded vs null fields

## Implementation

### Considerations

1. **Naming convention**: Prefix columns with owner or embedded name
2. **Null object**: How to represent absent embedded value
3. **Multiple embedded**: Multiple embedded values of same type need different prefixes
4. **Value Object immutability**: Embedded values should be immutable
5. **Reuse**: If embedded is used in multiple contexts, consider separate table
6. **Column explosion**: Limit number of embedded values per table

### Techniques

- **Prefix columns**: CUSTOMER_STREET, CUSTOMER_CITY avoids conflicts
- **Null object pattern**: Return Null Object when all fields are null
- **Factory methods**: Create embedded value from ResultSet
- **Immutable values**: Embedded values should be immutable
- **Column bundling**: Group related columns logically

## Known Uses

- **Address**: Addresses embedded in Customer, Order, etc.
- [**Money**](../base/007_money.md): Monetary values (amount + currency) embedded
- **Date Range**: Period with start/end date embedded
- **Dimensions**: Height, width, depth in Product
- **Coordinates**: Latitude/longitude in Location
- **Name**: First/middle/last name in Person

## Related Patterns

- [**Dependent Mapping**](007_dependent-mapping.md): Alternative when separate table is needed
- [**Serialized LOB**](009_serialized-lob.md): Alternative for complex objects
- [**Value Object**](../base/006_value-object.md): DDD concept for embedded values
- [**Foreign Key Mapping**](005_foreign-key-mapping.md): When sharing between owners
- [**Data Mapper**](../data-source/004_data-mapper.md): Implements mapping

### Relationship with Rules

- [003 - Primitive Encapsulation](../../object-calisthenics/003_encapsulamento-primitivos.md): Value Objects
- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): immutable embedded values

---

**Created on**: 2025-01-11
**Version**: 1.0
