---
titulo: Data Clumps (Aglomerados de Dados)
aliases:
  - Data Clumps
  - Aglomerados de Dados
tipo: anti-pattern
id: AP-20
severidade: 🟡 Médio
origem: refactoring
tags: [anti-pattern, estrutural, dominio, tipos]
criado: 2026-03-20
relacionados:
  - "[[primitive-obsession]]"
  - "[[003_primitive-encapsulation]]"
  - "[[long-method]]"
---

# Data Clumps (Aglomerados de Dados)

*Data Clumps*

---

## Definição

Grupos de dados que sempre aparecem juntos em parâmetros de funções, atributos de classes ou variáveis locais, mas não têm um objeto próprio que os represente como conceito coeso.

## Sintomas

- Funções que sempre recebem `(street, city, zipCode, country)` em vez de um `Address`
- Atributos que sempre são lidos/escritos juntos em uma classe
- Se remover um dos dados do grupo, os outros perdem sentido

## Causas Raiz

- Primitive Obsession: resistência a criar objetos para conceitos de domínio
- Crescimento incremental: parâmetros adicionados um por vez sem revisão
- Falta de modelagem de domínio explícita

## Consequências

- Funções com muitos parâmetros (Long Parameter List)
- Validação duplicada dos mesmos campos em vários lugares
- Mudança no conceito exige alterar N assinaturas de função

## Solução / Refatoração

Aplicar **Introduce Parameter Object** (Fowler): criar uma classe que agrupa os dados relacionados e move para ela os comportamentos sobre esses dados.

## Exemplo — Problemático

```javascript
// ❌ Endereço como 4 parâmetros separados em múltiplas funções
function createOrder(street, city, zipCode, country, productId, qty) { ... }
function validateShipping(street, city, zipCode, country) { ... }
function calculateFreight(street, city, zipCode, country) { ... }
```

## Exemplo — Refatorado

```javascript
// ✅ Address como objeto coeso
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

## Rules que Previnem

- [[003_primitive-encapsulation]] — encapsulação de primitivos
- [[limite-parametros-funcao]] — Data Clumps são causa de Long Parameter Lists

## Relacionados

- [[primitive-obsession]] — Data Clumps são Primitive Obsession em grupo
