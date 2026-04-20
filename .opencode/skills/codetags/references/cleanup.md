# CLEANUP — Código Desorganizado ou com Elementos Desnecessários

**Severidade:** 🟠 Alta
**Bloqueia PR:** Não (mas deve ser endereçado)

## O que é

Marca código desorganizado ou com elementos desnecessários que precisam ser limpos. Diferente de REFACTOR (que muda estrutura), CLEANUP remove ruído e organiza sem alterar comportamento.

## Quando Usar

- Código morto (funções nunca chamadas)
- Imports não utilizados (dependências órfãs)
- Comentários obsoletos (documentação desatualizada)
- Console.logs esquecidos (debug deixado para trás)
- Variáveis não utilizadas (declarações órfãs)

## Quando NÃO Usar

- Código a ser reestruturado → use REFACTOR
- Bug a ser corrigido → use FIXME
- Feature a implementar → use TODO
- Código obsoleto oficial → use DEPRECATED

## Formato

```typescript
// CLEANUP: tipo de limpeza necessária
// CLEANUP: remover código morto após confirmar não-uso
// CLEANUP: organizar imports/remover não utilizados
```

## Exemplo

```typescript
// CLEANUP: função não utilizada - verificar e remover
function oldCalculation(value: number): number {
  // Esta função era usada na v1, não é mais chamada
  return value * 1.5;
}

// CLEANUP: remover logs de debug antes do merge
function processOrder(order: Order): Result {
  console.log('DEBUG: order received', order);
  console.log('DEBUG: processing...', { timestamp: Date.now() });

  const result = calculate(order);

  console.log('DEBUG: result', result);
  return result;
}

// CLEANUP: imports não utilizados - remover
import { useState, useEffect, useCallback, useMemo } from 'react';
import { format, parse, addDays } from 'date-fns';
import _ from 'lodash';

// Apenas useState é usado
function SimpleComponent(): JSX.Element {
  const [value, setValue] = useState(0);
  return <div>{value}</div>;
}

// CLEANUP: comentários desatualizados - atualizar ou remover
function calculateDiscount(order: Order): number {
  // Retorna 10% de desconto para pedidos acima de R$100
  // NOTA: agora retorna 15% (mudou em 2023)
  // TODO: verificar com marketing (já verificado, manter 15%)
  return order.total > 100 ? order.total * 0.15 : 0;
}

// CLEANUP: código comentado - remover (está no git history)
function getCurrentPrice(product: Product): number {
  // const oldPrice = product.basePrice * 1.1;
  // const discount = calculateOldDiscount(product);
  // return oldPrice - discount;

  return product.basePrice * 1.2;
}
```

## Resolução

- **Timeline:** Antes do commit (console.logs) ou antes do PR (imports) ou próxima sprint (código morto)
- **Ação:** Identificar tipo de limpeza → Verificar remoção é segura → Remover código/imports/comentários → Testar que nada quebrou → Commitar
- **Convertido em:** N/A (removido após limpeza)

## Relacionado com

- Rules: [023](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md), [039](../../../.claude/rules/039_regra-escoteiro-refatoracao-continua.md)
- Tags similares: CLEANUP remove ruído, REFACTOR muda estrutura
