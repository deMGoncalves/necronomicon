# Rule 9 — Tell, Don't Ask

**Rule deMGoncalves:** COMPORTAMENTAL-009
**Pergunta:** Este código pergunta estado para decidir ação?

## O que é

Exige que um método chame métodos ou acesse propriedades apenas de seus "vizinhos imediatos": o próprio objeto, objetos passados como argumentos, objetos que ele cria ou objetos que são propriedades internas diretas.

**Princípio**: Diga ao objeto o que fazer, não pergunte seu estado para tomar decisões.

## Quando Aplicar

- Código pergunta estado: `if (obj.getStatus() === 'X')`
- Código decide ação baseado em estado de outro objeto
- Train wreck: `a.getB().getC().f()`
- Violação da Law of Demeter

## ❌ Violação

```typescript
class OrderProcessor {
  process(order: Order): void {
    // PERGUNTA estado para decidir - VIOLA
    if (order.getStatus() === 'pending') {
      if (order.getPayment().isPaid()) {
        order.setStatus('processing');
        order.getCustomer().sendEmail('Order processing');
      }
    }
  }
}
```

## ✅ Correto

```typescript
class OrderProcessor {
  process(order: Order): void {
    // DIGA ao objeto o que fazer
    order.processIfReady();
  }
}

class Order {
  processIfReady(): void {
    if (!this.status.isPending()) return;
    if (!this.payment.isPaid()) return;

    this.status = OrderStatus.processing();
    this.customer.notifyProcessing();
  }
}
```

## ✅ Correto (Ainda Melhor)

```typescript
class Order {
  processIfReady(): void {
    // Cada objeto tem responsabilidade própria
    this.validateCanProcess();
    this.startProcessing();
    this.notifyCustomer();
  }

  private validateCanProcess(): void {
    if (!this.status.isPending()) {
      throw new InvalidStatusError();
    }
    if (!this.payment.isPaid()) {
      throw new UnpaidOrderError();
    }
  }

  private startProcessing(): void {
    this.status = OrderStatus.processing();
  }

  private notifyCustomer(): void {
    this.customer.notifyProcessing();
  }
}
```

## Exceções

- **Fluent Interfaces**: Builders onde método retorna `this`
- **DTOs/Value Objects**: Acesso a dados de containers puros

## Related Rules

- [008 - Proibição de Getters/Setters](rule-08-no-getters-setters.md): reforça
- [005 - Um Ponto por Linha](rule-05-one-dot-per-line.md): reforça
- [012 - Princípio de Substituição de Liskov](../../rules/012_principio-substituicao-liskov.md): reforça
