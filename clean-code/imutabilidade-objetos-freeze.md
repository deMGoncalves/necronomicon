---
titulo: Imutabilidade de Objetos de Domínio (Object.freeze)
aliases:
  - Object Immutability
  - Immutable Objects
tipo: rule
id: CC-09
severidade: 🟠 Alto
origem: clean-code
tags:
  - clean-code
  - criacional
  - imutabilidade
resolver: Sprint atual
relacionados:
  - "[[003_encapsulamento-primitivos]]"
  - "[[008_proibicao-getters-setters]]"
  - "[[restricao-funcoes-efeitos-colaterais]]"
  - "[[006_processos-stateless]]"
criado: 2025-10-08
---

# Imutabilidade de Objetos de Domínio (Object.freeze)

*Object Immutability*


---

## Definição

Requer que todos os objetos criados para representar Entidades de Domínio ou *Value Objects* sejam **imutáveis**, aplicando explicitamente métodos de congelamento (`Object.freeze()`) antes de serem expostos.

## Motivação

A mutabilidade acidental introduz bugs graves e dificulta o rastreamento da origem das mudanças de estado, violando o princípio de **Encapsulamento**. O congelamento garante que o objeto não seja alterado após sua criação.

## Quando Aplicar

- [ ] Todas as instâncias de `Value Objects` ou `Entities` de domínio devem ser congeladas antes de sair do construtor ou da camada de persistência.
- [ ] É proibido aceitar objetos de domínio como parâmetros em métodos públicos e modificá-los sem clonar ou forçar um método de intenção.
- [ ] A imutabilidade deve ser aplicada de forma *shallow* ou *deep*, dependendo do objeto.

## Quando NÃO Aplicar

- **DTOs Puros**: Objetos de transferência de dados utilizados estritamente para comunicação externa ou mapeamento de dados.

## Violação — Exemplo

```javascript
// ❌ Objeto de domínio mutável — qualquer código pode alterar price após criação
function createProduct(data) {
  return { id: data.id, name: data.name, price: data.price };
}

const product = createProduct({ id: 1, name: 'Livro', price: 50 });
product.price = 0; // mutação acidental sem rastro
```

## Conformidade — Exemplo

```javascript
// ✅ Value Object imutável — qualquer tentativa de mutação lança erro em strict mode
function createProduct(data) {
  return Object.freeze({ id: data.id, name: data.name, price: data.price });
}

// TypeScript: readonly em todas as propriedades
interface Product {
  readonly id: number;
  readonly name: string;
  readonly price: number;
}
```

## Anti-Patterns Relacionados

- [[shared-mutable-state|Shared Mutable State]] — múltiplos módulos modificando o mesmo objeto sem coordenação
- [[accidental-mutation|Accidental Mutation]] — modificar parâmetro de função sem intenção explícita

## Como Detectar

### Manual

Verificar a ausência de `Object.freeze()` em métodos *Factory* ou construtores de Entidades.

### Automático

Biome: sem regra nativa para `Object.freeze`; usar `readonly` em todas as propriedades via TypeScript.

## Relação com ICP

Reduz **[[componente-responsabilidades|Responsabilidades]]**: objetos imutáveis têm uma única responsabilidade (representar um estado), eliminando métodos de mutação que adicionariam responsabilidades extras à classe.

## Relacionados

- [[003_encapsulamento-primitivos|Encapsulamento de Primitivos]] — reforça
- [[008_proibicao-getters-setters|Proibição de Getters/Setters]] — reforça
- [[restricao-funcoes-efeitos-colaterais]] — reforça
- [[006_processos-stateless|Processos Stateless]] — complementa
