# Visitor

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Representar uma operação a ser executada sobre os elementos de uma estrutura de objetos. Visitor permite definir uma nova operação sem alterar as classes dos elementos sobre os quais opera. Separa um algoritmo da estrutura de objetos sobre a qual opera.

## Também Conhecido Como

- Visitor

## Motivação

Considere um compilador que representa programas como árvores de sintaxe abstrata. Ele executará operações nessas árvores para análise, otimização e geração de código. A maioria dessas operações precisará tratar nós que representam diferentes construções da linguagem de forma diferente. Distribuir todas essas operações pelas diversas classes de nós leva a um sistema difícil de entender, manter e alterar.

Poderíamos definir essas operações em classes separadas. Para aplicar uma operação particular como verificação de tipos, criamos um TypeCheckingVisitor. Este visitor percorre a árvore visitando cada nó e realizando a verificação de tipos adequada. Para adicionar uma nova operação, basta adicionar uma nova subclasse Visitor. Visitor usa uma técnica chamada double-dispatch: a operação executada depende tanto do tipo de solicitação quanto do tipo do elemento que a recebe.

## Aplicabilidade

Use o padrão Visitor quando:

- Uma estrutura de objetos contém muitas classes de objetos com interfaces diferentes, e você deseja executar operações nesses objetos que dependem de suas classes concretas
- Muitas operações distintas e não relacionadas precisam ser executadas em objetos de uma estrutura de objetos, e você deseja evitar "poluir" suas classes com essas operações
- As classes que definem a estrutura de objetos raramente mudam, mas você frequentemente deseja definir novas operações sobre a estrutura
- Você precisa executar operações em objetos sem modificar suas classes
- Você tem uma hierarquia de classes estável mas operações voláteis

## Estrutura

```
Client
└── Usa: ObjectStructure, Visitor

ObjectStructure
├── Mantém: List<Element>
└── accept(visitor)
    └── Para cada elemento: element.accept(visitor)

Element (Interface)
└── accept(visitor: Visitor)

ConcreteElementA implements Element
└── accept(visitor)
    └── visitor.visitConcreteElementA(this)

ConcreteElementB implements Element
└── accept(visitor)
    └── visitor.visitConcreteElementB(this)

Visitor (Interface)
├── visitConcreteElementA(ConcreteElementA)
└── visitConcreteElementB(ConcreteElementB)

ConcreteVisitor1 implements Visitor
├── visitConcreteElementA(element)
│   └── Operação específica para A
└── visitConcreteElementB(element)
    └── Operação específica para B

ConcreteVisitor2 implements Visitor
├── visitConcreteElementA(element)
│   └── Outra operação para A
└── visitConcreteElementB(element)
    └── Outra operação para B
```

## Participantes

- [**Visitor**](011_visitor.md): Declara uma operação Visit para cada classe de ConcreteElement na estrutura de objetos; o nome e a assinatura da operação identificam a classe que envia a solicitação Visit ao visitor
- **ConcreteVisitor**: Implementa cada operação declarada por Visitor; fornece o contexto para o algoritmo e armazena seu estado local
- **Element**: Define uma operação Accept que recebe um visitor como argumento
- **ConcreteElement**: Implementa uma operação Accept que recebe um visitor como argumento
- **ObjectStructure**: Pode enumerar seus elementos; pode fornecer uma interface de alto nível para permitir que o visitor visite seus elementos; pode ser um Composite ou uma coleção

## Colaborações

- Um cliente que usa o padrão Visitor deve criar um objeto ConcreteVisitor e percorrer a estrutura de objetos, visitando cada elemento com o visitor
- Quando um elemento é visitado, ele chama a operação Visitor que corresponde à sua classe; o elemento fornece a si mesmo como argumento para essa operação para permitir ao visitor acessar seu estado se necessário

## Consequências

### Vantagens

- **Fácil adicionar novas operações**: Adicionar uma nova operação é simples; basta adicionar um novo visitor
- **Reúne operações relacionadas**: Operações relacionadas definidas em um visitor em vez de espalhadas pelas classes
- **Acumula estado**: Visitors podem acumular estado enquanto percorrem a estrutura
- **Pode percorrer estruturas não relacionadas**: Visitor não está limitado a estruturas que definem accept

### Desvantagens

- **Adicionar novas classes ConcreteElement é difícil**: Cada novo ConcreteElement requer uma nova operação Visit em cada Visitor
- **Quebra de encapsulamento**: Visitor pode precisar acessar o estado interno dos elementos
- **Dependência**: Visitors dependem de classes de elementos concretos

## Implementação

### Considerações

1. **Double dispatch**: Visitor usa double dispatch; a operação executada depende tanto do tipo de Visitor quanto do tipo de Element

2. **Quem é responsável pelo percurso**: Visitor, ObjectStructure ou outro objeto pode ser responsável; se ObjectStructure é Composite, pode usar Iterator

3. **Visitor sem classe abstrata de elemento**: Se a estrutura não tem uma classe abstrata comum para elementos, Visitor precisa de um método visit para cada tipo

### Técnicas

- **Visitor com Composite**: Combinar com Composite para percorrer estruturas de árvore
- **Visitor com Iterator**: Usar Iterator para o percurso
- **Acyclic Visitor**: Variante que evita dependências cíclicas
- **Reflective Visitor**: Usar reflexão para evitar double dispatch
- **Extension Methods**: Em linguagens que os suportam, usar extension methods como alternativa

## Usos Conhecidos

- **Compiladores**: Percurso de AST (verificação de tipos, otimização, geração de código)
- **Processamento de Documentos**: Operações no modelo de objeto de documento
- **Gráficos**: Operações de renderização em cenas gráficas
- **Sistemas de Arquivos**: Operações em estruturas de diretórios
- **Cálculo de Impostos**: Diferentes visitors de imposto para diferentes jurisdições
- **Relatórios**: Diferentes formatos de relatório sobre a mesma estrutura de dados

## Padrões Relacionados

- [**Composite**](008_composite.md): Visitor pode ser usado para aplicar uma operação sobre um Composite
- [**Interpreter**](003_interpreter.md): Visitor pode ser usado para interpretar uma AST
- [**Iterator**](004_iterator.md): Visitor pode usar Iterator para percorrer a estrutura
- [**Strategy**](009_strategy.md): Visitor é Strategy aplicado à estrutura de objetos
- [**Command**](002_command.md): Visitor pode tratar cada visita a um elemento como Command

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar operações sem modificar elementos
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separar operação da estrutura
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): visitor define interface específica

---

**Criado em**: 2025-01-11
**Versão**: 1.0
