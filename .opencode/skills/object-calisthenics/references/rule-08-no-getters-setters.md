# Rule 8 — Proibição de Getters/Setters

**Rule deMGoncalves:** COMPORTAMENTAL-008
**Pergunta:** Este método é um getter/setter puro sem lógica de negócio?

## O que é

Proíbe a criação de métodos puramente para acessar ou modificar diretamente o estado interno do objeto (como `getProperty()` e `setProperty()`), reforçando o encapsulamento e o princípio "Tell, Don't Ask".

## Quando Aplicar

- Método com nome `getXxx()` que apenas retorna atributo
- Método com nome `setXxx()` que apenas atribui valor
- Método que expõe estado interno sem transformação
- Cliente decidindo lógica baseado em getter

## ❌ Violação

```typescript
class Order {
  private status: string;
  private items: Item[];

  getStatus(): string {  // VIOLA: getter puro
    return this.status;
  }

  setStatus(status: string): void {  // VIOLA: setter puro
    this.status = status;
  }

  getItems(): Item[] {  // VIOLA: expõe coleção interna
    return this.items;
  }
}

// Cliente decidindo lógica - VIOLA Tell, Don't Ask
if (order.getStatus() === 'pending') {
  order.setStatus('processing');
}
```

## ✅ Correto

```typescript
class Order {
  private status: OrderStatus;
  private items: OrderItemList;

  startProcessing(): void {  // Método de intenção
    if (!this.status.isPending()) {
      throw new Error('Cannot process non-pending order');
    }
    this.status = OrderStatus.processing();
  }

  addItem(item: Item): void {  // Método de comportamento
    this.items.add(item);
  }

  getTotalValue(): number {  // Transformação/cálculo é OK
    return this.items.getTotalValue();
  }
}

// Cliente dizendo o que fazer - CORRETO
order.startProcessing();
```

## Exceções

- **DTOs**: Classes puras para transferência de dados
- **Frameworks de Serialização**: Bibliotecas que exigem getters/setters

## Related Rules

- [009 - Tell, Don't Ask](rule-09-tell-dont-ask.md): reforça
- [003 - Encapsulamento de Primitivos](rule-03-wrap-primitives.md): complementa
- [004 - Coleções de Primeira Classe](rule-04-first-class-collections.md): reforça
