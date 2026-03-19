# DEPRECATED

**Severidade**: 🟠 High
**Categoria**: Alerta e Aviso
**Resolver**: Conforme timeline de deprecação

---

## Definição

Marca código ou funcionalidade **obsoleta** que será removida em versão futura. Indica que existe alternativa melhor e que o uso atual deve ser migrado.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| API sendo descontinuada | Endpoint v1 sendo substituído por v2 |
| Função com substituta melhor | Helper antigo com nova implementação |
| Padrão abandonado | Abordagem que não será mais mantida |
| Dependência a ser removida | Biblioteca sendo trocada |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Código com bug | FIXME ou BUG |
| Código temporário | HACK |
| Código a melhorar | REFACTOR |
| Código removido | Deletar, não marcar |

## Formato

```javascript
// DEPRECATED: usar X em vez - remover em vY.Z
// @deprecated desde v1.2 - usar newFunction()
// DEPRECATED: [timeline] descrição da migração
```

## Exemplos

### Exemplo 1: Função Substituída

```javascript
// DEPRECATED: usar calculateTotalV2() - remover em v3.0
// Esta função não considera taxas regionais
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Nova função recomendada
function calculateTotalV2(items, region) {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  return applyRegionalTax(subtotal, region);
}
```

### Exemplo 2: API Endpoint

```javascript
// DEPRECATED: migrar para /api/v2/users - v1 será removida em 2024-06
// v2 retorna dados paginados e inclui metadata
app.get('/api/v1/users', (req, res) => {
  // Lógica antiga
});

// Endpoint novo
app.get('/api/v2/users', (req, res) => {
  // Lógica nova com paginação
});
```

### Exemplo 3: Componente React

```javascript
// DEPRECATED: usar <Button> de @design-system - remover após migração
// Este componente não segue o novo design system
function LegacyButton({ onClick, children }) {
  return (
    <button className="legacy-btn" onClick={onClick}>
      {children}
    </button>
  );
}
```

### Exemplo 4: Hook Obsoleto

```javascript
// DEPRECATED: usar useQuery do react-query - melhor cache e retry
// Este hook não tem cache nem tratamento de erro adequado
function useFetch(url) {
  const [data, setData] = useState(null);
  useEffect(() => {
    fetch(url).then(r => r.json()).then(setData);
  }, [url]);
  return data;
}
```

### Exemplo 5: Padrão de Configuração

```javascript
// DEPRECATED: configuração via JSON - migrar para variáveis de ambiente
// JSON config será removido em v4.0 (twelve-factor compliance)
const config = require('./config.json');

// Novo padrão
const config = {
  apiUrl: process.env.API_URL,
  apiKey: process.env.API_KEY,
};
```

## Boas Práticas de Deprecação

### 1. Usar @deprecated JSDoc

```javascript
/**
 * @deprecated desde v2.0 - usar newFunction() em vez
 * @see newFunction
 */
function oldFunction() {
  console.warn('oldFunction is deprecated, use newFunction instead');
  // ...
}
```

### 2. Emitir Warning em Runtime

```javascript
// DEPRECATED: usar formatCurrency() - remover em v3.0
function formatMoney(value) {
  if (process.env.NODE_ENV === 'development') {
    console.warn(
      'formatMoney() is deprecated. Use formatCurrency() instead.'
    );
  }
  return `$${value.toFixed(2)}`;
}
```

### 3. Documentar Timeline

```javascript
/*
 * DEPRECATED: Timeline de remoção
 * - v2.5: Avisos em desenvolvimento
 * - v2.6: Avisos em produção
 * - v3.0: Função removida
 */
```

## Ação Esperada

1. **Documentar** alternativa recomendada
2. **Definir** timeline de remoção
3. **Comunicar** aos consumidores da API/função
4. **Adicionar** warning em runtime (dev)
5. **Migrar** usos internos primeiro
6. **Remover** após período de deprecação

## Timeline Típica

| Fase | Ação |
|------|------|
| Anúncio | Marcar como deprecated, documentar alternativa |
| Grace period | Avisos em dev, suporte a migração |
| Warning | Avisos em prod (opcional) |
| Remoção | Deletar código deprecated |

## Busca no Código

```bash
# Encontrar todos os DEPRECATEDs
grep -rn "DEPRECATED:\|@deprecated" src/

# DEPRECATEDs com data/versão
grep -rn "DEPRECATED:.*v[0-9]\|@deprecated.*v[0-9]" src/

# Código usando funções deprecated
grep -rn "oldFunctionName" src/
```

## Anti-Patterns

```javascript
// ❌ DEPRECATED sem alternativa
// DEPRECATED:
function old() { }

// ❌ DEPRECATED sem timeline
// DEPRECATED: não usar
function old() { }

// ❌ DEPRECATED eterno
// DEPRECATED: (2018) remover depois
function stillHere() { }

// ❌ Deprecar sem comunicar
function secretlyDeprecated() { }
```

## Quality Factor Relacionado

- [Maintainability](../../software-quality/revision/001_maintainability.md): deprecação clara facilita manutenção
- [Interoperability](../../software-quality/transition/003_interoperability.md): deprecação bem comunicada ajuda integradores

## Rules Relacionadas

- [clean-code/003 - YAGNI](../../clean-code/003_prohibition-speculative-functionality.md): remover código não usado
- [package-principles/001 - REP](../../package-principles/001_release-reuse-equivalency-principle.md): versionamento adequado

---

**Criada em**: 2026-03-19
**Versão**: 1.0
