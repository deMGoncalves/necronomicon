# HACK

**Severidade**: 🟠 High
**Categoria**: Alerta e Aviso
**Resolver**: Antes do merge ou próxima sprint

---

## Definição

Marca **solução temporária** ou workaround que funciona mas não é a implementação correta. HACKs são conscientemente sub-ótimos e precisam ser reescritos adequadamente.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Workaround para bug externo | Contornando bug de biblioteca |
| Solução rápida para deadline | Precisa refatorar depois |
| Código para compatibilidade | Suporte temporário a versão antiga |
| Gambiarra que funciona | Solução não elegante mas funcional |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Bug no próprio código | FIXME |
| Código que precisa de melhoria | REFACTOR |
| Otimização pendente | OPTIMIZE |
| Código permanente | Não use codetag |

## Formato

```javascript
// HACK: razão do workaround - quando remover
// HACK: [ticket] descrição - remover quando X
// HACK: contornando bug em lib Y - issue #123
```

## Exemplos

### Exemplo 1: Bug de Biblioteca

```javascript
// HACK: Safari não suporta `gap` em flexbox < 14.1
// Remover quando dropar suporte a Safari 14
.container {
  display: flex;
  /* gap: 16px; // Não funciona em Safari antigo */
  margin: -8px;
}
.container > * {
  margin: 8px;
}
```

### Exemplo 2: Compatibilidade Temporária

```javascript
// HACK: API v1 retorna dates como string, v2 como timestamp
// Remover quando migração para v2 estiver completa
function parseDate(value) {
  if (typeof value === 'string') {
    return new Date(value); // API v1
  }
  return new Date(value * 1000); // API v2
}
```

### Exemplo 3: Deadline Apertado

```javascript
// HACK: validação inline por tempo - extrair para validator class
// TODO: Criar OrderValidator após release 2.0
function createOrder(data) {
  // Validação que deveria estar em classe separada
  if (!data.items?.length) throw new Error('Items required');
  if (!data.customer?.email) throw new Error('Email required');
  if (data.total < 0) throw new Error('Invalid total');
  // ... resto da função
}
```

### Exemplo 4: Workaround de Framework

```javascript
// HACK: React 18 strict mode causa double-mount em dev
// Não é bug, é comportamento intencional para detectar problemas
// Este useEffect precisa ser idempotente
useEffect(() => {
  let mounted = true;

  fetchData().then(data => {
    if (mounted) setData(data);
  });

  return () => { mounted = false; };
}, []);
```

### Exemplo 5: Integração Legada

```javascript
// HACK: sistema legado espera XML, novo espera JSON
// Converter até migração completa do sistema legado (Q3 2024)
function sendToLegacy(data) {
  const xml = jsonToXml(data);
  return legacyApi.post('/endpoint', xml, {
    headers: { 'Content-Type': 'application/xml' }
  });
}
```

## Ação Esperada

1. **Documentar** claramente o motivo do hack
2. **Especificar** quando pode ser removido
3. **Criar ticket** para refatoração
4. **Revisar** periodicamente se ainda é necessário
5. **Remover** assim que a solução correta for implementada

## Resolução

| Contexto | Quando Resolver |
|----------|-----------------|
| Hack para deadline | Próxima sprint |
| Hack para bug externo | Quando fix disponível |
| Hack de compatibilidade | Quando deprecar versão antiga |
| Hack sem prazo definido | Adicionar ao backlog técnico |

## Busca no Código

```bash
# Encontrar todos os HACKs
grep -rn "HACK:" src/

# HACKs com datas (possíveis antigos)
grep -rn "HACK:.*20[0-9][0-9]" src/

# Contar HACKs por diretório
grep -rc "HACK:" src/ | grep -v ":0"
```

## Anti-Patterns

```javascript
// ❌ HACK sem explicação
// HACK:
function workaround() { }

// ❌ HACK sem prazo de remoção
// HACK: gambiarra
function workaround() { }

// ❌ HACK permanente
// HACK: sempre foi assim
function workaround() { } // Não é hack, é o código real

// ❌ Usar HACK para código ruim próprio
// HACK: código confuso
function myBadCode() { } // Use REFACTOR
```

## Diferença de FIXME

| Aspecto | HACK | FIXME |
|---------|------|-------|
| Funciona? | Sim, mas mal | Não, está quebrado |
| Problema | Solução sub-ótima | Bug confirmado |
| Origem | Decisão consciente | Erro não intencional |
| Ação | Reescrever melhor | Consertar bug |

## Quality Factor Relacionado

- [Maintainability](../../software-quality/revision/001_maintainability.md): HACKs dificultam manutenção
- [Flexibility](../../software-quality/revision/002_flexibility.md): HACKs reduzem flexibilidade

## Rules Relacionadas

- [clean-code/002 - KISS](../../clean-code/002_prioritization-simplicity-clarity.md): HACKs violam simplicidade
- [clean-code/019 - Boy Scout Rule](../../clean-code/019_regra-escoteiro-refatoracao-continua.md): resolver HACKs ao passar pela área

---

**Criada em**: 2026-03-19
**Versão**: 1.0
