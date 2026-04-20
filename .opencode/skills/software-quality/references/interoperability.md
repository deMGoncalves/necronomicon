# Interoperability — Interoperabilidade

**Dimensão:** Transição
**Severidade Default:** 🟠 Importante
**Pergunta Chave:** Ele integra bem com outros sistemas?

## O que é

O esforço necessário para acoplar o software a outros sistemas. Alta interoperabilidade significa que o sistema usa padrões abertos, protocolos comuns e formatos de dados bem definidos para comunicação com sistemas externos.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| API pública sem versionamento | 🔴 Blocker |
| Webhook sem idempotência | 🟠 Important |
| Formato de erro inconsistente | 🟠 Important |
| Contrato não documentado | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não interoperável - formato proprietário
function exportData() {
  return `USER|${user.id}|${user.name}|${user.email}|END`;
  // Formato custom que só este sistema entende
}

// ✅ Interoperável - formato padrão
function exportData() {
  return JSON.stringify({
    type: 'user',
    data: {
      id: user.id,
      name: user.name,
      email: user.email
    }
  });
}
```

## Codetags Sugeridos

```javascript
// API: Endpoint precisa de versionamento
// CONTRACT: Documentar formato de resposta
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| API pública sem versionamento | 🔴 Blocker |
| Webhook sem idempotência | 🟠 Important |
| Formato de erro inconsistente | 🟠 Important |
| Contrato não documentado | 🟡 Suggestion |

## Rules Relacionadas

- 043 - Serviços de Apoio como Recursos
- 014 - Princípio de Inversão de Dependência
- 042 - Configurações via Ambiente
