# Prototype

**Categoria:** Criacional
**Intenção:** Especificar os tipos de objetos a criar usando uma instância prototípica e criar novos objetos copiando esse protótipo.

---

## Quando Usar

- Criação de objeto é custosa (ex: inicialização pesada, parsing de configuração)
- Precisa criar variações de um objeto sem subclassificar
- Sistema deve ser independente de como seus produtos são criados e compostos
- Ao trabalhar com objetos que têm estado inicial complexo

## Quando NÃO Usar

- Quando a criação direta é simples o suficiente (overengineering — rule 064)
- Quando o objeto contém referências circulares difíceis de clonar
- Quando cópia rasa (shallow copy) pode introduzir mutação acidental (rule 052)

## Estrutura Mínima (TypeScript)

```typescript
interface Cloneable<T> {
  clone(): T
}

class UserProfile implements Cloneable<UserProfile> {
  constructor(
    readonly name: string,
    readonly permissions: string[],
    readonly preferences: Record<string, unknown>
  ) {}

  // Cria cópia profunda do objeto
  clone(): UserProfile {
    return new UserProfile(
      this.name,
      [...this.permissions],
      { ...this.preferences }
    )
  }

  withName(name: string): UserProfile {
    const copy = this.clone()
    return new UserProfile(name, copy.permissions, copy.preferences)
  }
}
```

## Exemplo de Uso Real

```typescript
const adminProfile = baseProfile.clone()
const namedProfile = adminProfile.withName('admin')
```

## Relacionada com

- [abstract-factory.md](abstract-factory.md): complementa — Prototype pode ser usado dentro de Abstract Factory para criar produtos por clonagem
- [builder.md](builder.md): complementa — Prototype pode clonar o resultado final de um Builder
- [rule 052 - Proibição de Mutação Acidental](../../../rules/052_proibicao-mutacao-acidental.md): reforça — cópias rasas em objetos com referências aninhadas causam mutação acidental
- [rule 029 - Imutabilidade de Objetos](../../../rules/029_imutabilidade-objetos-freeze.md): reforça — clonar e congelar garante imutabilidade do protótipo
- [rule 064 - Proibição de Overengineering](../../../rules/064_proibicao-overengineering.md): reforça — não usar quando criação direta é suficiente

---

**GoF Categoria:** Creational
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
