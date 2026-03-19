# Interoperability (Interoperabilidade)

**Dimensão**: Transição
**Severidade Default**: 🟠 Important

---

## Pergunta Chave

**Ele integra bem com outros sistemas?**

## Definição

O esforço necessário para acoplar o software a outros sistemas. Alta interoperabilidade significa que o sistema usa padrões abertos, protocolos comuns e formatos de dados bem definidos para comunicação com sistemas externos.

## Critérios de Verificação

- [ ] APIs seguem padrões REST/GraphQL
- [ ] Formatos de dados padronizados (JSON, XML)
- [ ] Versionamento de API documentado
- [ ] Contratos de interface explícitos
- [ ] Tratamento de erros padronizado
- [ ] Documentação de integração disponível

## Indicadores de Problema

### Exemplo 1: Formato de Dados Proprietário

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

### Exemplo 2: API Sem Versionamento

```javascript
// ❌ Não interoperável - mudanças quebram clientes
app.get('/users/:id', handler);
// Qualquer mudança na estrutura quebra integrações

// ✅ Interoperável - API versionada
app.get('/v1/users/:id', handlerV1);
app.get('/v2/users/:id', handlerV2);
// Clientes podem migrar no próprio tempo
```

### Exemplo 3: Erros Não Padronizados

```javascript
// ❌ Não interoperável - erros inconsistentes
// Endpoint 1
res.status(400).json({ error: 'Invalid email' });
// Endpoint 2
res.status(400).json({ message: 'Email inválido', code: 'INVALID_EMAIL' });
// Endpoint 3
res.status(400).send('Bad request');

// ✅ Interoperável - formato de erro padronizado
const errorResponse = {
  error: {
    code: 'VALIDATION_ERROR',
    message: 'Invalid email format',
    details: [
      { field: 'email', message: 'Must be a valid email address' }
    ]
  }
};
res.status(400).json(errorResponse);
```

### Exemplo 4: Contrato Implícito

```javascript
// ❌ Não interoperável - contrato não documentado
async function getUserOrders(userId) {
  const response = await api.get(`/users/${userId}/orders`);
  return response.data.orders.map(o => ({
    ...o,
    total: parseFloat(o.total) // Assume que total é string
  }));
}

// ✅ Interoperável - contrato explícito com tipos
interface Order {
  id: string;
  total: number;
  status: 'pending' | 'completed' | 'cancelled';
  createdAt: string; // ISO 8601
}

interface GetOrdersResponse {
  orders: Order[];
  pagination: {
    page: number;
    totalPages: number;
  };
}

async function getUserOrders(userId: string): Promise<GetOrdersResponse> {
  const response = await api.get<GetOrdersResponse>(`/v1/users/${userId}/orders`);
  return response.data;
}
```

### Exemplo 5: Acoplamento Forte com Sistema Externo

```javascript
// ❌ Não interoperável - acoplado a estrutura externa
async function syncUsers() {
  const response = await externalApi.get('/api/v2/usuarios');
  // Código totalmente dependente da estrutura do sistema externo
  return response.data.usuarios.map(u => ({
    id: u.codigo,
    name: u.nome_completo,
    email: u.endereco_email
  }));
}

// ✅ Interoperável - adaptador para isolar
class ExternalUserAdapter {
  constructor(externalApi) {
    this.api = externalApi;
  }

  async getUsers() {
    const response = await this.api.get('/api/v2/usuarios');
    return response.data.usuarios.map(this.toInternalUser);
  }

  toInternalUser(external) {
    return {
      id: external.codigo,
      name: external.nome_completo,
      email: external.endereco_email
    };
  }
}
```

### Exemplo 6: Webhooks Sem Retry/Idempotência

```javascript
// ❌ Não interoperável - webhook frágil
app.post('/webhook', async (req, res) => {
  await processEvent(req.body);
  res.sendStatus(200);
  // Se processamento falhar, evento perdido
});

// ✅ Interoperável - webhook robusto
app.post('/webhook', async (req, res) => {
  const eventId = req.headers['x-event-id'];

  // Idempotência
  if (await eventStore.exists(eventId)) {
    return res.sendStatus(200);
  }

  try {
    await processEvent(req.body);
    await eventStore.markProcessed(eventId);
    res.sendStatus(200);
  } catch (error) {
    // Sistema externo pode fazer retry
    res.status(500).json({ error: 'Processing failed', retryable: true });
  }
});
```

## Sinais de Alerta em Code Review

1. **Formatos de dados** proprietários ou não documentados
2. **APIs** sem versionamento
3. **Respostas de erro** inconsistentes entre endpoints
4. **Mapeamento direto** de estruturas externas sem adaptador
5. **Webhooks** sem idempotência
6. **Contratos** de API não tipados ou documentados

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Formato proprietário | Difícil integrar novos sistemas |
| Sem versionamento | Mudanças quebram integrações |
| Erros inconsistentes | Debug difícil para integradores |
| Sem idempotência | Duplicação de processamento |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| API pública sem versionamento | 🔴 Blocker |
| Webhook sem idempotência | 🟠 Important |
| Formato de erro inconsistente | 🟠 Important |
| Contrato não documentado | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// API: Endpoint precisa de versionamento
// CONTRACT: Documentar formato de resposta

// TODO: Implementar adapter para sistema externo
// TODO: Padronizar formato de erro
```

## Exemplo de Comentário em Review

```
Los errores de la API no siguen un formato consistente:

// Endpoint A
res.json({ error: 'Not found' });

// Endpoint B
res.json({ message: 'Usuario no encontrado', code: 404 });

Mejor usar un formato estándar:

res.status(404).json({
  error: {
    code: 'NOT_FOUND',
    message: 'User not found',
    path: '/users/123'
  }
});

🟠 Importante para interoperabilidad
```

## Rules Relacionadas

- [twelve-factor/004 - Backing Services](../../twelve-factor/004_servicos-apoio-recursos.md)
- [solid/005 - Dependency Inversion](../../solid/005_principio-inversao-dependencia.md)

## Patterns Relacionados

- [gof/structural/001 - Adapter](../../gof/structural/001_adapter.md): para adaptar interfaces externas
- [gof/structural/005 - Facade](../../gof/structural/005_facade.md): para simplificar integração
- [poeaa/base/003 - Gateway](../../poeaa/base/003_gateway.md): para encapsular acesso externo
- [poeaa/data-source/004 - Table Data Gateway](../../poeaa/data-source/004_table-data-gateway.md): para acesso a dados

---

**Criada em**: 2026-03-18
**Versão**: 1.0
