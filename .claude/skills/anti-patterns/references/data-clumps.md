# Data Clumps (Aglomerados de Dados)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 053

## O que é

Grupos de dados que sempre aparecem juntos em parâmetros de funções, atributos de classes ou variáveis locais, mas não têm um objeto próprio que os represente como conceito coeso. São primitivos que sempre viajam juntos mas nunca se casaram.

## Sintomas

- Funções que sempre recebem `(street, city, zipCode, country)` em vez de um `Address`
- 3 ou mais parâmetros aparecem juntos em 2+ funções diferentes
- Atributos que sempre são lidos/escritos juntos em uma classe
- Se remover um dos dados do grupo, os outros perdem sentido
- Validação dos mesmos campos repetida em múltiplas localizações

## ❌ Exemplo (violação)

```javascript
// ❌ Endereço como 4 parâmetros separados em múltiplas funções
function createOrder(street, city, zipCode, country, productId, qty) { ... }
function validateShipping(street, city, zipCode, country) { ... }
function calculateFreight(street, city, zipCode, country) { ... }
```

## ✅ Refatoração

```javascript
// ✅ Address como objeto coeso (Introduce Parameter Object)
class Address {
  constructor({ street, city, zipCode, country }) {
    if (!zipCode) throw new Error('CEP obrigatório');
    Object.assign(this, { street, city, zipCode, country });
  }
}

function createOrder(address, productId, qty) { ... }
function validateShipping(address) { ... }
function calculateFreight(address) { ... }
```

## Codetag sugerida

```typescript
// FIXME: Data Clumps — (street, city, zipCode, country) aparecem em 3+ funções
// TODO: Introduce Parameter Object: criar Address class
```
