# Abstract Factory

**Classificação**: Padrão Criacional

---

## Intenção e Objetivo

Fornecer uma interface para criar famílias de objetos relacionados ou dependentes sem especificar suas classes concretas. Permite que o sistema seja independente de como seus produtos são criados, compostos e representados.

## Também Conhecido Como

- Kit

## Motivação

Considere um sistema de interface gráfica que suporta múltiplos estilos visuais (look-and-feel). Para garantir portabilidade entre diferentes plataformas, o código da aplicação não deve instanciar diretamente widgets específicos de plataforma (como `WindowsButton` ou `MacButton`).

Abstract Factory resolve esse problema definindo uma interface abstrata para criar cada tipo de widget. Cada plataforma implementa sua própria fábrica concreta que cria widgets no estilo adequado. O código do cliente usa apenas as interfaces abstratas, tornando-se independente de plataforma.

## Aplicabilidade

Use o padrão Abstract Factory quando:

- Um sistema deve ser independente de como seus produtos são criados, compostos e representados
- Um sistema deve ser configurado com uma de múltiplas famílias de produtos relacionados
- Uma família de objetos relacionados foi projetada para ser usada em conjunto, e você precisa garantir essa restrição
- Você deseja fornecer uma biblioteca de classes de produtos e quer revelar apenas suas interfaces, não suas implementações
- O tempo de vida das dependências é menor que o do consumidor

## Estrutura

```
AbstractFactory (Interface)
├── createProductA(): AbstractProductA
└── createProductB(): AbstractProductB

ConcreteFactory1 implements AbstractFactory
├── createProductA() → ProductA1
└── createProductB() → ProductB1

ConcreteFactory2 implements AbstractFactory
├── createProductA() → ProductA2
└── createProductB() → ProductB2

Client
└── Usa apenas: AbstractFactory, AbstractProductA, AbstractProductB
```

## Participantes

- **AbstractFactory**: Declara a interface para operações que criam objetos de produto abstratos
- **ConcreteFactory**: Implementa as operações para criar objetos de produto concretos
- **AbstractProduct**: Declara a interface para um tipo de objeto produto
- **ConcreteProduct**: Define um objeto produto a ser criado pela fábrica concreta correspondente; implementa a interface AbstractProduct
- **Client**: Usa apenas as interfaces declaradas pelas classes AbstractFactory e AbstractProduct

## Colaborações

- Normalmente uma única instância de ConcreteFactory é criada em tempo de execução
- AbstractFactory delega a criação de objetos produto para sua subclasse ConcreteFactory
- Client permanece independente das classes concretas, trabalhando apenas com abstrações

## Consequências

### Vantagens

- **Isola classes concretas**: Ajuda a controlar as classes de objetos criados pela aplicação
- **Facilita a troca de famílias de produtos**: A classe de fábrica concreta aparece apenas uma vez, facilitando alterações
- **Promove consistência entre produtos**: Quando objetos de uma família são projetados para trabalhar juntos, isso é garantido
- **Respeita o Open/Closed Principle**: Novas famílias podem ser adicionadas sem modificar o código do cliente

### Desvantagens

- **Difícil suportar novos tipos de produto**: Estender AbstractFactory para produzir novos tipos requer mudanças em toda a hierarquia
- **Aumenta a complexidade**: Introduz múltiplas interfaces e classes adicionais

## Implementação

### Considerações

1. **Fábricas como Singleton**: Tipicamente apenas uma instância de ConcreteFactory é necessária
2. **Criando produtos**: AbstractFactory apenas declara a interface; ConcreteFactory implementa a criação real
3. **Definindo fábricas extensíveis**: Adicionar um parâmetro ao método de criação permite criar tipos diferentes sem estender a interface

### Técnicas

- Usar Factory Method para implementar os métodos de criação
- Usar Prototype para implementar fábricas, eliminando a necessidade de subclasses
- A fábrica pode ser inicializada por configuração ou registro

## Usos Conhecidos

- **Frameworks UI**: Java Swing (UIManager), Qt (QStyle)
- **Bancos de Dados**: ADO.NET (DbProviderFactory), JDBC (DriverManager)
- **Temas de Aplicação**: Sistemas que suportam múltiplos temas visuais
- **Toolkits multiplataforma**: Bibliotecas que abstraem diferenças entre plataformas
- **Motores de Jogo**: Criação de famílias de entidades (inimigos, obstáculos) por fase

## Padrões Relacionados

- [**Factory Method**](003_factory-method.md): Abstract Factory frequentemente é implementado usando Factory Methods
- [**Prototype**](004_prototype.md): Pode usar Prototype para implementar os métodos de criação da fábrica
- [**Singleton**](005_singleton.md): Fábricas concretas são frequentemente Singletons
- [**Builder**](002_builder.md): Padrão alternativo quando a criação é complexa e passo a passo
- [**Facade**](../structural/005_facade.md): Abstract Factory pode ser usado com Facade para fornecer uma interface para criar objetos de subsistema

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): reforça
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): implementa
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): reforça

---

**Criado em**: 2025-01-11
**Versão**: 1.0
