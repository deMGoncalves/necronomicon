# Large Class (Classe Grande)

**Severidade:** 🟠 Alto
**Rule associada:** Rule 007

## O que é

Classe com atributos e métodos demais, indicando que está tentando fazer coisas demais. Fowler: quando uma classe tem responsabilidades demais, code smells como duplicação e falta de coesão emergem naturalmente. Estágio inicial de um The Blob.

## Sintomas

- Arquivos de classe com mais de 50 linhas de código (excluindo linhas em branco e comentários)
- Classes que atingem 40 linhas devem ser candidatas à refatoração
- Mais de 300–500 linhas
- Prefixos/sufixos nos atributos para distinguir grupos (`userEmail`, `orderEmail`, `shippingEmail`)
- Subconjuntos de atributos usados apenas por subconjuntos de métodos
- Testes que precisam de mocks extensos para testar um único comportamento
- Uma classe não deve conter mais de 10 métodos públicos

## ❌ Exemplo (violação)

```javascript
// ❌ Classe que mistura perfil, endereço e pagamento (> 50 linhas)
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

## ✅ Refatoração

```javascript
// ✅ Cada conceito em sua própria classe (Extract Class)
class User { constructor({ name, email }) { ... } }
class Address { constructor({ street, city, zipCode }) { ... } }
class PaymentMethod { constructor({ cardNumber, cardExpiry }) { ... } }

// Composição em vez de uma classe monolítica
class UserAccount {
  constructor(user, address, paymentMethod) {
    this.user = user;
    this.address = address;
    this.paymentMethod = paymentMethod;
  }
}
```

## Codetag sugerida

```typescript
// FIXME: Large Class — User tem 87 linhas, mistura profile + address + payment
// TODO: Extract Class — criar Address, PaymentMethod separados
```
