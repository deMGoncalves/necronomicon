# Interpreter

**Categoria:** Comportamental
**Intenção:** Dada uma linguagem, definir uma representação para sua gramática junto com um interpretador que usa essa representação para interpretar sentenças.

---

## Quando Usar

- Implementar DSLs simples (Domain Specific Languages)
- Parsers de expressões (calculadoras, filtros de busca)
- Sistemas de regras de negócio configuráveis
- Processamento de templates simples

## Quando NÃO Usar

- Para gramáticas complexas — usar geradores de parser dedicados como ANTLR (rule 068 — Martelo de Ouro)
- Quando performance é crítica — interpreters são lentos por natureza
- Para linguagens com muitas regras — explosão de classes Expression

## Estrutura Mínima (TypeScript)

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

## Exemplo de Uso Real

```typescript
new AddExpression(
  new VariableExpression('x'),
  new NumberExpression(5)
).interpret(new Map([['x', 10]]))
```

## Relacionada com

- [composite.md](composite.md): complementa — gramáticas compostas formam árvores; Composite é a estrutura natural para Interpreter
- [visitor.md](visitor.md): complementa — Visitor pode percorrer a árvore de expressões do Interpreter para operações distintas
- [rule 068 - Proibição de Martelo de Ouro](../../../rules/068_proibicao-martelo-de-ouro.md): reforça — para gramáticas complexas, usar ferramenta especializada em vez de Interpreter manual
- [rule 022 - Priorização de Simplicidade e Clareza](../../../rules/022_priorizacao-simplicidade-clareza.md): reforça — preferir Interpreter apenas quando a DSL é genuinamente simples

---

**GoF Categoria:** Behavioral
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
