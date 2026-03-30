# Template Method

**Categoria:** Comportamental
**Intenção:** Definir o esqueleto de um algoritmo em uma operação, adiando a definição de alguns passos para subclasses, sem alterar a estrutura do algoritmo.

---

## Quando Usar

- Algoritmo com estrutura fixa mas passos variáveis entre subclasses
- Evitar duplicação quando múltiplas classes têm algoritmos similares com pequenas diferenças
- Implementar hooks opcionais em frameworks
- Quando clientes devem poder estender partes específicas, não toda a estrutura

## Quando NÃO Usar

- Quando herança pode ser substituída por composição — preferir Strategy (rule 059 — Refused Bequest)
- Quando subclasses precisam alterar a estrutura do algoritmo, não apenas passos
- Para extensão onde herança causaria explosão de subclasses

## Estrutura Mínima (TypeScript)

```typescript
abstract class ReportGenerator {
  // Template Method: define o esqueleto do algoritmo
  generate(data: unknown[]): string {
    const header = this.renderHeader()
    const body = this.renderBody(data)
    const footer = this.renderFooter()
    return `${header}\n${body}\n${footer}`
  }

  protected abstract renderBody(data: unknown[]): string

  // Hooks opcionais com implementação padrão
  protected renderHeader(): string { return '=== Relatório ===' }
  protected renderFooter(): string { return '=== Fim ===' }
}

class CSVReport extends ReportGenerator {
  protected renderBody(data: unknown[]): string {
    return data.map(row => Object.values(row as object).join(',')).join('\n')
  }
}
```

## Exemplo de Uso Real

```typescript
new CSVReport().generate([{ name: 'Alice', age: 30 }])
```

## Relacionada com

- [factory-method.md](factory-method.md): complementa — Factory Method é frequentemente um passo do Template Method
- [strategy.md](strategy.md): substitui — Strategy usa composição; Template Method usa herança; prefira Strategy para evitar coupling de herança
- [rule 059 - Proibição de Herança de Refusão](../../../rules/059_proibicao-heranca-refusao.md): reforça — subclasses não devem sobrescrever o template method, apenas os passos abstratos
- [rule 011 - Princípio Aberto/Fechado](../../../rules/011_principio-aberto-fechado.md): reforça — adicionar nova variante sem alterar o algoritmo base

---

**GoF Categoria:** Behavioral
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
