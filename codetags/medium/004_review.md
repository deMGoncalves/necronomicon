# REVIEW

**Severidade**: 🟡 Medium
**Categoria**: Ação Requerida
**Resolver**: Antes do merge

---

## Definição

Marca código que **precisa ser revisado** por outro desenvolvedor, especialista de domínio ou stakeholder. Indica incerteza sobre a abordagem ou necessidade de validação.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Lógica de negócio complexa | Regra fiscal que precisa validação |
| Decisão arquitetural | Escolha de padrão a confirmar |
| Código de segurança | Autenticação a ser auditada |
| Domínio desconhecido | Área que autor não domina |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Bug identificado | FIXME |
| Código a refatorar | REFACTOR |
| Dúvida sobre abordagem | QUESTION |
| Informação contextual | NOTE |

## Formato

```javascript
// REVIEW: descrição - o que revisar
// REVIEW(@especialista): descrição
// REVIEW: [segurança] descrição
```

## Exemplos

### Exemplo 1: Regra de Negócio

```javascript
// REVIEW: cálculo de ICMS - validar com contabilidade
// Baseado em documentação de 2023, pode estar desatualizado
function calculateICMS(product, state) {
  const rates = {
    'SP': 0.18,
    'RJ': 0.20,
    'MG': 0.18,
    // ...
  };
  return product.price * (rates[state] || 0.17);
}
```

### Exemplo 2: Decisão Arquitetural

```javascript
// REVIEW: escolha de implementar cache em memória vs Redis
// Prós memória: simplicidade, sem infra extra
// Contras: não compartilha entre instâncias
// Validar com time de infra antes de prosseguir
class CacheService {
  constructor() {
    this.store = new Map();
  }

  get(key) {
    return this.store.get(key);
  }
}
```

### Exemplo 3: Código de Segurança

```javascript
// REVIEW(@security-team): implementação de rate limiting
// Verificar se abordagem é suficiente contra DDoS
const rateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // limite por IP
  message: 'Too many requests'
});

app.use('/api/', rateLimiter);
```

### Exemplo 4: Algoritmo Complexo

```javascript
// REVIEW: algoritmo de matching de produtos
// Testar com dataset real antes de deploy
// Edge cases: produtos sem descrição, descrições muito curtas
function findSimilarProducts(product, catalog) {
  const scores = catalog.map(p => ({
    product: p,
    score: calculateSimilarity(product, p)
  }));

  return scores
    .filter(s => s.score > 0.7)
    .sort((a, b) => b.score - a.score)
    .slice(0, 10);
}
```

### Exemplo 5: Integração Externa

```javascript
// REVIEW: mapeamento de campos da API do parceiro
// Documentação incompleta - validar com time do parceiro
function mapPartnerResponse(response) {
  return {
    id: response.codigo,          // Assumindo que é isso
    name: response.nome_produto,  // Ou seria 'descricao'?
    price: response.valor / 100,  // Centavos? Confirmar
  };
}
```

### Exemplo 6: Requisito Ambíguo

```javascript
// REVIEW: comportamento quando usuário não tem permissão
// Spec diz "negar acesso" mas não especifica:
// - Retornar 403 ou 404?
// - Mostrar mensagem ou redirecionar?
// - Logar tentativa?
function checkAccess(user, resource) {
  if (!user.hasPermission(resource)) {
    throw new ForbiddenError('Access denied'); // Confirmar abordagem
  }
}
```

## Tipos de Review

| Tipo | Quem Revisa | Foco |
|------|-------------|------|
| Técnico | Senior dev | Arquitetura, padrões |
| Segurança | Security team | Vulnerabilidades |
| Negócio | PO/Stakeholder | Regras de negócio |
| Domínio | Especialista | Área específica |

## Ação Esperada

1. **Identificar** o que precisa ser revisado
2. **Especificar** quem deve revisar
3. **Documentar** dúvidas específicas
4. **Solicitar** review explicitamente
5. **Aguardar** feedback antes de mergear
6. **Implementar** ajustes se necessário
7. **Remover** tag após aprovação

## Resolução

| Tipo de Review | Quando Resolver |
|----------------|-----------------|
| Blocker para feature | Antes do PR |
| Validação de negócio | Antes do merge |
| Nice-to-have | Pode mergear com follow-up |

## Busca no Código

```bash
# Encontrar REVIEWs
grep -rn "REVIEW:" src/

# REVIEWs com responsável
grep -rn "REVIEW(@" src/

# REVIEWs de segurança
grep -rn "REVIEW:.*\[segur\|REVIEW:.*security" src/
```

## Anti-Patterns

```javascript
// ❌ REVIEW sem especificar o quê
// REVIEW:
function ambiguous() { }

// ❌ REVIEW vago
// REVIEW: ver se está ok
function vague() { }

// ❌ REVIEW para código obviamente errado
// REVIEW: isso funciona?
function actuallyBroken() { } // Use FIXME

// ❌ REVIEW ignorado por muito tempo
// REVIEW: (há 6 meses) validar
function neverReviewed() { }
```

## Integração com Code Review

```javascript
// Na PR, mencionar explicitamente:
// "Este PR contém código marcado com REVIEW que precisa
// de atenção especial do @security-team na função X"
```

## Quality Factor Relacionado

- [Correctness](../../software-quality/operation/001_correctness.md): REVIEW ajuda a garantir corretude
- [Reliability](../../software-quality/operation/002_reliability.md): revisão melhora confiabilidade

## Rules Relacionadas

- [clean-code/006 - Comments](../../clean-code/006_qualidade-comentarios-porque.md): REVIEW comunica incerteza
- [clean-code/012 - Test Coverage](../../clean-code/012_cobertura-teste-minima-qualidade.md): código revisado deve ter testes

---

**Criada em**: 2026-03-19
**Versão**: 1.0
