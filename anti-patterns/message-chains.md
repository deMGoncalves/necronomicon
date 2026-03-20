---
titulo: Message Chains (Cadeia de Mensagens)
aliases:
  - Message Chains
  - Train Wreck
  - Cadeia de Mensagens
tipo: anti-pattern
id: AP-21
severidade: 🟡 Médio
origem: refactoring
tags: [anti-pattern, estrutural, acoplamento, encapsulamento]
criado: 2026-03-20
relacionados:
  - "[[005_method-chaining-restriction]]"
  - "[[009_tell-dont-ask]]"
  - "[[middle-man]]"
---

# Message Chains (Cadeia de Mensagens)

*Message Chains / Train Wreck*

---

## Definição

Sequência de chamadas encadeadas onde cada resultado serve de receptor para a próxima chamada: `a.getB().getC().getD().getValue()`. O cliente conhece a estrutura interna de toda a cadeia de objetos.

## Sintomas

- Linhas com 3 ou mais chamadas encadeadas navegando objetos
- Código que quebra quando a estrutura interna de qualquer objeto na cadeia muda
- Difícil de mockar para testes: precisa de stubs em profundidade

## Causas Raiz

- Violação do encapsulamento: expor estrutura interna via getters em cascata
- Tell, Don't Ask ignorado: perguntar dados em vez de pedir comportamento
- Lei de Demeter violada: objeto conhece muito mais do que seus vizinhos imediatos

## Consequências

- Acoplamento estrutural profundo: depende da estrutura de 3+ objetos
- Refatoração cara: mover um campo interno quebra todas as cadeias que o acessam
- Null safety problemática: falha difícil de diagnosticar no meio da cadeia

## Solução / Refatoração

Aplicar **Hide Delegate** (Fowler): criar um método na classe intermediária que abstrai o acesso ao objeto distante. A Lei de Demeter: fale apenas com seus vizinhos diretos.

## Exemplo — Problemático

```javascript
// ❌ Cadeia que expõe estrutura interna profunda
const city = order.getCustomer().getAddress().getCity().getName();

// ❌ Falha obscura em null: qual objeto é null?
order.getUser().getProfile().getAvatar().getUrl();
```

## Exemplo — Refatorado

```javascript
// ✅ Cada objeto encapsula o acesso ao seu vizinho
class Order {
  getCustomerCity() {
    return this.customer.getCity(); // encapsula a navegação
  }
}

const city = order.getCustomerCity();
```

## Rules que Previnem

- [[005_method-chaining-restriction]] — restrição de encadeamento de métodos
- [[009_tell-dont-ask]] — pedir comportamento em vez de navegar estrutura

## Relacionados

- [[feature-envy]] — Message Chains frequentemente causam Feature Envy
- [[middle-man]] — Hide Delegate pode criar um Middle Man se levado longe demais
