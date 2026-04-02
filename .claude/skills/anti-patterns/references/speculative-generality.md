# Speculative Generality (Generalidade Especulativa)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 023

## O que é

Código criado para suportar casos de uso hipotéticos que "talvez" sejam necessários no futuro: hooks, parâmetros, classes abstratas e configurações que não têm uso atual. Fowler: *"Oh, I think we'll need the ability to do this kind of thing someday."*

## Sintomas

- Classes ou métodos vazios que visam ser placeholders para funcionalidades futuras
- Parâmetros de função que sempre recebem o mesmo valor e nunca variam
- Classes abstratas com um único implementador
- Hooks e callbacks nunca invocados ("para extensibilidade futura")
- Métodos públicos que nenhum código externo chama
- Herança criada "para quando tivermos mais tipos"
- Código com mais de 5% de linhas marcadas como desabilitadas ou com `// TODO: futura implementação`

## ❌ Exemplo (violação)

```javascript
// ❌ Parâmetro "options" nunca usado com valores diferentes
function getUser(id, options = { includeDeleted: false, format: 'full' }) {
  // options.includeDeleted nunca é true em nenhum chamador
  // options.format nunca é diferente de 'full'
  return db.users.find(id);
}

// ❌ Classe abstrata com um único implementador
class BaseNotifier { notify(message) { throw new Error('Not implemented'); } }
class EmailNotifier extends BaseNotifier { notify(message) { sendEmail(message); } }
// EmailNotifier é o único implementador que existirá nos próximos 2 anos
```

## ✅ Refatoração

```javascript
// ✅ Simples e direto — adiciona flexibilidade quando houver caso de uso real (YAGNI)
function getUser(id) {
  return db.users.find(id);
}

function sendNotification(message) {
  sendEmail(message);
}

// Quando houver SMSNotifier real, aí cria abstraction
```

## Codetag sugerida

```typescript
// FIXME: Speculative Generality — options nunca usado, BaseNotifier tem 1 impl
// TODO: Remover abstração até existir 2º implementador REAL
```
