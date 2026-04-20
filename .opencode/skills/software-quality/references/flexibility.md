# Flexibility — Flexibilidade

**Dimensão:** Revisão
**Severidade Default:** 🟠 Importante
**Pergunta Chave:** É fácil mudar?

## O que é

O esforço necessário para modificar o software para atender a novos requisitos ou mudanças de negócio. Alta flexibilidade significa que novas funcionalidades podem ser adicionadas sem alterar código existente (Open/Closed Principle).

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Dependência circular entre módulos | 🔴 Blocker |
| Switch com > 5 cases crescentes | 🟠 Important |
| new Concrete() em classe de negócio | 🟠 Important |
| Herança > 3 níveis | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não flexível - precisa modificar para cada novo tipo
function calculateShipping(order) {
  switch (order.type) {
    case 'standard': return order.weight * 5;
    case 'express': return order.weight * 10;
    // Cada novo tipo requer modificar esta função
  }
}

// ✅ Flexível - extensível sem modificação
class ShippingCalculator {
  constructor(strategies) {
    this.strategies = strategies;
  }

  calculate(order) {
    const strategy = this.strategies.get(order.type);
    return strategy.calculate(order);
  }
}
```

## Codetags Sugeridos

```javascript
// OCP(011): Este switch viola Open/Closed - considerar Strategy
// DIP(014): Dependência concreta - injetar via construtor
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Dependência circular entre módulos | 🔴 Blocker |
| Switch com > 5 cases crescentes | 🟠 Important |
| new Concrete() em classe de negócio | 🟠 Important |
| Herança > 3 níveis | 🟡 Suggestion |

## Rules Relacionadas

- 011 - Princípio Aberto/Fechado
- 014 - Princípio de Inversão de Dependência
- 018 - Princípio de Dependências Acíclicas
