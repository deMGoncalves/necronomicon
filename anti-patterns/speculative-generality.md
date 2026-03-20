---
titulo: Speculative Generality (Generalidade Especulativa)
aliases:
  - Speculative Generality
  - Generalidade Especulativa
tipo: anti-pattern
id: AP-17
severidade: 🟡 Médio
origem: refactoring
tags: [anti-pattern, estrutural, yagni, complexidade]
criado: 2026-03-20
relacionados:
  - "[[overengineering]]"
  - "[[boat-anchor]]"
  - "[[proibicao-funcionalidade-especulativa]]"
---

# Speculative Generality (Generalidade Especulativa)

*Speculative Generality*

---

## Definição

Código criado para suportar casos de uso hipotéticos que "talvez" sejam necessários no futuro: hooks, parâmetros, classes abstratas e configurações que não têm uso atual. Fowler: *"Oh, I think we'll need the ability to do this kind of thing someday."*

## Sintomas

- Parâmetros de função que sempre recebem o mesmo valor e nunca variam
- Classes abstratas com um único implementador
- Hooks e callbacks nunca invocados ("para extensibilidade futura")
- Métodos públicos que nenhum código externo chama
- Herança criada "para quando tivermos mais tipos"

## Causas Raiz

- YAGNI ignorado: antecipar necessidades sem evidência
- Viés de engenheiro: prazer em criar arquiteturas extensíveis
- Medo de refatorar depois: "vou deixar flexível agora para não precisar mudar"

## Consequências

- Complexidade acidental: mais código para entender sem valor entregue
- APIs confusas: parâmetros extras que ninguém sabe para que servem
- Testes que testam comportamentos hipotéticos, não reais

## Solução / Refatoração

Remover o código especulativo. Quando a necessidade real surgir, ela definirá claramente o design adequado — que provavelmente será diferente do que foi imaginado.

## Exemplo — Problemático

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

## Exemplo — Refatorado

```javascript
// ✅ Simples e direto — adiciona flexibilidade quando houver caso de uso real
function getUser(id) {
  return db.users.find(id);
}

function sendNotification(message) {
  sendEmail(message);
}
```

## Rules que Previnem

- [[proibicao-funcionalidade-especulativa]] — YAGNI: não construa o que não é necessário

## Relacionados

- [[overengineering]] — Speculative Generality é a manifestação em nível de API do Overengineering
- [[boat-anchor]] — código especulativo que nunca é usado vira Boat Anchor
