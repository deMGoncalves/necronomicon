# Serialized LOB (Serialized Large Object)

**Type**: Object-Relational Mapping Pattern (Structural)

---

## Intent and Purpose

Save an object graph by serializing it into a single Large Object (LOB) database field, allowing complex structures to be persisted without decomposition into multiple tables.

## Also Known As

- Serialized Graph
- Blob Storage Pattern
- Object Serialization Mapping

---

## Motivation

In object-oriented systems, we frequently encounter complex object graphs where decomposition into multiple relational tables would be overly complex or unnecessary. For example, a `PurchaseOrder` object may contain a hierarchy of items, discounts, tax calculators, and business rules that change frequently. Mapping this structure to a normalized relational model would create dozens of tables and complex joins.

The Serialized LOB pattern solves this problem by serializing the entire object graph into a binary or textual format (JSON, XML, Protocol Buffers) and storing it in a single BLOB (Binary Large Object) or CLOB (Character Large Object) field. When the object is needed, the system deserializes the field content and reconstructs the complete object graph in memory.

The main advantage is mapping simplicity: a complex object is persisted with a single write operation and retrieved with a single read. This eliminates the object-relational impedance mismatch for structures that don't need to be queried by their individual parts. However, the cost is the loss of granular query capability — it's not possible to write SQL queries that filter by internal attributes of the serialized object without loading and deserializing all records.

---

## Applicability

Use Serialized LOB when:

- You have complex object graphs that change frequently and don't justify complete relational mapping
- The object's internal structure doesn't need to be queried or indexed by the database
- The object is always loaded and saved as an atomic unit (never partially)
- Serialization/deserialization performance is acceptable for the data volume
- You need to version or audit the complete state of an object at a point in time
- The object structure is highly hierarchical or graph-based, making relational mapping too complex

---

## Structure

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Code                          │
└────────────────────────────────┬────────────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Domain Object         │
                    │  (ComplexOrder)         │
                    │ ─────────────────────   │
                    │ - items: List           │
                    │ - pricing: PriceCalc    │
                    │ - metadata: Map         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Serializer            │
                    │ ─────────────────────   │
                    │ + serialize(obj): bytes │
                    │ + deserialize(bytes)    │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   LOB Field             │
                    │  (Database Column)      │
                    │ ─────────────────────   │
                    │  BLOB or CLOB type      │
                    └─────────────────────────┘

