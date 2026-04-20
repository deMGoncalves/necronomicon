# Lava Flow (Código Morto / Zombie Code)

**Severidade:** 🟠 Alto
**Rule associada:** Rule 056

## O que é

Código que não é mais usado mas permanece no sistema porque ninguém tem certeza se pode ser removido com segurança. Como lava que solidifica e endurece, esse código vira obstáculo permanente à manutenção. Código abandonado, comentado ou nunca chamado.

## Sintomas

- Funções, classes ou módulos nunca chamados/executados
- Código comentado com markers (`// old version`, `// deprecated`, `// TODO remove`)
- Importações de módulos/pacotes que nunca são referenciados
- Branches de `if` ou `switch` que nunca são executadas (cobertura de teste = 0%)
- Variáveis declaradas e nunca lidas
- Arquivos inteiros que ninguém sabe para que servem

## ❌ Exemplo (violação)

```javascript
// ❌ Funções que ninguém chama, código comentado acumulado
function calculateOldDiscount(price) { // deprecated - use calculateDiscount
  return price * 0.1;
}

// function formatUserV1(user) {
//   return user.name + ' (' + user.email + ')';
// }

function getUser(id) {
  // const cache = loadCache(); // removido em 2023 mas mantido por segurança
  return db.find(id);
}
```

## ✅ Refatoração

```javascript
// ✅ Apenas o que é usado existe no código
function getUser(id) {
  return db.find(id);
}

// Código morto eliminado — controle de versão guarda o histórico
```

## Codetag sugerida

```typescript
// FIXME: Lava Flow — calculateOldDiscount nunca chamado, código comentado acumulado
// TODO: Remover código morto; git guarda histórico
```
