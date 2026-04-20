# SECURITY — Vulnerabilidade de Segurança

**Severidade:** 🔴 Crítica
**Bloqueia PR:** Sim (NUNCA mergear com SECURITY pendente)

## O que é

Marca código com vulnerabilidade de segurança potencial ou confirmada. Este é o codetag mais crítico — código marcado com SECURITY não deve ir para produção até ser resolvido.

## Quando Usar

- Injection (SQL, Command, XSS) — input não sanitizado em query
- Exposição de dados sensíveis — logs com PII, secrets em código
- Autenticação/Autorização falha — bypass de permissões
- Configuração insegura — CORS *, debug em prod

## Quando NÃO Usar

- Bug sem implicação de segurança → use BUG ou FIXME
- Código funciona mas é feio → use REFACTOR
- Melhoria de performance → use OPTIMIZE
- Código temporário sem risco → use HACK

## Formato

```typescript
// SECURITY: tipo de vulnerabilidade - ação necessária
// SECURITY: [OWASP-XX] descrição do risco
// SECURITY: descrição - impacto: o que pode acontecer
```

## Exemplo

```typescript
// SECURITY: SQL injection - usar prepared statement
function getUser(username: string) {
  return db.query(`SELECT * FROM users WHERE username = '${username}'`);
  // Atacante pode passar: ' OR '1'='1
}

// ✅ Corrigido
function getUser(username: string) {
  return db.query('SELECT * FROM users WHERE username = ?', [username]);
}

// SECURITY: XSS - não usar innerHTML com input de usuário
function renderComment(comment: Comment): void {
  element.innerHTML = comment.text; // ❌ Pode executar <script>
}

// ✅ Corrigido
function renderComment(comment: Comment): void {
  element.textContent = comment.text;
  // Ou se precisar de HTML: element.innerHTML = DOMPurify.sanitize(comment.text);
}

// SECURITY: API key exposta no código - mover para env vars
const stripe = new Stripe('sk_live_abc123xyz789'); // ❌

// ✅ Corrigido
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
```

## Resolução

- **Timeline:** Imediatamente — não mergear até resolver
- **Ação:** PARAR → Avaliar risco → Corrigir imediatamente → Revisar com especialista → Testar com casos de ataque → Documentar → Remover comentário
- **Convertido em:** N/A (removido após correção)

## Relacionado com

- Rules: [030](../../../.claude/rules/030_proibicao-funcoes-inseguras.md), [042](../../../.claude/rules/042_configuracoes-via-ambiente.md)
- Tags similares: SECURITY é crítico de segurança, FIXME é crítico funcional
