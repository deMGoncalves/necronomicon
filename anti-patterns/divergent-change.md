---
titulo: Divergent Change (Mudança Divergente)
aliases:
  - Divergent Change
  - Mudança Divergente
tipo: anti-pattern
id: AP-16
severidade: 🟠 Alto
origem: refactoring
tags: [anti-pattern, estrutural, responsabilidade, acoplamento]
criado: 2026-03-20
relacionados:
  - "[[shotgun-surgery]]"
  - "[[large-class]]"
  - "[[001_single-responsibility-principle]]"
---

# Divergent Change (Mudança Divergente)

*Divergent Change*

---

## Definição

Uma única classe muda por múltiplas razões diferentes e não relacionadas. Cada novo tipo de mudança exige editar a mesma classe por um motivo completamente diferente do anterior. Oposto complementar do Shotgun Surgery.

## Sintomas

- "Mudei essa classe porque trocamos o banco de dados... e porque mudou a regra de desconto... e porque o relatório mudou de formato"
- Uma classe com seções claramente separadas por comentários (`// database logic`, `// business rules`, `// formatting`)
- Histórico de commits: commits de features muito diferentes sempre tocam o mesmo arquivo

## Causas Raiz

- Violação do SRP: classe com múltiplas responsabilidades
- The Blob em formação
- Falta de separação de camadas

## Consequências

- Mudanças de features não relacionadas interferem entre si
- Difícil de testar em isolamento
- Maior risco de regressão: mudar a lógica de banco afeta acidentalmente as regras de negócio

## Solução / Refatoração

Aplicar **Extract Class** (Fowler): separar as responsabilidades em classes dedicadas, cada uma mudando por apenas um motivo.

## Exemplo — Problemático

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

## Exemplo — Refatorado

```javascript
// ✅ Cada classe muda por apenas um motivo
class OrderRepository { async findOrders(filters) { ... } }       // muda quando o banco muda
class TaxCalculator { calculateTax(order) { ... } }               // muda quando a lei muda
class OrderReportFormatter { formatForReport(orders) { ... } }    // muda quando o relatório muda
```

## Rules que Previnem

- [[001_single-responsibility-principle]] — uma classe, um motivo para mudar

## Relacionados

- [[shotgun-surgery]] — complementares: Divergent Change = 1 classe, N motivos; Shotgun Surgery = 1 motivo, N classes
- [[large-class]] — Divergent Change é sintoma de Large Class
