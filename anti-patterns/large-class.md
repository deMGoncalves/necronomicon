---
titulo: Large Class (Classe Grande)
aliases:
  - Large Class
  - Classe Grande
tipo: anti-pattern
id: AP-12
severidade: 🟠 Alto
origem: refactoring
tags: [anti-pattern, estrutural, responsabilidade, acoplamento]
criado: 2026-03-20
relacionados:
  - "[[the-blob]]"
  - "[[long-method]]"
  - "[[divergent-change]]"
  - "[[001_single-responsibility-principle]]"
---

# Large Class (Classe Grande)

*Large Class*

---

## Definição

Classe com atributos e métodos demais, indicando que está tentando fazer coisas demais. Fowler: quando uma classe tem responsabilidades demais, code smells como duplicação e falta de coesão emergem naturalmente.

## Sintomas

- Mais de 300–500 linhas
- Prefixos/sufixos nos atributos para distinguir grupos (`userEmail`, `orderEmail`, `shippingEmail`)
- Subconjuntos de atributos usados apenas por subconjuntos de métodos
- Testes que precisam de mocks extensos para testar um único comportamento

## Causas Raiz

- The Blob em formação: funcionalidades adicionadas sem criação de novas classes
- Herança mal aplicada: subclasse que herda tudo mas usa pouco
- Falta de revisão de design ao longo do tempo

## Consequências

- Violação do SRP: múltiplos motivos para mudar
- Alta probabilidade de conflitos de merge
- Impossível entender sem ler tudo
- Testes lentos e frágeis

## Solução / Refatoração

Aplicar **Extract Class** (Fowler): identificar grupos de atributos que "andam juntos" e extraí-los com seus métodos relacionados em classes dedicadas.

## Exemplo — Problemático

```javascript
// ❌ Classe que mistura perfil, endereço e pagamento
class User {
  constructor() {
    this.name = '';
    this.email = '';
    this.street = '';       // endereço
    this.city = '';         // endereço
    this.zipCode = '';      // endereço
    this.cardNumber = '';   // pagamento
    this.cardExpiry = '';   // pagamento
  }
  formatAddress() { ... }
  validateCard() { ... }
  sendEmail() { ... }
}
```

## Exemplo — Refatorado

```javascript
// ✅ Cada conceito em sua própria classe
class User { constructor({ name, email }) { ... } }
class Address { constructor({ street, city, zipCode }) { ... } }
class PaymentMethod { constructor({ cardNumber, cardExpiry }) { ... } }
```

## Rules que Previnem

- [[001_single-responsibility-principle]] — uma classe, um motivo para mudar
- [[007_maximum-lines-per-class]] — limite de linhas por classe

## Relacionados

- [[the-blob]] — Large Class é o estágio inicial de um Blob
- [[long-method]] — Large Classes acumulam Long Methods
- [[divergent-change]] — Large Class sofre Divergent Change
