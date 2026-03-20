---
titulo: Feature Envy (Inveja de Funcionalidade)
aliases:
  - Feature Envy
  - Inveja de Funcionalidade
tipo: anti-pattern
id: AP-13
severidade: 🟡 Médio
origem: refactoring
tags: [anti-pattern, estrutural, acoplamento, responsabilidade]
criado: 2026-03-20
relacionados:
  - "[[001_single-responsibility-principle]]"
  - "[[large-class]]"
  - "[[009_tell-dont-ask]]"
---

# Feature Envy (Inveja de Funcionalidade)

*Feature Envy*

---

## Definição

Método que usa dados e comportamentos de outra classe mais do que da própria. Indica que o método está na classe errada — ele "inveja" a outra classe.

## Sintomas

- Método chama getters de outro objeto 3 ou mais vezes
- Método parece mais interessado nos dados de outro objeto do que nos próprios
- Para testar o método, você precisa construir um objeto de outra classe

## Causas Raiz

- Design inicial incorreto: lógica colocada na classe "mais conveniente"
- Evolução sem refatoração: a classe A ganhou lógica que pertencia à B
- Uso excessivo de getters: expor dados em vez de comportamentos

## Consequências

- Acoplamento desnecessário entre classes
- Lógica fragmentada: para entender uma regra de negócio, você lê duas classes
- Violação do Tell, Don't Ask: perguntar estado em vez de pedir comportamento

## Solução / Refatoração

Aplicar **Move Method** (Fowler): mover o método para a classe cujos dados ele mais usa.

## Exemplo — Problemático

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

## Exemplo — Refatorado

```javascript
// ✅ Lógica de desconto pertence a Customer
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
    return customer.applyDiscount(base);
  }
}
```

## Rules que Previnem

- [[009_tell-dont-ask]] — tell, don't ask: peça comportamento, não dados

## Relacionados

- [[middle-man]] — oposto: Middle Man delega tudo; Feature Envy faz o trabalho dos outros
- [[large-class]] — Feature Envy frequentemente alimenta Large Classes
