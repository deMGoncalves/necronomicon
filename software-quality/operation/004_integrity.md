# Integrity (Integridade)

**Dimensão**: Operação
**Severidade Default**: 🔴 Critical (SEMPRE blocker)

---

## Pergunta Chave

**Oferece segurança?**

## Definição

O grau em que o acesso ao software ou dados pode ser controlado e protegido. Integridade abrange proteção contra ataques, validação de dados, controle de acesso e proteção de informações sensíveis.

## Critérios de Verificação

- [ ] Sanitização de inputs (XSS, SQL Injection)
- [ ] Autenticação e autorização adequadas
- [ ] Proteção de dados sensíveis (PII, senhas)
- [ ] OWASP Top 10 compliance
- [ ] Secrets não expostos em código
- [ ] HTTPS para comunicação sensível

## Indicadores de Problema

### Exemplo 1: SQL Injection

```javascript
// ❌ Vulnerável - SQL Injection
function getUser(username) {
  return db.query(`SELECT * FROM users WHERE username = '${username}'`);
}

// ✅ Seguro - Prepared Statement
function getUser(username) {
  return db.query('SELECT * FROM users WHERE username = ?', [username]);
}
```

### Exemplo 2: Cross-Site Scripting (XSS)

```javascript
// ❌ Vulnerável - XSS
element.innerHTML = userInput;

// ✅ Seguro - Text content ou sanitização
element.textContent = userInput;
// ou se precisar de HTML:
element.innerHTML = DOMPurify.sanitize(userInput);
```

### Exemplo 3: Senha em Texto Plano

```javascript
// ❌ Vulnerável - senha sem hash
async function createUser(email, password) {
  await db.users.insert({ email, password }); // 💀
}

// ✅ Seguro - senha com hash
async function createUser(email, password) {
  const hashedPassword = await bcrypt.hash(password, 10);
  await db.users.insert({ email, password: hashedPassword });
}
```

### Exemplo 4: Secrets Hardcoded

```javascript
// ❌ Vulnerável - API key no código
const stripe = new Stripe('sk_live_abc123xyz789');

// ✅ Seguro - via variável de ambiente
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
```

### Exemplo 5: Broken Access Control

```javascript
// ❌ Vulnerável - sem verificação de ownership
app.get('/api/documents/:id', async (req, res) => {
  const doc = await db.documents.findById(req.params.id);
  res.json(doc); // Qualquer um pode ver qualquer documento!
});

// ✅ Seguro - verifica ownership
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
// ❌ Vulnerável - command injection
function convertImage(filename) {
  exec(`convert ${filename} output.png`); // filename pode ser "; rm -rf /"
}

// ✅ Seguro - escapar/validar entrada
function convertImage(filename) {
  if (!/^[a-zA-Z0-9._-]+$/.test(filename)) {
    throw new InvalidFilenameError();
  }
  execFile('convert', [filename, 'output.png']);
}
```

## OWASP Top 10 Checklist

| Vulnerabilidade | Como Detectar |
|-----------------|---------------|
| **Injection** | Strings concatenadas em queries |
| **Broken Auth** | Sessões mal gerenciadas |
| **Sensitive Data Exposure** | Dados sem criptografia |
| **XXE** | Parser XML sem proteção |
| **Broken Access Control** | Sem verificação de permissões |
| **Security Misconfiguration** | Debug habilitado em prod |
| **XSS** | innerHTML com input de usuário |
| **Insecure Deserialization** | JSON.parse de dados externos |
| **Vulnerable Components** | Dependências desatualizadas |
| **Insufficient Logging** | Ações sensíveis sem log |

## Sinais de Alerta em Code Review

1. **String interpolation** em queries SQL
2. **innerHTML** com dados de usuário
3. **Senhas/tokens** em código fonte
4. **eval()** ou new Function() com input externo
5. **Falta de verificação** de permissões
6. **CORS \*** em produção

## Impacto Quando Violado

| Vulnerabilidade | Impacto |
|-----------------|---------|
| SQL Injection | Vazamento total do banco |
| XSS | Roubo de sessão/cookies |
| Senha em texto | Comprometimento de contas |
| Broken Access | Acesso não autorizado a dados |

## Calibração de Severidade

**SEMPRE 🔴 Blocker** - Não há exceções para vulnerabilidades de segurança.

| Situação | Ação |
|----------|------|
| Qualquer vulnerabilidade de segurança | 🔴 Blocker - não mergear |
| Possível vulnerabilidade (precisa análise) | 🔴 Blocker até confirmar |
| Melhoria de segurança (não vulnerável) | 🟠 Important |

## Codetags Sugeridos

```javascript
// SECURITY: Sanitizar input antes de usar em query
// SECURITY: Implementar rate limiting neste endpoint

// FIXME: SQL injection vulnerability - usar prepared statement
// FIXME: XSS vulnerability - usar textContent
```

## Exemplo de Comentário em Review

```
🚨 El password se está guardando en texto plano:

await db.users.insert({ email, password }); // ❌

Hay que hashearlo antes de persistir:

const hashedPassword = await bcrypt.hash(password, 10);
await db.users.insert({ email, password: hashedPassword });

🔴 Crítico - esto no puede ir a producción
```

## Rules Relacionadas

- [clean-code/010 - Insecure Functions](../../clean-code/proibicao-funcoes-inseguras.md)
- [twelve-factor/003 - Config via Environment](../../twelve-factor/003_configuracoes-via-ambiente.md)

## Patterns Relacionados

- [gof/structural/007 - Proxy](../../gof/structural/007_proxy.md): para controle de acesso
- [gof/behavioral/001 - Chain of Responsibility](../../gof/behavioral/001_chain-of-responsibility.md): para filtros de segurança

---

**Criada em**: 2026-03-18
**Versão**: 1.0
