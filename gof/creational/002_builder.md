# Builder

**Classificação**: Padrão Criacional

---

## Intenção e Objetivo

Separar a construção de um objeto complexo de sua representação, de modo que o mesmo processo de construção possa criar diferentes representações. Permite construir objetos passo a passo, tornando o processo de criação mais controlado e legível.

## Também Conhecido Como

- Constructor
- Assembler

## Motivação

Um leitor de documentos RTF deve converter RTF para múltiplos formatos (ASCII, TeX, Widget). O problema é que o número de conversões possíveis é ilimitado, e seria impraticável adicioná-las todas como métodos na classe do leitor.

A solução é configurar o leitor com um objeto Builder que sabe como converter RTF para um formato específico. Enquanto o leitor analisa o documento, ele notifica o builder, que gradualmente constrói o produto final. Builders diferentes produzem representações diferentes.

## Aplicabilidade

Use o padrão Builder quando:

- O algoritmo para criar um objeto complexo deve ser independente das partes que compõem o objeto e de como são montadas
- O processo de construção deve permitir diferentes representações do objeto construído
- Você precisa construir objetos com muitos parâmetros opcionais (evitar construtores telescópicos)
- Você deseja garantir que o objeto seja utilizável apenas após sua construção completa (imutabilidade)
- Criar um objeto requer múltiplas etapas ou validações intermediárias

## Estrutura

```
Director
├── Compõe: Builder (interface)
└── construct()
    ├── builder.buildPartA()
    ├── builder.buildPartB()
    └── builder.buildPartC()

Builder (Interface)
├── buildPartA()
├── buildPartB()
└── getResult(): Product

ConcreteBuilder implements Builder
├── Mantém referência ao Product sendo construído
├── buildPartA() → configura a parte A do Product
├── buildPartB() → configura a parte B do Product
└── getResult() → retorna o Product final

Product
└── Objeto complexo sendo construído
```

## Participantes

- [**Builder**](002_builder.md): Especifica a interface abstrata para criar partes de um objeto Product
- **ConcreteBuilder**: Constrói e monta partes do produto; define e mantém a representação que cria; fornece interface para recuperar o produto
- **Director**: Constrói um objeto usando a interface Builder
- **Product**: Representa o objeto complexo sendo construído; ConcreteBuilder constrói a representação interna e define o processo de montagem

## Colaborações

- Client cria o objeto Director e o configura com o Builder desejado
- Director notifica o builder sempre que uma parte do produto deve ser construída
- Builder trata as solicitações do director e adiciona partes ao produto
- Client recupera o produto do builder

## Consequências

### Vantagens

- **Permite variar a representação interna**: Usar builders diferentes fornece representações diferentes
- **Isola o código de construção e representação**: Encapsula como um objeto complexo é construído e representado
- **Controle refinado sobre o processo de construção**: Constrói o produto passo a passo, sob controle do director
- **Imutabilidade**: Permite criar objetos imutáveis de forma elegante
- **Validação centralizada**: Pode validar o estado antes de retornar o produto final

### Desvantagens

- **Requer criar builder específico**: Um ConcreteBuilder é necessário para cada representação diferente
- **Aumenta o número de classes**: Adiciona complexidade ao design

## Implementação

### Considerações

1. **Interface de montagem e construção**: Builders devem ser genéricos o suficiente para permitir diferentes Directors
2. **Por que não há produto abstrato**: Produtos produzidos por builders podem diferir drasticamente, sem uma interface comum
3. **Métodos vazios como padrão**: Métodos do Builder podem ter implementação vazia por padrão (apenas os necessários são sobrescritos)
4. **Fluent Interface**: Builder pode retornar `this` para permitir encadeamento de métodos
5. **Validação**: Realizar validação no método `getResult()` ou `build()`

### Técnicas

- **Step Builder**: Garantir a ordem de chamada por meio de interfaces intermediárias
- **Parâmetros Nomeados**: Simular parâmetros nomeados em linguagens que não os suportam
- **Validação no Build**: Validar completude e consistência antes de retornar o produto

## Usos Conhecidos

- **StringBuilder/StringBuffer**: Construção de strings complexas
- **Document Builders**: Builders de XML, JSON, HTML (DocumentBuilder, JsonBuilder)
- **HTTP Request Builders**: Bibliotecas HTTP (OkHttp, Retrofit)
- **Test Data Builders**: Criação de objetos complexos em testes
- **Query Builders**: Construção de consultas SQL ou NoSQL
- **Configuration Builders**: Criação de objetos de configuração complexos

## Padrões Relacionados

- [**Abstract Factory**](001_abstract-factory.md): Similar, mas Abstract Factory retorna o produto imediatamente, enquanto Builder constrói passo a passo
- [**Composite**](../structural/003_composite.md): O que Builder frequentemente constrói
- [**Factory Method**](003_factory-method.md): Alternativa quando há apenas uma etapa de construção
- [**Prototype**](004_prototype.md): Builder e Prototype podem trabalhar juntos (clonar e depois construir sobre a cópia)
- [**Singleton**](005_singleton.md): Builder pode ser singleton se não tiver estado

### Relação com Rules

- [033 - Limit of Parameters per Function](../../clean-code/limite-parametros-funcao.md): resolve (evita construtores telescópicos)
- [029 - Object Immutability](../../clean-code/imutabilidade-objetos-freeze.md): facilita
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): reforça
- [003 - Primitive Encapsulation](../../object-calisthenics/003_encapsulamento-primitivos.md): complementa

---

**Criado em**: 2025-01-11
**Versão**: 1.0
