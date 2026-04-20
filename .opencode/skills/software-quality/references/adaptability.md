# Adaptability — Adaptabilidade

**Dimensão:** Operação
**Severidade Default:** 🟠 Importante
**Pergunta Chave:** Ele é configurável?

## O que é

A facilidade com que o software pode ser modificado para atender diferentes necessidades de usuários, ambientes ou requisitos sem alteração do código fonte. Adaptabilidade inclui configurabilidade, parametrização e extensibilidade via plugins.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Credenciais/URLs hardcoded | 🔴 Blocker |
| Lógica que varia por cliente hardcoded | 🟠 Important |
| Timeout/retry sem configuração | 🟠 Important |
| Textos UI sem i18n | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não adaptável - valores fixos no código
function shouldRetry(attempts) {
  return attempts < 3; // Sempre 3 tentativas
}

// ✅ Adaptável - valores configuráveis
function shouldRetry(attempts) {
  const maxRetries = config.get('MAX_RETRIES', 3);
  return attempts < maxRetries;
}
```

## Codetags Sugeridos

```javascript
// CONFIG(042): Este valor deveria ser configurável via ambiente
// CONFIG(024): Considerar feature flag para esta funcionalidade
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Credenciais/URLs de ambiente hardcoded | 🔴 Blocker |
| Lógica que varia por cliente hardcoded | 🟠 Important |
| Timeout/retry sem configuração | 🟠 Important |
| Textos UI sem i18n | 🟡 Suggestion |

## Rules Relacionadas

- 042 - Configurações via Ambiente
- 024 - Proibição de Constantes Mágicas
- 011 - Princípio Aberto/Fechado
