# HACK — Solução Temporária ou Workaround

**Severidade:** 🟠 Alta
**Bloqueia PR:** Não (mas deve ser documentado)

## O que é

Marca solução temporária ou workaround que funciona mas não é a implementação correta. HACKs são conscientemente sub-ótimos e precisam ser reescritos adequadamente.

## Quando Usar

- Workaround para bug externo (contornando bug de biblioteca)
- Solução rápida para deadline (precisa refatorar depois)
- Código para compatibilidade (suporte temporário a versão antiga)
- Gambiarra que funciona (solução não elegante mas funcional)

## Quando NÃO Usar

- Bug no próprio código → use FIXME
- Código que precisa de melhoria → use REFACTOR
- Otimização pendente → use OPTIMIZE
- Código permanente → não use codetag

## Formato

```typescript
// HACK: razão do workaround - quando remover
// HACK: [ticket] descrição - remover quando X
// HACK: contornando bug em lib Y - issue #123
```

## Exemplo

```typescript
// HACK: Safari não suporta `gap` em flexbox < 14.1
// Remover quando dropar suporte a Safari 14
const styles = {
  display: 'flex',
  // gap: '16px', // Não funciona em Safari antigo
  margin: '-8px',
  '& > *': { margin: '8px' }
};

// HACK: API v1 retorna dates como string, v2 como timestamp
// Remover quando migração para v2 estiver completa
function parseDate(value: string | number): Date {
  if (typeof value === 'string') {
    return new Date(value); // API v1
  }
  return new Date(value * 1000); // API v2
}

// HACK: validação inline por tempo - extrair para validator class
// TODO: Criar OrderValidator após release 2.0
function createOrder(data: OrderData): Order {
  if (!data.items?.length) throw new Error('Items required');
  if (!data.customer?.email) throw new Error('Email required');
  if (data.total < 0) throw new Error('Invalid total');
  // ... resto da função
}
```

## Resolução

- **Timeline:** Próxima sprint (deadline) ou quando fix disponível (bug externo)
- **Ação:** Documentar claramente motivo → Especificar quando remover → Criar ticket → Revisar periodicamente → Remover quando solução correta implementada
- **Convertido em:** Removido ou convertido em código permanente após refatoração

## Relacionado com

- Rules: [022](../../../.claude/rules/022_priorizacao-simplicidade-clareza.md), [039](../../../.claude/rules/039_regra-escoteiro-refatoracao-continua.md)
- Tags similares: HACK funciona mas mal, FIXME não funciona (bug)
