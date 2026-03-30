---
name: big-o
description: Convenção de análise de complexidade algorítmica Big-O. Use quando avaliar performance de métodos que iteram sobre coleções, fazem buscas ou combinam loops.
model: haiku
allowed-tools: Read, Grep, Glob
user-invocable: true
location: managed
---

# Big-O

Convenção de análise de complexidade algorítmica para identificar e classificar a performance de métodos conforme a notação Big-O.

---

## Quando Usar

Use quando avaliar métodos que iteram sobre coleções, fazem buscas, combinam loops aninhados ou executam operações recursivas.

## Classificação

| Notação | Nome | Severidade |
|---------|------|------------|
| O(1) | Constante | Ideal |
| O(log n) | Logarítmica | Ideal |
| O(n) | Linear | Aceitável |
| O(n log n) | Log-linear | Aceitável |
| O(n^2) | Quadrática | Atenção |
| O(n^3) | Polinomial | Crítica |
| O(2^n) | Exponencial | Crítica |
| O(n!) | Fatorial | Crítica |

## Detecção por Estrutura

| Estrutura no Código | Big-O | Padrão |
|---------------------|-------|--------|
| Acesso direto por índice ou chave | O(1) | `map.get(key)`, `array[i]`, `object.prop` |
| Busca binária ou divisão por metade | O(log n) | `while (low <= high) { mid = ... }` |
| Loop simples sobre coleção | O(n) | `for`, `for...of`, `forEach`, `map`, `filter`, `reduce` |
| Sort nativo ou merge sort | O(n log n) | `array.sort()`, `Array.from().sort()` |
| Loop dentro de loop na mesma coleção | O(n^2) | `for { for }`, `forEach { filter }`, `map { find }` |
| Triplo aninhamento na mesma coleção | O(n^3) | `for { for { for } }` |
| Recursão que dobra a cada chamada | O(2^n) | `f(n) = f(n-1) + f(n-2)` sem memoização |
| Permutações ou combinações completas | O(n!) | Gerar todas as permutações de um conjunto |

## Limites

| Big-O | Limite | Ação |
|-------|--------|------|
| O(1), O(log n) | Ideal | Nenhuma ação necessária |
| O(n), O(n log n) | Aceitável | Nenhuma ação necessária |
| O(n^2) | Atenção | Avaliar se existe alternativa linear — anotar com OPTIMIZE se n pode crescer |
| O(n^3) | Crítica | Refatoração obrigatória — anotar com FIXME |
| O(2^n) | Crítica | Refatoração obrigatória — aplicar memoização ou programação dinâmica |
| O(n!) | Crítica | Refatoração obrigatória — substituir por heurística ou limitar entrada |

## Técnicas de Refatoração

| De | Para | Técnica |
|----|------|---------|
| O(n^2) com busca interna | O(n) | Substituir loop interno por Map/Set para lookup O(1) |
| O(n^2) com comparação de pares | O(n log n) | Ordenar primeiro e usar busca binária |
| O(n^2) com filtro dentro de loop | O(n) | Pré-computar Set com valores filtrados |
| O(2^n) recursão sem cache | O(n) | Aplicar memoização ou programação dinâmica |
| O(n) múltiplas passagens | O(n) single pass | Combinar operações em uma única iteração |

## Combinações Comuns

| Código | Big-O Resultante |
|--------|------------------|
| `array.filter().map()` | O(n) — duas passagens lineares = O(2n) = O(n) |
| `array.sort().filter()` | O(n log n) — sort domina |
| `array.map(x => other.find())` | O(n * m) — quadrática se n ≈ m |
| `array.map(x => other.includes())` | O(n * m) — quadrática se n ≈ m |
| `array.forEach(x => set.has())` | O(n) — Set.has é O(1) |

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Loop aninhado sem justificativa em coleções que podem crescer | O(n^2) ou pior degrada rapidamente |
| `find`/`includes`/`indexOf` dentro de `map`/`forEach`/`filter` | Cria O(n^2) oculto |
| Recursão sem memoização em problemas com subproblemas repetidos | O(2^n) quando O(n) é possível |
| Múltiplos `sort()` consecutivos na mesma coleção | Cada sort é O(n log n) desnecessário |
| `Array.from(set).filter()` quando `set.has()` resolve | Transforma O(1) lookup em O(n) scan |

## Fundamentação

- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): complexidade algorítmica alta obscurece a intenção e reduz clareza
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): loops aninhados indicam múltiplas responsabilidades no mesmo método
- [007 - Limite Máximo de Linhas por Classe](../../rules/007_limite-maximo-linhas-classe.md): algoritmos complexos tendem a exceder limites de linhas
- [001 - Nível Único de Indentação](../../rules/001_nivel-unico-indentacao.md): loops aninhados violam diretamente a restrição de indentação
- [039 - Regra do Escoteiro](../../rules/039_regra-escoteiro-refatoracao-continua.md): identificar e melhorar performance é parte da refatoração contínua
