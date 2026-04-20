# Reliability — Confiabilidade

**Dimensão:** Operação
**Severidade Default:** 🔴 Crítica
**Pergunta Chave:** Ele é preciso?

## O que é

O grau em que o software produz resultados consistentes e precisos sob diferentes condições. Um software confiável funciona corretamente mesmo em situações adversas, falha graciosamente e recupera-se de erros.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Erro pode causar perda de dados | 🔴 Blocker |
| Erro pode derrubar o serviço | 🔴 Blocker |
| Erro afeta experiência do usuário | 🟠 Important |
| Erro em fluxo secundário | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não confiável - pode falhar silenciosamente
async function fetchUser(id) {
  const response = await api.get(`/users/${id}`);
  return response.data.user; // E se response.data for undefined?
}

// ✅ Confiável - trata erros e valida dados
async function fetchUser(id) {
  if (!id) throw new UserIdRequiredError();

  const response = await api.get(`/users/${id}`);

  if (!response.data?.user) {
    throw new UserNotFoundError(id);
  }

  return response.data.user;
}
```

## Codetags Sugeridos

```javascript
// FIXME: Promise sem tratamento de erro
// FIXME: Adicionar retry para chamada externa
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Erro pode causar perda de dados | 🔴 Blocker |
| Erro pode derrubar o serviço | 🔴 Blocker |
| Erro afeta experiência do usuário | 🟠 Important |
| Erro em fluxo secundário | 🟡 Suggestion |

## Rules Relacionadas

- 027 - Qualidade no Tratamento de Erros de Domínio
- 028 - Tratamento de Exceção Assíncrona
- 036 - Restrição de Funções com Efeitos Colaterais
