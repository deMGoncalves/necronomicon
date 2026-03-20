---
titulo: Limite Máximo de Parâmetros por Função
aliases:
  - Long Parameter List
  - Parameter Object
tipo: rule
id: CC-13
severidade: 🟠 Alto
origem: clean-code
tags:
  - clean-code
  - estrutural
  - solid
  - srp
resolver: Sprint atual
relacionados:
  - "[[003_encapsulamento-primitivos]]"
  - "[[001_single-responsibility-principle]]"
  - "[[proibicao-argumentos-sinalizadores]]"
criado: 2025-10-08
---

# Limite Máximo de Parâmetros por Função (Long Parameter List)

*Long Parameter List*


---

## Definição

Define um limite máximo de **3 parâmetros** por função ou método para reduzir a complexidade da assinatura e reforçar a coesão, promovendo o uso de *Parameter Objects* (DTOs).

## Motivação

Funções com muitos parâmetros (*Long Parameter List*) aumentam a **complexidade cognitiva**, dificultam a testabilidade e frequentemente indicam uma violação do Princípio da Responsabilidade Única (SRP).

## Quando Aplicar

- [ ] Funções e métodos não devem ter mais de **3** parâmetros.
- [ ] Para mais de 3 parâmetros, deve ser criado um objeto de parâmetro (DTO ou *Value Object*) para agrupar os dados.
- [ ] Construtores de classes podem exceder o limite se estiverem configurando um objeto via injeção de dependência.

## Quando NÃO Aplicar

- **Funções de Bibliotecas Externas**: Funções que implementam uma assinatura exigida por um *framework* ou biblioteca de terceiros.

## Violação — Exemplo

```javascript
// ❌ 6 parâmetros — o que significa cada um? Qual a ordem correta?
function createOrder(userId, productId, quantity, discount, couponCode, deliveryAddress) {
  // ...
}

createOrder(123, 456, 2, 0.1, 'SUMMER', '...'); // ilegível na chamada
```

## Conformidade — Exemplo

```javascript
// ✅ Parameter Object — autodocumentado, extensível e testável
function createOrder({ userId, productId, quantity, discount, couponCode, deliveryAddress }) {
  // ...
}

createOrder({
  userId: 123,
  productId: 456,
  quantity: 2,
  discount: 0.1,
  couponCode: 'SUMMER',
  deliveryAddress: '...'
});
```

## Anti-Patterns Relacionados

- **Long Parameter List** — sinal clássico de que a função faz coisas demais

## Como Detectar

### Manual

Identificar assinaturas de métodos com 4 ou mais parâmetros.

### Automático

Biome/ESLint: `max-params: ["error", 3]`.

## Relação com ICP

Reduz **Acoplamento**: funções com menos parâmetros dependem de menos dados externos. Também reduz **Responsabilidades**: muitos parâmetros frequentemente indicam que a função está orquestrando múltiplas preocupações.

## Relacionados

- [[003_encapsulamento-primitivos|Encapsulamento de Primitivos]] — reforça
- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — reforça
- [[proibicao-argumentos-sinalizadores]] — reforça
