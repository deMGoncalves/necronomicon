# Integrity — Integridade

**Dimensão:** Operação
**Severidade Default:** 🔴 Crítica (SEMPRE blocker)
**Pergunta Chave:** Oferece segurança?

## O que é

O grau em que o acesso ao software ou dados pode ser controlado e protegido. Integridade abrange proteção contra ataques, validação de dados, controle de acesso e proteção de informações sensíveis.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Qualquer vulnerabilidade de segurança | 🔴 Blocker |
| Possível vulnerabilidade (precisa análise) | 🔴 Blocker |
| Melhoria de segurança (não vulnerável) | 🟠 Important |

## Exemplo de Violação

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

## Codetags Sugeridos

```javascript
// SECURITY: Sanitizar input antes de usar em query
// FIXME: SQL injection vulnerability - usar prepared statement
// FIXME: API key hardcoded - mover para variável de ambiente
```

## Calibração de Severidade

**SEMPRE 🔴 Blocker** - Não há exceções para vulnerabilidades de segurança.

| Situação | Ação |
|----------|------|
| Qualquer vulnerabilidade de segurança | 🔴 Blocker - não mergear |
| Possível vulnerabilidade (precisa análise) | 🔴 Blocker até confirmar |
| Melhoria de segurança (não vulnerável) | 🟠 Important |

## Rules Relacionadas

- 030 - Proibição de Funções Inseguras
- 042 - Configurações via Ambiente
- 024 - Proibição de Constantes Mágicas
