# Naming (Rules 006, 034, 035)

## Rules

- **006**: No abbreviated names or ambiguous acronyms
- **034**: Classes = nouns, Methods = verbs
- **035**: No misleading names or Hungarian notation

## Checklist

- [ ] Names ≥3 characters (except `i`, `j` in loops)
- [ ] No acronyms (`Mngr` → `Manager`)
- [ ] Classes in PascalCase, singular nouns
- [ ] Methods in camelCase, verbs
- [ ] Booleans with prefixes `is`, `has`, `can`
- [ ] Collections named according to real structure (Set, Map, Array)
- [ ] No type prefixes (`strName` → `name`)

## Examples

```typescript
// ❌ Violations
class UserMgr { } // ambiguous acronym
function usr(id) { } // abbreviated + noun as method
const strName = 'Alice'; // Hungarian notation
const accountList = new Set(); // misleading name (Set isn't List)

// ✅ Compliance
class UserManager { }
function getUser(id) { } // verb + noun
const userName = 'Alice';
const accountSet = new Set();
const isActive = true;
const hasPermission = user.roles.includes('admin');
```

## Relation to ICP

Clear names reduce cognitive cost — reader understands intent without needing to read implementation.
