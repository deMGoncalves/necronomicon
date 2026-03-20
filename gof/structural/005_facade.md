# Facade

**Classificação**: Padrão Estrutural

---

## Intenção e Objetivo

Fornecer uma interface unificada para um conjunto de interfaces em um subsistema. O Facade define uma interface de nível mais alto que torna o subsistema mais fácil de usar, reduzindo a complexidade e as dependências entre sistemas.

## Também Conhecido Como

- Facade

## Motivação

Estruturar um sistema em subsistemas ajuda a reduzir a complexidade. Um objetivo comum de design é minimizar a comunicação e as dependências entre subsistemas. Uma forma de alcançar isso é introduzir um objeto facade que forneça uma interface única e simplificada para as facilidades mais gerais de um subsistema.

Considere um compilador: os subsistemas incluem scanner, parser, analisador semântico, gerador de código. Alguns programas especializados podem acessar essas facilidades diretamente, mas a maioria dos clientes do compilador não se preocupa com os detalhes — eles apenas querem compilar. A classe Compiler fornece uma interface unificada que oculta a complexidade.

## Aplicabilidade

Use o padrão Facade quando:

- Você quer fornecer uma interface simples para um subsistema complexo
- Existem muitas dependências entre clientes e classes de implementação de uma abstração
- Você quer organizar seus subsistemas em camadas; o facade define o ponto de entrada para cada nível
- Você quer desacoplar o subsistema de clientes e outros subsistemas
- Você quer promover fraco acoplamento entre subsistema e clientes
- Você quer ocultar a complexidade de APIs de terceiros

## Estrutura

```
Client
└── Uses: Facade
    └── operation()
        ├── subsystemClass1.operation1()
        ├── subsystemClass2.operation2()
        ├── subsystemClass3.operation3()
        └── coordinates subsystems

Facade
├── Knows: SubsystemClass1, SubsystemClass2, SubsystemClass3
└── Delegates client requests to appropriate subsystem objects

SubsystemClass1
└── Implements subsystem functionality

SubsystemClass2
└── Implements subsystem functionality

SubsystemClass3
└── Implements subsystem functionality
```

## Participantes

- [**Facade**](005_facade.md): Sabe quais classes do subsistema são responsáveis por uma requisição; delega requisições dos clientes aos objetos de subsistema adequados
- **Classes do Subsistema**: Implementam a funcionalidade do subsistema; executam o trabalho atribuído pelo Facade; não têm conhecimento do Facade (não mantêm referência)

## Colaborações

- Clientes se comunicam com o subsistema enviando requisições ao Facade, que as encaminha para os objetos de subsistema adequados
- Embora os objetos do subsistema façam o trabalho real, o Facade pode precisar traduzir sua interface para as interfaces do subsistema
- Clientes que usam o facade não precisam acessar os objetos do subsistema diretamente

## Consequências

### Vantagens

- **Protege clientes dos componentes do subsistema**: Reduz o número de objetos com os quais os clientes lidam, tornando o subsistema mais fácil de usar
- **Promove acoplamento fraco**: Permite variar componentes do subsistema sem afetar os clientes
- **Não impede acesso ao subsistema**: Clientes podem escolher entre o facade e o acesso direto ao subsistema
- **Camadas de abstração**: Simplifica dependências entre camadas
- **Facilita refatoração**: Mudanças no subsistema não afetam os clientes

### Desvantagens

- **Pode se tornar um God Object**: Se concentrar muitas responsabilidades
- **Pode criar acoplamento indesejado**: Se mal projetado, pode acoplar o facade a muitas classes
- **Violação do SRP**: Se o facade faz mais do que simples coordenação

## Implementação

### Considerações

1. **Reduzir o acoplamento cliente-subsistema**: Tornar o Facade uma classe abstrata com subclasses concretas para diferentes implementações permite trocar implementações inteiras

2. **Classes de subsistema públicas vs privadas**: O subsistema é similar a uma classe — ambos têm interfaces e ambos encapsulam algo. A interface pública do subsistema consiste em classes acessíveis aos clientes; as privadas são para uso interno

3. **Facade adicional**: Não há limitação de ter apenas um facade por subsistema

### Técnicas

- **Facade em Camadas**: Crie facades para diferentes níveis de abstração
- **Facade como Singleton**: Frequentemente apenas uma instância do facade é necessária
- **Facade com Factory**: O Facade pode usar Factory Methods para criar objetos do subsistema

## Usos Conhecidos

- **Java Database Connectivity (JDBC)**: `DriverManager` é facade para o subsistema de drivers
- **javax.faces.context.FacesContext**: Facade para JSF
- **Spring Framework**: Muitas classes facade (`JdbcTemplate`, `RestTemplate`)
- **APIs de Sistema Operacional**: APIs de alto nível que ocultam a complexidade do kernel
- **Frontends de Compiladores**: Interface simplificada para processos de compilação complexos
- **Reprodutores de Mídia**: Interface simples para subsistemas de codec, renderização e áudio

## Padrões Relacionados

- [**Abstract Factory**](../creational/001_abstract-factory.md): Pode ser usado com Facade para fornecer interface de criação de objetos do subsistema independentemente do subsistema
- [**Mediator**](017_mediator.md): Similar — abstrai funcionalidade de objetos existentes; diferença: Mediator centraliza a comunicação entre colegas que se conhecem; Facade apenas abstrai a interface do objeto do subsistema
- [**Singleton**](../creational/005_singleton.md): Facade frequentemente é Singleton
- [**Adapter**](001_adapter.md): Adapta interface existente; Facade define nova interface simplificada

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): coordenação é responsabilidade única
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): fornece interface específica
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): clientes dependem do facade
- [018 - Acyclic Dependencies Principle](../../package-principles/004_acyclic-dependencies-principle.md): quebra ciclos

---

**Criado em**: 2025-01-11
**Versão**: 1.0
