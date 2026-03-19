# Reliability (Confiabilidade)

**Dimensão**: Operação
**Severidade Default**: 🔴 Critical

---

## Pergunta Chave

**Ele é preciso?**

## Definição

O grau em que o software produz resultados consistentes e precisos sob diferentes condições. Um software confiável funciona corretamente mesmo em situações adversas, falha graciosamente e recupera-se de erros.

## Critérios de Verificação

- [ ] Error handling adequado em todas as operações
- [ ] Validação de dados de entrada
- [ ] Resultados consistentes entre execuções
- [ ] Tratamento de estados inválidos
- [ ] Timeout e retry para operações de rede
- [ ] Fallbacks para serviços indisponíveis

## Indicadores de Problema

### Exemplo 1: Falha Silenciosa

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

### Exemplo 2: Promise Sem Tratamento de Erro

```javascript
// ❌ Não confiável - promise flutuante
function saveData(data) {
  api.post('/data', data); // Promise não tratada
  console.log('Dados salvos'); // Mentira - não sabe se salvou
}

// ✅ Confiável - aguarda e trata resultado
async function saveData(data) {
  try {
    await api.post('/data', data);
    console.log('Dados salvos com sucesso');
  } catch (error) {
    console.error('Falha ao salvar dados:', error);
    throw new DataPersistenceError(error);
  }
}
```

### Exemplo 3: Sem Retry em Operações de Rede

```javascript
// ❌ Não confiável - falha na primeira tentativa
async function fetchWithNoRetry(url) {
  return await fetch(url);
}

// ✅ Confiável - retry com backoff exponencial
async function fetchWithRetry(url, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await fetch(url);
    } catch (error) {
      if (attempt === maxRetries) throw error;
      await sleep(Math.pow(2, attempt) * 100);
    }
  }
}
```

### Exemplo 4: Validação de Entrada Ausente

```javascript
// ❌ Não confiável - assume dados válidos
function processUserInput(input) {
  return input.trim().toLowerCase().split(',');
}

// ✅ Confiável - valida entrada
function processUserInput(input) {
  if (typeof input !== 'string') {
    throw new InvalidInputError('Input must be a string');
  }
  if (input.length === 0) {
    return [];
  }
  return input.trim().toLowerCase().split(',');
}
```

## Sinais de Alerta em Code Review

1. **Catch vazio** ou que apenas loga sem tratar
2. **Promises sem await** ou `.catch()`
3. **Operações de rede** sem timeout
4. **Acesso a propriedades** sem verificar existência
5. **JSON.parse** sem try/catch
6. **Operações em banco** sem transação quando necessário

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| API Endpoints | 500 errors não tratados |
| Processamento de dados | Dados parcialmente processados |
| Integrações externas | Falhas em cascata |
| Cache | Dados inconsistentes |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Erro pode causar perda de dados | 🔴 Blocker |
| Erro pode derrubar o serviço | 🔴 Blocker |
| Erro afeta experiência do usuário | 🟠 Important |
| Erro em fluxo secundário | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// FIXME: Adicionar retry para chamada externa
// FIXME: Promise sem tratamento de erro

// TODO: Implementar circuit breaker para este serviço
// TODO: Adicionar validação de entrada
```

## Exemplo de Comentário em Review

```
Ojo que el fix está bien pero falta manejar el caso de error.
Si la request falla, el catch está vacío y el usuario no ve nada.

try {
  const user = await loginService.authenticate(credentials);
} catch (error) {
  // 👆 Acá deberían mostrar feedback al usuario
  showError('Error de autenticación, intenta de nuevo');
  logger.error('Login failed', error);
}

🔴 Arreglar antes del merge
```

## Rules Relacionadas

- [clean-code/007 - Error Handling](../../clean-code/007_qualidade-tratamento-erros-dominio.md)
- [clean-code/008 - Async Exceptions](../../clean-code/008_tratamento-excecao-assincrona.md)
- [clean-code/016 - Side Effects](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md)

## Patterns Relacionados

- [gof/behavioral/001 - Chain of Responsibility](../../gof/behavioral/001_chain-of-responsibility.md): para tratamento de erros em cadeia
- [poeaa/offline-concurrency/001 - Coarse-Grained Lock](../../poeaa/offline-concurrency/001_coarse-grained-lock.md): para consistência

---

**Criada em**: 2026-03-18
**Versão**: 1.0
