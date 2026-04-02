# REVIEW — Necessita Revisão

**Severidade:** 🟡 Média | Resolver antes do merge
**Bloqueia PR:** Sim (se crítico para corretude)

## O que é

Marca código que precisa ser revisado por outro desenvolvedor, especialista de domínio ou stakeholder. Indica incerteza sobre a abordagem ou necessidade de validação externa antes de considerar completo.

## Quando Usar

- Lógica de negócio complexa (regra fiscal que precisa validação)
- Decisão arquitetural (escolha de padrão a confirmar)
- Código de segurança (autenticação a ser auditada)
- Domínio desconhecido pelo autor (área que autor não domina)

## Quando NÃO Usar

- Bug identificado → use **FIXME**
- Código a refatorar → use **REFACTOR**
- Dúvida sobre abordagem → use **QUESTION**
- Informação contextual → use **NOTE**

## Formato

```typescript
// REVIEW: descrição - o que revisar especificamente
// REVIEW: descrição direcionada
// REVIEW: [segurança|negócio|arquitetura] descrição categorizada
```

## Exemplo

```typescript
// REVIEW: cálculo de ICMS - validar com contabilidade
// Baseado em documentação de 2023, pode estar desatualizado
function calculateICMS(product: Product, state: string): number {
  const rates = { 'SP': 0.18, 'RJ': 0.20, 'MG': 0.18 };
  return product.price * (rates[state] || 0.17);
}

// REVIEW: implementação de rate limiting
// Verificar se abordagem é suficiente contra DDoS
const rateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests'
});

// REVIEW: algoritmo de matching de produtos
// Testar com dataset real antes de deploy
// Edge cases: produtos sem descrição, descrições muito curtas
function findSimilarProducts(product: Product, catalog: Product[]) {
  const scores = catalog.map(p => ({
    product: p,
    score: calculateSimilarity(product, p)
  }));
  return scores
    .filter(s => s.score > 0.7)
    .sort((a, b) => b.score - a.score)
    .slice(0, 10);
}

// REVIEW: comportamento quando usuário não tem permissão
// Spec diz "negar acesso" mas não especifica:
// - Retornar 403 ou 404?
// - Mostrar mensagem ou redirecionar?
// - Logar tentativa?
function checkAccess(user: User, resource: Resource) {
  if (!user.hasPermission(resource)) {
    throw new ForbiddenError('Access denied');
  }
}
```

## Resolução

- **Timeline:** Antes do PR (blocker) ou antes do merge (validação de negócio)
- **Ação:** Identificar revisor, solicitar review explicitamente, aguardar feedback, implementar ajustes, remover tag após aprovação
- **Convertido em:** NOTE (se decisão for documentada) ou removido (após aprovação)

## Relacionado com

- Rules: [032 - Test Coverage](../../../.claude/rules/032_cobertura-teste-minima-qualidade.md) (código revisado deve ter testes)
- Tags similares: REVIEW (precisa validação) vs QUESTION (dúvida do autor)
