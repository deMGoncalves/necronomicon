# Feature Envy (Inveja de Funcionalidade)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 057

## O que é

Método que usa dados e comportamentos de outra classe mais do que da própria. Indica que o método está na classe errada — ele "inveja" a outra classe e deveria estar lá. O método parece mais interessado nos dados de outro objeto do que nos próprios.

## Sintomas

- Método chama getters de outro objeto 3 ou mais vezes
- Método acessa propriedades de outro objeto mais do que de `this`
- Para testar o método, você precisa configurar estado complexo de objetos dependentes
- Método que não usa nenhum atributo ou método da própria classe, apenas de dependências

## ❌ Exemplo (violação)

```javascript
// ❌ calculateBill está em Reservation mas usa dados de Customer
class Reservation {
  calculateBill(customer) {
    const base = this.nights * this.room.rate;
    // usa 3 atributos de customer — está na classe errada
    if (customer.membershipYears > 2) return base * 0.9;
    if (customer.totalSpent > 5000) return base * 0.95;
    return base;
  }
}
```

## ✅ Refatoração

```javascript
// ✅ Lógica de desconto pertence a Customer (Move Method)
class Customer {
  applyDiscount(base) {
    if (this.membershipYears > 2) return base * 0.9;
    if (this.totalSpent > 5000) return base * 0.95;
    return base;
  }
}

class Reservation {
  calculateBill(customer) {
    const base = this.nights * this.room.rate;
    return customer.applyDiscount(base); // Tell, Don't Ask
  }
}
```

## Codetag sugerida

```typescript
// FIXME: Feature Envy — calculateBill usa customer.membershipYears, customer.totalSpent
// TODO: Move Method — mover lógica de desconto para Customer.applyDiscount()
```
