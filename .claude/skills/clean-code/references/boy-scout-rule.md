# Regra do Escoteiro (Rule 039)

## Regra

- **039**: Sempre deixar o código melhor do que foi encontrado

## Checklist

- [ ] Pequenos code smells corrigidos no escopo de alteração
- [ ] Arquivos modificados com CC>5 → refatorar
- [ ] Nomes ruins → renomear durante alteração
- [ ] Guard clauses ausentes → adicionar
- [ ] Diff do PR mostra melhorias além do solicitado

## Filosofia

> "Leave the campground cleaner than you found it."

Refatoração contínua e emergente previne acúmulo de débito técnico. Não esperar por "sprint de refatoração" — melhorar sempre que tocar no código.

## Exemplos

```typescript
// Antes (encontrado)
function processOrder(order) {
  if (order.status == 'pending') {
    if (order.total > 0) {
      if (order.user) {
        // lógica de processamento
        order.status = 'processing';
        saveOrder(order);
        return true;
      }
    }
  }
  return false;
}

// Depois (melhorado ao passar por aqui)
function processOrder(order: Order): boolean {
  // Guard clauses adicionadas
  if (order.status !== OrderStatus.PENDING) return false;
  if (order.total <= 0) return false;
  if (!order.user) return false;

  // Lógica principal
  order.status = OrderStatus.PROCESSING;
  saveOrder(order);
  return true;
}

// Enums criados onde havia strings mágicas
enum OrderStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed'
}
```

## Oportunidades de Escotismo

| Encontrei | Ação de Escotismo |
|-----------|-------------------|
| `if (x) { if (y) { ... } }` | Aplicar guard clause ou extrair método |
| `strName`, `bIsActive` | Remover notação húngara |
| `const val = 100` | Criar constante nomeada (`MAX_RETRIES`) |
| Método com CC=6 | Extrair condicionais em métodos privados |
| Comentário redundante | Remover ou transformar em PORQUÊ |
| `return null` | Lançar exceção de domínio |

## Quando NÃO Aplicar

- **Hotfixes críticos**: Risco de refatoração > ganho imediato
- **Código não testado**: Sem testes, refatoração pode introduzir bugs
- **Escopo muito distante**: Não refatorar arquivos não relacionados ao PR

## Relação com ICP

- Reduz débito técnico incrementalmente
- Mantém CC_base e Responsabilidades sob controle
- Previne formação de Blobs e Lava Flow
