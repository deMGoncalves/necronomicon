# Rule 1 — Nível Único de Indentação

**Rule deMGoncalves:** ESTRUTURAL-001
**Pergunta:** Este método tem mais de um nível de indentação após o escopo inicial?

## O que é

Limita a complexidade de um método ou função ao impor um único nível de indentação para blocos de código (condicionais, loops ou try-catch), forçando a extração de lógica em métodos separados.

## Quando Aplicar

- Método possui `if` dentro de `for`
- Método possui `for` dentro de `if`
- Método possui callbacks aninhados
- Complexidade Ciclomática > 5

## ❌ Violação

```typescript
class OrderProcessor {
  processOrders(orders: Order[]): void {
    for (const order of orders) {
      if (order.isValid()) {
        if (order.isPaid()) {
          // Três níveis de indentação - VIOLA
          this.shipOrder(order);
        }
      }
    }
  }
}
```

## ✅ Correto

```typescript
class OrderProcessor {
  processOrders(orders: Order[]): void {
    for (const order of orders) {
      this.processOrder(order);  // Um nível de indentação
    }
  }

  private processOrder(order: Order): void {
    if (!order.isValid()) return;  // Guard clause
    if (!order.isPaid()) return;   // Guard clause
    this.shipOrder(order);
  }
}
```

## Exceções

- **Try/Catch/Finally**: Tratamento de erros que não pode ser delegado
- **Guard Clauses**: Retornos antecipados não contam como novo nível

## Related Rules

- [002 - Proibição de ELSE](rule-02-no-else.md): reforça
- [007 - Classes Pequenas](rule-07-small-classes.md): complementa
- [022 - Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): reforça
