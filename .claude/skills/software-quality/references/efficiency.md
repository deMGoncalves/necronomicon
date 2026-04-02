# Efficiency — Eficiência

**Dimensão:** Operação
**Severidade Default:** 🟠 Importante
**Pergunta Chave:** Ele tem boa performance?

## O que é

A quantidade de recursos computacionais e código necessários para o software realizar suas funções. Eficiência abrange tempo de execução (CPU), uso de memória, consumo de banda e otimização de I/O.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Performance crítica (< 100ms required) | 🔴 Blocker |
| Lista com 10k+ items | 🟠 Important |
| Lista com < 100 items | 🟡 Suggestion |
| Código executado raramente | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Ineficiente - O(n²) desnecessário
function findDuplicates(items) {
  const duplicates = [];
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      if (items[i] === items[j]) {
        duplicates.push(items[i]);
      }
    }
  }
  return duplicates;
}

// ✅ Eficiente - O(n) com Set
function findDuplicates(items) {
  const seen = new Set();
  const duplicates = new Set();

  for (const item of items) {
    if (seen.has(item)) duplicates.add(item);
    seen.add(item);
  }

  return [...duplicates];
}
```

## Codetags Sugeridos

```javascript
// OPTIMIZE: Este loop O(n²) pode ser O(n) com Set
// PERFORMANCE: N+1 queries - considerar batch loading
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Performance crítica (< 100ms required) | 🔴 Blocker |
| Lista com 10k+ items | 🟠 Important |
| Lista com < 100 items | 🟡 Suggestion |
| Código executado raramente | 🟡 Suggestion |

## Rules Relacionadas

- 022 - Priorização da Simplicidade e Clareza
- 001 - Nível Único de Indentação
- 055 - Limite Máximo de Linhas por Método
