# Interpreter

**Category:** Behavioral
**Intent:** Given a language, define a representation for its grammar along with an interpreter that uses the representation to interpret sentences.

---

## When to Use

- Implement simple DSLs (Domain Specific Languages)
- Expression parsers (calculators, search filters)
- Configurable business rule systems
- Simple template processing

## When NOT to Use

- For complex grammars — use dedicated parser generators like ANTLR (rule 068 — Golden Hammer)
- When performance is critical — interpreters are inherently slow
- For languages with many rules — Expression class explosion

## Minimal Structure (TypeScript)

```typescript
interface Expression {
  interpret(context: Map<string, number>): number
}

class NumberExpression implements Expression {
  constructor(private readonly value: number) {}
  interpret(_: Map<string, number>): number { return this.value }
}

class VariableExpression implements Expression {
  constructor(private readonly name: string) {}
  interpret(context: Map<string, number>): number {
    return context.get(this.name) ?? 0
  }
}

class AddExpression implements Expression {
  constructor(
    private readonly left: Expression,
    private readonly right: Expression
  ) {}
  interpret(context: Map<string, number>): number {
    return this.left.interpret(context) + this.right.interpret(context)
  }
}
```

## Real Usage Example

```typescript
new AddExpression(
  new VariableExpression('x'),
  new NumberExpression(5)
).interpret(new Map([['x', 10]]))
```

## Related to

- [composite.md](composite.md): complements — composed grammars form trees; Composite is the natural structure for Interpreter
- [visitor.md](visitor.md): complements — Visitor can traverse the Interpreter's expression tree for distinct operations
- [rule 068 - Prohibition of Golden Hammer](../../../rules/068_proibicao-martelo-de-ouro.md): reinforces — for complex grammars, use specialized tool instead of manual Interpreter
- [rule 022 - Prioritization of Simplicity and Clarity](../../../rules/022_priorizacao-simplicidade-clareza.md): reinforces — prefer Interpreter only when the DSL is genuinely simple

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
