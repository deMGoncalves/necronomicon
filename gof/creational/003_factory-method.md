# Factory Method

**Classificação**: Padrão Criacional

---

## Intenção e Objetivo

Definir uma interface para criar um objeto, mas deixar as subclasses decidirem qual classe instanciar. Factory Method permite que uma classe adie a instanciação para as subclasses, promovendo o acoplamento fraco entre o criador e os produtos concretos.

## Também Conhecido Como

- Virtual Constructor

## Motivação

Frameworks usam classes abstratas para definir e manter relacionamentos entre objetos. Um framework para aplicações que podem apresentar múltiplos documentos ao usuário define abstrações como Application e Document, mas deixa a criação de documentos concretos para subclasses específicas.

A classe Application é responsável por gerenciar Documents mas não sabe qual tipo específico criar — isso depende da aplicação concreta. Factory Method permite que Application defina a interface de criação mas delegue a decisão sobre qual classe Document instanciar para as subclasses.

## Aplicabilidade

Use o padrão Factory Method quando:

- Uma classe não pode antecipar a classe de objetos que deve criar
- Uma classe quer que suas subclasses especifiquem os objetos que ela cria
- Classes delegam responsabilidade a uma de várias subclasses auxiliares, e você deseja localizar o conhecimento sobre qual subclasse auxiliar é o delegado
- Você deseja fornecer aos usuários de sua biblioteca uma forma de estender componentes internos
- Substituir construtores por métodos nomeados que descrevem a criação

## Estrutura

```
Creator (Classe Abstrata/Interface)
├── factoryMethod(): Product (abstrato)
└── operation()
    ├── product = factoryMethod()
    └── usa o product

ConcreteCreatorA extends Creator
└── factoryMethod() → retorna new ConcreteProductA()

ConcreteCreatorB extends Creator
└── factoryMethod() → retorna new ConcreteProductB()

Product (Interface)
├── ConcreteProductA implements Product
└── ConcreteProductB implements Product
```

## Participantes

- **Product**: Define a interface dos objetos que o factory method cria
- **ConcreteProduct**: Implementa a interface Product
- **Creator**: Declara o factory method que retorna objeto do tipo Product; pode definir implementação padrão que retorna ConcreteProduct padrão; pode chamar o factory method para criar um Product
- **ConcreteCreator**: Sobrescreve o factory method para retornar instância de ConcreteProduct

## Colaborações

- Creator depende de suas subclasses para definir o factory method de modo que retorne a instância adequada de ConcreteProduct

## Consequências

### Vantagens

- **Elimina acoplamento**: O código não depende de classes concretas, apenas de interfaces
- **Open/Closed Principle**: Código aberto para extensão, fechado para modificação
- **Single Responsibility**: Código de criação movido para um único lugar
- **Nomenclatura**: Factory methods com nomes descritivos são mais claros que construtores
- **Polimorfismo**: Substitui condicionais por polimorfismo

### Desvantagens

- **Hierarquia de classes**: Pode levar a muitas subclasses pequenas
- **Complexidade**: O código pode se tornar mais complicado com muitas classes adicionais

## Implementação

### Considerações

1. **Duas variedades principais**:
   - Creator é classe abstrata sem implementação padrão do factory method
   - Creator é classe concreta com implementação padrão

2. **Factory methods parametrizados**: Aceita parâmetro identificando o tipo de objeto a criar

3. **Convenções de nomenclatura**: `createProduct()`, `newProduct()`, `makeProduct()`

4. **Usando templates**: Em linguagens tipadas, usar generics/templates para evitar herança

5. **Inicialização preguiçosa**: Factory method pode implementar criação preguiçosa

### Técnicas

- **Static Factory Method**: Método estático que retorna instâncias (não o padrão puro, mas útil)
- **Named Constructor**: Factory methods com nomes descritivos que substituem construtores
- **Registro de Fábricas**: Manter registro de criadores disponíveis

## Usos Conhecidos

- **Collection Factories**: `Array.from()`, `List.of()`, `Map.of()`
- **Frameworks GUI**: Criação de componentes específicos de plataforma
- **Loggers**: `LoggerFactory.getLogger()`
- **Conexões de Banco de Dados**: `ConnectionFactory.createConnection()`
- **Parser Factories**: Criação de parsers específicos (XML, JSON)
- **Criação de Iterator**: `collection.iterator()`

## Padrões Relacionados

- [**Abstract Factory**](001_abstract-factory.md): Frequentemente implementado usando Factory Methods
- [**Template Method**](../behavioral/010_template-method.md): Factory Methods são frequentemente chamados dentro de Template Methods
- [**Prototype**](004_prototype.md): Não requer herança mas requer operação de inicialização; Factory Method requer herança mas não inicialização
- [**Singleton**](005_singleton.md): Pode usar Factory Method para controlar instanciação única
- [**Builder**](002_builder.md): Focado em construir objetos complexos passo a passo; Factory Method cria objetos em uma única chamada

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): implementa
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): reforça
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): elimina (substitui por polimorfismo)
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): reforça

---

**Criado em**: 2025-01-11
**Versão**: 1.0
