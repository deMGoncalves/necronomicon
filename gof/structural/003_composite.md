# Composite

**Classificação**: Padrão Estrutural

---

## Intenção e Objetivo

Compor objetos em estruturas de árvore para representar hierarquias parte-todo. O Composite permite que os clientes tratem objetos individuais e composições de objetos de forma uniforme.

## Também Conhecido Como

- Composite Object

## Motivação

Aplicações gráficas permitem construir diagramas complexos a partir de componentes simples. O usuário pode agrupar componentes para formar componentes maiores, que podem ser agrupados novamente. Uma implementação simples poderia definir classes para primitivos gráficos e classes contêiner que atuam como compostos.

O problema é que o código que usa essas classes precisa tratar objetos primitivos e contêineres de forma diferente, mesmo que na maioria das vezes trate ambos de forma idêntica. O Composite resolve isso definindo uma classe abstrata Component que representa tanto primitivos quanto contêineres. Primitivos são folhas, contêineres são compostos.

## Aplicabilidade

Use o padrão Composite quando:

- Você quer representar hierarquias parte-todo de objetos
- Você quer que os clientes ignorem a diferença entre composições de objetos e objetos individuais
- A estrutura pode ter qualquer nível de complexidade e é dinâmica
- Você precisa aplicar operações sobre toda a estrutura hierárquica
- Você tem objetos com comportamentos recursivos (árvores, menus, sistemas de arquivos)

## Estrutura

```
Client
└── Uses: Component (Interface)
    ├── operation()
    └── add/remove(Component)

Component (Interface)
├── operation()
├── add(Component)
└── remove(Component)

Leaf implements Component
└── operation() → implementation for leaf

Composite implements Component
├── Maintains: List<Component> children
├── operation()
│   └── For each child: child.operation()
├── add(Component) → adds to children
└── remove(Component) → removes from children
```

## Participantes

- **Component**: Declara a interface para objetos na composição; implementa comportamento padrão comum a todas as classes; declara interface para acesso e gerenciamento de componentes filhos; (opcional) define interface para acesso ao pai
- **Leaf**: Representa objetos folha (sem filhos); define comportamento para objetos primitivos
- [**Composite**](003_composite.md): Define comportamento para componentes com filhos; armazena filhos; implementa operações relacionadas a filhos na interface Component
- **Client**: Manipula objetos na composição por meio da interface Component

## Colaborações

- Clientes usam a interface Component para interagir com objetos na estrutura composta
- Se o destinatário for um Leaf, a requisição é tratada diretamente
- Se o destinatário for um Composite, ele geralmente encaminha requisições aos filhos, possivelmente realizando operações adicionais antes/depois

## Consequências

### Vantagens

- **Define hierarquias de classes**: Objetos primitivos podem ser compostos em objetos complexos de forma recursiva
- **Simplifica o cliente**: O cliente trata todos os objetos de forma uniforme
- **Facilita a adição de novos componentes**: Novos Leafs ou Composites funcionam automaticamente com estruturas e código existentes
- **Promove Responsabilidade Única**: Cada componente tem uma única responsabilidade

### Desvantagens

- **Pode tornar o design muito genérico**: Dificulta a restrição de componentes do Composite
- **Overhead**: Operações precisam verificar o tipo do filho
- **Dificuldade em restringir filhos**: Componentes podem aceitar qualquer filho

## Implementação

### Considerações

1. **Referências explícitas ao pai**: Manter a referência filho-para-pai simplifica a travessia e a implementação de Chain of Responsibility

2. **Compartilhamento de componentes**: Difícil quando os componentes têm apenas um pai; Flyweight pode ajudar

3. **Maximizar a interface Component**: Colocar o máximo de operações comuns no Component; pode ser necessário substituir operações que não fazem sentido em Leaf

4. **Declarar operações de gerenciamento de filhos**: Declarar no Component (transparência) vs declarar apenas no Composite (segurança)

5. **Ordenação dos filhos**: Quando a ordem importa, design cuidadoso da interface de acesso e gerenciamento

6. **Caching**: O Composite pode armazenar em cache resultados de travessias ou buscas

7. **Visitor para operações**: Quando há operações específicas na estrutura composta, use o Visitor

### Técnicas

- **Segurança de Tipos**: Em linguagens tipadas, use generics/templates para restringir tipos de filhos
- **Null Object Pattern**: Use Null Object em vez de null para filhos inexistentes
- **Iterator Pattern**: Forneça iteradores para travessia da árvore

## Usos Conhecidos

- **Sistemas de Arquivos**: Diretórios (Composite) e arquivos (Leaf)
- **Componentes GUI**: Contêineres (painéis, janelas) e widgets (botões, rótulos)
- **Organogramas**: Organizações compostas por departamentos e funcionários
- **Estrutura de Documentos**: Documentos com parágrafos, seções, capítulos
- **Sistemas de Menus**: Menus contendo itens e submenus
- **Árvores de Expressão**: Árvores sintáticas em compiladores

## Padrões Relacionados

- [**Chain of Responsibility**](013_chain-of-responsibility.md): Frequentemente usado com Composite; o componente pode passar a requisição para seu pai
- [**Decorator**](004_decorator.md): Frequentemente usado em conjunto; ambos compartilham diagramas similares; Decorator adiciona responsabilidades, Composite agrega filhos
- [**Flyweight**](006_flyweight.md): Permite compartilhar componentes, mas eles não podem referenciar pais
- [**Iterator**](016_iterator.md): Usado para percorrer compostos
- [**Visitor**](../gof/behavioral/011_visitor.md): Localiza operações que de outra forma estariam distribuídas entre as classes Composite e Leaf

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): fácil adicionar novos componentes
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): Leaf e Composite são intercambiáveis
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada componente tem responsabilidade única
- [004 - First-Class Collections](../../object-calisthenics/004_colecoes-primeira-classe.md): Composite encapsula a coleção

---

**Criado em**: 2025-01-11
**Versão**: 1.0
