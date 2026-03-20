# QUESTION

**Severidade**: 🟢 Low (pode ser 🟡 Medium se bloqueante)
**Categoria**: Documentação e Contexto
**Resolver**: Code review ou discussão

---

## Definição

Marca **dúvida ou pergunta** sobre abordagem, requisito ou decisão de implementação. Indica incerteza do autor que precisa ser esclarecida.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Requisito ambíguo | Spec não está clara |
| Escolha de abordagem | Qual padrão usar? |
| Comportamento esperado | O que fazer neste caso? |
| Validação de entendimento | Isso está certo? |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Código a ser revisado | REVIEW |
| Informação importante | NOTE |
| Bug identificado | FIXME |
| Tarefa pendente | TODO |

## Formato

```javascript
// QUESTION: a pergunta específica
// QUESTION(@pessoa): pergunta direcionada
// QUESTION: opção A vs opção B - qual preferir?
```

## Exemplos

### Exemplo 1: Requisito Ambíguo

```javascript
// QUESTION: quando o usuário cancela, devemos manter os dados no form?
// Spec diz "cancelar operação" mas não especifica estado do form
function handleCancel() {
  closeModal();
  // resetForm() ?
}
```

### Exemplo 2: Escolha de Padrão

```javascript
// QUESTION: Strategy vs Factory para criar processadores de pagamento?
// Strategy: mais flexível, pode trocar em runtime
// Factory: mais simples, decisão no momento da criação
function createPaymentProcessor(type) {
  // Implementação pendente de decisão
}
```

### Exemplo 3: Edge Case

```javascript
// QUESTION: o que retornar quando lista está vazia?
// Opções: [], null, throw EmptyListError
// Impacta contrato da API
function getActiveUsers() {
  const users = db.users.findAll({ active: true });
  if (users.length === 0) {
    return []; // Ou null? Ou throw?
  }
  return users;
}
```

### Exemplo 4: Performance vs Clareza

```javascript
// QUESTION: vale otimizar para O(1) lookup ou manter array simples?
// Array: 100 items max, O(n) lookup = ~100 comparações
// Map: overhead de criação, O(1) lookup
// Contexto: chamado ~10x por request
const config = [
  { key: 'theme', value: 'dark' },
  // ... ~100 items
];

function getConfig(key) {
  return config.find(c => c.key === key)?.value;
}
```

### Exemplo 5: Comportamento de Erro

```javascript
// QUESTION: falha silenciosa ou throw em log failure?
// Silenciosa: não interrompe fluxo principal
// Throw: garante que problemas sejam notados
async function logEvent(event) {
  try {
    await analytics.track(event);
  } catch (error) {
    console.error('Log failed', error);
    // throw error; ???
  }
}
```

### Exemplo 6: Validação de Entendimento

```javascript
// QUESTION: entendi certo que desconto máximo é 50%?
// Email do cliente dizia "até metade do valor"
// Confirmar antes de deploy
function applyDiscount(price, discountPercent) {
  const maxDiscount = 0.5; // 50%
  const safeDiscount = Math.min(discountPercent, maxDiscount);
  return price * (1 - safeDiscount);
}
```

### Exemplo 7: Nomenclatura

```javascript
// QUESTION: "user" ou "customer" neste contexto?
// Domínio usa ambos termos, qual é correto aqui?
function getUser(id) {
  // ou getCustomer?
}
```

## Boas Práticas

### Seja Específico

```javascript
// ❌ Vago
// QUESTION: isso está certo?

// ✅ Específico
// QUESTION: timeout de 30s é suficiente para upload de arquivos grandes?
```

### Ofereça Opções

```javascript
// QUESTION: formato de data para API
// Opção A: ISO 8601 (2024-03-15T10:30:00Z) - padrão, mais preciso
// Opção B: Unix timestamp (1710499800) - mais compacto
// Opção C: Ambos (timestamp + formatted) - mais flexível
```

### Direcione se Necessário

```javascript
// QUESTION(@maria): validação de CPF deve aceitar formatado?
// Ex: "123.456.789-00" vs "12345678900"
// Maria definiu os requisitos originais
```

## Ação Esperada

1. **Formular** pergunta clara e específica
2. **Oferecer** alternativas quando possível
3. **Direcionar** para pessoa certa se souber
4. **Discutir** em code review ou sync
5. **Documentar** resposta se for decisão importante
6. **Remover** ou converter para NOTE após resolução

## Resolução

| Tipo de Questão | Como Resolver |
|-----------------|---------------|
| Requisito | Perguntar ao PO/stakeholder |
| Técnica | Discutir com time |
| Arquitetura | Revisar com senior/architect |
| Performance | Medir e decidir com dados |

## Busca no Código

```bash
# Encontrar QUESTIONs
grep -rn "QUESTION:" src/

# QUESTIONs direcionadas
grep -rn "QUESTION(@" src/

# QUESTIONs não resolvidas (antigas)
grep -rn "QUESTION:" src/ | head -20
```

## Anti-Patterns

```javascript
// ❌ QUESTION sem a pergunta
// QUESTION:
function unclear() { }

// ❌ QUESTION retórica
// QUESTION: por que alguém faria isso?
function judgmental() { }

// ❌ QUESTION que deveria ser pesquisada
// QUESTION: como funciona Promise.all?
// → Pesquise na documentação

// ❌ QUESTION muito antiga
// QUESTION: (2020) nunca respondida
function forgotten() { } // Resolva ou remova

// ❌ QUESTION sobre código obvio
// QUESTION: o que faz essa soma?
const total = a + b;
```

## Conversão Após Resposta

```javascript
// Antes (questão)
// QUESTION: aceitar email sem TLD? (ex: user@localhost)

// Depois (decisão documentada)
// NOTE: emails sem TLD são aceitos para suporte a ambientes de dev
// Decisão: 2024-03-15 com PO @joao
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+/; // Sem exigir TLD
```

## Quality Factor Relacionado

- [Correctness](../../software-quality/operation/001_correctness.md): QUESTIONs ajudam a garantir requisitos corretos
- [Reliability](../../software-quality/operation/002_reliability.md): esclarecer dúvidas melhora confiabilidade

## Rules Relacionadas

- [clean-code/006 - Comments](../../clean-code/qualidade-comentarios-porque.md): QUESTION é comunicação temporária

---

**Criada em**: 2026-03-19
**Versão**: 1.0
