# SECURITY

**Severidade**: 🔴 Critical
**Categoria**: Alerta e Aviso
**Resolver**: Imediatamente (NUNCA mergear com SECURITY pendente)

---

## Definição

Marca código com **vulnerabilidade de segurança** potencial ou confirmada. Este é o codetag mais crítico - código marcado com SECURITY não deve ir para produção até ser resolvido.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Injection (SQL, Command, XSS) | Input não sanitizado em query |
| Exposição de dados sensíveis | Logs com PII, secrets em código |
| Autenticação/Autorização falha | Bypass de permissões |
| Configuração insegura | CORS *, debug em prod |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Bug sem implicação de segurança | BUG ou FIXME |
| Código funciona mas é feio | REFACTOR |
| Melhoria de performance | OPTIMIZE |
| Código temporário sem risco | HACK |

## Formato

```javascript
// SECURITY: tipo de vulnerabilidade - ação necessária
// SECURITY: [OWASP-XX] descrição do risco
// SECURITY: descrição - impacto: o que pode acontecer
```

## Exemplos

### Exemplo 1: SQL Injection

```javascript
// SECURITY: SQL injection - usar prepared statement
function getUser(username) {
  return db.query(`SELECT * FROM users WHERE username = '${username}'`);
  // Atacante pode passar: ' OR '1'='1
}

// ✅ Corrigido
function getUser(username) {
  return db.query('SELECT * FROM users WHERE username = ?', [username]);
}
```

### Exemplo 2: XSS (Cross-Site Scripting)

```javascript
// SECURITY: XSS - não usar innerHTML com input de usuário
function renderComment(comment) {
  element.innerHTML = comment.text; // ❌ Pode executar <script>
}

// ✅ Corrigido
function renderComment(comment) {
  element.textContent = comment.text;
  // Ou se precisar de HTML:
  element.innerHTML = DOMPurify.sanitize(comment.text);
}
```

### Exemplo 3: Senha em Texto Plano

```javascript
// SECURITY: senha armazenada sem hash - usar bcrypt
async function createUser(email, password) {
  await db.users.insert({ email, password }); // ❌ Texto plano!
}

// ✅ Corrigido
async function createUser(email, password) {
  const hashedPassword = await bcrypt.hash(password, 10);
  await db.users.insert({ email, password: hashedPassword });
}
```

### Exemplo 4: Secrets Hardcoded

```javascript
// SECURITY: API key exposta no código - mover para env vars
const stripe = new Stripe('sk_live_abc123xyz789'); // ❌

// ✅ Corrigido
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
```

### Exemplo 5: Broken Access Control

```javascript
// SECURITY: sem verificação de ownership - qualquer usuário acessa qualquer doc
app.get('/api/documents/:id', async (req, res) => {
  const doc = await db.documents.findById(req.params.id);
  res.json(doc); // ❌ Não verifica se pertence ao usuário
});

// ✅ Corrigido
app.get('/api/documents/:id', async (req, res) => {
  const doc = await db.documents.findById(req.params.id);
  if (doc.ownerId !== req.user.id) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  res.json(doc);
});
```

### Exemplo 6: Command Injection

```javascript
// SECURITY: command injection - filename pode ser "; rm -rf /"
function convertImage(filename) {
  exec(`convert ${filename} output.png`); // ❌
}

// ✅ Corrigido
function convertImage(filename) {
  if (!/^[a-zA-Z0-9._-]+$/.test(filename)) {
    throw new InvalidFilenameError();
  }
  execFile('convert', [filename, 'output.png']);
}
```

## OWASP Top 10 Reference

| Vulnerabilidade | Palavras-chave para SECURITY |
|-----------------|------------------------------|
| Injection | SQL, command, LDAP, XPath |
| Broken Auth | session, token, password |
| Sensitive Data | PII, credentials, encrypt |
| XXE | XML, parser, DTD |
| Broken Access | permission, authorization, ownership |
| Misconfiguration | debug, CORS, headers |
| XSS | innerHTML, document.write, eval |
| Deserialization | JSON.parse, unserialize |
| Vulnerable Components | outdated, CVE |
| Insufficient Logging | audit, log, sensitive actions |

## Ação Esperada

1. **PARAR** - não mergear código com SECURITY pendente
2. **Avaliar** o risco e impacto
3. **Corrigir** imediatamente
4. **Revisar** com especialista em segurança se necessário
5. **Testar** correção com casos de ataque
6. **Documentar** a vulnerabilidade e correção
7. **Remover** o comentário após correção

## Resolução Obrigatória

| Contexto | Ação |
|----------|------|
| Qualquer código com SECURITY | NÃO MERGEAR até resolver |
| Descoberto em produção | Hotfix imediato |
| Código legado | Prioridade máxima |

## Busca no Código

```bash
# Encontrar todos os SECURITYs - CRÍTICO
grep -rn "SECURITY:" src/

# Verificar antes de deploy
if grep -rq "SECURITY:" src/; then
  echo "ABORTING: Security issues found"
  exit 1
fi
```

## Anti-Patterns

```javascript
// ❌ SECURITY sem descrição
// SECURITY:
function vulnerable() { }

// ❌ SECURITY ignorado por muito tempo
// SECURITY: (added 2020) fix later
function stillVulnerable() { }

// ❌ Usar SECURITY para não-segurança
// SECURITY: código feio
function notActuallyVulnerable() { }
```

## Quality Factor Relacionado

- [Integrity](../../software-quality/operation/004_integrity.md): SECURITY indica violação direta de integridade

## Rules Relacionadas

- [clean-code/010 - Insecure Functions](../../clean-code/proibicao-funcoes-inseguras.md)
- [twelve-factor/003 - Config via Environment](../../twelve-factor/003_configuracoes-via-ambiente.md)

---

**Criada em**: 2026-03-19
**Versão**: 1.0
