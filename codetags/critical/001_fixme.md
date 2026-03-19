# FIXME

**Severidade**: 🔴 Critical
**Categoria**: Ação Requerida
**Resolver**: Antes do commit/merge

---

## Definição

Marca código com **bug confirmado** que produz comportamento incorreto e deve ser corrigido imediatamente. Diferente de BUG (que documenta defeito conhecido), FIXME indica que o código precisa ser consertado agora.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Lógica incorreta descoberta | Cálculo que retorna valor errado |
| Edge case não tratado | Divisão por zero, array vazio |
| Comportamento inesperado | Função retorna undefined quando não deveria |
| Regressão identificada | Código que funcionava e parou |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Bug conhecido mas não urgente | BUG |
| Código funciona mas é feio | REFACTOR |
| Melhoria de performance | OPTIMIZE |
| Vulnerabilidade de segurança | SECURITY |

## Formato

```javascript
// FIXME: descrição do problema - causa identificada
// FIXME: [ticket-123] descrição do problema
// FIXME(@autor): descrição do problema
```

## Exemplos

### Exemplo 1: Edge Case Não Tratado

```javascript
// FIXME: divisão por zero quando items está vazio
function calculateAverage(items) {
  const sum = items.reduce((a, b) => a + b, 0);
  return sum / items.length; // 💥 NaN se items = []
}

// ✅ Corrigido
function calculateAverage(items) {
  if (items.length === 0) return 0;
  const sum = items.reduce((a, b) => a + b, 0);
  return sum / items.length;
}
```

### Exemplo 2: Lógica Incorreta

```javascript
// FIXME: desconto calculado sobre valor errado - deve ser sobre subtotal
function applyDiscount(order) {
  const discount = order.total * 0.1; // ❌ total já inclui taxas
  return order.total - discount;
}

// ✅ Corrigido
function applyDiscount(order) {
  const discount = order.subtotal * 0.1;
  return order.total - discount;
}
```

### Exemplo 3: Off-by-One Error

```javascript
// FIXME: retorna N-1 items em vez de N - off-by-one error
function getLastNItems(items, n) {
  return items.slice(items.length - n + 1); // ❌
}

// ✅ Corrigido
function getLastNItems(items, n) {
  return items.slice(-n);
}
```

### Exemplo 4: Comparação Incorreta

```javascript
// FIXME: comparação com == permite coerção de tipos - "5" == 5 é true
function isEqual(a, b) {
  return a == b; // ❌
}

// ✅ Corrigido
function isEqual(a, b) {
  return a === b;
}
```

## Ação Esperada

1. **Identificar** a causa raiz do bug
2. **Corrigir** o código imediatamente
3. **Testar** a correção com casos de borda
4. **Remover** o comentário FIXME após correção
5. **Considerar** adicionar teste unitário para prevenir regressão

## Resolução Obrigatória

| Contexto | Quando Resolver |
|----------|-----------------|
| Código novo | Antes do commit |
| PR em review | Antes do merge |
| Código existente | Sprint atual |
| Hotfix | Imediatamente |

## Busca no Código

```bash
# Encontrar todos os FIXMEs
grep -rn "FIXME:" src/

# Contar FIXMEs por arquivo
grep -rc "FIXME:" src/ | grep -v ":0" | sort -t: -k2 -rn

# FIXMEs com contexto
grep -rn -A2 -B2 "FIXME:" src/
```

## Anti-Patterns

```javascript
// ❌ FIXME sem descrição
// FIXME:
function broken() { }

// ❌ FIXME vago
// FIXME: fix this
function broken() { }

// ❌ FIXME antigo não resolvido
// FIXME: (2020-01-01) consertar depois
function broken() { }

// ❌ Usar FIXME para melhorias
// FIXME: poderia ser mais eficiente
function works() { } // Use OPTIMIZE
```

## Quality Factor Relacionado

- [Correctness](../../software-quality/operation/001_correctness.md): FIXME indica violação direta de corretude

## Rules Relacionadas

- [clean-code/007 - Error Handling](../../clean-code/007_qualidade-tratamento-erros-dominio.md)
- [clean-code/019 - Boy Scout Rule](../../clean-code/019_regra-escoteiro-refatoracao-continua.md)

---

**Criada em**: 2026-03-19
**Versão**: 1.0
