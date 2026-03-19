# Association Table Mapping

**Classification**: Object-Relational Structural Pattern

---

## Intent and Purpose

Save many-to-many association as link table with foreign keys to both tables. Uses intermediate table to represent bidirectional relationship between objects.

## Also Known As

- Join Table Mapping
- Link Table Mapping
- Many-to-Many Mapping
- Junction Table

## Motivation

Many-to-many relationships are common in objects: Student has many Courses, Course has many Students. Relational databases don't support many-to-many directly - they require intermediate table. Association Table Mapping manages this link table transparently.

Association table contains only foreign keys pointing to the two related entities. For example, student_courses has student_id and course_id. When adding Course to Student, Mapper inserts row in link table. When removing, deletes row. When loading Student, Mapper joins tables via link table to retrieve Courses.

Link table can be simple (only FKs) or rich (with additional attributes like enrollment date, grade). Rich link eventually becomes its own entity.

## Applicability

Use Association Table Mapping when:

- Objects have many-to-many relationships
- Normalized relational database is used
- Relationship doesn't have significant attributes of its own
- Both sides of relationship are independent entities
- Bidirectional collections need to be navigated
- ORM pattern requires explicit mapping

## Structure

```
Domain Objects (in memory)
Student
├── id: 1
└── courses: [Course{id:101}, Course{id:102}]

Course
├── id: 101
└── students: [Student{id:1}, Student{id:2}]

Database (persisted)
students table
└── id: 1, name: "Alice"

courses table
├── id: 101, name: "Math"
└── id: 102, name: "Physics"

student_courses (link table)
├── student_id: 1, course_id: 101
├── student_id: 1, course_id: 102
└── student_id: 2, course_id: 101
```

## Participants

- **Entity A**: First entity in relationship (Student)
- **Entity B**: Second entity in relationship (Course)
- **Association Table**: Table containing only foreign keys
- **Link Row**: Row in association table
- [**Data Mapper**](../data-source/004_data-mapper.md): Manages insertion/deletion/query of links

## Collaborations

**When Adding Relationship:**
- Client adds Course to Student.courses collection
- On commit, Mapper detects change in collection
- Mapper inserts row in student_courses with both IDs
- Relationship now exists in database

**When Loading:**
- Mapper loads Student from database
- Mapper queries student_courses WHERE student_id = 1
- Mapper obtains related course_ids
- Mapper loads corresponding Courses
- Mapper populates Student.courses with Course objects

**When Removing:**
- Client removes Course from Student.courses collection
- On commit, Mapper detects removal
- Mapper deletes corresponding row from student_courses
- Relationship undone without affecting entities

## Consequences

### Advantages

- **Normalization**: Follows normalized relational design
- **Independence**: Entities exist independently
- **Bidirectionality**: Relationship navigable from both sides
- **Flexibility**: Easy to add/remove associations
- **Integrity**: Foreign keys maintain referential integrity
- **Standard pattern**: Widely used and understood

### Disadvantages

- **Join complexity**: Queries require additional joins
- **Performance**: More tables to query
- **Extra table**: Additional table to manage
- **Richer links**: If link needs attributes, becomes entity
- **Cascade deletes**: Requires careful configuration
- **Bulk operations**: Bulk operations are complex

## Implementation

### Considerations

1. **Table naming**: Convention for link table name
2. **Composite key**: Compound primary key or own ID?
3. **Bidirectionality**: Maintain both sides synchronized
4. **Lazy/Eager**: Collection loading strategy
5. **Cascade**: What happens when entity is deleted
6. **Link attributes**: If link has attributes, consider entity

### Techniques

- **Composite PK**: Use (entity_a_id, entity_b_id) as primary key
- **Unique Constraint**: Prevent duplicate links
- **Cascade Delete**: Delete links when entity is removed
- **Lazy Collection**: Don't load collection until accessed
- **Join Fetch**: Use join to load collection efficiently
- **Inverse Side**: Designate one side as "owner" of relationship

## Known Uses

- **Hibernate @ManyToMany**: With @JoinTable for link table
- **Entity Framework Many-to-Many**: Navigation properties
- **ActiveRecord has_and_belongs_to_many**: HABTM with join table
- **Sequelize belongsToMany**: With through option
- **TypeORM @ManyToMany**: With @JoinTable
- **Doctrine ManyToMany**: With JoinTable annotation

## Related Patterns

- [**Foreign Key Mapping**](005_foreign-key-mapping.md): Link table has two foreign keys
- [**Identity Field**](004_identity-field.md): IDs used in link table
- [**Data Mapper**](../data-source/004_data-mapper.md): Implements the mapping
- [**Dependent Mapping**](007_dependent-mapping.md): Alternative for dependent objects
- [**Lazy Load**](003_lazy-load.md): Loads collections on demand

### Relation to Rules

- [004 - First-Class Collections](../../object-calisthenics/004_colecoes-primeira-classe.md): well-encapsulated collections

---

**Created**: 2025-01-11
**Version**: 1.0
