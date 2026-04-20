# Strategy

**Categoria:** Comportamental
**Intenção:** Definir família de algoritmos, encapsular cada um e torná-los intercambiáveis, permitindo que o algoritmo varie independentemente dos clientes que o usam.

---

## Quando Usar

- Trocar algoritmo em runtime (ex: diferentes estratégias de ordenação, compressão, cálculo)
- Eliminar `if/switch` que selecionam comportamento por tipo
- Quando múltiplas variantes de um algoritmo existem
- Para isolar lógica de negócio variável do código que a usa

## Quando NÃO Usar

- Quando há apenas um algoritmo fixo — use diretamente sem encapsular (overengineering — rule 064)
- Quando a variação de algoritmo é rara e `if` simples é mais legível
- Prefira Strategy sobre Template Method quando quiser composição em vez de herança

## Estrutura Mínima (TypeScript)

```typescript
interface SortStrategy<T> {
  sort(data: T[]): T[]
}

class BubbleSortStrategy<T> implements SortStrategy<T> {
  sort(data: T[]): T[] {
    const arr = [...data]
    for (let i = 0; i < arr.length; i++) {
      for (let j = 0; j < arr.length - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]]
        }
      }
    }
    return arr
  }
}

class NativeSortStrategy<T> implements SortStrategy<T> {
  sort(data: T[]): T[] { return [...data].sort() }
}

class Sorter<T> {
  constructor(private strategy: SortStrategy<T>) {}

  setStrategy(strategy: SortStrategy<T>): void { this.strategy = strategy }
  sort(data: T[]): T[] { return this.strategy.sort(data) }
}
```

## Exemplo de Uso Real

```typescript
const sorter = new Sorter(new NativeSortStrategy())
sorter.sort([3, 1, 2])
```

## Relacionada com

- [state.md](state.md): complementa — Strategy troca algoritmo manualmente; State transiciona comportamento automaticamente com base em estado
- [template-method.md](template-method.md): substitui — Strategy usa composição; Template Method usa herança; prefira Strategy quando quiser evitar herança
- [decorator.md](decorator.md): complementa — Decorator adiciona comportamento empilhando; Strategy substitui comportamento central
- [rule 011 - Princípio Aberto/Fechado](../../../rules/011_principio-aberto-fechado.md): reforça — adicionar nova estratégia sem modificar o Sorter
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): reforça — Sorter depende da interface SortStrategy, não de implementações concretas
- [rule 064 - Proibição de Overengineering](../../../rules/064_proibicao-overengineering.md): reforça — não usar quando há apenas um algoritmo

---

**GoF Categoria:** Behavioral
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
