# QUESTION — Dúvida ou Pergunta

**Severidade:** 🟢 Baixa | Resolver em code review
**Bloqueia PR:** Pode ser 🟡 Média se bloqueante para corretude

## O que é

Marca dúvida ou pergunta sobre abordagem, requisito ou decisão de implementação. Indica incerteza do autor que precisa ser esclarecida por meio de discussão em code review ou sync com time.

## Quando Usar

- Requisito ambíguo (spec não está clara)
- Escolha de abordagem (qual padrão usar?)
- Comportamento esperado (o que fazer neste caso?)
- Validação de entendimento (isso está certo?)

## Quando NÃO Usar

- Código a ser revisado → use **REVIEW**
- Informação importante → use **NOTE**
- Bug identificado → use **FIXME**
- Tarefa pendente → use **TODO**

## Formato

```typescript
// QUESTION: a pergunta específica
// QUESTION: pergunta direcionada a alguém
// QUESTION: opção A vs opção B - qual preferir?
```

## Exemplo

```typescript
// QUESTION: quando o usuário cancela, devemos manter os dados no form?
// Spec diz "cancelar operação" mas não especifica estado do form
function handleCancel() {
  closeModal();
  // resetForm() ???
}

// QUESTION: Strategy vs Factory para criar processadores de pagamento?
// Strategy: mais flexível, pode trocar em runtime
// Factory: mais simples, decisão no momento da criação
function createPaymentProcessor(type: string) {
  // Implementação pendente de decisão
}

// QUESTION: o que retornar quando lista está vazia?
// Opções: [], null, throw EmptyListError
// Impacta contrato da API
function getActiveUsers(): User[] | null {
  const users = db.users.findAll({ active: true });
  if (users.length === 0) {
    return []; // Ou null? Ou throw?
  }
  return users;
}

// QUESTION: vale otimizar para O(1) lookup ou manter array simples?
// Array: 100 items max, O(n) lookup = ~100 comparações
// Map: overhead de criação, O(1) lookup
// Contexto: chamado ~10x por request
const config = [
  { key: 'theme', value: 'dark' },
  // ... ~100 items
];

// QUESTION: falha silenciosa ou throw em log failure?
// Silenciosa: não interrompe fluxo principal
// Throw: garante que problemas sejam notados
async function logEvent(event: Event) {
  try {
    await analytics.track(event);
  } catch (error) {
    console.error('Log failed', error);
    // throw error; ???
  }
}

// QUESTION: entendi certo que desconto máximo é 50%?
// Email do cliente dizia "até metade do valor"
// Confirmar antes de deploy
function applyDiscount(price: number, discountPercent: number): number {
  const maxDiscount = 0.5; // 50%
  const safeDiscount = Math.min(discountPercent, maxDiscount);
  return price * (1 - safeDiscount);
}

// QUESTION: validação de CPF deve aceitar formatado?
// Ex: "123.456.789-00" vs "12345678900"
// Maria definiu os requisitos originais
```

## Resolução

- **Timeline:** Code review ou sync com time
- **Ação:** Formular pergunta clara, oferecer alternativas, direcionar para pessoa certa, discutir, documentar resposta, remover ou converter para NOTE
- **Convertido em:** NOTE (se decisão for importante) ou removido (após resposta)

## Relacionado com

- Rules: [026 - Comments Quality](../../../.claude/rules/026_qualidade-comentarios-porque.md) (QUESTION é comunicação temporária)
- Tags similares: QUESTION (dúvida do autor) vs REVIEW (precisa validação externa)
