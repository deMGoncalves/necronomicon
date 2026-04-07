# Rule 6 — No Abbreviations Prohibition

**deMGoncalves Rule:** ESTRUTURAL-006
**Question:** Is this name an incomprehensible abbreviation?

## What It Is

Requires that names of variables, methods, classes and parameters be complete, self-explanatory and not use abbreviations or acronyms that are not widely recognized in the problem domain.

## When to Apply

- Name with less than 3 characters (except loops)
- Name with abbreviation (`usr`, `calc`, `mngr`)
- Name with ambiguous acronym (`Proc`, `Svc`, `Mgr`)
- Name requiring comment to explain

## ❌ Violation

```typescript
class UsrMngr {  // VIOLATES: abbreviations
  calcTot(ord: Order): number {  // VIOLATES: calc, tot, ord
    const itms = ord.getItms();  // VIOLATES: itms
    let t = 0;  // VIOLATES: t is ambiguous
    for (const i of itms) {  // OK: i in loop is exception
      t += i.prc;  // VIOLATES: prc
    }
    return t;
  }
}
```

## ✅ Correct

```typescript
class UserManager {
  calculateTotal(order: Order): number {
    const items = order.getItems();
    let total = 0;
    for (const item of items) {
      total += item.price;
    }
    return total;
  }
}
```

## ✅ Correct (Better Approach)

```typescript
class OrderTotalCalculator {
  calculate(order: Order): number {
    return order.items.reduce(
      (total, item) => total + item.price,
      0
    );
  }
}
```

## Exceptions

- **Loop Conventions**: `i`, `j`, `k` for iterators
- **Ubiquitous Acronyms**: `ID`, `URL`, `API`, `HTTP`, `CPF`

## Related Rules

- [003 - Primitive Encapsulation](rule-03-wrap-primitives.md): reinforces
- [024 - No Magic Constants Prohibition](../../rules/024_proibicao-constantes-magicas.md): complements
- [034 - Consistent Names](../../rules/034_nomes-classes-metodos-consistentes.md): reinforces
