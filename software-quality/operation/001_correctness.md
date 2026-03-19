# Correctness (Corretude)

**Dimensão**: Operação
**Severidade Default**: 🔴 Critical

---

## Pergunta Chave

**Ele faz o que é pedido?**

## Definição

O grau em que o software cumpre suas especificações e atende aos objetivos do usuário. Um software correto produz os resultados esperados para todas as entradas válidas e trata adequadamente os casos de borda.

## Critérios de Verificação

- [ ] Requisitos funcionais estão implementados corretamente
- [ ] Edge cases são tratados
- [ ] Comportamento esperado em cenários normais
- [ ] Lógica de negócio corresponde às especificações
- [ ] Valores de retorno estão corretos
- [ ] Estados finais são consistentes

## Indicadores de Problema

### Exemplo 1: Bug de Lógica - Edge Case Não Tratado

```javascript
// ❌ Incorreto - não considera edge cases
function calculateDiscount(price, quantity) {
  return price * quantity * 0.1; // E se quantity for 0 ou negativo?
}

// ✅ Correto - trata edge cases
function calculateDiscount(price, quantity) {
  if (quantity <= 0) return 0;
  if (price <= 0) return 0;
  return price * quantity * 0.1;
}
```

### Exemplo 2: Operação com Array Vazio

```javascript
// ❌ Incorreto - explode com array vazio
function getAverage(numbers) {
  const sum = numbers.reduce((a, b) => a + b);
  return sum / numbers.length; // Division by zero se vazio
}

// ✅ Correto - trata array vazio
function getAverage(numbers) {
  if (numbers.length === 0) return 0;
  const sum = numbers.reduce((a, b) => a + b, 0);
  return sum / numbers.length;
}
```

### Exemplo 3: Comparação Incorreta

```javascript
// ❌ Incorreto - comparação de tipos diferentes
function isEqual(a, b) {
  return a == b; // '5' == 5 é true
}

// ✅ Correto - comparação estrita
function isEqual(a, b) {
  return a === b;
}
```

### Exemplo 4: Off-by-One Error

```javascript
// ❌ Incorreto - off-by-one
function getLastNItems(items, n) {
  return items.slice(items.length - n + 1); // Erro de 1
}

// ✅ Correto
function getLastNItems(items, n) {
  return items.slice(-n);
}
```

## Sinais de Alerta em Code Review

1. **Funções matemáticas** sem validação de divisão por zero
2. **Operações em arrays/strings** sem verificar se estão vazios
3. **Comparações** usando `==` em vez de `===`
4. **Loops** com condições de parada incorretas
5. **Índices** calculados sem considerar arrays vazios
6. **Promises** que não tratam rejeição

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Cálculos financeiros | Perda monetária direta |
| Validação de dados | Dados corrompidos |
| Controle de acesso | Brechas de segurança |
| Interface do usuário | Experiência quebrada |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Bug afeta dados do usuário | 🔴 Blocker |
| Bug afeta cálculos críticos | 🔴 Blocker |
| Bug em edge case raro | 🟠 Important |
| Bug cosmético | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// FIXME: Division by zero quando items está vazio
// BUG: Comparação incorreta entre tipos

// HACK: Workaround temporário para edge case X
// Remover quando issue #123 for resolvido
```

## Exemplo de Comentário em Review

```
Ojo que si `items` viene vacío, el reduce va a explotar porque no tiene valor inicial.

items.reduce((acc, item) => acc + item.price) // 💥 si items = []

Agregale el valor inicial:
items.reduce((acc, item) => acc + item.price, 0) // ✓

🔴 Esto hay que arreglarlo
```

## Rules Relacionadas

- [clean-code/007 - Error Handling](../../clean-code/007_qualidade-tratamento-erros-dominio.md)
- [clean-code/008 - Async Exceptions](../../clean-code/008_tratamento-excecao-assincrona.md)
- [object-calisthenics/002 - No Else Clause](../../object-calisthenics/002_prohibition-else-clause.md)

## Patterns Relacionados

- [gof/behavioral/008 - State](../../gof/behavioral/008_state.md): para gerenciar estados válidos
- [poeaa/base/008 - Special Case](../../poeaa/base/008_special-case.md): para tratar casos especiais

---

**Criada em**: 2026-03-18
**Versão**: 1.0
