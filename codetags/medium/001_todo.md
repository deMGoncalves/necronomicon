# TODO

**Severidade**: 🟡 Medium
**Categoria**: Ação Requerida
**Resolver**: Sprint planejada

---

## Definição

Marca **tarefa pendente** ou funcionalidade planejada que ainda não foi implementada. É o codetag mais comum e indica trabalho futuro que está no radar.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Feature parcialmente implementada | Falta validação de edge case |
| Placeholder para implementação | Função com stub |
| Melhoria planejada | Adicionar cache |
| Integração pendente | Conectar com API externa |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Bug a corrigir | FIXME |
| Código a reestruturar | REFACTOR |
| Otimização de performance | OPTIMIZE |
| Ideia futura não confirmada | IDEA |

## Formato

```javascript
// TODO: descrição da tarefa
// TODO: [ticket-123] descrição
// TODO(@responsavel): descrição - prazo
```

## Exemplos

### Exemplo 1: Validação Pendente

```javascript
// TODO: adicionar validação de formato de email
function createUser(email, password) {
  // Validação de email pendente
  return db.users.create({ email, password });
}
```

### Exemplo 2: Feature Incompleta

```javascript
// TODO: implementar paginação - limite atual de 100 items
async function listProducts() {
  return db.products.findAll({ limit: 100 });
}
```

### Exemplo 3: Integração Futura

```javascript
// TODO: integrar com serviço de analytics quando disponível
function trackEvent(eventName, data) {
  console.log('Event:', eventName, data);
  // Enviar para analytics service
}
```

### Exemplo 4: Stub/Placeholder

```javascript
// TODO: implementar lógica de cálculo de frete
function calculateShipping(order) {
  return 10.00; // Valor fixo temporário
}
```

### Exemplo 5: Com Ticket

```javascript
// TODO: [PROJ-456] adicionar suporte a múltiplas moedas
function formatPrice(amount) {
  return `R$ ${amount.toFixed(2)}`;
}
```

### Exemplo 6: Com Responsável

```javascript
// TODO(@joao): implementar retry com exponential backoff
async function fetchWithRetry(url) {
  return fetch(url);
}
```

## Boas Práticas

### Seja Específico

```javascript
// ❌ Vago
// TODO: melhorar isso

// ✅ Específico
// TODO: adicionar rate limiting de 100 req/min por usuário
```

### Inclua Contexto

```javascript
// ❌ Sem contexto
// TODO: adicionar validação

// ✅ Com contexto
// TODO: validar CPF usando algoritmo de dígitos verificadores
```

### Vincule a Tickets

```javascript
// ❌ Sem rastreamento
// TODO: implementar cache

// ✅ Com rastreamento
// TODO: [PERF-123] implementar cache Redis para sessões
```

## Ação Esperada

1. **Descrever** claramente a tarefa
2. **Vincular** a ticket quando possível
3. **Priorizar** no backlog
4. **Implementar** quando priorizado
5. **Remover** o comentário após implementação

## Resolução

| Tipo de TODO | Quando Resolver |
|--------------|-----------------|
| Blocker para feature | Sprint atual |
| Melhoria planejada | Próxima sprint |
| Nice-to-have | Backlog |
| Sem ticket | Criar ticket ou IDEA |

## Busca no Código

```bash
# Encontrar todos os TODOs
grep -rn "TODO:" src/

# TODOs com tickets
grep -rn "TODO:.*\[" src/

# TODOs sem tickets (precisam de rastreamento)
grep -rn "TODO:" src/ | grep -v "\["

# TODOs antigos (mais de 1 ano)
grep -rn "TODO:.*202[0-3]" src/

# Contar TODOs por arquivo
grep -rc "TODO:" src/ | grep -v ":0" | sort -t: -k2 -rn
```

## Anti-Patterns

```javascript
// ❌ TODO sem descrição
// TODO:
function incomplete() { }

// ❌ TODO vago
// TODO: fazer isso
function vague() { }

// ❌ TODO eterno
// TODO: (2018) implementar quando tiver tempo
function never() { }

// ❌ TODO para bug
// TODO: arrumar esse bug
function broken() { } // Use FIXME

// ❌ Muitos TODOs no mesmo arquivo
// Indica que feature não deveria ter sido mergeada
```

## Limite de TODOs

| Contexto | Limite Recomendado |
|----------|-------------------|
| Por arquivo | Máximo 3 |
| Por PR | Máximo 5 |
| Total no projeto | Monitorar tendência |

## Gestão de TODOs

### Revisão Periódica

```bash
# Script para relatório de TODOs
echo "=== TODO Report ==="
echo "Total: $(grep -rc "TODO:" src/ | grep -v ":0" | wc -l)"
echo ""
echo "Por arquivo:"
grep -rc "TODO:" src/ | grep -v ":0" | sort -t: -k2 -rn | head -10
echo ""
echo "Mais antigos:"
grep -rn "TODO:.*20[12][0-9]" src/ | head -5
```

### Integração com CI

```yaml
# GitHub Action para alertar sobre TODOs
- name: Check TODO count
  run: |
    count=$(grep -rc "TODO:" src/ | grep -v ":0" | awk -F: '{sum+=$2} END {print sum}')
    if [ "$count" -gt 50 ]; then
      echo "::warning::Too many TODOs: $count"
    fi
```

## Quality Factor Relacionado

- [Correctness](../../software-quality/operation/001_correctness.md): TODOs indicam features incompletas
- [Maintainability](../../software-quality/revision/001_maintainability.md): muitos TODOs dificultam manutenção

## Rules Relacionadas

- [clean-code/003 - YAGNI](../../clean-code/003_prohibition-speculative-functionality.md): não criar TODOs especulativos
- [clean-code/019 - Boy Scout Rule](../../clean-code/019_regra-escoteiro-refatoracao-continua.md): resolver TODOs ao passar

---

**Criada em**: 2026-03-19
**Versão**: 1.0
