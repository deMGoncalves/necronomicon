# DEPRECATED — Código Obsoleto a Ser Removido

**Severidade:** 🟠 Alta
**Bloqueia PR:** Não (mas deve seguir timeline)

## O que é

Marca código ou funcionalidade obsoleta que será removida em versão futura. Indica que existe alternativa melhor e que o uso atual deve ser migrado.

## Quando Usar

- API sendo descontinuada (endpoint v1 sendo substituído por v2)
- Função com substituta melhor (helper antigo com nova implementação)
- Padrão abandonado (abordagem que não será mais mantida)
- Dependência a ser removida (biblioteca sendo trocada)

## Quando NÃO Usar

- Código com bug → use FIXME ou BUG
- Código temporário → use HACK
- Código a melhorar → use REFACTOR
- Código removido → deletar, não marcar

## Formato

```typescript
// DEPRECATED: usar X em vez - remover em vY.Z
// @deprecated desde v1.2 - usar newFunction()
// DEPRECATED: [timeline] descrição da migração
```

## Exemplo

```typescript
// DEPRECATED: usar calculateTotalV2() - remover em v3.0
// Esta função não considera taxas regionais
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Nova função recomendada
function calculateTotalV2(items: Item[], region: string): number {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  return applyRegionalTax(subtotal, region);
}

/**
 * @deprecated desde v2.0 - usar newFunction() em vez
 * @see newFunction
 */
function oldFunction(): void {
  if (process.env.NODE_ENV === 'development') {
    console.warn('oldFunction() is deprecated. Use newFunction() instead.');
  }
  // ...
}

// DEPRECATED: configuração via JSON - migrar para variáveis de ambiente
// JSON config será removido em v4.0 (twelve-factor compliance)
const config = require('./config.json');

// Novo padrão
const config = {
  apiUrl: process.env.API_URL,
  apiKey: process.env.API_KEY,
};
```

## Resolução

- **Timeline:** Anúncio → Grace period (avisos dev) → Warning (avisos prod opcional) → Remoção
- **Ação:** Documentar alternativa → Definir timeline → Comunicar consumidores → Adicionar warning runtime (dev) → Migrar usos internos → Remover após período
- **Convertido em:** Código removido após período de deprecação

## Relacionado com

- Rules: [023](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md), [015](../../../.claude/rules/015_principio-equivalencia-lancamento-reuso.md)
- Tags similares: DEPRECATED tem timeline e alternativa, código morto é deletado imediatamente
