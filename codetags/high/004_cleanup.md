# CLEANUP

**Severidade**: 🟠 High
**Categoria**: Ação Requerida
**Resolver**: Próxima sprint ou Boy Scout Rule

---

## Definição

Marca código **desorganizado** ou com elementos desnecessários que precisam ser limpos. Diferente de REFACTOR (que muda estrutura), CLEANUP remove ruído e organiza sem alterar comportamento.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Código morto | Funções nunca chamadas |
| Imports não utilizados | Dependências órfãs |
| Comentários obsoletos | Documentação desatualizada |
| Console.logs esquecidos | Debug deixado para trás |
| Variáveis não utilizadas | Declarações órfãs |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Código a ser reestruturado | REFACTOR |
| Bug a ser corrigido | FIXME |
| Feature a implementar | TODO |
| Código obsoleto oficial | DEPRECATED |

## Formato

```javascript
// CLEANUP: tipo de limpeza necessária
// CLEANUP: remover código morto após confirmar não-uso
// CLEANUP: organizar imports/remover não utilizados
```

## Exemplos

### Exemplo 1: Código Morto

```javascript
// CLEANUP: função não utilizada - verificar e remover
function oldCalculation(value) {
  // Esta função era usada na v1, não é mais chamada
  return value * 1.5;
}

// Função atual
function newCalculation(value) {
  return value * 1.8;
}
```

### Exemplo 2: Console.logs de Debug

```javascript
// CLEANUP: remover logs de debug antes do merge
function processOrder(order) {
  console.log('DEBUG: order received', order);
  console.log('DEBUG: processing...', { timestamp: Date.now() });

  const result = calculate(order);

  console.log('DEBUG: result', result);
  return result;
}
```

### Exemplo 3: Imports Não Utilizados

```javascript
// CLEANUP: imports não utilizados - remover
import { useState, useEffect, useCallback, useMemo } from 'react';
import { format, parse, addDays } from 'date-fns';
import _ from 'lodash';

// Apenas useState é usado
function SimpleComponent() {
  const [value, setValue] = useState(0);
  return <div>{value}</div>;
}
```

### Exemplo 4: Comentários Obsoletos

```javascript
// CLEANUP: comentários desatualizados - atualizar ou remover
function calculateDiscount(order) {
  // Retorna 10% de desconto para pedidos acima de R$100
  // NOTA: agora retorna 15% (mudou em 2023)
  // TODO: verificar com marketing (já verificado, manter 15%)
  return order.total > 100 ? order.total * 0.15 : 0;
}
```

### Exemplo 5: Variáveis Não Utilizadas

```javascript
// CLEANUP: variáveis declaradas mas não utilizadas
function processData(input) {
  const config = getConfig(); // Nunca usado
  const logger = getLogger(); // Nunca usado
  const validator = getValidator(); // Nunca usado

  // Apenas input é usado
  return transform(input);
}
```

### Exemplo 6: Código Comentado

```javascript
// CLEANUP: código comentado - remover (está no git history)
function getCurrentPrice(product) {
  // const oldPrice = product.basePrice * 1.1;
  // const discount = calculateOldDiscount(product);
  // return oldPrice - discount;

  return product.basePrice * 1.2;
}
```

### Exemplo 7: Arquivos Órfãos

```javascript
// CLEANUP: este arquivo não é importado por nenhum outro
// Verificar se pode ser removido ou se falta import em algum lugar

// old-utils.js
export function deprecatedHelper() {
  // ...
}
```

## Checklist de Limpeza

| Item | Comando/Ferramenta |
|------|-------------------|
| Imports não usados | ESLint `no-unused-vars` |
| Variáveis não usadas | TypeScript strict mode |
| Código morto | Coverage report (0% coverage) |
| Console.logs | `grep -rn "console.log"` |
| Comentários TODO antigos | `grep -rn "TODO:.*20[12]"` |
| Arquivos órfãos | `npx unimported` |

## Ação Esperada

1. **Identificar** o tipo de limpeza necessária
2. **Verificar** que remoção é segura
3. **Remover** código/imports/comentários
4. **Testar** que nada quebrou
5. **Commitar** com mensagem descritiva

## Resolução

| Tipo de Limpeza | Quando Fazer |
|-----------------|--------------|
| Console.logs | Antes do commit |
| Imports não usados | Antes do PR |
| Código morto | Próxima sprint |
| Arquivos órfãos | Revisão periódica |

## Busca no Código

```bash
# Encontrar CLEANUPs
grep -rn "CLEANUP:" src/

# Console.logs esquecidos
grep -rn "console\.log" src/ --include="*.ts" --include="*.js"

# Comentários TODO antigos
grep -rn "TODO:.*201[0-9]\|TODO:.*202[0-2]" src/

# Código comentado (linhas começando com //)
grep -rn "^[[:space:]]*//.*function\|^[[:space:]]*//.*const\|^[[:space:]]*//.*return" src/
```

## Anti-Patterns

```javascript
// ❌ CLEANUP sem especificar o quê
// CLEANUP:
const messyCode = true;

// ❌ Usar CLEANUP para refatoração
// CLEANUP: separar em classes
function godFunction() { } // Use REFACTOR

// ❌ Marcar mas nunca limpar
// CLEANUP: (2020) remover isso
const stillHere = true;
```

## Ferramentas de Automação

```json
// ESLint config para detectar automaticamente
{
  "rules": {
    "no-unused-vars": "error",
    "no-console": "warn",
    "no-unreachable": "error",
    "no-unused-imports": "error"
  }
}
```

```json
// TypeScript config
{
  "compilerOptions": {
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

## Quality Factor Relacionado

- [Maintainability](../../software-quality/revision/001_maintainability.md): código limpo é mais fácil de manter
- [Efficiency](../../software-quality/operation/003_efficiency.md): menos código = bundle menor

## Rules Relacionadas

- [clean-code/003 - YAGNI](../../clean-code/proibicao-funcionalidade-especulativa.md): remover código não necessário
- [clean-code/019 - Boy Scout Rule](../../clean-code/regra-escoteiro-refatoracao-continua.md): limpar ao passar

---

**Criada em**: 2026-03-19
**Versão**: 1.0
