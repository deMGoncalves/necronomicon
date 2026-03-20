# NOTE

**Severidade**: 🟢 Low
**Categoria**: Documentação e Contexto
**Resolver**: N/A (informativo)

---

## Definição

Marca **informação importante** sobre decisão, contexto ou comportamento não óbvio. Diferente de comentários comuns, NOTE destaca algo que o leitor precisa saber para entender ou modificar o código.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Decisão de design | Por que foi escolhida essa abordagem |
| Comportamento não óbvio | Efeito colateral intencional |
| Contexto histórico | Razão de código "estranho" |
| Dependência importante | Ordem que precisa ser mantida |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Tarefa pendente | TODO |
| Código perigoso | XXX |
| Explicação do óbvio | Não comente |
| Documentação de API | JSDoc/TSDoc |

## Formato

```javascript
// NOTE: informação importante
// NOTE: razão da decisão
// NOTE: contexto que afeta manutenção
```

## Exemplos

### Exemplo 1: Decisão de Design

```javascript
// NOTE: usando Map em vez de Object para preservar ordem de inserção
// e permitir chaves não-string (ex: objetos como chave)
const cache = new Map();
```

### Exemplo 2: Comportamento Intencional

```javascript
// NOTE: retorno null é intencional - indica "não encontrado" vs erro
// Caller deve verificar: if (result === null) { handleNotFound() }
function findUser(id) {
  const user = users.get(id);
  return user || null;
}
```

### Exemplo 3: Contexto Histórico

```javascript
// NOTE: timeout de 30s é requisito do parceiro de pagamento
// Documentação: https://docs.partner.com/timeouts
// Não reduzir sem validar com eles primeiro
const PAYMENT_TIMEOUT = 30000;
```

### Exemplo 4: Ordem Importante

```javascript
// NOTE: ordem dos middlewares é crítica
// 1. Auth deve vir antes de rate-limit (para identificar usuário)
// 2. Rate-limit deve vir antes de validation (para bloquear abuso)
app.use(authMiddleware);
app.use(rateLimitMiddleware);
app.use(validationMiddleware);
```

### Exemplo 5: Trade-off Consciente

```javascript
// NOTE: usando eager loading aqui apesar do custo
// Trade-off: +100ms no load vs N+1 queries na renderização
// Testado: eager é 3x mais rápido no caso de uso típico
const orders = await db.orders.findAll({
  include: [{ model: OrderItem }, { model: Customer }]
});
```

### Exemplo 6: Compatibilidade

```javascript
// NOTE: formato de data mantido para compatibilidade com API mobile v1
// Novos endpoints usam ISO 8601, mas este precisa manter DD/MM/YYYY
// Migração planejada para Q3 quando v1 for descontinuada
function formatDateLegacy(date) {
  return format(date, 'dd/MM/yyyy');
}
```

### Exemplo 7: Limitação Conhecida

```javascript
// NOTE: limite de 1000 items é do Elasticsearch, não do negócio
// Para mais items, usar cursor pagination (implementado em v2 da API)
const SEARCH_LIMIT = 1000;
```

## Boas Práticas

### Explique o "Por quê"

```javascript
// ❌ O que (óbvio do código)
// NOTE: incrementa o contador
counter++;

// ✅ Por quê (não óbvio)
// NOTE: incrementa antes do uso pois IDs começam em 1, não 0
counter++;
```

### Seja Específico

```javascript
// ❌ Vago
// NOTE: importante

// ✅ Específico
// NOTE: valor default de 5 vem do SLA contratual com cliente X
```

### Vincule a Fontes

```javascript
// NOTE: algoritmo baseado em RFC 7519 (JWT spec)
// Seção 4.1: https://tools.ietf.org/html/rfc7519#section-4.1
```

## Ação Esperada

NOTEs são **informativos**, não requerem ação:

1. **Ler** antes de modificar código relacionado
2. **Considerar** o contexto ao fazer mudanças
3. **Atualizar** se a informação ficar desatualizada
4. **Remover** se não for mais relevante

## Quando Atualizar/Remover

| Situação | Ação |
|----------|------|
| Informação desatualizada | Atualizar |
| Contexto não mais relevante | Remover |
| Migração completada | Remover |
| Trade-off mudou | Atualizar |

## Busca no Código

```bash
# Encontrar NOTEs
grep -rn "NOTE:" src/

# NOTEs com links (referências externas)
grep -rn "NOTE:.*http" src/

# NOTEs em arquivo específico
grep -n "NOTE:" src/services/payment.js
```

## Anti-Patterns

```javascript
// ❌ NOTE explicando o óbvio
// NOTE: esta função soma dois números
function add(a, b) { return a + b; }

// ❌ NOTE como TODO disfarçado
// NOTE: melhorar isso depois
function needsWork() { } // Use TODO

// ❌ NOTE sem conteúdo útil
// NOTE: ver documentação
function vague() { } // Qual documentação?

// ❌ NOTE desatualizado
// NOTE: (2019) temporário até migração
function stillTemporary() { } // Atualize ou remova
```

## Diferença de INFO

| Aspecto | NOTE | INFO |
|---------|------|------|
| Importância | Alta - afeta decisões | Baixa - contexto extra |
| Leitura | Obrigatória antes de modificar | Opcional |
| Foco | Decisão/trade-off | Detalhe técnico |

## Quality Factor Relacionado

- [Maintainability](../../software-quality/revision/001_maintainability.md): NOTEs ajudam na manutenção
- [Usability](../../software-quality/operation/005_usability.md): código bem documentado é mais usável

## Rules Relacionadas

- [clean-code/006 - Comments](../../clean-code/qualidade-comentarios-porque.md): NOTE explica o "porquê"

---

**Criada em**: 2026-03-19
**Versão**: 1.0
