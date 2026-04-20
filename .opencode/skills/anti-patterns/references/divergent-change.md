# Divergent Change (Mudança Divergente)

**Severidade:** 🟠 Alto
**Rule associada:** Rule 054

## O que é

Uma única classe muda por múltiplas razões diferentes e não relacionadas. Cada novo tipo de mudança exige editar a mesma classe por um motivo completamente diferente do anterior. Oposto complementar do Shotgun Surgery: aqui, uma classe muda por N razões.

## Sintomas

- Classe possui seções separadas por comentários (`// database logic`, `// business rules`, `// ui formatting`)
- Histórico de commits mostra commits de features totalmente diferentes sempre modificando mesmo arquivo
- Testes de unidade precisam mockar múltiplas responsabilidades para testar uma única funcionalidade
- Múltiplas razões para mudar: "mudei porque trocamos o banco... e porque mudou a regra de desconto... e porque o relatório mudou"

## ❌ Exemplo (violação)

```javascript
// ❌ OrderService muda quando: muda o banco, muda regra fiscal, muda formato de relatório
class OrderService {
  // Camada de dados
  async findOrders(filters) { return db.query('SELECT ...', filters); }

  // Regra de negócio
  calculateTax(order) { return order.subtotal * TAX_RATES[order.region]; }

  // Formatação
  formatForReport(orders) { return orders.map(o => ({ id: o.id, total: formatCurrency(o.total) })); }
}
```

## ✅ Refatoração

```javascript
// ✅ Cada classe muda por apenas um motivo (Extract Class)
class OrderRepository {
  async findOrders(filters) { ... }  // muda quando o banco muda
}

class TaxCalculator {
  calculateTax(order) { ... }        // muda quando a lei muda
}

class OrderReportFormatter {
  formatForReport(orders) { ... }    // muda quando o relatório muda
}
```

## Codetag sugerida

```typescript
// FIXME: Divergent Change — OrderService tem 3 responsabilidades: persistência, cálculo, formatação
// TODO: Extract OrderRepository, TaxCalculator, OrderReportFormatter
```
