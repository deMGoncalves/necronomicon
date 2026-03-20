# INFO

**Severidade**: 🟢 Low
**Categoria**: Documentação e Contexto
**Resolver**: N/A (informativo)

---

## Definição

Marca **informação técnica adicional** ou explicação que ajuda a entender o código. Menos crítico que NOTE - é contexto útil mas não essencial para modificar o código.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Referência a documentação | Link para spec ou RFC |
| Explicação de algoritmo | Como funciona internamente |
| Contexto técnico | Limitação de biblioteca |
| Exemplo de uso | Como a função é chamada |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Decisão importante | NOTE |
| Tarefa pendente | TODO |
| Código perigoso | XXX |
| Documentação de API | JSDoc/TSDoc |

## Formato

```javascript
// INFO: detalhe técnico
// INFO: referência a documentação
// INFO: explicação do algoritmo
```

## Exemplos

### Exemplo 1: Referência a Documentação

```javascript
// INFO: implementação baseada em Web Crypto API
// Spec: https://www.w3.org/TR/WebCryptoAPI/
async function generateKey() {
  return crypto.subtle.generateKey(
    { name: 'AES-GCM', length: 256 },
    true,
    ['encrypt', 'decrypt']
  );
}
```

### Exemplo 2: Explicação de Algoritmo

```javascript
// INFO: Fisher-Yates shuffle - O(n) com distribuição uniforme
// Cada elemento tem probabilidade igual de estar em qualquer posição
function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}
```

### Exemplo 3: Limitação de Biblioteca

```javascript
// INFO: date-fns não suporta timezone nativo
// Para operações com timezone, usar date-fns-tz
import { format } from 'date-fns';

function formatDate(date) {
  return format(date, 'yyyy-MM-dd');
}
```

### Exemplo 4: Exemplo de Uso

```javascript
// INFO: uso típico:
// const result = pipe(
//   double,
//   addOne,
//   square
// )(5); // ((5 * 2) + 1)² = 121
function pipe(...fns) {
  return (value) => fns.reduce((acc, fn) => fn(acc), value);
}
```

### Exemplo 5: Formato de Dados

```javascript
// INFO: formato esperado do response:
// {
//   "data": { "user": { "id": "123", "name": "John" } },
//   "meta": { "requestId": "abc-123" }
// }
async function fetchUser(id) {
  const response = await api.get(`/users/${id}`);
  return response.data.user;
}
```

### Exemplo 6: Comportamento de Framework

```javascript
// INFO: useEffect com array vazio executa apenas no mount
// Equivalente a componentDidMount em class components
useEffect(() => {
  initializeAnalytics();
}, []);
```

### Exemplo 7: Valores Mágicos Explicados

```javascript
// INFO: 86400000 = 24h * 60min * 60s * 1000ms
// Representa um dia inteiro em milissegundos
const ONE_DAY_MS = 86400000;
```

## Boas Práticas

### Links para Referências

```javascript
// INFO: Debounce pattern
// Artigo explicativo: https://css-tricks.com/debouncing-throttling-explained/
```

### Exemplos Concretos

```javascript
// INFO: regex captura: [1]=área, [2]=prefixo, [3]=número
// Exemplo: "(11) 98765-4321" → ["11", "98765", "4321"]
const PHONE_REGEX = /\((\d{2})\)\s*(\d{5})-(\d{4})/;
```

### Contexto Técnico

```javascript
// INFO: Promise.allSettled (ES2020) - não falha se uma promise rejeitar
// Diferente de Promise.all que falha no primeiro erro
const results = await Promise.allSettled(promises);
```

## Ação Esperada

INFO é puramente **informativo**:

1. **Ler** se precisar entender detalhes
2. **Ignorar** se já conhece o contexto
3. **Atualizar** se links quebrarem
4. **Remover** se informação for trivial

## Quando Remover

| Situação | Ação |
|----------|------|
| Link quebrado | Atualizar ou remover |
| Informação comum | Remover (todos sabem) |
| Código auto-explicativo | Remover |
| Documentado em JSDoc | Remover duplicata |

## Busca no Código

```bash
# Encontrar INFOs
grep -rn "INFO:" src/

# INFOs com links
grep -rn "INFO:.*http" src/

# INFOs com exemplos
grep -rn -A3 "INFO:.*exemplo\|INFO:.*usage" src/
```

## Anti-Patterns

```javascript
// ❌ INFO explicando o óbvio
// INFO: esta variável guarda o nome do usuário
const userName = user.name;

// ❌ INFO sem valor
// INFO: código abaixo
function obvious() { }

// ❌ INFO para decisão importante (usar NOTE)
// INFO: escolhemos Redis por causa de X
const cache = new Redis(); // Use NOTE para decisões

// ❌ INFO muito longo (usar JSDoc)
// INFO: esta função recebe um usuário, valida os campos,
// normaliza os dados, salva no banco e retorna o ID...
function processUser() { } // Use JSDoc
```

## Diferença de NOTE

| Aspecto | INFO | NOTE |
|---------|------|------|
| Importância | Contexto extra | Decisão crítica |
| Leitura | Opcional | Recomendada |
| Foco | Como funciona | Por que assim |
| Remoção | Fácil de remover | Pensar antes |

## Quality Factor Relacionado

- [Maintainability](../../software-quality/revision/001_maintainability.md): INFO facilita entendimento
- [Usability](../../software-quality/operation/005_usability.md): código documentado é mais usável

## Rules Relacionadas

- [clean-code/006 - Comments](../../clean-code/qualidade-comentarios-porque.md): INFO complementa, não substitui bom código

---

**Criada em**: 2026-03-19
**Versão**: 1.0
