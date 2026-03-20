---
titulo: Cut-and-Paste Programming (Programação por Cópia)
aliases:
  - Cut-and-Paste Programming
  - Copy-Paste Programming
  - Clonagem de Código
tipo: anti-pattern
id: AP-05
severidade: 🟠 Alto
origem: antipatterns-book
tags: [anti-pattern, estrutural, dry, duplicacao]
criado: 2026-03-20
relacionados:
  - "[[proibicao-duplicacao-logica]]"
  - "[[lava-flow]]"
  - "[[shotgun-surgery]]"
---

# Cut-and-Paste Programming (Programação por Cópia)

*Cut-and-Paste Programming / Copy-Paste Programming*

---

## Definição

Reutilizar código copiando e colando blocos entre arquivos ou funções em vez de criar abstrações reutilizáveis. A lógica existe em múltiplos lugares sem uma fonte única de verdade.

## Sintomas

- Blocos de código idênticos ou quase idênticos em arquivos diferentes
- Bug corrigido em um lugar mas presente nos clones
- `// copied from UserService` como comentário
- Funções com nomes tipo `processOrderV2`, `processOrderFinal`, `processOrderFixed`

## Causas Raiz

- Pressão de prazo: "mais rápido copiar do que abstrair"
- Medo de alterar código existente: criar cópia parece mais seguro
- Falta de conhecimento sobre como criar abstrações adequadas
- Ausência de revisão de código que detecte duplicação

## Consequências

- Violação direta do DRY: cada clone é uma fonte de divergência futura
- Bugs sistemáticos: correção precisa ser aplicada em N lugares
- Inconsistência inevitável: clones divergem ao longo do tempo
- Aumento de tamanho da codebase sem aumento de valor

## Solução / Refatoração

Aplicar **Extract Function** (Fowler): identificar o código duplicado, parametrizar as diferenças e criar uma função/classe reutilizável. Regra: se você copiou mais de 3 linhas, provavelmente precisa de uma abstração.

## Exemplo — Problemático

```javascript
// ❌ Mesma validação copiada em três lugares
function createUser(data) {
  if (!data.email || !data.email.includes('@')) throw new Error('Email inválido');
  if (!data.name || data.name.length < 2) throw new Error('Nome inválido');
  return db.users.create(data);
}

function updateUser(id, data) {
  if (!data.email || !data.email.includes('@')) throw new Error('Email inválido');
  if (!data.name || data.name.length < 2) throw new Error('Nome inválido');
  return db.users.update(id, data);
}
```

## Exemplo — Refatorado

```javascript
// ✅ Validação extraída para uma única fonte de verdade
function validateUserData(data) {
  if (!data.email || !data.email.includes('@')) throw new Error('Email inválido');
  if (!data.name || data.name.length < 2) throw new Error('Nome inválido');
}

function createUser(data) {
  validateUserData(data);
  return db.users.create(data);
}

function updateUser(id, data) {
  validateUserData(data);
  return db.users.update(id, data);
}
```

## Rules que Previnem

- [[proibicao-duplicacao-logica]] — proíbe explicitamente duplicação (DRY)

## Relacionados

- [[shotgun-surgery]] — consequência: bug no clone exige mudança em N arquivos
- [[lava-flow]] — clones abandonados viram código morto
