# Abstract Factory

**Categoria:** Criacional
**Intenção:** Fornecer interface para criar famílias de objetos relacionados sem especificar classes concretas.

---

## Quando Usar

- Sistema precisa ser independente de como seus produtos são criados
- Sistema deve trabalhar com múltiplas famílias de objetos
- Ao construir UI que precisa ter temas (light/dark) ou plataformas diferentes
- Quando os produtos de uma família devem ser usados juntos

## Quando NÃO Usar

- Quando há apenas uma família de produtos — Factory Method é suficiente
- Quando adicionar novos tipos de produto exige alterar toda a interface (custo alto)
- Para objetos sem relação entre si (overengineering — rule 064)

## Estrutura Mínima (TypeScript)

```typescript
interface Button { render(): string }
interface Input { render(): string }

interface UIFactory {
  createButton(): Button
  createInput(): Input
}

class MaterialUIFactory implements UIFactory {
  createButton(): Button {
    return { render: () => '<button class="material">...</button>' }
  }
  createInput(): Input {
    return { render: () => '<input class="material" />' }
  }
}

class BootstrapUIFactory implements UIFactory {
  createButton(): Button {
    return { render: () => '<button class="btn">...</button>' }
  }
  createInput(): Input {
    return { render: () => '<input class="form-control" />' }
  }
}
```

## Exemplo de Uso Real

```typescript
const factory: UIFactory = new MaterialUIFactory()
factory.createButton().render()
```

## Relacionada com

- [factory-method.md](factory-method.md): depende — Abstract Factory é composta por Factory Methods
- [builder.md](builder.md): complementa — Builder constrói um produto complexo; Abstract Factory cria famílias
- [prototype.md](prototype.md): complementa — Prototype pode ser usado dentro de Abstract Factory para criar produtos por clonagem
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): reforça — clientes dependem da interface UIFactory, não das classes concretas
- [rule 011 - Princípio Aberto/Fechado](../../../rules/011_principio-aberto-fechado.md): reforça — adicionar nova família sem modificar clientes existentes

---

**GoF Categoria:** Creational
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
