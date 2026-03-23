---
titulo: Tratamento Completo de Exceções Assíncronas (Promises)
aliases:
  - Floating Promises
  - Unhandled Promise Rejection
tipo: rule
id: CC-08
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - comportamental
  - assincrono
  - error-handling
resolver: Antes do commit
relacionados:
  - "[[qualidade-tratamento-erros-dominio]]"
  - "[[005_dependency-inversion-principle]]"
  - "[[009_descartabilidade-processos]]"
criado: 2025-10-08
---

# Tratamento Completo de Exceções Assíncronas (Promises)

*Async Exception Handling*


---

## Definição

Requer que todas as Promises retornadas sejam explicitamente tratadas (consumidas) com **`await`**, **`.catch()`** ou um padrão de resultado, para prevenir *Uncaught Promise Rejections*.

## Motivação

Em ambientes como o Node.js, exceções não tratadas em Promises são fatais e encerram o processo principal. Garante que a **estabilidade** do sistema não seja comprometida por chamadas assíncronas "flutuantes" ou erros ignorados.

## Quando Aplicar

- [ ] Todas as chamadas de função que retornam `Promise` devem ser seguidas de `await` ou `Promise.then().catch()`.
- [ ] É proibido o uso de `async` em um método sem ter pelo menos um `await` ou chamada assíncrona dentro de seu corpo.
- [ ] O código não deve lançar Promises sem capturar o erro em um contexto tratável.

## Quando NÃO Aplicar

- **Event Emitters/Listeners**: Código que se integra com *Event Loops* internos ou padrões Observer, onde o tratamento de erros é delegado ao *listener* central.

## Violação — Exemplo

```javascript
// ❌ Promise "flutuante" — rejeição não tratada termina o processo
function handleRequest(req) {
  saveToDatabase(req.body); // retorna Promise, mas não é aguardada
  return { status: 'ok' };
}

// ❌ async sem await — falsa intenção assíncrona
async function getUser(id) {
  return users.find(u => u.id === id); // não há nada assíncrono aqui
}
```

## Conformidade — Exemplo

```javascript
// ✅ Todas as Promises explicitamente tratadas
async function handleRequest(req) {
  await saveToDatabase(req.body);
  return { status: 'ok' };
}

// ✅ .catch() explícito quando não é possível usar await
function fireAndForgetWithLog(promise) {
  promise.catch(err => logger.error('Operação assíncrona falhou', err));
}
```

## Anti-Patterns Relacionados

- [[callback-hell|Floating Promises]] — Promises criadas mas nunca aguardadas nem tratadas
- **Fire and Forget sem tratamento** — disparar operação assíncrona ignorando falhas

## Como Detectar

### Manual

Buscar chamadas de função que retornam Promises sem `await` ou `.catch()` imediatamente após.

### Automático

Biome: [`useAwait`](https://biomejs.dev/linter/rules/use-await/) detecta funções `async` sem `await`; Promises flutuantes requerem revisão manual ou [`noAsyncPromiseExecutor`](https://biomejs.dev/linter/rules/no-async-promise-executor/).

## Relação com ICP

Reduz **[[componente-cc-base|CC_base]]**: Promises tratadas explicitamente tornam os caminhos de execução visíveis e contáveis. Promises flutuantes ocultam caminhos de erro, criando complexidade ciclomática invisível.

## Relacionados

- [[qualidade-tratamento-erros-dominio]] — reforça
- [[005_dependency-inversion-principle|Princípio da Inversão de Dependência]] — complementa
- [[009_descartabilidade-processos|Descartabilidade de Processos]] — complementa