Table: orders
┌──────────┬─────────────┬──────────────────┐
│ order_id │ created_at  │ serialized_data  │
│ (PK)     │ TIMESTAMP   │ BLOB             │
├──────────┼─────────────┼──────────────────┤
│ 1001     │ 2025-01-15  │ <binary data...> │
│ 1002     │ 2025-01-16  │ <binary data...> │
└──────────┴─────────────┴──────────────────┘
```

---

## Participants

- **Domain Object** (`ComplexOrder`): The complex domain object containing nested graphs of other objects. It's agnostic about its persistence form.

- **Serializer** (`ObjectSerializer`): Responsible for converting the object graph to a serializable format (binary or text) and vice versa. Can use libraries like JSON, MessagePack, Protocol Buffers, or native language serialization.

- **LOB Field** (Column `serialized_data`): Database field of BLOB or CLOB type that stores the serialized representation of the object. Has no queryable internal structure.

- **Data Mapper/Repository** (`OrderRepository`): Component that coordinates persistence, invoking the Serializer to transform objects before saving and after loading from the database.

- **Schema** (Table `orders`): Minimalist relational structure containing only the identifier, basic metadata (timestamps, version), and the LOB field.

---

## Collaborations

When the client requests saving a complex Domain Object, the Data Mapper invokes the Serializer to transform the object graph into a byte sequence (or JSON string). This serialized representation is then stored in the corresponding table's LOB field along with metadata like ID and timestamp.

During reading, the process is reversed: the Data Mapper retrieves the LOB field content, passes it to the Serializer which reconstructs the original object graph, and returns the Domain Object to the client. All persistence complexity is encapsulated, and the client works only with rich domain objects.

---

## Consequences

### Advantages

1. **Mapping Simplicity**: Eliminates the need to create dozens of tables and relationships for complex graphs.
2. **Structure Flexibility**: Changes to object structure don't require complex schema migrations — only format versioning.
3. **Load Performance**: A single read operation loads the entire object, without need for multiple queries or joins.
4. **Natural Atomicity**: The object is always saved and loaded as a consistent unit, avoiding partial states.
5. **Facilitated Versioning**: Easy to maintain complete object snapshots for auditing or history.
6. **Reduced ORM Complexity**: Doesn't require complex object-relational mapping configuration for hierarchical structures.

### Disadvantages

1. **Loss of Query Capability**: Not possible to write SQL queries that filter or sort by internal object attributes without deserializing everything.
2. **Impossibility of Indexing**: Internal object fields cannot have database indexes, hurting search performance.
3. **Serialization Overhead**: Serialization/deserialization operations can be CPU-intensive for very large objects.
4. **Storage Size**: Serialization formats can be less efficient than normalized relational decomposition.
5. **Data Migration Difficulty**: Changing object structure requires migration logic in code, not in SQL, and can break deserialization of old data.

---

## Implementation

### Implementation Considerations

1. **Serialization Format Choice**: JSON offers readability and portability; Protocol Buffers or MessagePack offer compaction and performance; native binary serialization offers speed but loses cross-language portability.

2. **Schema Versioning**: Include a version field in the serialized format to allow controlled migrations when object structure changes.

3. **Maximum LOB Size**: Databases have limits for LOB fields (e.g., 16MB in standard MySQL). Validate that your objects don't exceed these limits or configure the database appropriately.

4. **Circular Reference Handling**: Many serializers don't handle cyclic graphs well. Use libraries that support object identity preservation or refactor the model to avoid cycles.

5. **Deserialization Security**: Deserialization of untrusted data can be an attack vector (insecure deserialization). Validate and sanitize data before deserializing, especially if the format is native binary.

6. **Compression**: For large objects, consider compressing (gzip, zstd) serialized data before storing in LOB to save space and I/O.

### Implementation Techniques

1. **Abstract Serializer**: Create a `Serializer<T>` interface with methods `serialize(T obj): bytes` and `deserialize(bytes): T` to allow swapping implementations.

2. **Versioning Metadata**: Include a `version` field at the beginning of serialized data (e.g., `{ version: 2, data: {...} }`) to support multiple schema versions.

3. **Lazy Loading of LOBs**: In some databases, LOB fields are loaded lazily. Ensure the connection is still open when accessing the LOB.

4. **Deserialized Caching**: Keep the deserialized object in cache (Identity Map) to avoid repeated deserialization of the same record.

5. **Auditing via Snapshots**: Use Serialized LOB to create audit tables where each change writes a complete serialized object snapshot with timestamp.

6. **Hybrid Queries**: Keep important queryable fields outside the LOB (e.g., `order_id`, `customer_id`, `total_amount`) to allow filtering, and use LOB only for data that isn't queried.

---

## Known Uses

1. **Hibernate ORM**: Supports mapping properties as `@Lob` to serialize complex objects into BLOB/CLOB fields.

2. **Event Sourcing Systems**: Frameworks like Axon Framework store serialized domain events (JSON or Avro) in LOB fields of event stores.

3. **Salesforce**: The platform stores object customization metadata as serialized JSON in internal LOB fields.

4. **Rails Active Record**: The `serialize` method allows storing complex Ruby hashes or arrays in TEXT fields using YAML or JSON.

5. **MongoDB (hybrid)**: Although a NoSQL database, the pattern is analogous — BSON documents are "Serialized LOBs" that allow nested structures without fixed schema.

6. **Audit Trails in Financial Systems**: Banks store complete transaction snapshots as XML or JSON in CLOB fields for regulatory compliance.

---

## Related Patterns

- [**Single Table Inheritance**](010_single-table-inheritance.md): Can combine with Serialized LOB to store subclass-specific attributes in a LOB field.
- [**Embedded Value**](008_embedded-value.md): Alternative that decomposes the object into parent table columns, opposite of complete serialization.
- [**Data Transfer Object**](056_data-transfer-object.md): DTOs can be serialized in LOBs for communication between layers or systems.
- [**GoF Memento**](../../gof/behavioral/006_memento.md): Serialized LOB is a way to implement Memento to capture and restore object state.
- [**Repository**](016_repository.md): Repositories coordinate serialization/deserialization of Domain Objects when persisting to LOBs.
- [**Unit of Work**](001_unit-of-work.md): Manages when to serialize and persist modified objects in LOBs.
- [**Metadata Mapping**](014_metadata-mapping.md): Can use metadata to control which properties are serialized in the LOB.
- **Event Sourcing**: Domain events are frequently stored as Serialized LOBs in event stores.

### Relationship with Rules

- [003 - Primitive Encapsulation](../../object-calisthenics/003_encapsulamento-primitivos.md): Serialized Value Objects
- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): serialized objects should be immutable

---

## Relationship with Business Rules

- **[003] Primitive Encapsulation**: Serialized complex objects encapsulate all their logic and data, avoiding primitive exposure.
- **[029] Object Immutability**: Serialized objects can be treated as immutable — each change creates a new serialized version.
- **[010] Single Responsibility Principle**: The Serializer has the sole responsibility of format transformation, separated from domain logic.
- **[045] Stateless Processes**: Serialized LOBs allow stateless processes to persist and recover complete object state between requests.

---

**Created on**: 2025-01-10
**Version**: 1.0
