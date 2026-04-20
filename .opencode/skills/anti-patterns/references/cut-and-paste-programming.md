# Cut-and-Paste Programming (Programação por Cópia)

**Severidade:** 🔴 Crítico
**Rule associada:** Rule 021

## O que é

Reutilizar código copiando e colando blocos entre arquivos ou funções em vez de criar abstrações reutilizáveis. A lógica existe em múltiplos lugares sem uma fonte única de verdade. Violação direta do DRY (Don't Repeat Yourself).

## Sintomas

- É proibida a cópia direta de blocos de código com mais de 5 linhas entre classes ou métodos
- Lógica complexa usada em mais de 2 locais sem ser extraída
- Blocos de código idênticos ou quase idênticos em arquivos diferentes
- Bug corrigido em um lugar mas presente nos clones
- `// copied from UserService` como comentário
- Funções com nomes tipo `processOrderV2`, `processOrderFinal`, `processOrderFixed`

## ❌ Exemplo (violação)

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

## ✅ Refatoração

```javascript
// ✅ Validação extraída para uma única fonte de verdade (Extract Function)
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

## Codetag sugerida

```typescript
// FIXME: Cut-and-Paste Programming — validação duplicada em create/update/patch
// TODO: Extract Function — criar validateUserData() reutilizável
```
