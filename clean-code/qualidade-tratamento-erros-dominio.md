---
titulo: "Qualidade do Tratamento de Erros: Use Exceções de Domínio"
aliases:
  - Domain Exceptions
  - Domain Error Handling
tipo: rule
id: CC-07
severidade: 🟠 Alto
origem: clean-code
tags:
  - clean-code
  - comportamental
  - error-handling
resolver: Sprint atual
relacionados:
  - "[[002_proibicao-clausula-else]]"
  - "[[priorizacao-simplicidade-clareza]]"
  - "[[tratamento-excecao-assincrona]]"
  - "[[restricao-funcoes-efeitos-colaterais]]"
  - "[[011_logs-fluxo-eventos]]"
criado: 2025-10-08
---

# Qualidade do Tratamento de Erros: Use Exceções de Domínio (Domain Exceptions)

*Domain Exceptions*


---

## Definição

Requer que a lógica de negócio utilize **exceções (erros)** para reportar problemas, em vez de códigos de retorno ou valores nulos. As exceções devem ser específicas do domínio (ex.: `UserNotFoundError`).

## Motivação

Códigos de erro ou valores nulos (ex.: `return null`) forçam o cliente a verificar o retorno em cada chamada, espalhando a lógica de erro. Exceções garantem que os erros não sejam ignorados e fornecem stack traces.

## Quando Aplicar

- [ ] Métodos de negócio (Services, Use Cases) devem retornar tipos válidos ou lançar exceção, **proibindo** `return null` ou `return undefined`.
- [ ] É proibido o uso de blocos `catch` vazios ou blocos que apenas registram o erro e continuam o fluxo (deve relançar ou tratar).
- [ ] As exceções lançadas devem ser customizadas para o domínio (ex.: estender uma classe `BaseDomainError`).

## Quando NÃO Aplicar

- **Funções de Parse/Utilitário**: Funções de baixo nível que podem retornar `null` ou `undefined` para indicar falha de leitura ou conversão.

## Violação — Exemplo

```javascript
// ❌ null retornado força verificação em cascata no cliente
function findUser(id) {
  const user = db.find(id);
  return user || null; // cliente precisa verificar null em todo lugar
}

// ❌ catch vazio silencia o erro
async function processOrder(id) {
  try {
    await orderService.process(id);
  } catch (e) {} // erro ignorado
}
```

## Conformidade — Exemplo

```javascript
// ✅ Exceção de domínio com contexto claro
class UserNotFoundError extends BaseDomainError {
  constructor(id) { super(`Usuário ${id} não encontrado`); }
}

function findUser(id) {
  const user = db.find(id);
  if (!user) throw new UserNotFoundError(id);
  return user;
}
```

## Anti-Patterns Relacionados

- **Return null** — usar null para representar ausência em vez de exceção ou Optional
- **Swallowed Exception** — capturar exceção e não fazer nada com ela

## Como Detectar

### Manual

Buscar `return null`, `return -1`, ou `catch (e) {}` em código de negócio.

### Automático

Biome: [`noEmptyBlockStatements`](https://biomejs.dev/linter/rules/no-empty-block-statements/) detecta blocos `catch` vazios; ausência de retorno nulo requer revisão manual.

## Relação com ICP

Reduz **[[componente-cc-base|CC_base]]** (menos caminhos de verificação nula distribuídos pelo sistema) e **[[componente-responsabilidades|Responsabilidades]]** (tratamento de erro centralizado em exceções específicas em vez de espalhado em verificações de retorno).

## Relacionados

- [[002_proibicao-clausula-else|Proibição da Cláusula ELSE]] — complementa
- [[priorizacao-simplicidade-clareza]] — reforça
- [[tratamento-excecao-assincrona]] — reforça
- [[restricao-funcoes-efeitos-colaterais]] — reforça
- [[011_logs-fluxo-eventos|Logs como Fluxo de Eventos]] — complementa
