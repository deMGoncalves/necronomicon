# SECURITY — Security Vulnerability

**Severity:** 🔴 Critical
**Blocks PR:** Yes (NEVER merge with pending SECURITY)

## What It Is

Marks code with potential or confirmed security vulnerability. This is the most critical codetag — code marked with SECURITY must not go to production until resolved.

## When to Use

- Injection (SQL, Command, XSS) — unsanitized input in query
- Sensitive data exposure — logs with PII, secrets in code
- Authentication/Authorization failure — permission bypass
- Insecure configuration — CORS *, debug in prod

## When NOT to Use

- Bug without security implication → use BUG or FIXME
- Code works but is ugly → use REFACTOR
- Performance improvement → use OPTIMIZE
- Temporary code without risk → use HACK

## Format

```typescript
// SECURITY: vulnerability type - necessary action
// SECURITY: [OWASP-XX] risk description
// SECURITY: description - impact: what could happen
```

## Example

```typescript
// SECURITY: SQL injection - use prepared statement
function getUser(username: string) {
  return db.query(`SELECT * FROM users WHERE username = '${username}'`);
  // Attacker can pass: ' OR '1'='1
}

// ✅ Fixed
function getUser(username: string) {
  return db.query('SELECT * FROM users WHERE username = ?', [username]);
}

// SECURITY: XSS - don't use innerHTML with user input
function renderComment(comment: Comment): void {
  element.innerHTML = comment.text; // ❌ Can execute <script>
}

// ✅ Fixed
function renderComment(comment: Comment): void {
  element.textContent = comment.text;
  // Or if need HTML: element.innerHTML = DOMPurify.sanitize(comment.text);
}

// SECURITY: API key exposed in code - move to env vars
const stripe = new Stripe('sk_live_abc123xyz789'); // ❌

// ✅ Fixed
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
```

## Resolution

- **Timeline:** Immediately — don't merge until resolved
- **Action:** STOP → Assess risk → Fix immediately → Review with specialist → Test with attack cases → Document → Remove comment
- **Converted to:** N/A (removed after correction)

## Related to

- Rules: [030](../../../.claude/rules/030_proibicao-funcoes-inseguras.md), [042](../../../.claude/rules/042_configuracoes-via-ambiente.md)
- Similar tags: SECURITY is security critical, FIXME is functional critical
